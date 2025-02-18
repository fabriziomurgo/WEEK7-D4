USE adventureworksdw;

SELECT * FROM dimproduct;
SELECT * FROM dimproductsubcategory;
SELECT * FROM dimproductcategory;

-- Implementa una vista denominata Product al fine di creare unʼanagrafica (dimensione) prodotto completa. 
-- La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome prodotto, il nome della sottocategoria associata e il nome della categoria associata.
CREATE VIEW Product as
SELECT p.ProductKey , IFNULL(r.ResellerKey, 'Not found') as ResellerKey, p.EnglishProductName as Product, IFNULL(s.EnglishProductSubcategoryName, 'Not found') as Subcategory, IFNULL(c.EnglishProductCategoryName, 'Not found') as Category
FROM dimproduct as p LEFT JOIN dimproductsubcategory as s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
LEFT JOIN dimproductcategory as c ON s.ProductCategoryKey = c.ProductCategoryKey
LEFT JOIN factresellersales as sales ON p.ProductKey = sales.ProductKey
LEFT JOIN dimreseller as r ON sales.ResellerKey = r.ResellerKey;


SELECT * FROM Product;

SELECT * FROM dimreseller;
SELECT * FROM dimgeography;


-- Implementa una vista denominata Reseller al fine di creare unʼanagrafica (dimensione) reseller completa. 
-- La vista, se interrogata o utilizzata come sorgente dati, deve esporre il nome del reseller, il nome della città e il nome della regione.

CREATE VIEW Reseller as
SELECT r.ResellerKey, r.ResellerName as Reseller, IFNULL(g.City, 'Not found') as City, IFNULL(g.EnglishCountryRegionName, 'Not found') as Region 
FROM dimreseller as r LEFT JOIN dimgeography as g ON r.GeographyKey = g.GeographyKey;


SELECT * FROM Reseller; 

-- Crea una vista denominata Sales che deve restituire la data dellʼordine, 
-- il codice documento, la riga di corpo del documento, la quantità venduta, lʼimporto totale e il profitto.

SELECT * FROM factresellersales;
SELECT * FROM factsales;

CREATE VIEW Sales as 
SELECT d.ResellerKey, r.OrderDate, r.SalesOrderNumber, SUM(r.OrderQuantity) as Quantity, ROUND(SUM(r.SalesAmount), 2) as Total, ROUND(SUM(r.SalesAmount - IFNULL(r.TotalProductCost, 0)), 2) as Revenue
FROM factresellersales as r LEFT JOIN dimreseller as d ON r.Resellerkey = d.ResellerKey
LEFT JOIN  dimproduct as p ON r.ProductKey = p.ProductKey
GROUP BY r.OrderDate, r.SalesOrderNumber, d.ResellerKey;

SELECT * FROM Sales;











