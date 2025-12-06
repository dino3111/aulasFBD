--Tabela Airport:
CREATE TABLE dbo.Airport (
    PK_Airport_Code VARCHAR(10)     NOT NULL,
    City            VARCHAR(100),
    State           VARCHAR(50),
    Name            VARCHAR(255),
    PRIMARY KEY (PK_Airport_Code)
);

--Tabela Airplane_Type:
CREATE TABLE dbo.Airplane_Type (
    PK_Type_Name    VARCHAR(50)     NOT NULL,
    Company         VARCHAR(100),
    Max_Seats       INT,
    PRIMARY KEY (PK_Type_Name)
);

--Tabela Can_Land:
CREATE TABLE dbo.Can_Land (
    FK_Airport_Code         VARCHAR(10)     NOT NULL,
    FK_Type_Name_Airport    VARCHAR(50)     NOT NULL,
    PRIMARY KEY (FK_Airport_Code, FK_Type_Name_Airport),
    FOREIGN KEY (FK_Airport_Code) REFERENCES dbo.Airport(PK_Airport_Code),
    FOREIGN KEY (FK_Type_Name_Airport) REFERENCES dbo.Airplane_Type(PK_Type_Name)
);

--Tabela Airplane:
CREATE TABLE dbo.Airplane (
    PK_Airplace_ID  VARCHAR(50)     NOT NULL,
    Total_No_Of_Seats INT,
    FK_Type_Name    VARCHAR(50),
    PRIMARY KEY (PK_Airplace_ID),
    FOREIGN KEY (FK_Type_Name) REFERENCES dbo.Airplane_Type(PK_Type_Name)
);

--Tabela Flight:
CREATE TABLE dbo.Flight (
    PK_Number       INT             NOT NULL,
    Airline         VARCHAR(100),
    Weekdays        VARCHAR(50),
    PRIMARY KEY (PK_Number)
);

--Tabela Flight_Leg:
CREATE TABLE dbo.Flight_Leg (
    PK_Leg_No       INT             NOT NULL,
    FK_Number_Flight INT            NOT NULL,
    Schedule_dep_time TIME,
    Schedule_arr_time TIME,
    FK_Airport_Code VARCHAR(10),
    FK_Departure_Airport_Code VARCHAR(10),
    
    PRIMARY KEY (PK_Leg_No, FK_Number_Flight),
    
    FOREIGN KEY (FK_Airport_Code) REFERENCES dbo.Airport(PK_Airport_Code),
    FOREIGN KEY (FK_Departure_Airport_Code) REFERENCES dbo.Airport(PK_Airport_Code),
    FOREIGN KEY (FK_Number_Flight) REFERENCES dbo.Flight(PK_Number)
);

--Tabela Leg_Instance:
CREATE TABLE dbo.Leg_Instance (
    PK_Date             DATE            NOT NULL,
    FK_Leg_No           INT             NOT NULL,
    FK_Number_Flight    INT             NOT NULL,
    
    No_Of_Avail_Seats   INT,
    FK_Airplance_ID     VARCHAR(50),
    Dep_Time            TIME,
    Arr_Time            TIME,
    FK_Airport_Code     VARCHAR(10),
    
    PRIMARY KEY (PK_Date, FK_Leg_No, FK_Number_Flight),
    
    FOREIGN KEY (FK_Leg_No, FK_Number_Flight) REFERENCES dbo.Flight_Leg(PK_Leg_No, FK_Number_Flight),
    FOREIGN KEY (FK_Airplance_ID) REFERENCES dbo.Airplane(PK_Airplace_ID),
    FOREIGN KEY (FK_Airport_Code) REFERENCES dbo.Airport(PK_Airport_Code)
);

--Tabela Seat:
CREATE TABLE dbo.Seat (
    PK_Seat_No          VARCHAR(10)     NOT NULL,
    FK_Date             DATE            NOT NULL,
    FK_Leg_No           INT             NOT NULL,
    FK_Number_Flight    INT             NOT NULL,
    
    Customer_Name       VARCHAR(255),
    Cphone              VARCHAR(20),
    
    PRIMARY KEY (PK_Seat_No, FK_Date, FK_Leg_No, FK_Number_Flight),
    
    FOREIGN KEY (FK_Date, FK_Leg_No, FK_Number_Flight) 
        REFERENCES dbo.Leg_Instance(PK_Date, FK_Leg_No, FK_Number_Flight)
);

--Tabela Fare:
CREATE TABLE dbo.Fare (
    FK_Number       INT             NOT NULL,
    PK_Fare_Code    VARCHAR(20)     NOT NULL,
    Amount          DECIMAL(10, 2),
    Restrictions    VARCHAR(255),
    PRIMARY KEY (FK_Number, PK_Fare_Code),
    FOREIGN KEY (FK_Number) REFERENCES dbo.Flight(PK_Number)
);