import pandas as pd
import numpy as np
from fastapi import FastAPI, Query
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# 1. 데이터 & 벡터화 준비 (앱 시작 시 1회만)
df = pd.read_csv('recipes_with_features_new_v3.csv')
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(df['features'])

# 2. FastAPI 앱 객체 생성
app = FastAPI()


# 3. 추천 API 엔드포인트
@app.get("/recommend")
def recommend(menus: str = Query(..., description="좋아하는 메뉴 이름 콤마(,)로 구분")):
    # (1) 사용자가 좋아하는 메뉴 이름 리스트
    user_likes = [m.strip() for m in menus.split(',')]
    user_indices = df[df['메뉴 이름'].isin(user_likes)].index.tolist()
    if not user_indices:
        return {"result": "추천할 메뉴가 없음", "recommendations": []}

    # (2) 사용자 프로필 벡터(평균)
    user_vec = X[user_indices].mean(axis=0)
    user_vec = np.asarray(user_vec)
    cos_sim = cosine_similarity(user_vec, X).flatten()
    recommend_idx = [i for i in cos_sim.argsort()[::-1] if i not in user_indices][:10]

    # (3) 추천 결과 만들기
    result = []
    for idx in recommend_idx:
        item = {
            "메뉴이름": df.iloc[idx]['메뉴 이름'],
            "유사도": round(float(cos_sim[idx]), 3),
            "방법분류": df.iloc[idx]['방법 분류'],
            "국가분류": df.iloc[idx]['국가 분류'],
            "테마분류": df.iloc[idx]['테마 분류'],
            "주재료이름": df.iloc[idx]['주재료 이름']
        }
        result.append(item)
    return {"result": "ok", "recommendations": result}
