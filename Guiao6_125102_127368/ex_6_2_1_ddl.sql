USE Company;
GO

CREATE TABLE employee (
   Fname               VARCHAR(16),
   Minit               VARCHAR(16),
   Lname               VARCHAR(16),
   Ssn                 INT	            NOT NULL,
   Bdate               DATE,
   Morada              VARCHAR(32),
   Sex                 VARCHAR(1),
   Salary              INT,
   Super_ssn           INT,
   Dno                 INT,
   PRIMARY KEY (Ssn),
   FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn)
);

CREATE TABLE department (
   Dname               VARCHAR(16),
   Dnumber             INT             NOT NULL,
   Mgr_ssn             INT,
   Mgr_start_date      DATE,
   PRIMARY KEY (Dnumber),
   UNIQUE(Dname)
);

CREATE TABLE dept_location (
   Dnumber             INT             NOT NULL,
   Dlocation           VARCHAR(16)     NOT NULL,
   PRIMARY KEY (Dnumber, Dlocation),
   FOREIGN KEY (Dnumber) REFERENCES department(Dnumber)
);

CREATE TABLE project (
   Pname               VARCHAR(16)    NOT NULL,
   Pnumber             INT            NOT NULL,
   Plocation           VARCHAR(16),
   Dnum                INT,
   PRIMARY KEY (Pnumber),
   UNIQUE(Pname),
   FOREIGN KEY (Dnum) REFERENCES department(Dnumber)
);

CREATE TABLE works_on (
   Essn                INT            NOT NULL,
   Pno                 INT            NOT NULL,
   Horas               INT, 
   PRIMARY KEY (Essn, Pno),
   FOREIGN KEY (Essn) REFERENCES employee(Ssn),
   FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);

CREATE TABLE dependent (
   Essn                INT         NOT NULL,
   Dependent_name      VARCHAR(16)    NOT NULL,
   Sex                 VARCHAR(1),
   Bdate               DATE,
   Relationship        VARCHAR(8),
   PRIMARY KEY (Essn, Dependent_name),
   FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);
GO