/*This query calculates the total purchase amount per customer from the TPC-H sample dataset.

Joins CUSTOMER to ORDERS on c_custkey
Groups by customer key, name, and nation
Sums o_totalprice for each customer
Filters out customers with no orders (HAVING > 0)
The result is a list of customers who have placed orders, along with their nation and total spending.*/

{{ config(materialized='table') }}
SELECT
    c.c_custkey,
    c.c_name,
    c.c_nationkey AS nation,
    SUM(o.o_totalprice) AS total_order_price
FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER c
LEFT JOIN SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.ORDERS o
    ON c.c_custkey = o.o_custkey
GROUP BY c.c_custkey, c.c_name, c.c_nationkey
HAVING SUM(o.o_totalprice) > 0

