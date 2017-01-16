-- SPROC for safely removing an FK constraint
-- Captured from StackOverflow: http://stackoverflow.com/questions/17161496/drop-foreign-key-only-if-it-exists
-- wich was captured from: http://simpcode.blogspot.com.ng/2015/03/mysql-drop-foreign-key-if-exists.html

DROP PROCEDURE IF EXISTS DROP_FK;

DELIMITER //

CREATE PROCEDURE DROP_FK(IN tableName VARCHAR(64), IN constraintName VARCHAR(64))
BEGIN
	IF EXISTS(
		SELECT *
		FROM information_schema.table_constraints
		WHERE 
			table_schema = DATABASE() AND
			table_name = tableName AND
			constraint_name = constraintName AND 
			constraint_type = 'FOREIGN KEY'
	)
	THEN
		SET @query = CONCAT('ALTER TABLE ', tableName, ' DROP FOREIGN KEY ', constraintName, ';');
		PREPARE stmt FROM @query; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 
END//

DELIMITER ;
