{{ config(materialized='incremental' ,
         unique_key='constructed_time')
         }}
-- Selects all columns from TIME_DIM and adds a constructed_time column.
-- Filters to only return rows where the time is less than or equal to the current time of day.
WITH CURRRENT_CTE AS (
SELECT *,to_time(concat(T_HOUR::varchar, ':', T_MINUTE::varchar, ':', T_SECOND::varchar)) as constructed_time
from SNOWFLAKE_SAMPLE_DATA.TPCDS_SF10TCL.TIME_DIM
)
SELECT * FROM CURRRENT_CTE WHERE constructed_time <=CURRENT_TIME()

{% if is_incremental() %}
  AND constructed_time > (SELECT MAX(constructed_time) FROM {{ this }})
{% endif %}