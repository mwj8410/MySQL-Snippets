SELECT
  *
FROM information_schema.table_constraints
WHERE
  table_schema = 'api' AND
  constraint_type = 'FOREIGN KEY'
;
