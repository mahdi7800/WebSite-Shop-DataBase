
/*
===========================================================
 File Name : WebShopDb.sql
 Purpose   : Create the database structure for WebShop
             including users, roles, products, blog,
             wishlist, orders and website settings
 Database  : WebShopDb
 Author    : Mahdi Davoudi
 Date      : 2026/08/13
===========================================================

 Notes:
 - Designed for Microsoft SQL Server
 - Uses relational tables with Foreign Keys
 - Uses UNIQUE indexes for UserLogin and Email
 - Product and Blog categories are separated
 - User roles are stored in a dedicated Role table
 - Image files are stored as file paths instead of binary data
 - This script is still under development
===========================================================
*/




/*
===========================================================
 Database Name : WebShopDb
 Purpose       : Create the main application database

 Logic:
 - Checks whether WebShopDb already exists
 - If the database exists, it is dropped and recreated
 - If the database does not exist, it is created

 Notes:
 - This section is intended for the initial database setup
 - Dropping the database will permanently remove all
   existing data
===========================================================
*/


IF EXISTS (SELECT 1 FROM sys.databases WHERE [name]= N'WebShopDb')
BEGIN 
	  USE WebShopDb;
      DROP DATABASE WebShopDb;
	  CREATE DATABASE WebShopDb;
END
ELSE IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE [name]= N'WebShopDb')
BEGIN
	CREATE DATABASE WebShopDb;
END 
GO 

USE WebShopDb;
GO 

/*
===========================================================
 Table Name : Role
 Purpose    : Stores the available roles in the website
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Role')
BEGIN

CREATE TABLE [Role] (RoleID int NOT NULL IDENTITY PRIMARY KEY ,
					 RoleName nvarchar(20) NOT NULL);
INSERT INTO [Role] (RoleName)
	 VALUES (N'Admin'),
			(N'Manager'),
			(N'ContentManager'),
			(N'ProductManager'),
			(N'OrderManager'),
			(N'Customer');

END
GO

/*
===========================================================
 Table Name : Users
 Purpose    : Stores website users and their authentication
              and basic profile information
===========================================================

 Columns:
 - UserID         : Unique identifier for each user
 - UserLogin      : Unique username used for login
 - UserPass       : Password hash of the user
 - FirstName      : User first name
 - LastName       : User last name
 - Email          : User email address
 - UserRegistered : Date and time when the user registered
 - RoleID         : User role reference

 Relationships:
 - RoleID -> Role.RoleID

 Notes:
 - UserLogin must be unique
 - Email must be unique
 - RoleID determines user permissions
 - Password must be stored as a HASH, never plain text
===========================================================
*/



IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Users')
BEGIN
CREATE TABLE [Users] (UserID int NOT NULL IDENTITY PRIMARY KEY,
					  UserLogin nvarchar(50) NOT NULL ,
					  UserPass nvarchar(255) NOT NULL ,
					  FirstName nvarchar(40) NOT NULL ,
					  LastName nvarchar(45) NOT NULL ,
					  Email nvarchar(90) NOT NULL ,
					  PhoneNumber nvarchar(15) NULL ,
					  UserRegistered datetime NOT NULL DEFAULT SYSDATETIME(),
					  RoleID int NOT NULL CONSTRAINT FK_Role_Users FOREIGN KEY (RoleID) REFERENCES [Role] (RoleID) DEFAULT (6))
INSERT INTO [Users] ( UserLogin ,UserPass,FirstName,LastName,Email,RoleID)
  VALUES(N'admin'+CONVERT(nvarchar(10),GETDATE()),N'123456789',N'adminName',N'adminLastName',N'admin@gamil.com',1);

CREATE UNIQUE INDEX IX_Users_UserLogin ON Users (UserLogin);


CREATE UNIQUE  INDEX IX_Users_Email ON Users  (Email); 

END

GO

