import psycopg2
from faker import Faker
from tqdm import tqdm

con = psycopg2.connect(database="customers", user="postgres",
                       password=[REDACTED], host="127.0.0.1", port="5432")
table = "CUSTOMER_1"

print("Database opened successfully")
cur = con.cursor()
cur.execute('''CREATE TABLE ''' + table + '''  
       (ID INT PRIMARY KEY     NOT NULL,
       Name           TEXT    NOT NULL,
       Address            TEXT     NOT NULL,
       review        TEXT);''')
print("Table " + table + " created successfully")

fake = Faker()
for i in tqdm(range(250000)):
    cur.execute("INSERT INTO " +table + " (ID,Name,Address,review) VALUES ('"+ str(i)+"','"+fake.name()+"','"+fake.address()+"','"+fake.text()+"')")
    con.commit()

