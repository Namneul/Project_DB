import pandas as pd
import ast

df = pd.read_csv('recipes_with_features_new_v2.csv')

# 리스트 형태의 컬럼명
list_cols = ['방법 분류', '주재료 이름']

# 리스트 컬럼을 문자열에서 실제 리스트로 변환 + 공백으로 합침
for col in list_cols:
    df[col] = df[col].apply(lambda x: ' '.join(ast.literal_eval(x)) if pd.notnull(x) else '')

# features 재생성
cols_to_combine = [
    '메뉴 이름',  # 메뉴 이름
    '방법 분류',  # 방법 분류
    '국가 분류',  # 국가 분류
    '테마 분류',  # 테마 분류
    '주재료 이름'  # 분량
]
df[cols_to_combine] = df[cols_to_combine].fillna('')
df['features'] = df[cols_to_combine].apply(lambda row: ' '.join(row.values.astype(str)), axis=1)

df.to_csv('recipes_with_features_new_v3.csv', index=False)
print(df[['메뉴 이름', 'features']].head())
