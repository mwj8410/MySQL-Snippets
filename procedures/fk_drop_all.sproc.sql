DROP PROCEDURE IF EXISTS fk_drop_all;
DELIMITER //

CREATE PROCEDURE fk_drop_all(IN param_table_schema VARCHAR(255))
BEGIN

DECLARE done INT DEFAULT 0;
DECLARE table_name VARCHAR(255);
DECLARE curs CURSOR FOR
	SELECT
		TABLE_NAME
	FROM information_schema.columns
	WHERE
		TABLE_SCHEMA = param_table_schema
		AND
		COLUMN_NAME IN (SELECT table_name FROM information_schema.tables WHERE table_schema = param_table_schema)
	ORDER BY table_name,ordinal_position
;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

OPEN curs;
REPEAT
	FETCH curs INTO table_name;
	IF NOT done THEN
		CALL fk_drop_all_on_table(@table_name);
	END IF;
UNTIL done END REPEAT;
CLOSE curs;

END //
DELIMITER ;
