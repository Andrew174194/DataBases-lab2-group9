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

#print(m)

nice = {}

geolocator = Nominatim(user_agent="db")

print(m)

for i in m:
        try:
                location = geolocator.geocode(i[0].split(',')[1][1:-2])
                nice[i[0].split(',')[0][1:]] = (location.latitude, location.longitude)
        except Exception as e:
                print(e)
                nice[i[0].split(',')[0][1:]] = (0, 0)

cur.execute('''alter table address add column if not exists latitude varchar;''')
cur.execute('''alter table address add column if not exists longtitude varchar;''')

print(nice)

for k in nice.keys():
        cur.execute('''update address set latitude={latitude}, longtitude={longtitude} where address_id={address_id};'''.format(latitude=nice[k][0], longtitude=nice[k][1], address_id=k))

con.commit()

# close db connection
cur.close()
con.close()
