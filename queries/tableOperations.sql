-- Check if a table exists
SHOW TABLES LIKE ?;

-- Alternatively
SELECT
  * 
FROM
  information_schema.tables
WHERE
  table_schema = ?
  AND
  table_name = ?
LIMIT 1;

