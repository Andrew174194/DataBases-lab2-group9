create or replace function test()
returns table(address varchar)
as
$$
begin
   return query select address.address from address where address.address like '%11%' and city_id between 400 and 600;
end;
$$
language plpgsql;
