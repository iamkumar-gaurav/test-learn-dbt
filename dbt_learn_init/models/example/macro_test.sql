select 
  c_custkey, 
  c_mktsegment,
  {{ renaming_col('c_mktsegment') }} as Adjusted_mktsegment
from 
  {{ source('snowflake', 'customer') }}
