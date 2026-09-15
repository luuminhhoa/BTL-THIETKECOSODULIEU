-- Run after schema.sql in an empty TEST database. All fixture data is rolled back.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET ARITHABORT ON;
SET NUMERIC_ROUNDABORT OFF;
SET XACT_ABORT OFF;
GO
BEGIN TRY
    BEGIN TRANSACTION;
    INSERT TENANT VALUES ('test-tenant', N'Test tenant', N'{}');
    INSERT ROLE VALUES (1, N'Staff');
    INSERT MERCHANT VALUES ('test-merchant', 'test-tenant', N'Test merchant', 'Active');
    INSERT CUSTOMER VALUES ('test-c1', NULL, NULL), ('test-c2', NULL, NULL),
        ('test-c3', 'wallet-unique', NULL);
    INSERT [USER] (UserID, MerchantID, Email, PasswordHash, RoleID, ManagerID)
    VALUES ('test-u1', 'test-merchant', 'u1@example.invalid', 'hash', 1, NULL),
           ('test-u2', 'test-merchant', 'u2@example.invalid', 'hash', 1, 'test-u1');
    INSERT API_CREDENTIAL VALUES ('test-key1', 'test-merchant', 'api-unique', 'hash');
    INSERT CAMPAIGN VALUES
        ('test-camp', 'test-merchant', N'Test campaign', '20260101', NULL, 'Draft'),
        ('test-camp2', 'test-merchant', N'Test dates', '20260101', '20260101', 'Active');
    INSERT CREDIT VALUES ('test-credit', 'test-c1', 'test-merchant', 0);
    INSERT REWARD_RULE VALUES ('test-rule', 'test-camp', 'Purchase', 1);
    INSERT CREDIT_TRANSACTION
        (TransactionID, CreditID, CampaignID, Amount, TransactionType, SuiTxDigest)
    VALUES ('test-t1', 'test-credit', NULL, 10, 'Earn', NULL),
           ('test-t2', 'test-credit', NULL, -2, 'Redeem', NULL),
           ('test-t3', 'test-credit', 'test-camp', 2, 'Refund', 'digest-unique'),
           ('test-t4', 'test-credit', 'test-camp', -1, 'Refund', NULL);

    DECLARE @Cases TABLE (Name NVARCHAR(100), Statement NVARCHAR(MAX), ExpectedError INT);
    INSERT @Cases VALUES
        (N'duplicate wallet', N'INSERT CUSTOMER VALUES (''bad-c'', ''wallet-unique'', NULL)', 2601),
        (N'duplicate API key', N'INSERT API_CREDENTIAL VALUES (''bad-key'', ''test-merchant'', ''api-unique'', ''hash'')', 2627),
        (N'duplicate customer merchant pair', N'INSERT CREDIT VALUES (''bad-credit'', ''test-c1'', ''test-merchant'', 0)', 2627),
        (N'negative balance', N'UPDATE CREDIT SET AvailableBalance = -1 WHERE CreditID = ''test-credit''', 547),
        (N'invalid JSON', N'UPDATE TENANT SET SystemConfig = N''not json'' WHERE TenantID = ''test-tenant''', 547),
        (N'missing manager', N'UPDATE [USER] SET ManagerID = ''absent'' WHERE UserID = ''test-u2''', 547),
        (N'self manager', N'UPDATE [USER] SET ManagerID = UserID WHERE UserID = ''test-u2''', 547),
        (N'duplicate user email', N'UPDATE [USER] SET Email = ''u1@example.invalid'' WHERE UserID = ''test-u2''', 2627),
        (N'end before start', N'UPDATE CAMPAIGN SET EndDate = ''20251231'' WHERE CampaignID = ''test-camp''', 547),
        (N'unknown campaign status', N'UPDATE CAMPAIGN SET Status = ''Paused'' WHERE CampaignID = ''test-camp''', 547),
        (N'unknown merchant status', N'UPDATE MERCHANT SET Status = ''Inactive'' WHERE MerchantID = ''test-merchant''', 547),
        (N'zero multiplier', N'UPDATE REWARD_RULE SET PointsMultiplier = 0 WHERE RuleID = ''test-rule''', 547),
        (N'negative multiplier', N'UPDATE REWARD_RULE SET PointsMultiplier = -1 WHERE RuleID = ''test-rule''', 547),
        (N'duplicate digest', N'UPDATE CREDIT_TRANSACTION SET SuiTxDigest = ''digest-unique'' WHERE TransactionID = ''test-t1''', 2601),
        (N'unknown transaction type', N'UPDATE CREDIT_TRANSACTION SET TransactionType = ''Burn'' WHERE TransactionID = ''test-t1''', 547),
        (N'negative earn', N'UPDATE CREDIT_TRANSACTION SET Amount = -1 WHERE TransactionID = ''test-t1''', 547),
        (N'positive redeem', N'UPDATE CREDIT_TRANSACTION SET Amount = 1 WHERE TransactionID = ''test-t2''', 547),
        (N'zero refund', N'UPDATE CREDIT_TRANSACTION SET Amount = 0 WHERE TransactionID = ''test-t3''', 547),
        (N'missing campaign', N'UPDATE CREDIT_TRANSACTION SET CampaignID = ''absent'' WHERE TransactionID = ''test-t1''', 547),
        (N'delete referenced merchant', N'DELETE MERCHANT WHERE MerchantID = ''test-merchant''', 547);
    DECLARE @Name NVARCHAR(100), @Statement NVARCHAR(MAX), @ExpectedError INT;
    DECLARE @Rejected BIT, @Message NVARCHAR(2048), @Passed INT = 0;
    DECLARE test_cursor CURSOR LOCAL FAST_FORWARD FOR
        SELECT Name, Statement, ExpectedError FROM @Cases;
    OPEN test_cursor;
    FETCH NEXT FROM test_cursor INTO @Name, @Statement, @ExpectedError;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Rejected = 0;
        BEGIN TRY
            EXEC sys.sp_executesql @Statement;
        END TRY
        BEGIN CATCH
            IF ERROR_NUMBER() <> @ExpectedError THROW;
            SET @Rejected = 1;
        END CATCH;
        IF @Rejected = 0
        BEGIN
            SET @Message = N'Expected rejection: ' + @Name;
            THROW 51000, @Message, 1;
        END;
        SET @Passed += 1;
        FETCH NEXT FROM test_cursor INTO @Name, @Statement, @ExpectedError;
    END;
    CLOSE test_cursor;
    DEALLOCATE test_cursor;
    ROLLBACK TRANSACTION;
    SELECT @Passed AS PassedRejectionTests, N'Valid fixtures accepted; all data rolled back' AS Result;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
