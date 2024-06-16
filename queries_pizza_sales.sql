-- Reterieve the total no of orders placed.

select count(order_id) as "Total order placed" from orders;

-- Calculate the total revenue generated from pizza sales

select * from order_details;
select * from pizzas;

select sum(order_details.quantity * pizzas.price) as "Total Price" from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.

select pizza_types.name, pizza_types.category, pizzas.price from pizzas
join pizza_types
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price 
desc limit 5;


-- Identify the most common pizza size ordered.

select pizzas.size, count(pizzas.size) as "Total ordered"  from order_details
join pizzas
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by pizzas.size
limit 1;


-- List the top 5 most ordered pizza types along with their quantities.
select * from pizza_types;

select pizza_types.name, sum(order_details.quantity) as total_qty from order_details
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by total_qty
desc limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category;


-- Determine the distribution of orders by hour of the day.



select  hour(time) as hours, count(order_id) as "total orderes" from orders group by hour(time) order by count(order_id) desc;

-- Determine the distribution of order by weekdays.

select dayname(date) as weekdays, count(order_id) from orders group by weekdays order by count(order_id) desc;


-- Group the orders by date and calculate the average number of pizzas quantity ordered per day.

select avg(qty) from 
(select orders.date, sum(order_details.quantity) as qty from order_details
join orders on orders.order_id = order_details.order_id
group by orders.date) as total_qty;

-- Determine the top 3 most ordered pizzas name based on revenue.

select pizza_types.name, sum(order_details.quantity * pizzas.price) as rev_perpizza from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by rev_perpizza
desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.


select pizza_types.name, concat(round(((sum(order_details.quantity * pizzas.price)*100)/ (select sum(pizzas.price * order_details.quantity) from order_details join pizzas on pizzas.pizza_id = order_details.pizza_id)),2), " %") as percent_contri from order_details
join pizzas on order_details.pizza_id =  pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.name
order by percent_contri
desc;

-- Analyze the cumulative revenue generated over time.


select aggr_revenue.date, sum(sales) over(order by aggr_revenue.date) as cum_revenue from
(select orders.date , sum(pizzas.price * order_details.quantity) as sales from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.date) as aggr_revenue;


-- Determine the top 3 most ordered pizza name based on revenue for each pizza category.

select * from
(select *, rank() over(partition by category order by revenue desc) as rn  from
(select pizza_types.category, pizza_types.name, sum(order_details.quantity * pizzas.price) as revenue from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category, pizza_types.name) as cat) as a 
where rn = 1;







 
