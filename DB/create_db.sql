-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mock-nequi
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mock-nequi
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mock-nequi` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mock-nequi` ;

-- -----------------------------------------------------
-- Table `mock-nequi`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mock-nequi`.`users` (
  `iduser` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name_user` VARCHAR(100) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `pass` VARCHAR(40) NOT NULL,
  `datecreated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`iduser`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 4
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mock-nequi`.`accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mock-nequi`.`accounts` (
  `idaccount` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_account` ENUM('ahorros', 'colchon', 'bolsillos', 'metas') NOT NULL,
  `balance` DOUBLE NOT NULL DEFAULT '0',
  `name_account` VARCHAR(25) NULL DEFAULT NULL,
  `goal_date` DATE NULL DEFAULT NULL,
  `goal_balance` DOUBLE NULL DEFAULT NULL,
  `datecreated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `iduser` INT(10) UNSIGNED NOT NULL,
  `status_account` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`idaccount`),
  INDEX `fk_account_user_idx` (`iduser` ASC) VISIBLE,
  CONSTRAINT `fk_account_user`
    FOREIGN KEY (`iduser`)
    REFERENCES `mock-nequi`.`users` (`iduser`))
ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mock-nequi`.`movements`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mock-nequi`.`movements` (
  `idmovements` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `valor` DOUBLE NOT NULL DEFAULT '0',
  `balance` DOUBLE NOT NULL DEFAULT '0',
  `description` VARCHAR(100) NULL DEFAULT NULL,
  `type` TINYINT(4) NULL DEFAULT NULL,
  `iduser_sending` INT(10) UNSIGNED NOT NULL,
  `iduser_receiving` INT(10) UNSIGNED NOT NULL,
  `idaccount` INT(10) UNSIGNED NOT NULL,
  `datecreated` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idmovements`),
  INDEX `fk_movements_user1_idx` (`iduser_sending` ASC) VISIBLE,
  INDEX `fk_movements_user2_idx` (`iduser_receiving` ASC) VISIBLE,
  INDEX `fk_movements_account1_idx` (`idaccount` ASC) VISIBLE,
  CONSTRAINT `fk_movements_account1`
    FOREIGN KEY (`idaccount`)
    REFERENCES `mock-nequi`.`accounts` (`idaccount`),
  CONSTRAINT `fk_movements_user1`
    FOREIGN KEY (`iduser_sending`)
    REFERENCES `mock-nequi`.`users` (`iduser`),
  CONSTRAINT `fk_movements_user2`
    FOREIGN KEY (`iduser_receiving`)
    REFERENCES `mock-nequi`.`users` (`iduser`))
ENGINE = InnoDB
AUTO_INCREMENT = 116
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

USE `mock-nequi` ;

-- -----------------------------------------------------
-- function account_balance
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `account_balance`(
	`idaccount` INT

)
RETURNS double
LANGUAGE SQL
NOT DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	RETURN (ifnull((SELECT balance FROM movements m WHERE m.idaccount = idaccount ORDER BY m.idmovements DESC LIMIT 1),0));
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function account_id
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `account_id`(
	`iduser` INT

,
	`type_account` VARCHAR(50)

)
RETURNS int(11)
LANGUAGE SQL
DETERMINISTIC
READS SQL DATA
SQL SECURITY DEFINER
COMMENT ''
BEGIN
	return (select a.idaccount FROM accounts a WHERE a.type_account = type_account AND a.iduser = iduser LIMIT 1);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure create_user
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(
	IN `user_name` VARCHAR(100),
	IN `email` VARCHAR(50),
	IN `pass` VARCHAR(40)


)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT ''
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- rollback any changes made in the transaction
        RESIGNAL;  -- raise again the sql exception to the caller
    END;

	START TRANSACTION;
		INSERT INTO users (`name_user`, `email`, `pass`) VALUES (user_name, email, SHA1(pass));
		SET @user_id = LAST_INSERT_ID(); 
		INSERT INTO accounts (`type_account`, `iduser`) VALUES ('ahorros', @user_id);
		INSERT INTO accounts (`type_account`, `iduser`) VALUES ('colchon', @user_id);
	COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure movement_accounts
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `movement_accounts`(
	IN `iduser` INT,
	IN `account` INT
,
	IN `valor` DOUBLE

)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'pasar dinero entre todlas las cuentas del mismo usuario'
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- rollback any changes made in the transaction
        RESIGNAL;  -- raise again the sql exception to the caller
    END;

	START TRANSACTION;
		SET @iduser                    = iduser;
		SET @valor                     = valor;
		SET @account_id_sending        = account_id(@iduser, 'ahorros');
		SET @account_id_receiving      = account;
		SET @account_balance_sending   = (account_balance(@account_id_sending  ))  + @valor ;
		SET @account_balance_receiving = (account_balance(@account_id_receiving )) - @valor ;
		
		SET @account_name              = (SELECT a.type_account FROM accounts a WHERE a.idaccount = @account_id_receiving);
		SET @description_sending       = IF(@valor > 0,CONCAT('Ingreso desde ',@account_name),CONCAT('Envio a ',@account_name));
		SET @description_receiving     = IF(@valor < 0,'Ingreso desde cuenta','Envio a cuenta');
		
		INSERT INTO movements (`valor`, `balance`, `description`, `iduser_sending`, `iduser_receiving`, `idaccount`) 
				 VALUES ( @valor, @account_balance_sending, @description_sending, @iduser, @iduser, @account_id_sending );
										
		INSERT INTO movements (`valor`, `balance`, `description`, `iduser_sending`, `iduser_receiving`, `idaccount`) 
				 VALUES ( -@valor, @account_balance_receiving, @description_receiving, @iduser, @iduser, @account_id_receiving);
		
		UPDATE accounts SET `balance`= @account_balance_sending   WHERE  `idaccount`= @account_id_sending;
		UPDATE accounts SET `balance`= @account_balance_receiving WHERE  `idaccount`= @account_id_receiving ;
	COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure movement_account_deposit
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `movement_account_deposit`(
	IN `iduser` INT,
	IN `valor` DOUBLE



)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'meter y sacar dinero de la cuenta de ahorrros'
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- rollback any changes made in the transaction
        RESIGNAL;  -- raise again the sql exception to the caller
    END;

	START TRANSACTION;
		SET @valor = valor;
		SET @iduser = iduser;
		SET @idaccount = account_id(@iduser ,'ahorros');
		SET @balance   = (account_balance(@idaccount ) + @valor );
		
		INSERT INTO movements (`valor`, `balance`, `description`, `iduser_sending`, `iduser_receiving`, `idaccount`) 
		VALUES (@valor, @balance, IF(@valor > 0,'Ingreso a cuenta','Retiro de cuenta') , @iduser, @iduser, @idaccount);
		
		UPDATE accounts SET `balance`= @balance WHERE  `idaccount`= @idaccount;
	COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure tranfer_to_account
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `tranfer_to_account`(
	IN `idaccount_sending` INT,
	IN `email_user_receiving` VARCHAR(50),
	IN `valor` DOUBLE






)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'para transferir dinero de una cuenta de ahorrros a otra usando el email'
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- rollback any changes made in the transaction
        RESIGNAL;  -- raise again the sql exception to the caller
    END;


	START TRANSACTION;
		SET @iduser_sending            = (SELECT a.iduser FROM accounts a WHERE a.idaccount = idaccount_sending LIMIT 1);
		SET @iduser_receiving          = (SELECT u.iduser FROM users u WHERE u.email = email_user_receiving  LIMIT 1);
		SET @valor                     = valor;
		SET @account_id_sending        = idaccount_sending;
		SET @account_id_receiving      = account_id(@iduser_receiving ,'ahorros');
		SET @account_balance_sending   = (account_balance(idaccount_sending   ) - @valor );
		SET @account_balance_receiving = (account_balance(@account_id_receiving ) + @valor );

	    IF valor < 0 THEN
	        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se aceptan valores negativos', MYSQL_ERRNO = 2000;
	    END IF;
		
		INSERT INTO movements (`valor`, `balance`, `description`, `iduser_sending`, `iduser_receiving`, `idaccount`) 
				 VALUES ( -@valor, @account_balance_sending, 'Enviado a usuario',
				  @iduser_sending, @iduser_receiving, @account_id_sending );
										
		INSERT INTO movements (`valor`, `balance`, `description`, `iduser_sending`, `iduser_receiving`, `idaccount`) 
				 VALUES ( @valor, @account_balance_receiving, 'Recibido de usuario',
				  @iduser_sending, @iduser_receiving, @account_id_receiving);
		
		UPDATE accounts SET `balance`= @account_balance_sending   WHERE  `idaccount`= @account_id_sending;
		UPDATE accounts SET `balance`= @account_balance_receiving WHERE  `idaccount`= @account_id_receiving ;
	COMMIT;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure disable_account
-- -----------------------------------------------------

DELIMITER $$
USE `mock-nequi`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `disable_account`(
	IN `idaccount_desable` INT

)
LANGUAGE SQL
NOT DETERMINISTIC
CONTAINS SQL
SQL SECURITY DEFINER
COMMENT 'deshabilita la cuenta para que no sea usada, devuelve todo el saldo a la cuenta principal'
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;  -- rollback any changes made in the transaction
        RESIGNAL;  -- raise again the sql exception to the caller
    END;

	START TRANSACTION;
		SET @iduser    = (SELECT a.iduser  from accounts a WHERE a.idaccount = idaccount_desable);
		SET @valor     = (SELECT a.balance from accounts a WHERE a.idaccount = idaccount_desable);
		
		CALL movement_accounts(@iduser, idaccount_desable, @valor);
		
		UPDATE accounts SET status_account = 0 WHERE  idaccount = idaccount_desable;
	COMMIT;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
