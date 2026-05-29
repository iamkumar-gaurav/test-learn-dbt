-- cumulative_orders_by_date: Cumulative sales by order date from TPCH_SF1.ORDERS
{{ config(materialized='table') }}
SELECT
    o_orderdate,
    SUM(o_totalprice) AS daily_sales,
    SUM(SUM(o_totalprice)) OVER (ORDER BY o_orderdate) AS cumulative_sales
FROM "SNOWFLAKE_SAMPLE_DATA"."TPCH_SF1"."ORDERS"
GROUP BY o_orderdate
ORDER BY o_orderdate