/*
===========================================================
 Table Name : CategoriesProducts
 Purpose    : Stores main categories for shop products
===========================================================

 Columns:
 - CategoryID   : Unique category identifier
 - CategoryName : Product category name
 - Description  : Category description
 - Picture      : Relative path of category image
 - Slug         : URL-friendly category identifier

 Notes:
 - Slug must be unique.
===========================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CategoriesProducts')
BEGIN
CREATE TABLE CategoriesProducts (CategoryID int NOT NULL IDENTITY PRIMARY KEY ,
								 CategoryName nvarchar(15) NOT NULL,
								 [Description] nvarchar(60) NULL ,
								 Picture nvarchar(500) NULL , 
								 Slug nvarchar(15) NOT NULL UNIQUE);

INSERT INTO CategoriesProducts (CategoryName,Slug)
	  VALUES(N'Uncategorized',N'Uncategorized');

END

GO

/*
===========================================================
 Table Name : CategoriesChildProducts
 Purpose    : Stores child/subcategories of product categories
===========================================================

 Columns:
 - ChildID      : Unique subcategory identifier
 - ChildName    : Subcategory name
 - CategoryID   : Parent product category
 - Description  : Subcategory description
 - Picture      : Relative path of subcategory image
 - Slug         : URL-friendly subcategory identifier

 Relationships:
 - CategoryID -> CategoriesProducts.CategoryID

 Notes:
 - Each child category belongs to one parent category.
===========================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CategoriesChildProducts')
BEGIN
CREATE TABLE CategoriesChildProducts (ChildID int NOT NULL IDENTITY PRIMARY KEY ,
									  ChildName nvarchar(15) NOT NULL,
									  CategoryID int NOT NULL CONSTRAINT FK_CategoriesChild_CategoriesProducts FOREIGN KEY (CategoryID) REFERENCES CategoriesProducts (CategoryID),
									  [Description] nvarchar(60) NULL ,
									  Picture nvarchar(500) NULL  , 
									  Slug nvarchar(40) NOT NULL UNIQUE);
END
GO 

/*
===========================================================
 Table Name : TagsProducts
 Purpose    : Stores tags used for products
===========================================================

 Columns:
 - TagID   : Unique tag identifier
 - TagName : Product tag name
 - Slug    : URL-friendly tag identifier

 Notes:
 - Slug must be unique.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'TagsProducts')
BEGIN
CREATE TABLE TagsProducts (TagID int  NOT NULL IDENTITY PRIMARY KEY ,
						   TagName nvarchar(15) NOT NULL ,
						   Slug nvarchar(40) NOT NULL UNIQUE );
END
GO

/*
===========================================================
 Table Name : CategoriesBlog
 Purpose    : Stores main categories for blog posts
===========================================================

 Columns:
 - CategoryID   : Unique blog category identifier
 - CategoryName : Blog category name
 - Description  : Category description
 - Picture      : Relative path of category image
 - Slug         : URL-friendly category identifier

 Notes:
 - Slug must be unique.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CategoriesBlog')
BEGIN
CREATE TABLE CategoriesBlog (CategoryID int NOT NULL IDENTITY PRIMARY KEY ,
								 CategoryName nvarchar(15) NOT NULL,
								 [Description] nvarchar(60) NULL ,
								 Picture nvarchar(500) NULL  , 
								 Slug nvarchar(15) NOT NULL UNIQUE);

INSERT INTO CategoriesBlog (CategoryName,Slug)
	  VALUES(N'Uncategorized',N'Uncategorized');
END
GO

/*
===========================================================
 Table Name : CategoriesChildBlog
 Purpose    : Stores child/subcategories of blog categories
===========================================================

 Columns:
 - ChildID      : Unique subcategory identifier
 - ChildName    : Subcategory name
 - CategoryID   : Parent blog category
 - Description  : Subcategory description
 - Picture      : Relative path of subcategory image
 - Slug         : URL-friendly subcategory identifier

 Relationships:
 - CategoryID -> CategoriesBlog.CategoryID

 Notes:
 - Each child category belongs to one parent blog category.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'CategoriesChildBlog')
BEGIN
CREATE TABLE CategoriesChildBlog (ChildID int NOT NULL IDENTITY PRIMARY KEY ,
									  ChildName nvarchar(15) NOT NULL,
									  CategoryID int NOT NULL CONSTRAINT FK_CategoriesChild_CategoriesBlog FOREIGN KEY (CategoryID) REFERENCES CategoriesBlog (CategoryID),
									  [Description] nvarchar(60) NULL ,
									  Picture nvarchar(500) NULL , 
									  Slug nvarchar(40) NOT NULL UNIQUE);
END 
GO

/*
===========================================================
 Table Name : TagsBlog
 Purpose    : Stores tags used for blog posts
===========================================================

 Columns:
 - TagID   : Unique tag identifier
 - TagName : Blog tag name
 - Slug    : URL-friendly tag identifier

 Notes:
 - Slug must be unique.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'TagsBlog')
BEGIN
CREATE TABLE TagsBlog (TagID int  NOT NULL IDENTITY PRIMARY KEY ,
					   TagName nvarchar(15) NOT NULL ,
					   Slug nvarchar(40) NOT NULL UNIQUE );
END
GO

/*
===========================================================
 Table Name : Products
 Purpose    : Stores all products available in the shop
===========================================================

 Columns:
 - ProductID         : Unique product identifier
 - ProductName       : Product display name
 - CategoryProductID : Product category reference
 - TagProductID      : Product tag reference
 - Description       : Product description
 - Price             : Original product price
 - Discount          : Discount amount
 - UnitsStock        : Current available stock
 - UnitOnOrder       : Number of units currently on order
 - ReorderLevel      : Minimum stock level before reorder
 - Thumbnail         : Main product image path
 - ImageGallery      : Product gallery image path/data
 - Discontinued       : Indicates whether the product is discontinued

 Relationships:
 - CategoryProductID -> CategoriesProducts.CategoryID
 - TagProductID      -> TagsProducts.TagID

 Notes:
 - Price cannot be negative
 - Discount cannot be greater than Price
 - Product images are stored as file paths
 - Stock-related fields are used for inventory management
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Products')
BEGIN
CREATE TABLE [Products] (
						ProductID int IDENTITY(1,1) PRIMARY KEY NOT NULL , 
						ProductName nvarchar(40) NOT NULL ,
						CategoryProductID int NOT NULL CONSTRAINT FK_Products_CategoriesProducts  FOREIGN KEY (CategoryProductID) REFERENCES CategoriesProducts (CategoryID) ,
						TagProductID int  NULL CONSTRAINT FK__Products_TagsProducts  FOREIGN KEY (TagProductID) REFERENCES TagsProducts (TagID)  , 
						[Description] nvarchar(200) NOT NULL ,
						Price money NOT NULL DEFAULT 0 CHECK (Price >= 0 ),
						Discount money NOT NULL DEFAULT 0 CHECK (Discount >= 0 ),
						UnitsStock smallint NOT NULL ,
						UnitOnOrder smallint NOT NULL,
						ReorderLevel smallint NOT NULL,
						Thumbnail nvarchar(500)  NULL  DEFAULT 'Z:\Users\AFERI\RiderProjects\WebShop.com\WebShop.com\wwwroot\Image\image-defult-website.webp',
						[ImageGallry] nvarchar(500)  NULL  ,
						Discontinued bit NOT NULL DEFAULT 0 
);

INSERT INTO [Products] (ProductName,TagProductID,[Description],Price,Discount,UnitsStock,ReorderLevel,Discontinued)
	VALUES ( N'Test Product',1,NULL,N'Test product description',100000,0,10,0,2,0);

END
GO 

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'MetaProducts')
BEGIN
	 CREATE TABLE MetaProducts (MetaID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	                            ProductID int NOT NULL CONSTRAINT FK_ProductMeta_Products FOREIGN KEY (ProductID) REFERENCES Products (ProductID) ,
								[MetaKey] nvarchar(255) NOT NULL ,
								[MetaValue] nvarchar(max))
END
GO 

/*
===========================================================
 Table Name : Posts
 Purpose    : Stores blog posts/articles
===========================================================

 Columns:
 - PostID         : Unique post identifier
 - Title          : Post title
 - Content        : Full post content
 - Thumbnail      : Main post image path
 - AuthorID       : User who created the post
 - CategoryPostID : Blog category reference
 - TagPostID      : Blog tag reference
 - CreateAt       : Post creation date
 - UpdateAt       : Last modification date

 Relationships:
 - AuthorID       -> Users.UserID
 - CategoryPostID -> CategoriesBlog.CategoryID
 - TagPostID      -> TagsBlog.TagID

 Notes:
 - TagPostID can be NULL.
 - UpdateAt can be NULL for posts that have never been edited.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Posts')
BEGIN
CREATE TABLE [Posts] (
					 PostID int NOT NULL IDENTITY PRIMARY KEY,
					 Title nvarchar(40) NOT NULL ,
					 Content nvarchar(MAX) NOT NULL ,
					 Thumbnail nvarchar(500)  NULL DEFAULT 'Z:\Users\AFERI\RiderProjects\WebShop.com\WebShop.com\wwwroot\Image\image-defult-website.webp' ,
					 AuthorID int NOT NULL CONSTRAINT FK_Posts_Users FOREIGN KEY (AuthorID) REFERENCES Users (UserID) ,
					 CategoryPostID int NOT NULL DEFAULT 1 CONSTRAINT FK_Posts_CategoriesBlog  FOREIGN KEY (CategoryPostID) REFERENCES CategoriesBlog (CategoryID) ,
					 TagPostID int NULL CONSTRAINT FK_Posts_TagsBlog  FOREIGN KEY (TagPostID) REFERENCES TagsBlog (TagID),
					 CreateAt datetime NOT NULL DEFAULT SYSDATETIME() ,
					 UpdateAt datetime NULL 
);
INSERT INTO [Posts] (Title,Content,AuthorID,CategoryPostID) 
	VALUES (N'The web: 20 infographics about business',
			N'light newspaper up its enjoyment agreeable depending. Timed voice share led him to widen noisy young. At weddings believed laughing although the material does the exercise of. Up attempt offered ye civilly so sitting to. She new course gets living within Elinor joy. She rapturous suffering concealed.
				Demesne far hearted suppose venture excited see had has. Dependent on so extremely delivered by. Yet no jokes worse her why. Bed one supposing breakfast day fulfilled off depending questions. Whatever boy her exertion his extended. Ecstatic followed handsome drawings entirely Mrs one yet outweigh. Of acceptance insipidity remarkably is an invitation.
				Warrant private blushes removed an in equally totally if. Delivered dejection necessary objection do Mr prevailed. Mr feeling does chiefly cordial in do. Water timed folly right aware if oh truth. Imprudence attachment him his for sympathize. Large',
				1,
				1);
END
GO 

/*
===========================================================
 Table Name : Post Meta
 Purpose    : Stores additional key/value metadata for blog posts
===========================================================

 Columns:
 - MetaID    : Unique metadata identifier
 - PostID    : Related post
 - MetaKey   : Metadata key
 - MetaValue : Metadata value

 Relationships:
 - PostID -> Posts.PostID

 Notes:
 - This table can be used for additional post information
   without adding new columns to Posts.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PostMeta')
BEGIN
CREATE TABLE [PostMeta] ( MetaID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
						   PostID int NOT NULL CONSTRAINT FK_PostMeta_Posts FOREIGN KEY (PostID) REFERENCES Posts (PostID) ,
						   [MetaKey] nvarchar(255) NOT NULL ,
						   [MetaValue] nvarchar(max)
);
END
GO


/*
===========================================================
 Table Name : Wishlist
 Purpose    : Stores products saved by users
===========================================================

 Columns:
 - WishlistID : Unique wishlist record identifier
 - ProductID  : Saved product
 - UserID     : User who saved the product

 Relationships:
 - ProductID -> Products.ProductID
 - UserID    -> Users.UserID

 Notes:
 - A user should not be able to add the same product
   to the wishlist more than once.
 - Unique index:
   IX_Wishlist_User_Product
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Wishlist')
BEGIN
CREATE TABLE Wishlist (WishlistID int NOT NULL IDENTITY PRIMARY KEY ,
					   ProductID int NOT NULL CONSTRAINT FK_Wishlist_Products FOREIGN KEY(ProductID) REFERENCES Products (ProductID)  ,
					   UserID int NOT NULL CONSTRAINT FK_Wishlist_Users FOREIGN KEY (UserID) REFERENCES Users (UserID) ,
					   );
CREATE UNIQUE INDEX IX_Wishlist_User_Product ON Wishlist(UserID, ProductID);

END
GO 

/*
===========================================================
 Table Name : FAQ
 Purpose    : Stores FAQ sections
===========================================================

 Columns:
 - FaqID  : Unique FAQ section identifier
 - Header : FAQ section title

 Notes:
 - Detailed questions and answers are stored in FaqDetails.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FAQ')
BEGIN
CREATE TABLE FAQ (FaqID int NOT NULL IDENTITY PRIMARY KEY , Header nvarchar(80) NOT NULL  ); 
END
GO 

/*
===========================================================
 Table Name : FaqDetails
 Purpose    : Stores questions and answers belonging to an FAQ
===========================================================

 Columns:
 - ID        : Unique FAQ detail identifier
 - FaqID     : Parent FAQ section
 - Questions : FAQ question
 - Answer    : FAQ answer

 Relationships:
 - FaqID -> FAQ.FaqID

 Notes:
 - Multiple FAQ details can belong to one FAQ section.
===========================================================
*/



IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'FaqDetails')
BEGIN
CREATE TABLE FaqDetails (ID int NOT NULL IDENTITY PRIMARY KEY ,
						 FaqID int NOT NULL CONSTRAINT FK_FaqDetails_FAQ FOREIGN KEY (FaqID) REFERENCES FAQ (FaqID) ,
						 Questions nvarchar(100) NOT NULL ,
						 Answer nvarchar(150) NOT NULL );
END
GO 

/*
===========================================================
 Table Name : Sliders
 Purpose    : Stores homepage slider/banner content
===========================================================

 Columns:
 - SliderID  : Unique slider identifier
 - TopTitle  : Small/top slider title
 - MainTitle : Main slider title
 - SubTitle  : Slider subtitle
 - Thumbnail : Slider image path
 - Slug      : URL-friendly slider identifier

 Notes:
 - Thumbnail has a default image.
 - Slug can be used for identifying sliders.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Sliders')
BEGIN
CREATE TABLE Sliders (SliderID int NOT NULL IDENTITY PRIMARY KEY ,
					  TopTitle nvarchar(50) NOT NULL ,
					  MainTitle nvarchar(50) NOT NULL ,
					  SubTitle nvarchar(50) NOT NULL,
					  Thumbnail nvarchar(500) NOT NULL DEFAULT 'Z:\Users\AFERI\RiderProjects\WebShop.com\WebShop.com\wwwroot\Image\image-defult-website.webp',
					  Slug nvarchar(80)
					  );
END
GO

/*
===========================================================
 Table Name : Baners
 Purpose    : Stores website promotional banners
===========================================================

 Columns:
 - BanerID   : Unique banner identifier
 - Title     : Banner title
 - Thumbnail : Banner image path
 - Slug      : URL-friendly banner identifier

 Notes:
 - Banner images are stored as relative paths.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Baners')
BEGIN
CREATE TABLE Baners (BanerID int NOT NULL IDENTITY PRIMARY KEY ,
                     Title nvarchar(35) NOT NULL ,
					 Thumbnail nvarchar(500) NOT NULL,
					 Slug nvarchar(80)
					 )
END
GO 

/*
===========================================================
 Table Name : Orders
 Purpose    : Stores customer orders
===========================================================

 Columns:
 - OrderID        : Unique order identifier
 - CustomerID     : User who placed the order
 - OrderDate      : Date when the order was created
 - RequiredDate   : Requested delivery date
 - ShippedDate    : Actual shipping date
 - ShipPostalCode : Customer postal code
 - ShipCountry    : Customer country
 - ShipCity       : Customer city
 - ShipAddress    : Customer shipping address
 - Freight        : Shipping cost

 Relationships:
 - CustomerID -> Users.UserID

 Notes:
 - RequiredDate and ShippedDate can be NULL
   because an order may not have been shipped yet.
 - Order items are stored separately in OrderDetails.
===========================================================
*/



IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Orders')
BEGIN
CREATE TABLE Orders (OrderID int NOT NULL IDENTITY PRIMARY KEY ,
					 CustomerID int NOT NULL CONSTRAINT FK_Orders_Users FOREIGN KEY (CustomerID) REFERENCES Users (UserID),
					 OrderDate datetime NOT NULL ,
					 RequiredDate datetime NULL ,
					 ShippedDate datetime  NULL ,
					 ShipPostalCode nvarchar(10) NOT NULL ,
					 ShipCountry nvarchar(15) NOT NULL  DEFAULT N'Iran', 
					 ShipCity nvarchar(15) NOT NULL ,
					 ShipAddress  nvarchar(60) NOT NULL ,
					 Freight money  NOT NULL 
					 );
END
GO


/*
===========================================================
 Table Name : OrderDetails
 Purpose    : Stores individual products belonging to an order
===========================================================

 Columns:
 - OrderDetailID : Unique order-detail identifier
 - OrderID       : Parent order reference
 - ProductID     : Ordered product reference
 - UnitPrice     : Product price at the time of purchase
 - Quantity      : Number of purchased units
 - Discount      : Discount applied to the item
 - Total         : Calculated final price

 Relationships:
 - OrderID   -> Orders.OrderID
 - ProductID -> Products.ProductID

 Notes:
 - UnitPrice is stored here intentionally.
   Product price may change after an order is placed,
   but the historical order price must remain unchanged.
 - Total is calculated automatically by SQL Server.
===========================================================
*/


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'OrderDetails')
BEGIN

	CREATE TABLE OrderDetails (OrderDetailID int NOT NULL IDENTITY PRIMARY KEY ,
						       OrderID int NOT NULL CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (OrderID) REFERENCES Orders (OrderID) ,
                               ProductID int NOT NULL CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (ProductID) REFERENCES Products (ProductID),
						       UnitPrice money NOT NULL ,
						       Quantity smallint NOT NULL ,
						       Discount real NOT NULL DEFAULT 0 , 
						       Total AS CONVERT(money,(UnitPrice * Quantity) * (1 -Discount )));
