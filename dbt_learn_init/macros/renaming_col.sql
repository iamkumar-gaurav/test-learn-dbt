{% macro renaming_col(Columns_name) %}
    -- This macro categorizes the input column value into one of two segments.
    -- If the value is one of the listed categories, it returns 'SEGMENT 1'.
    -- Otherwise, it returns 'SEGMENT 2'.
    CASE
        WHEN {{Columns_name}} in ('BUILDING', 'FURNITURE', 'HOUSEHOLD') THEN 'SEGMENT 1'
        ELSE 'SEGMENT 2'
    END
{% endmacro %}