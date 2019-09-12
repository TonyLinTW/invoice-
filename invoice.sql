DROP DATABASE IF EXISTS invoice;
CREATE DATABASE invoice;
USE invoice; #set a default data base

CREATE TABLE invoiceheader ( invoicenum VARCHAR(8), invoicedate DATE, invoiceamount FLOAT(1) );
CREATE TABLE invoicedetail ( invoicenum VARCHAR(8), trackingno VARCHAR(18), detailamount FLOAT(1) );
CREATE TABLE invoicecharges ( invoicenum VARCHAR(8), trackingno VARCHAR(18), chargetype VARCHAR(3), chargeamount FLOAT(1));

INSERT INTO invoiceheader
	(invoicenum, invoicedate, invoiceamount) 
VALUES 
	('00551198', '2014-01-01', 150.5),
    ('00551199', '2014-01-02', 10);
    
INSERT INTO invoicedetail
	(invoicenum, trackingno, detailamount)
VALUES
	('00551198', '1Z2F12346861507266', 50),
    ('00551198', '1Z2F12346861507267', 80),
    ('00551198', '1Z2F12346861507268', 20.5),
    ('00551199', '1Z2F12346861503423', 10.5);
    
INSERT INTO invoicecharges
	(invoicenum, trackingno, chargetype, chargeamount)
VALUES
	('00551198', '1Z2F12346861507266', 'FRT', 40),
    ('00551198', '1Z2F12346861507266', 'FUE', 11),
    ('00551198', '1Z2F12346861507267', 'FRT', 65),
    ('00551198', '1Z2F12346861507267', 'FUE', 17),
    ('00551198', '1Z2F12346861507268', 'FRT', 10),
    ('00551198', '1Z2F12346861507268', 'FUE', 5),
    ('00551198', '1Z2F12346861507268', 'HAZ', 5.5),
    ('00551199', '1Z2F12346861503423', 'FRT', 8),
    ('00551199', '1Z2F12346861503423', 'FUE', 2.5);


### Report 1
DELIMITER //

DROP PROCEDURE IF EXISTS report1 //

CREATE PROCEDURE 
  report1( _begin DATE, _end DATE)
BEGIN  
   SELECT * 
   FROM invoiceheader
   WHERE (invoicedate BETWEEN _begin AND _end);  
    
    SELECT SUM(invoiceamount) AS total_amount, COUNT(invoicenum) AS nums_of_invoices 
    FROM invoiceheader
    WHERE (invoicedate BETWEEN _begin AND _end);
    
    
END 
//

DELIMITER ;

call report1( '2013-01-01', '2014-01-2' )


### Report 2
DELIMITER //

DROP PROCEDURE IF EXISTS report2 //

CREATE PROCEDURE 
  report2( _begin DATE, _end DATE)
BEGIN  
   SELECT a.invoicenum, b.invoicedate, b.invoiceamount, x.detailamount_total, (b.invoiceamount-x.detailamount_total) as discrepancy_amount
   FROM invoicedetail a
   LEFT JOIN(
		SELECT SUM(detailamount) as detailamount_total, invoicenum
        FROM invoicedetail
        GROUP BY invoicenum
    )x on x.invoicenum=a.invoicenum
    JOIN invoiceheader b ON b.invoicenum=a.invoicenum AND x.detailamount_total!=b.invoiceamount
    ;
    
END 
//

DELIMITER ;

call report2( '2013-01-01', '2014-01-2' )

### Report 3
DELIMITER //
DROP PROCEDURE IF EXISTS repot3 //
CREATE PROCEDURE
	report3(_begin DATE, _end DATE)
BEGIN
	SELECT a.invoicenum, c.invoicedate, a.trackingno, b.detailamount, x.chargeamount_total,(b.detailamount-x.chargeamount_total) as discrepancy_amount
    FROM invoicecharges a
    LEFT JOIN(
		SELECT SUM(chargeamount) as chargeamount_total, trackingno
		FROM invoicecharges
		GROUP BY trackingno
	)x on a.trackingno=x.trackingno
    JOIN invoicedetail b ON a.trackingno = b.trackingno AND x.chargeamount_total!=b.detailamount
    LEFT JOIN invoiceheader c ON c.invoicenum=a.invoicenum
    ;
    
END
//

DELIMITER ;
call report3( '2013-01-01', '2014-01-2' )


DELIMITER $$
CREATE PROCEDURE reportall()
BEGIN
  CALL report1( '2013-01-01', '2014-01-2' );
  CALL report2( '2013-01-01', '2014-01-2' );
  CALL report3( '2013-01-01', '2014-01-2' );
END$$
DELIMITER 

call reportall();