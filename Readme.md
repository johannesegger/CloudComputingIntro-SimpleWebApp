## Post-deploy actions

1. Navigate to the DB in the Azure Portal and run the following in the DB query editor:

    ```sql
    -- Enable access from web app - *Managed Identity*
    CREATE USER [<webappname>] FROM EXTERNAL PROVIDER;
    ALTER ROLE db_datareader ADD MEMBER [<webappname>];
    ALTER ROLE db_datawriter ADD MEMBER [<webappname>];
    -- ALTER ROLE db_ddladmin ADD MEMBER [<webappname>];

    -- Create schema and insert some test data
    CREATE TABLE students (
        id INT NOT NULL IDENTITY PRIMARY KEY,
        NAME VARCHAR(255) NOT NULL
    );
    INSERT INTO students (name) VALUES ('Bauernfeind Robert'), ('Bijelic Lukas'), ('Broeckx Marvin');
    ```
