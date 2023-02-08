-- Showing  the count and percentage of customers who have bought Premium Account
select sum(customer_type) as PremiumAccount,
	CAST(sum(customer_type) as float) / cast(COUNT(*) as float) as PremiumAccountPercentage
from MIS_Project.dbo.Customer

-- Showing the total sales of each City
select customer_city as City, count(*) as SalesAmount
from MIS_Project.dbo.Customer
group by customer_city

-- Showing average price of products in each category
select product_type as ProductType,
	round(AVG(cast(product_price as float)), 0) as PriceAverage
from mis_project.dbo.Product
group by product_type

-- Showing the price of each order
select i.order_id as OrderId
	, SUM(p.product_price * i.quantity) as OrderPrice
from MIS_Project.dbo.Product p Join MIS_Project.dbo.Invoice i
on p.product_id = i.product_id
group by i.order_id
order by 1

-- Showing average delivery duration for each city
select c.customer_city as City,
	CONCAT(round(AVG(o.delivery_duration), 2), ' day') as DeliveryDuration
from MIS_Project.dbo.Customer c Join MIS_Project.dbo.Customer_Order o
on c.customer_id = o.customer_id
Group by  c.customer_city
Order by 2 Desc

-- Showing the most common reason of returning orders
select failed_reason as Reason,
	count(*) as Amount,
	round(cast(COUNT(*) as float) / cast((select count(*)
										  from MIS_Project.dbo.Customer_Order
										  where delivery_status Like 'Not%') as float) * 100, 2) as PercentageAmount
from MIS_Project.dbo.Customer_Order
where delivery_status like 'Not%'
Group by failed_reason
Order by 2 Desc

-- Showing mistake rate of each biker
select o.biker_id as BikerId,
	   d.biker_name as BikerName,
	   round(cast(count(*) as float) / cast((select count(*)
									   from MIS_Project.dbo.Customer_Order
									   where failed_reason Like '%Delivery%') as float) * 100,2) as MistakeRate,
	   d.delivery_vehicle as BikerVehicle
from MIS_Project.dbo.Customer_Order o Join MIS_Project.dbo.Delivery d
on o.biker_id = d.biker_id
where o.failed_reason Like '%Delivery%'
group by o.biker_id, d.biker_name, d.delivery_vehicle
Order by 3 Desc

-- Showing the fill rate of each warehouse
select s.store_id, s.store_capacity as capacity, count(*) as ProductAmount,
	   round(cast(count(*) as float) / cast(s.store_capacity as float) * 100, 2) as FillRate
from MIS_Project.dbo.Product p Join MIS_Project.dbo.Store s
on p.store_id=s.store_id
group by s.store_id, s.store_capacity
Order by 4 Desc

-- Showing the amount of products supplied by each supplier(ActivityRate)
select s.supplier_id as SupplierId, s.supplier_name as SupplierName,
	   count(*) as ProductCount,
	   round(cast(count(*) as float) / cast((select COUNT(*) from MIS_Project.dbo.Product) as float) * 100, 2) as ActivityRate
from MIS_Project.dbo.Product p Join MIS_Project.dbo.Supplier s
on p.supplier_id = s.supplier_id
Group by s.supplier_id, s.supplier_name
Order by 4 Desc

-- Showing the order number of each month
select SUBSTRING(order_date, 1, 4) as OrderYear,
	   SUBSTRING(order_date, 6, 1) as OrderMonth,
	   count(*) as OrderCount
from MIS_Project.dbo.Customer_Order
Group by SUBSTRING(order_date, 1, 4), SUBSTRING(order_date, 6, 1)
Order by 1


-- Showing the variety of paying methods
select payment_type as PaymentType, Count(*) as OrderCount, 
	   round(cast(count(*) as float) / cast((select count(*) from MIS_Project.dbo.Customer_Order) as float) * 100, 2) as OrderPercentage
from MIS_Project.dbo.Customer_Order
Group by payment_type