END
GO 

/*
===========================================================
 Table Name : Newsletter
 Purpose    : Store email addresses of users subscribed
              to the website newsletter

 Columns:
 - NewsletterID : Primary key and identity column
 - Email        : Subscriber email address
 - CreateAt     : Date and time when the subscription was created

 Notes:
 - This table is used to manage newsletter subscribers
 - Each record represents a newsletter subscription
===========================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Newsletter')
BEGIN 
     CREATE TABLE Newsletter (NewsletterID int NOT NULL IDENTITY PRIMARY KEY ,
							  Email nvarchar(40) NOT NULL , 
							  CreateAt datetime NOT NULL DEFAULT SYSDATETIME())
END
GO 

/*
===========================================================
 Table Name : VerifyCode
 Purpose    : Store verification codes used for
              phone number verification

 Columns:
 - VerifyCodeID : Primary key and identity column
 - Phone        : User phone number
 - VerifyCode   : Verification code sent to the user
 - CreateAt     : Date and time when the verification code
                  was created

 Notes:
 - Verification codes can be used for registration,
   login, or other phone verification processes
 - VerifyCode contains the temporary verification code
===========================================================
*/

IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE name = 'VerifyCode')
BEGIN 
	CREATE TABLE VerifyCode (VerifyCodeID int NOT NULL IDENTITY PRIMARY KEY,
	                         phone nvarchar(15) NOT NULL ,
							 VerifyCode nvarchar(6) NOT NULL ,
							 CreateAt datetime NOT NULL DEFAULT SYSDATETIME())
