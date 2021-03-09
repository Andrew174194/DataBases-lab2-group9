import psycopg2
from faker import Faker
from geopy.geocoders import Nominatim
con = psycopg2.connect(database="postgres", user="postgres",
                       password="postgres", host="127.0.0.1", port="5432")

print("Database opened successfully")
cur = con.cursor()

# time to create our function
cur.execute('''create or replace function retrieve()
returns table(address_id integer, address varchar)
as
$$
begin
   return query select address.address_id, address.address from address where address.address like '%11%' and city_id between 400 and 600;
end;
$$
language plpgsql;''')

cur.execute('''select retrieve();''')
m = cur.fetchall()

print(m)

geolocator = Nominatim(user_agent="db")

for i in m:
        try:
                location = geolocator.geocode(i[0].split(',')[1][1:-2])
                print((location.latitude, location.longitude))
        except Exception:
                print((0,0))

cur.execute('''alter table address add column if not exists latitude varchar;''')
cur.execute('''alter table address add column if not exists longtitude varchar;''')
con.commit()

# close db connection
cur.close()
con.close()
