-- find user_id that has invalid order (user_id in order but not in user)
select user_id from test.order o where o.user_id not in (select id from test.user);

-- find product name that has invalid order (user_id in order but not in user)
-- create a view of table of ids, join with table of details, get details  
with x as (
select o.product_id as pid, o.user_id as uid from test.order o where o.user_id not in (select id from test.user)
) select p.name from test.product p inner join x on p.id = x.pid;

-- find product of user named "mo"
-- create a view of ids, join with other tables of details, get details
with x as (
select o.product_id as pid, o.user_id as uid from test.order o inner join test.user u on o.user_id = u.id where u.fname = "mo"
) select u.fname, u.lname, p.name from test.product p inner join x on p.id = x.pid inner join test.user u on u.id = x.uid;
