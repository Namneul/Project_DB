import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

df = pd.read_csv('recipes_with_features_new_v3.csv')
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(df['features'])

user_likes = ['김치볶음밥', '부대찌개']
user_indices = df[df['메뉴 이름'].isin(user_likes)].index.tolist()

user_vec = X[user_indices].mean(axis=0)
user_vec = np.asarray(user_vec)  # 이 부분이 핵심!
cos_sim = cosine_similarity(user_vec, X).flatten()

recommend_idx = [i for i in cos_sim.argsort()[::-1] if i not in user_indices][:10]

print("\n[추천 레시피 Top 10]")
for idx in recommend_idx:
    print(f"{df.iloc[idx]['메뉴 이름']} (유사도: {cos_sim[idx]:.2f})")
