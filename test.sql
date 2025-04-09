--
BEGIN TRANSACTION;
select db_NAME() as DB_NAME_CURRENT;

DECLARE @CustomerID       INT = 615;
DECLARE @GiftCardURL      NVARCHAR(10)='';
DECLARE @GiftCardAmount   INT  = 50; -- or DECIMAL if needed
DECLARE @CategoryID       INT  = 27;
-- We will not use @CardNumber, @RegistrationCode here directly 
-- because those come from the temp table now.
DECLARE @CreatedBy        NVARCHAR(10) = 'DDayh003';
DECLARE @CreatedDate      DATETIME     = GETDATE();

DECLARE @StartDate        DATE = '2025-02-01';
DECLARE @EndDate          DATE = '2026-01-31';

;WITH Months AS
(
    SELECT FirstOfMonth = CONVERT(DATE,
                                  DATEFROMPARTS(YEAR(@StartDate), MONTH(@StartDate), 1))
    UNION ALL
    SELECT DATEADD(MONTH, 1, FirstOfMonth)
    FROM Months
    WHERE DATEADD(MONTH, 1, FirstOfMonth) 
          <= DATEFROMPARTS(YEAR(@EndDate), MONTH(@EndDate), 1)
)
INSERT INTO cap.WinningSlots 
(
    CustomerId,
    CellPhone,
    SlotOpenDateTime,
    DrawStartDateTime,
    DrawEndDateTime,
    GiftCardUrl,
    GiftCardAmount,
    CategoryId,
    CardNumber,
    RegistrationCode,
    CreatedDate,
    CreatedBy
)
SELECT
    @CustomerID,
    NULL,  -- Winners of the slots will display their cell phone number here
    -- Generate a random date/time (with ms) within the month:
    DATEADD(
        MILLISECOND,
        CAST(RAND(CHECKSUM(NEWID())) * 1000 AS INT),           -- 0-999 ms
        DATEADD(
            SECOND,
            CAST(RAND(CHECKSUM(NEWID())) * 60 AS INT),         -- 0-59 seconds
            DATEADD(
                MINUTE,
                CAST(RAND(CHECKSUM(NEWID())) * 60 AS INT),     -- 0-59 minutes
                DATEADD(
                    HOUR,
                    CAST(RAND(CHECKSUM(NEWID())) * 24 AS INT), -- 0-23 hours
                    DATEADD(
                        DAY,
                        CAST(RAND(CHECKSUM(NEWID())) 
                           * DAY(EOMONTH(FirstOfMonth)) AS INT),
                        CAST(FirstOfMonth AS DATETIME2(3))     -- cast DATE -> DATETIME2(3)
                    )
                )
            )
        )
    ) AS SlotOpenDateTime,
    @StartDate AS DrawStartDateTime,
    @EndDate   AS DrawEndDateTime,
    @GiftCardURL,
    @GiftCardAmount,
    @CategoryID,
    --t.GiftCardNumber,        -- from tmp_TacoMacGCs2025
    TRY_CONVERT(BIGINT, REPLACE(t.GiftCardNumber, ' ', '')) AS GiftCardNumber,  -- from tmp_TacoMacGCs2025
    t.RegistrationCode,      -- from tmp_TacoMacGCs2025
    @CreatedDate,            -- or CAST(@CreatedDate AS DATE) if you want only date
    @CreatedBy
FROM Months m
INNER JOIN tmp_TacoMacGCs2025 t
    ON MONTH(m.FirstOfMonth) = t.Month
   AND YEAR(m.FirstOfMonth)  = t.Year
OPTION (MAXRECURSION 0);


--select * from cap.WinningSlots where CustomerId = 615 and CellPhone is NULL;
--select * from tmp_TacoMacGCs2025;
--SELECT FirstOfMonth = CONVERT(DATE, DATEFROMPARTS(YEAR('2025-01-15'), MONTH('2025-01-15'), 1))

-- SELECT  @@TRANCOUNT;
-- COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION;
-- SELECT @@IDENTITY;
-- SELECT @@ROWCOUNT;

-- send Email


select * from cli.Customer where [name] like '%taco%' -- customerId=615
select * from cli.Customer where customerId=615
select * from cap.ClientEmailDistributionList
select * from cap.ClientEmailDistributionList  where customerId=615
select * from cap.ClientEmailDistributionList

begin transaction
insert into cap.ClientEmailDistributionList (CustomerID, EmailAddress, Active) 
values(615, 'gamrhein@tacomac.com', 1);
--commit transaction

--Low NPS Setup: https://acloserlook.atlassian.net/wiki/x/DwDmAw
--Set up the DesignatedNPS score, chatOption, smsOption and emailOption
--Net Promoter Score (NPS)
select * from [cap].[DesignatedLowerThanNPSSettings] where customerId = 615;

