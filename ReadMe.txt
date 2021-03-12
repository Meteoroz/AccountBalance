* Modify the database script located in Data\SqlScripts, so that it contains a valid path for the MDF and LDF files to create the IIS Express LocalDb.
	Run the script.
	This will create the database, tables and seed them with data.

* Load the AccountBalance solution in Visual Studio, update nuget packages and run with 'AccountBalance' as the startup project.
* Test with Postman using https://localhost:44311/account/tim for a valid response or https://localhost:44311/account/<any_other_name> for testing account not found

Architecture
============

The solution is a .Net Core web api which connects to an SQL Server Express database to retrieve account and payment details.
It uses the built-in .Net Core dependency injection which facilitates testing and cleanliness of code.
Built-in logging is also used which could be extended to provide more information.
XUnit was used for the unit test. If I'd had more time I would have written more tests for the Controller and checking for correct responses.
The Controller calls the BusinessServicesLayer which is responsible for retrieving data from the dbContext and mapping it to DTOs.
I would normally use Automapper for the mapping, but as there were only a couple of classes, I left it manual.

The Data project contains the data access code and was created using Database-First scaffolding, then extracting an interface for DI.

The unit test is located in AccountBalanceTests.
