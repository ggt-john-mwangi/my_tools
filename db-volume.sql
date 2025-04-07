SELECT
    sch.name AS SchemaName,
    tbl.name AS TableName,
    SUM(p.rows) AS TotalRows,
    CAST(SUM(a.total_pages) * 8 / 1024.0 AS DECIMAL(10,2)) AS TableSizeMB, -- Total space allocated
    CAST(SUM(a.used_pages) * 8 / 1024.0 AS DECIMAL(10,2)) AS UsedSpaceMB, -- Space actually used
    CAST(SUM(a.data_pages) * 8 / 1024.0 AS DECIMAL(10,2)) AS DataSpaceMB, -- Data-only space
    CAST((SUM(a.used_pages) - SUM(a.data_pages)) * 8 / 1024.0 AS DECIMAL(10,2)) AS IndexSpaceMB, -- Index space only
    CAST(SUM(a.total_pages) * 8 / 1024.0 AS DECIMAL(10,2)) AS TotalSpaceMB -- (Data + Indexes) Corrected!
FROM sys.tables AS tbl
    JOIN sys.schemas AS sch ON tbl.schema_id = sch.schema_id
    JOIN sys.indexes AS idx ON tbl.object_id = idx.object_id
    JOIN sys.partitions AS p ON idx.object_id = p.object_id AND idx.index_id = p.index_id
    JOIN sys.allocation_units AS a ON p.partition_id = a.container_id
WHERE idx.index_id IN (0,1) -- Only clustered index or heap
GROUP BY sch.name, tbl.name
HAVING CAST(SUM(a.used_pages) * 8 / 1024.0 AS DECIMAL(10,2)) > 100 -- Filtering tables >1GB
    OR SUM(p.rows) > -1 -- Tables with more than 100K rows
ORDER BY TotalRows DESC, TotalSpaceMB DESC;