select * from  cap.ClientSupportContact where customerId = 615 order by LocationID,Email desc ;
select * from [cap].[LowNPSClientMessage] where customerId = 615;


select distinct LocationID from  cap.ClientSupportContact where customerId = 615;

-- rather use join to validated if deleted
select l.locationId from cli.Location l
join cap.ClientSupportContact csc on 
	l.customerId = csc.CustomerID
where l.customerId = 615
and l.isDeleted != 1
group by l.locationId
order by l.locationId

-- Validate whats in one select not in the other
-- SELECT DISTINCT
--     l.locationId
-- FROM
--     cli.Location l
-- LEFT JOIN
--     cap.ClientSupportContact csc
--     ON l.locationId = csc.LocationID
--     AND l.customerId = csc.CustomerID
-- WHERE
--     l.customerId = 615
--     AND l.isDeleted != 1
--     AND csc.LocationID IS NULL  -- Locations in Location table but not in ClientSupportContact
-- UNION
-- SELECT DISTINCT
--     csc.LocationID
-- FROM
--     cap.ClientSupportContact csc
-- LEFT JOIN
--     cli.Location l
--     ON l.locationId = csc.LocationID
--     AND l.customerId = csc.CustomerID
-- WHERE
--     csc.CustomerID = 615
--     AND l.locationId IS NULL  -- Locations in ClientSupportContact but not in Location table
-- ORDER BY
--     locationId;

---iNSERT EMAIL  gamrhein@tacomac.com to all  locations for Low NPS notification via Email
BEGIN TRANSACTION;

INSERT INTO cap.ClientSupportContact (CustomerID, LocationID, email)
VALUES 
(615, 1708, 'gamrhein@tacomac.com'),
(615, 1709, 'gamrhein@tacomac.com'),
(615, 1710, 'gamrhein@tacomac.com'),
(615, 1711, 'gamrhein@tacomac.com'),
(615, 1712, 'gamrhein@tacomac.com'),
(615, 1713, 'gamrhein@tacomac.com'),
(615, 1714, 'gamrhein@tacomac.com'),
(615, 1715, 'gamrhein@tacomac.com'),
(615, 1716, 'gamrhein@tacomac.com'),
(615, 1717, 'gamrhein@tacomac.com'),
(615, 1718, 'gamrhein@tacomac.com'),
(615, 1719, 'gamrhein@tacomac.com'),
(615, 1720, 'gamrhein@tacomac.com'),
(615, 1721, 'gamrhein@tacomac.com'),
(615, 1722, 'gamrhein@tacomac.com'),
(615, 1723, 'gamrhein@tacomac.com'),
(615, 1724, 'gamrhein@tacomac.com'),
(615, 1725, 'gamrhein@tacomac.com'),
(615, 1726, 'gamrhein@tacomac.com'),
(615, 1727, 'gamrhein@tacomac.com'),
(615, 1728, 'gamrhein@tacomac.com'),
(615, 1729, 'gamrhein@tacomac.com'),
(615, 1730, 'gamrhein@tacomac.com'),
(615, 1731, 'gamrhein@tacomac.com'),
(615, 1732, 'gamrhein@tacomac.com'),
(615, 1733, 'gamrhein@tacomac.com'),
(615, 1734, 'gamrhein@tacomac.com'),
(615, 1895, 'gamrhein@tacomac.com'),
(615, 2036, 'gamrhein@tacomac.com');

-- COMMIT TRANSACTION;
ROLLBACK TRANSACTION;

---iNSERT EMAIL  404-579-7175  == +14045797175 to all  locations for Low NPS notification via Text
BEGIN TRANSACTION;

INSERT INTO cap.ClientSupportContact (CustomerID, LocationID, phone)
VALUES 
(615, 1708, '+14045797175'),
(615, 1709, '+14045797175'),
(615, 1710, '+14045797175'),
(615, 1711, '+14045797175'),
(615, 1712, '+14045797175'),
(615, 1713, '+14045797175'),
(615, 1714, '+14045797175'),
(615, 1715, '+14045797175'),
(615, 1716, '+14045797175'),
(615, 1717, '+14045797175'),
(615, 1718, '+14045797175'),
(615, 1719, '+14045797175'),
(615, 1720, '+14045797175'),
(615, 1721, '+14045797175'),
(615, 1722, '+14045797175'),
(615, 1723, '+14045797175'),
(615, 1724, '+14045797175'),
(615, 1725, '+14045797175'),
(615, 1726, '+14045797175'),
(615, 1727, '+14045797175'),
(615, 1728, '+14045797175'),
(615, 1729, '+14045797175'),
(615, 1730, '+14045797175'),
(615, 1731, '+14045797175'),
(615, 1732, '+14045797175'),
(615, 1733, '+14045797175'),
(615, 1734, '+14045797175'),
(615, 1895, '+14045797175'),
(615, 2036, '+14045797175');

-- COMMIT TRANSACTION;

ROLLBACK TRANSACTION;
