create table Category(
	CategoryId nvarchar(255) primary key,
	CategoryName nvarchar(255) 
)
go
create table Product(
	ProductId nvarchar(255) primary key,
	ProductName nvarchar(255),
	SortDescription nvarchar(255),
	Price nvarchar(255),
	Image nvarchar(255),
	CategoryId nvarchar(255) foreign key(CategoryId) references Category(CategoryId)
)
go
create table ProductDetails(
	ProductDescriptionId nvarchar(255) primary key,
	ProductId nvarchar(255) foreign key(ProductId) references Product(ProductId),
	Description nvarchar(255),
	Details nvarchar(255)
)