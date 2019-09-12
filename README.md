# invoice-
We have a set of three tables (for each one schema is followed by the sample data):

1) invoiceheader (
invoicenum varchar, 
invoicedate date, 
invoiceamount float
)

invoicenum | invoicedate | invoiceamount
-----------+-------------+--------------
00551198   | 1/1/2014    | $150.5
00551199   | 1/2/2014    | $10

2) invoicedetail (
invoicenum varchar, 
trackingno varchar, 
detailamount float
)

invoicenum | trackingno         | detailamount
-----------+--------------------+-------------
00551198   | 1Z2F12346861507266 | $50
00551198   | 1Z2F12346861507267 | $80
00551198   | 1Z2F12346861507268 | $20.5
00551199   | 1Z2F12346861503423 | $10.5

3) invoicecharges (
invoicenum varchar, 
trackingno varchar, 
chargetype varchar, 
chargeamount float
)

invoicenum | trackingno         | chargetype | chargeamount
-----------+--------------------+------------+-------------
00551198   | 1Z2F12346861507266 | FRT        | $40
00551198   | 1Z2F12346861507266 | FUE        | $11
00551198   | 1Z2F12346861507267 | FRT        | $65
00551198   | 1Z2F12346861507267 | FUE        | $17
00551198   | 1Z2F12346861507268 | FRT        | $10
00551198   | 1Z2F12346861507268 | FUE        | $5
00551198   | 1Z2F12346861507268 | HAZ        | $5.5
00551199   | 1Z2F12346861503423 | FRT        | $8
00551199   | 1Z2F12346861503423 | FUE        | $2.5

The relationship between tables: the data set contains invoice with overall invoice amount, list of packages uniquely identified by tracking# in detail table and break down of charges for the tracking#. I.e. Freight, Fuel.

Using the data from the tables above program should generate the following reports:

Report 1.
Input parameters: from date and to date
For specified time period print all invoices
for each show 
invoicenum, invoice date and invoice amount
Print a total line: # of invoices and total amount for the period
 
Report 2.
Same input as above
For specified time period print all invoices where the invoice amount does not match the sum of all detailamount column values for this invoice
for each show 
invoicenum, invoice date and invoice amount, detailamount total and the discrepancy amount
 
Report 3.
Same input as above
For specified time period print all tracking#s  where the detailamount does not match the sum of all chargemount column values for this invoice and trackingno
for each show 
invoicenum, invoice date, trackingno, detailamount, chargeamount total and the discrepancy amount

