DROP PROCEDURE IF EXISTS audit_find_unused_cols;
DELIMITER //

CREATE PROCEDURE audit_find_unused_cols(db_name VARCHAR(255))
BEGIN

DECLARE done INT DEFAULT FALSE;
DECLARE tableName VARCHAR(255);
DECLARE columnName VARCHAR(255);
DECLARE colCur CURSOR FOR
    SELECT
		TABLE_NAME,
		COLUMN_NAME
	FROM `INFORMATION_SCHEMA`.`COLUMNS`
	WHERE
		TABLE_SCHEMA = db_name;

DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

DROP TABLE IF EXISTS sum_totals;
CREATE TEMPORARY TABLE sum_totals (
	tbl VARCHAR(255),
    col VARCHAR(255),
    ttl INT(10)
);
OPEN colCur;

read_loop: LOOP
    FETCH colCur INTO tableName, columnName;
    IF done THEN
        LEAVE read_loop;
    END if;

    SET @q = CONCAT('INSERT INTO sum_totals ( tbl, col, ttl ) VALUES ( "', tableName, '", "', columnName, '", (SELECT COUNT(', columnName, ') FROM ', tableName, ' WHERE ', columnName, ' IS NOT NULL ) )'); 
	PREPARE stmt FROM @q;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
END LOOP;

CLOSE colCur;

SELECT * FROM sum_totals WHERE ttl = 0;

DROP TABLE sum_totals;
END //
DELIMITER ;
