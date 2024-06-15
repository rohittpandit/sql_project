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


select pizza_types.category, sum(order_details.quantity) as total_qty from order_details
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category
order by total_qty
desc;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join pizza_types on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category;


-- Determine the distribution of orders by hour of the day.


 