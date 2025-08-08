USE [SHOP_DB]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Stored procedure to create a new order
ALTER PROCEDURE [dbo].[CreateNewOrder]
AS
BEGIN
	
	DECLARE 
		@CustCnt INT,
		@RndCustId INT,
		@RndProductId INT,
		@ProductCnt INT,
		@RndProductCnt INT,
		@RndProductQty INT,
		@UnitPrice DECIMAL,
		@OrderId UNIQUEIDENTIFIER,
		@TotalAmount DECIMAL = 0, -- Initialize TotalAmount
		@Cnt INT = 1; -- Initialize Cnt

	-- Amount of various items bought
	SET @RndProductCnt = FLOOR(RAND() * (6 - 1 + 1) + 1);

	-- Amount of each item bought (default 0)
	SET @RndProductQty = 1;

	-- Total customers count
	SET @CustCnt = (SELECT COUNT(Id) FROM [SHOP_DB].[dbo].[Customer]);

	-- Random customer id
	SET @RndCustId = FLOOR(RAND() * (@CustCnt - 1 + 1) + 1);

	-- Total products count (id is an identifier)
	SET @ProductCnt = (SELECT COUNT(Id) FROM [SHOP_DB].[dbo].[Product]);

	-- New Order ID
	SET @OrderId = NEWID();

	WHILE @Cnt <= @RndProductCnt
	BEGIN
		SET @RndProductId = FLOOR(RAND() * (@ProductCnt - 1) + 1);
		SET @RndProductQty = FLOOR(RAND() * (15 - 1) + 1);
		SET @UnitPrice = (SELECT UnitPrice FROM [SHOP_DB].[dbo].[Product] WHERE [id] = @RndProductId);


		INSERT INTO [SHOP_DB].[dbo].[OrderItem] (OrderId, ProductId, UnitPrice, Quantity)
		VALUES (CONVERT(VARCHAR(255), @OrderId), @RndProductId, @UnitPrice, @RndProductQty);

		UPDATE [SHOP_DB].[dbo].[Product] SET Stock = (stock - @RndProductQty) WHERE id = @RndProductId;

		SET @Cnt = @Cnt + 1;
		SET @TotalAmount = @TotalAmount + (@UnitPrice * @RndProductQty);
		

	END;

	INSERT INTO [SHOP_DB].[dbo].[Order] (Id, OrderDate, CustomerId, TotalAmount)
	VALUES (@OrderId, GETDATE(), @RndCustId, @TotalAmount);
	
END;
