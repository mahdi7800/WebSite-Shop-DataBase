# WebShop Database

A SQL Server database project for a web-based shopping platform, designed to manage users, products, orders, website content, and application settings.

## Overview

**WebShop Database** is a relational database project built with Microsoft SQL Server and T-SQL. It provides the database foundation for an e-commerce website and includes tables for product management, user authentication, order processing, blog content, and other website features.

This project is currently under development. The database script is an initial implementation and may require further improvements before being used in a production environment.

## Features

- **User Management:** User accounts, profile information, and role-based classification.
- **Role Management:** Separate roles for administrators, managers, content managers, product managers, order managers, and customers.
- **Product Management:** Products, categories, subcategories, tags, pricing, discounts, and inventory information.
- **Blog Management:** Blog posts, categories, subcategories, tags, and metadata.
- **Order Management:** Customer orders and order details, including historical product prices and calculated totals.
- **Wishlist:** Database support for saving products to a wishlist.
- **Website Content:** FAQ entries, sliders, and banners.
- **Newsletter:** Storage of newsletter subscribers.
- **Authentication Support:** Tables for verification codes and tokens.
- **Website Settings:** Key-value storage for configurable website options.
- **Relational Integrity:** Primary keys, foreign keys, unique indexes, and default constraints.

## Technologies

- Microsoft SQL Server
- T-SQL (Transact-SQL)
- SQL Server Management Studio (SSMS)

## Database Structure

The `WebShopDb.sql` script defines the following tables:

| Table | Purpose |
|---|---|
| `Role` | Stores available user roles. |
| `Users` | Stores user accounts and profile information. |
| `CategoriesProducts` | Stores product categories. |
| `CategoriesChildProducts` | Stores product subcategories. |
| `TagsProducts` | Stores product tags. |
| `Products` | Stores product information and inventory data. |
| `MetaProducts` | Stores additional product metadata. |
| `CategoriesBlog` | Stores blog categories. |
| `CategoriesChildBlog` | Stores blog subcategories. |
| `TagsBlog` | Stores blog tags. |
| `Posts` | Stores blog posts and website content. |
| `PostMeta` | Stores additional post metadata. |
| `Wishlist` | Supports product wishlist functionality. |
| `Orders` | Stores customer orders. |
| `OrderDetails` | Stores individual items within orders. |
| `FAQ` | Stores frequently asked questions. |
| `FaqDetails` | Stores additional FAQ details. |
| `Sliders` | Stores website slider information. |
| `Baners` | Stores website banner information. |
| `Newsletter` | Stores newsletter subscriptions. |
| `VerifyCode` | Stores phone verification codes. |
| `Token` | Stores authentication or verification tokens. |
| `WebsiteOptions` | Stores website configuration settings. |

## Requirements

Before installing the database, make sure you have:

- Microsoft SQL Server installed and running.
- SQL Server Management Studio (SSMS), or another compatible SQL client.
- Sufficient permissions to create and manage databases.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/mahdi7800/WebSite-Shop-DataBase.git
cd WebSite-Shop-DataBase
```

### 2. Open the SQL script

Open `WebShopDb.sql` in SQL Server Management Studio.

### 3. Review the script

**Important:** The current script drops and recreates the `WebShopDb` database if it already exists. This operation permanently deletes the existing database and its data.

Do not execute the script against a database containing important information without first creating a verified backup.

### 4. Execute the script

Run `WebShopDb.sql` in SSMS. The script creates the database, defines its tables and relationships, and inserts initial role and category records.

### 5. Verify the database

After execution, refresh the Databases section in SSMS and verify that `WebShopDb` and its tables have been created successfully.

## Development Status

**Status: In Progress**

The database schema is an evolving part of the WebShop project. Some structures, constraints, and installation procedures may be incomplete or require additional validation.

Planned improvements include:

- Completing and reviewing the database schema.
- Improving installation safety and repeatability.
- Reviewing data types, constraints, and indexes.
- Improving authentication-related data handling.
- Adding database documentation and relationship diagrams.
- Testing the schema against the application's requirements.

## Security Notes

- Passwords must be stored as securely generated hashes, never as plaintext.
- Verification codes and authentication tokens should be protected and expire appropriately.
- Database credentials should not be committed to source control.
- The installation script should be reviewed before execution, especially on production servers.

## Contributing

Contributions, suggestions, and bug reports are welcome. Feel free to open an issue or submit a pull request to help improve the database design and installation process.

## Author

**Mahdi Davoudi**

GitHub: [@mahdi7800](https://github.com/mahdi7800)

## License

No license has been specified for this repository yet. Please contact the author before redistributing or reusing the project beyond the permissions granted by GitHub's default terms.
