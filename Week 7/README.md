```sql
postgres=# select concat(address,':',latitude,':',longtitude) from address where address.address like '%11%' and city_id between 400 and 600;;
                            concat                             
---------------------------------------------------------------
 1133 Rizhao Avenue:35.092307:119.2624129
 1197 Sokoto Boulevard:13.0610588:5.2373194
 1152 al-Qatif Lane:26.616667:49.933333
 1176 Southend-on-Sea Manor:51.5364227:0.6900118
 1101 Bucuresti Boulevard:47.6461295:23.53305023147744
 1103 Quilmes Boulevard:-34.66153524897959:-58.639474587755096
 1411 Lillydale Drive:37.6764972:-81.6632312
 1121 Loja Avenue:-13.0712346:-55.91418188770646
 117 Boa Vista Way:-14.891852799999999:-40.8374381
 1103 Bilbays Parkway:30.4:31.5
 1192 Tongliao Street:43.6026008:122.265625
 1145 Vilnius Manor:43.655417:-79.45841823780488
 114 Jalib al-Shuyukh Manor:0:0
 1191 Tandil Drive:-38.9678907:-68.0334429
(14 rows)
````
