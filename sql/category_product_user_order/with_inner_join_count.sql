-- select name from users that has at least 2 order of category "Books" or "Hats"
with 
x as (
select u.fname as name, c.name as category_name from test.user u 
inner join test.order o on u.id = o.user_id
inner join test.product p on p.id = o.product_id
inner join test.category c on c.id = p.category_id
where c.name in ("Books", "Hats")
),
y as (select name, count(*) num from x group by name)
select name from y where num >=2;

