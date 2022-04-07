-- find all users whose bill of books and electrics >= 40% total bill
-- first idea
with 
x as ( -- find: | user | product | bill | totalBill
select o.user_id as uid, o.product_id as pid, o.bill as bill, (sum(bill) over (partition by o.user_id)) as totalBill from test.order o
),
y as ( -- filter only product of Books/ Electricities, calculate necessary sum , percentage
select u.id, u.fname, u.lname, (sum(bill) over (partition by id))/x.totalBill percent from test.user u
inner join x on u.id = x.uid 
inner join test.product p on p.id = x.pid
inner join test.category c on c.id = p.category_id
where c.name = "Books" or c.name = "Electrics"
)
select distinct * from y where percent >= 0.4;
-- second idea (way better)
select o.user_id as uid, sum(case when c.name = "Books" or c.name = "Electrics" then bill else 0 end) xbill, sum(bill) as totalBill
from  test.order o
inner join test.user u on o.user_id = u.id
inner join test.product p on o.product_id = p.id
inner join test.category c on c.id = p.category_id
group by uid;

-- find all users whose order has avgPrice >= 30 (avgPrice = totalCost/numberOfItems)
select o.user_id uid, sum(o.bill)/count(*) avgPricePerItem from test.order o group by user_id having avgPricePerItem >= 30;
