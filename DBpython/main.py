import pandas as pd

# 1. 전체 레시피 CSV 읽기
df = pd.read_csv('recipe_all_cleaned.csv')

# 2. 필요한 열만 선택 (원하는 column명만 리스트에)
cols = [
    '메뉴 이름',            # 메뉴 이름
    '방법 분류',          # 방법 분류
    '국가 분류',          # 국가 분류
    '테마 분류',           # 테마 분류
    '주재료 이름'         # 분량
]

# 3. 해당 열만 추출
filtered_df = df[cols]

# 4. 새 CSV 파일로 저장
filtered_df.to_csv('filtered_recipes_new.csv', index=False)
