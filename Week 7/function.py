import psycopg2
from faker import Faker
con = psycopg2.connect(database="postgres", user="postgres",
                       password="postgres", host="127.0.0.1", port="5432")

print("Database opened successfully")
cur = con.cursor()

# time to create our function
cur.execute('''create or replace function retrieve()
returns table(address varchar)
as
$$
begin
   return query select address.address from address where address.address like '%11%' and city_id between 400 and 600;
end;
$$
language plpgsql;''')

print('Status of creation of function:')
print(cur.fetchone()[0], end='\n\n')

cur.execute('''select retrieve();''')
print('Retrieved data:')
print(cur.fetchone()[0], end='\n\n')

con.commit()

# close db connection
cur.close()
con.close()
