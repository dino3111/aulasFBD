# BD: Guião 8


## ​8.1
 
### *a)*

```
CREATE PROCEDURE ex1
    @ssn CHAR(9),
    @deleteStatus INT OUTPUT,
    @message VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION
            -- Atualiza os funcionários que tinham o @ssn como supervisor
            UPDATE EMPLOYEE
            SET Super_ssn = NULL
            WHERE Super_ssn = @ssn;

            -- Atualiza os departamentos que tinham o @ssn como gestor
            UPDATE DEPARTMENT
            SET Mgr_ssn = NULL
            WHERE Mgr_ssn = @ssn;

            -- Remover Dependentes
            DELETE FROM DEPENDENT
            WHERE Essn = @ssn;

            -- Remover Entradas em WORKS_ON
            DELETE FROM WORKS_ON
            WHERE Essn = @ssn;

            -- Remover o Funcionário
            DELETE FROM EMPLOYEE
            WHERE Ssn = @ssn;

            SET @deleteStatus = 0;
            SET @message = 'Funcionário apagado.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        SET @deleteStatus = -1;
        SET @message = 'Erro ao apagar o funcionário:' + ERROR_MESSAGE();
    END CATCH
END
GO
```

### *b)* 

```
CREATE PROCEDURE ex2
AS
BEGIN
    DECLARE @MaisAntigoSSN CHAR(9);
    DECLARE @AnosComoGestor INT;

    -- encontrar o mais antigo e calcular
    SELECT TOP 1
        @MaisAntigoSSN = D.Mgr_ssn,
        -- data atual - antiga
        @AnosComoGestor = DATEDIFF(year, D.Mgr_start_date, GETDATE())
    FROM 
        DEPARTMENT AS D
    WHERE
        D.Mgr_ssn IS NOT NULL
    ORDER BY 
        D.Mgr_start_date ASC; -- ordena pela data de inicio mais antiga

    SELECT
        E.Fname,
        E.Minit,
        E.Lname,
        E.Ssn AS Gestor_SSN,
        D.Dname AS Nome_Departamento,
        D.Mgr_start_date AS Data_Inicio_Gestao,
        -- Adiciona as informações do gestor mais antigo a cada linha do record-set, para serem retornadas num só resultado.
        @MaisAntigoSSN AS SSN_Gestor_Mais_Antigo,
        @AnosComoGestor AS Anos_Gestor_Mais_Antigo
    FROM 
        EMPLOYEE AS E
    INNER JOIN 
        DEPARTMENT AS D ON E.Ssn = D.Mgr_ssn
    ORDER BY 
        D.Mgr_start_date ASC;

END;
GO
```

### *c)* 

```
CREATE TRIGGER ex3
ON Company_Department
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Verifica se o Mgr_ssn já existe como gestor de um outro departamento 
        IF EXISTS (
        SELECT I.Mgr_ssn
        FROM INSERTED I
        INNER JOIN Company_Department D ON I.Mgr_ssn = D.Mgr_ssn
        WHERE I.Dnumber <> D.Dnumber 
    )
    BEGIN
        -- Erro
        RAISERROR ('Erro, este funcionário já é gestor de outro departamento.', 16, 1);
        RETURN;
    END
    ELSE
    BEGIN
        -- INSERT:
        IF EXISTS (SELECT * FROM INSERTED) AND NOT EXISTS (SELECT * FROM DELETED) 
            INSERT INTO Company_Department (Dname, Dnumber, Mgr_ssn, Mgr_start_date)
            SELECT Dname, Dnumber, Mgr_ssn, Mgr_start_date FROM INSERTED;
        
        -- UPDATE:
        ELSE IF EXISTS (SELECT * FROM INSERTED) AND EXISTS (SELECT * FROM DELETED) 
            UPDATE D
            SET D.Dname = I.Dname,
                D.Mgr_ssn = I.Mgr_ssn,
                D.Mgr_start_date = I.Mgr_start_date
            FROM Company_Department D INNER JOIN INSERTED I ON D.Dnumber = I.Dnumber;
    END
END
GO
```

### *d)* 

```
CREATE TRIGGER ex4
ON Company_Employee
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE E
    -- Colocar salário para > Salário Gestor - 1
    SET E.Salary = M.Salary - 1
    FROM Company_Employee E

    -- Apenas para funcionários inseridos à pouco tempo ou atualizados
    INNER JOIN inserted I ON E.Ssn = I.Ssn 
    INNER JOIN Company_Department D ON E.Dno = D.Dnumber

    -- M é o Gestor
    INNER JOIN Company_Employee M ON D.Mgr_ssn = M.Ssn

    -- Verifica se o salário do E (funcionário) > M (Gestor)
    WHERE E.Salary > M.Salary;

END
GO
```

### *e)* 

