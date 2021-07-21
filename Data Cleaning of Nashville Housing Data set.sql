--data cleaning project part 3
select *
from PortfolioProjectFinal.dbo.NashvilleHousing

--standardize the date format
select SaleDateConverted, convert(Date,SaleDate)
from PortfolioProjectFinal.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate= convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;



--Populate Property Address Data
select *
from PortfolioProjectFinal.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectFinal.dbo.NashvilleHousing a
JOIN PortfolioProjectFinal.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

Update a
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectFinal.dbo.NashvilleHousing a
JOIN PortfolioProjectFinal.dbo.NashvilleHousing b
    on a.ParcelID=b.ParcelID
	AND a.[UniqueID]<>b.[UniqueID]
Where a.PropertyAddress is null

--Breaking out address into Individual Columns (Address, City, State)

 select PropertyAddress
from PortfolioProjectFinal.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

--important, 1 means starting from position 1)
--charindex( look for this, what we looking in), result will go untl comma, -1 to remove comma from result

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',' , PropertyAddress)-1) as Address,
--CHARINDEX(',' ,PropertyAddress)
--above code gives position of comma
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))as Address
from PortfolioProjectFinal.dbo.NashvilleHousing

ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProjectFinal.dbo.NashvilleHousing
Set PropertySplitAddress=SUBSTRING(PropertyAddress, 1 ,CHARINDEX(',' , PropertyAddress)-1) 

ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProjectFinal.dbo.NashvilleHousing
Set PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress)+1, LEN(PropertyAddress))


SELECT OwnerAddress
From PortfolioProjectFinal.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From PortfolioProjectFinal.dbo.NashvilleHousing


ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProjectFinal.dbo.NashvilleHousing
Set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProjectFinal.dbo.NashvilleHousing
Set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProjectFinal.dbo.NashvilleHousing
Set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From PortfolioProjectFinal.dbo.NashvilleHousing


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjectFinal.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProjectFinal.dbo.NashvilleHousing

Update PortfolioProjectFinal.dbo.NashvilleHousing
SET SoldAsVacant= CASE When SoldAsVacant = 'Y' THEN 'Yes'
     When SoldAsVacant ='N' THEN 'No'
	 ELSE SoldAsVacant
	 END


-- removing duplicates
WITH RowNumCTE AS(
Select *,
     ROW_NUMBER()OVER(
	 PARTITION BY PARCELID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  Order by 
				       UniqueID
					   ) row_num

From  PortfolioProjectFinal.dbo.NashvilleHousing
--order by ParcelID
)
--Select *
--From RowNumCTE



SELECT *
--DELETE
From RowNumCTE
Where row_num >1
Order by PropertyAddress

--DELETING UNUSED COLUMNS
 Select *
 From PortfolioProjectFinal.dbo.NashvilleHousing
 
ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing 
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 ALTER TABLE PortfolioProjectFinal.dbo.NashvilleHousing 
 DROP COLUMN SaleDate