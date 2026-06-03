import pandas as pd
from sqlalchemy import create_engine
import matplotlib.pyplot as plt

# PostgreSQL connection (өз пароліңді жаз)
engine = create_engine("postgresql+psycopg2://postgres:123123@localhost:5432/shop_analytics")

# data жүктеу
df = pd.read_sql("SELECT sale_date, total_amount FROM sales", engine)

df['sale_date'] = pd.to_datetime(df['sale_date'])
df = df.set_index('sale_date')

# 1. күнделікті түсім
daily = df.resample('D').sum()

# 2. жинақталған сумма
daily['cumsum'] = daily['total_amount'].cumsum()

# 3. 7 күндік орташа
daily['rolling'] = daily['total_amount'].rolling(7).mean()

# ===== GRAPH =====
plt.figure(figsize=(12,8))

# Жоғары график
plt.subplot(2,1,1)
plt.bar(daily.index, daily['total_amount'], label="Daily Revenue")
plt.plot(daily.index, daily['rolling'], color='red', label="7-day average")
plt.legend()
plt.title("Sales Analysis")

# Төменгі график
plt.subplot(2,1,2)
plt.fill_between(daily.index, daily['cumsum'], color='skyblue')
plt.title("Cumulative Revenue")

plt.tight_layout()
plt.show()