END 
GO 

/*
===========================================================
 Table Name : Token
 Purpose    : Store authentication or verification tokens

 Columns:
 - TokenID : Primary key and identity column
 - Email   : Email address associated with the token
 - Token   : Authentication or verification token
 - CreateAt: Date and time when the token was created

 Notes:
 - Tokens can be used for email verification,
   password reset, or other temporary authentication
   operations
 - Token should be treated as sensitive authentication data
===========================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Token')
BEGIN 
    CREATE TABLE Token (TokenID int NOT NULL IDENTITY PRIMARY KEY ,
	                    Email nvarchar(256) NOT NULL ,
						Token nvarchar(256) NOT NULL ,
						CreateAt datetime NOT NULL DEFAULT SYSDATETIME())
END
GO 

/*
===========================================================
 Table Name : WebsiteOptions
 Purpose    : Stores configurable website settings
===========================================================

 Columns:
 - OptionID   : Unique option identifier
 - KEYOption  : Configuration key
 - ValueOption: Configuration value

 Notes:
 - KEYOption must be unique.
 - This table can store global website settings such as:
     * Website title
     * Logo path
     * Contact information
     * Social media links
     * Default settings
===========================================================
*/

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'WebsiteOptions')
BEGIN
	 CREATE TABLE WebsiteOptions (OptionID int NOT NULL IDENTITY PRIMARY KEY ,
							      KEYOption nvarchar(20) NOT NULL UNIQUE,
							      ValueOption nvarchar(MAX) NOT NULL );
END
GO 

