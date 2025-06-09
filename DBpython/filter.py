import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer

# 1. 필요한 컬럼만 있는 csv 불러오기
df = pd.read_csv('filtered_recipes_new.csv')

# 2. 합칠 컬럼 리스트 지정 (예시: 한글로 수정)
cols_to_combine = [
    '메뉴 이름',            # 메뉴 이름
    '방법 분류',          # 방법 분류
    '국가 분류',          # 국가 분류
    '테마 분류',           # 테마 분류
    '주재료 이름'         # 분량
]

# 3. 결측치(NaN) 방지: 모두 문자열로, NaN은 빈칸 처리
df[cols_to_combine] = df[cols_to_combine].fillna('')

# 4. 한 행의 여러 속성을 문자열로 합치기 (' '로 구분)
df['features'] = df[cols_to_combine].apply(lambda row: ' '.join(row.values.astype(str)), axis=1)

# 5. 결과 확인
print(df[['메뉴 이름', 'features']].head(3))

# 1. features 컬럼 벡터화
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(df['features'])

print("벡터 shape:", X.shape)  # (레시피 개수, 고유단어 수)

df.to_csv('recipes_with_features_new_v2.csv', index=False)