```
GO
CREATE FUNCTION ex5 (@ssn CHAR(9))
RETURNS TABLE 
AS
RETURN 
(
    SELECT Proj.Pname, Proj.Plocation
    FROM Company_Project Proj
    INNER JOIN Company_WorksOn w ON Proj.Pnumber = w.Pno
    WHERE w.Essn = @ssn
);
GO
```

### *f)* 

```
CREATE FUNCTION ex6 (@Dno INT)
RETURNS TABLE AS 
RETURN (
    SELECT Emp.Fname, Emp.Minit, Emp.Lname, Emp.Salary
    FROM Company_Employee Emp
    WHERE Emp.Dno = @Dno
    AND Emp.Salary > (
        SELECT AVG(Salary)
        FROM Company_Employee
        WHERE Dno = @Dno
    )
);
GO
```

### *g)* 

```
CREATE FUNCTION ex7 (@dno INT)
RETURNS @ProjectBudget TABLE
(
    Pname VARCHAR(50),
    Pnumber INT,
    Plocation VARCHAR(50),
    Dnum INT,
    budget DECIMAL(10, 2),        
    totalbudget DECIMAL(10, 2)    
)
AS
BEGIN
    -- Variáveis de iteração
    DECLARE @Pno_Cursor INT;
    DECLARE @ProjectName VARCHAR(50);
    DECLARE @ProjectLocation VARCHAR(50);
    
    -- Variáveis de cálculo
    DECLARE @CurrentProjectBudget DECIMAL(10, 2);
    -- Inicializar o acumulador
    DECLARE @TotalBudget DECIMAL(10, 2) = 0.00; 

    -- Obtém apenas os projetos do departamento
    DECLARE ProjectCursor CURSOR LOCAL FOR
        SELECT Pnumber, Pname, Plocation
        FROM PROJECT
        WHERE Dnum = @dno
        ORDER BY Pnumber;

    OPEN ProjectCursor;
    FETCH NEXT FROM ProjectCursor INTO @Pno_Cursor, @ProjectName, @ProjectLocation;

    -- Processamento, por cada projeto
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcula o Orçamento Mensal de Mão de Obra para o projeto atual
        SELECT @CurrentProjectBudget = SUM(E.Salary / 52.0 / 40.0 * WO.Hours * 4.0) 
        FROM WORKS_ON WO
        INNER JOIN EMPLOYEE E ON WO.Essn = E.Ssn
        WHERE WO.Pno = @Pno_Cursor;

        -- Acumula o orçamento total
        SET @TotalBudget = @TotalBudget + ISNULL(@CurrentProjectBudget, 0.00);

        -- Insere a linha na tabela de resultados
        INSERT INTO @ProjectBudget (Pname, Pnumber, Plocation, Dnum, budget, totalbudget)
        VALUES (@ProjectName, @Pno_Cursor, @dno, @dno, ISNULL(@CurrentProjectBudget, 0.00), @TotalBudget);

        FETCH NEXT FROM ProjectCursor INTO @Pno_Cursor, @ProjectName, @ProjectLocation;
    END

    -- Fecho e Libertação do Cursor
    CLOSE ProjectCursor;
    DEALLOCATE ProjectCursor;

    RETURN;
END
GO
```

### *h)* 

```
GO
CREATE TRIGGER ex8
ON Company.Department
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Department_Deleted')
    BEGIN
        SELECT 
            D.*, 
            GETDATE() AS Deleted_At 
        INTO 
            Department_Deleted -- Sem prefixo de esquema
        FROM 
            deleted D 
        WHERE 
            1 = 0; 
            
        ALTER TABLE Department_Deleted
        ADD CONSTRAINT PK_DeptDel_IO PRIMARY KEY (Dnumber);
    END

    INSERT INTO Department_Deleted (Dname, Dnumber, Mgr_ssn, Mgr_start_date, Deleted_At)
    SELECT Dname, Dnumber, Mgr_ssn, Mgr_start_date, GETDATE() FROM deleted;

END
GO

Vantagens : Simplicidade e Controlo Total sobre a transação
Desvantagens : Perda de Dados e Anulações de FKs.
```

### *i)* 

```
As Stored Procedures (SPs) e User-Defined Functions (UDFs) são ferramentas para organizar código nas bases de dados. Ambas melhoram o desempenho através da pré-compilação e aumentam a segurança.

A diferença principal está no que podem fazer: as SPs podem modificar dados (INSERT, UPDATE, DELETE), enquanto as UDFs apenas podem ler dados. Além disso, as SPs executam sozinhas (com EXEC) e as UDFs são usadas dentro de outras queries (como SELECT).

Usamos SPs para ações que alteram dados, como registrar vendas ou processos complexos. Usamos UDFs para cálculos específicos, como calcular IVA ou formatar dados dentro de consultas.

```
