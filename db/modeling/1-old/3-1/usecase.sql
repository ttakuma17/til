-- 持ち帰り注文の一覧表示
select products.name, quantity
from orders
         join order_details on orders.id = order_details.order_id
         join products on order_details.product_id = products.id
where order_id = 1;

-- 合計皿数表示
select sum(quantity) as 合計皿数
from orders
         join order_details on orders.id = order_details.order_id
where order_id = 1;

-- 皿寿司の売上ランキングTOP3
select
    products.id, products.name, SUM(quantity) as count
from order_details
         join products on order_details.product_id = products.id
group by products.name, products.id
order by count desc
