import os
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client
import pandas as pd

load_dotenv(Path(__file__).parent / ".env")

supabase = create_client(os.getenv("SUPABASE_URL"), os.getenv("SUPABASE_KEY"))
response = supabase.table('sales').select('*').execute()
df = pd.DataFrame(response.data)

# Põhistatistika — nagu SQL SELECT COUNT, SUM, AVG
print("Total Revenue:", df['total_price'].sum())
print("Average Order:", df['total_price'].mean())
print("Number of Customers:", df['customer_id'].nunique())

# 1. Leia TOP 5 toodet kogukäibe järgi
top_products = df.groupby('product_name')['total_price'].sum().nlargest(5)
print(top_products)
# 2. Leia klient suurima kogukulutusega
top_customer = df.groupby('customer_id')['total_price'].sum().idxmax()
print("Top customer:", top_customer)