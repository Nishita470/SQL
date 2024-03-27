-- Initial Data Overview
SELECT TOP 10 *
FROM SQL.dbo.housing;

-- Summary Statistics
SELECT 
    COUNT(*) AS TotalRecords,
    MIN(SalePrice) AS MinSalePrice,
    MAX(SalePrice) AS MaxSalePrice,
    AVG(SalePrice) AS AvgSalePrice,
    MIN(SaleDateConverted) AS MinSaleDate,
    MAX(SaleDateConverted) AS MaxSaleDate
FROM SQL.dbo.housing;


-- Data Distribution (Example: SalePrice)
SELECT 
    SalePrice,
    COUNT(*) AS Frequency
FROM SQL.dbo.housing
GROUP BY SalePrice
ORDER BY SalePrice;


-- Correlation Analysis (Example: SalePrice vs. SaleDate)
SELECT 
    SaleDateConverted,
    round(AVG(SalePrice),5) AS AvgSalePrice
FROM SQL.dbo.housing
GROUP BY SaleDateConverted
ORDER BY SaleDateConverted;

-- Missing Values Analysis (Example: PropertyAddress)
SELECT 
    COUNT(*) - COUNT(PropertySplitAddress) AS MissingPropertyAddressCount,
    100.0 * (COUNT(*) - COUNT(PropertySplitAddress)) / COUNT(*) AS MissingPropertyAddressPercentage
FROM SQL.dbo.housing;


-- Data Visualization (Example: Time Series of SalePrice)
SELECT 
    SaleDateConverted,
    AVG(SalePrice) AS AvgSalePrice
FROM SQL.dbo.housing
GROUP BY SaleDateConverted
ORDER BY SaleDateConverted;
