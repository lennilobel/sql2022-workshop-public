CREATE PROCEDURE uspRankCustomers
AS
	DECLARE @CustomerId int
	DECLARE @OrderTotal money
	DECLARE @RankingId int

	DECLARE curCustomer CURSOR FOR
	 SELECT CustomerId, OrderTotal FROM vwCustomerOrderSummary

	OPEN curCustomer
	FETCH NEXT FROM curCustomer INTO @CustomerId, @OrderTotal

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @OrderTotal = 0 SET @RankingId = 1
		ELSE IF @OrderTotal < 100 SET @RankingId = 2
		ELSE IF @OrderTotal < 1000 SET @RankingId = 3
		ELSE IF @OrderTotal < 10000 SET @RankingId = 4
		ELSE SET @RankingId = 5

		UPDATE Customer
		 SET RankingId = @RankingId
		 WHERE CustomerId = @CustomerId

		FETCH NEXT FROM curCustomer INTO @CustomerId, @OrderTotal
	END

	CLOSE curCustomer
	DEALLOCATE curCustomer
