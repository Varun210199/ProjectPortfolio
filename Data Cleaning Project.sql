select * from PortfolioProject..NashvilleHousing

--Standardise date format
select SaleDateConv, CONVERT(Date,SaleDate) 
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

Alter table NashvilleHousing
Add SaleDateConv Date

update NashvilleHousing
set SaleDateConv = CONVERT(date,SaleDate)

select SaleDateConv 
from PortfolioProject..NashvilleHousing

--Populate Property Address Data

Select *
from PortfolioProject..NashvilleHousing
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking address into separate columns (Address, City, State)
Select PropertyAddress
from PortfolioProject..NashvilleHousing

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) As Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) As Address2
from PortfolioProject..NashvilleHousing

Alter table NashvilleHousing
Add PropAddress1 nvarchar(255)

update NashvilleHousing
set PropAddress1 = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvilleHousing
Add PropAddress2 nvarchar(255)

update NashvilleHousing
set PropAddress2 = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from PortfolioProject..NashvilleHousing

--Cleaning Owner Address
select OwnerAddress
from PortfolioProject..NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing

Alter table NashvilleHousing
Add OwnerAddress1 nvarchar(255)

update NashvilleHousing
set OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter table NashvilleHousing
Add OwnerAddress2 nvarchar(255)

update NashvilleHousing
set OwnerAddress2 = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter table NashvilleHousing
Add OwnerAddress3 nvarchar(255)

update NashvilleHousing
set OwnerAddress3 = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select * from PortfolioProject..NashvilleHousing

-- Correct values in SoldAsVacant column

select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end

Select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant

-- Remove Duplicates

With RowNumCTE as (
Select *,
ROW_NUMBER() Over (Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
)
Delete from RowNumCTE where row_num > 1

--Delete Unused Columns

select *
from PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Drop column OwnerAddress, PropertyAddress

Alter table PortfolioProject..NashvilleHousing
Drop column SaleDate
