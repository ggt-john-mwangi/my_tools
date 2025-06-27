WITH
    snapshot_cte
    AS
    (
        SELECT
            internal_execution_id,
            JSON_F52E2B61_18A1_11d1_B105_00805F49916B = 
            (SELECT [JSON_F52E2B61-18A1-11d1-B105-00805F49916B]
            FROM [dbo].[PerformanceSnapshotLog] AS sub
            WHERE sub.internal_execution_id = main.internal_execution_id
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')
        FROM
            [dbo].[PerformanceSnapshotLog] AS main
        GROUP BY 
        internal_execution_id
    )
SELECT
    JSON_F52E2B61_18A1_11d1_B105_00805F49916B AS my_json
FROM
    snapshot_cte;
-- This query retrieves the JSON data from the PerformanceSnapshotLog table, grouping by internal_execution_id.
-- The JSON data is aggregated into a single NVARCHAR(MAX) field for each internal_execution_id 