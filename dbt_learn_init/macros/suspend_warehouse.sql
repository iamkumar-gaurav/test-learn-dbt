{% macro suspend_warehouse(warehouse_name) %}
    {% set sql %}
        -- Suspend the warehouse to save costs
        ALTER WAREHOUSE {{ warehouse_name }} SUSPEND;
    {% endset %}
    {% set table = run_query(sql) %}
    {% do print(table) %}
{%endmacro %}