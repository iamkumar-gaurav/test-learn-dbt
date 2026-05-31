{% macro suspend_warehouse_safely(warehouse_name) %}
  -- Query Snowflake metadata to check the current warehouse status
  {% set check_status_sql %}
    SHOW WAREHOUSES LIKE '{{ warehouse_name.upper() }}';
  {% endset %}
  
  {% set results = run_query(check_status_sql) %}
  
  {% if execute and results %}
    -- Get the value of the 'state' column (usually index 1)
    {% set current_state = results.columns['state'][0] %}
    
    {% if current_state == 'STARTED' %}
      {% set suspend_sql %}
        ALTER WAREHOUSE {{ warehouse_name }} SUSPEND;
      {% endset %}
      {% do run_query(suspend_sql) %}
      {{ log("Warehouse " ~ warehouse_name ~ " has been suspended successfully.", info=True) }}
    {% else %}
      {{ log("Warehouse " ~ warehouse_name ~ " is already in state: " ~ current_state ~ ". Skipping suspend operations.", info=True) }}
    {% endif %}
  {% endif %}
{% endmacro %}
