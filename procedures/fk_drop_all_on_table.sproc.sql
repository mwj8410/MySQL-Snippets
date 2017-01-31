-- SPROC for safely removing all FK constraints on a single table
-- Captured from StackOverflow: http://stackoverflow.com/questions/13733281/drop-all-foreign-keys-in-mysql-database

DROP PROCEDURE IF EXISTS fk_drop_all_on_table;
DELIMITER //

CREATE PROCEDURE fk_drop_all_on_table(IN param_table_schema VARCHAR(255), IN param_table_name varchar(255))
BEGIN

DECLARE done INT default FALSE;
DECLARE dropCommand VARCHAR(255);
DECLARE dropCur cursor for
    SELECT concat('alter table ',table_schema,'.',table_name,' DROP FOREIGN KEY ',constraint_name, ';')
    FROM information_schema.table_constraints
    WHERE constraint_type='FOREIGN KEY'
        AND table_name = param_table_name
        AND table_schema = param_table_schema;

DECLARE continue handler for NOT found SET done = true;

OPEN dropCur;

read_loop: loop
    fetch dropCur INTO dropCommand;
    if done THEN
        leave read_loop;
    END if;
    SET @sdropCommand = dropCommand;

    PREPARE dropClientUpdateKeyStmt FROM @sdropCommand;
    EXECUTE dropClientUpdateKeyStmt;
    DEALLOCATE PREPARE dropClientUpdateKeyStmt;
END loop;

CLOSE dropCur;

END //
DELIMITER ;
