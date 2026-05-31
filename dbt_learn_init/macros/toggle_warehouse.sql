{% macro toggle_warehouse(warehouse_name) %}
  -- Query Snowflake metadata to check the current warehouse status
  {% set check_status_sql %}
    SHOW WAREHOUSES LIKE '{{ warehouse_name.upper() }}';
  {% endset %}
  
  {% set results = run_query(check_status_sql) %}
  
  {% if execute and results and results.rows %}
    -- Print the query results table to the CLI terminal logs
    {% do results.print_table() %}

    -- Get the value of the 'state' column from the first matching row
    {% set current_state = results.columns['state'][0] | upper %}
    
    {% if current_state == 'SUSPENDED' %}
      {% set resume_sql %}
        ALTER WAREHOUSE {{ warehouse_name }} RESUME IF SUSPENDED;
      {% endset %}
      {% do run_query(resume_sql) %}
      {{ log("Warehouse " ~ warehouse_name ~ " was SUSPENDED. It has now been RESUMED.", info=True) }}
      
    {% elif current_state == 'STARTED' %}
      {% set suspend_sql %}
        ALTER WAREHOUSE {{ warehouse_name }} SUSPEND;
      {% endset %}
      {% do run_query(suspend_sql) %}
      {{ log("Warehouse " ~ warehouse_name ~ " was STARTED. It has now been SUSPENDED.", info=True) }}
      
    {% else %}
      {{ log("Warehouse " ~ warehouse_name ~ " is in an unhandled state: " ~ current_state, info=True) }}
    {% endif %}
    
  {% else %}
    {{ log("Warehouse " ~ warehouse_name ~ " could not be found or verified.", info=True) }}
  {% endif %}
{% endmacro %}
