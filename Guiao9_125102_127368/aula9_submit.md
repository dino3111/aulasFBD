# BD: Guião 9


## ​9.1. Complete a seguinte tabela.
Complete the following table.

| #    | Query                                                                                                      | Rows  | Cost  | Pag. Reads | Time (ms) | Index used | Index Op.            | Discussion |
| :--- | :--------------------------------------------------------------------------------------------------------- | :---- | :---- | :--------- | :-------- | :--------- | :------------------- | :--------- |
| 1    | SELECT * from Production.WorkOrder                                                                         | 72591 |0,488021|   530   |   794     |    PK      |  Clustered Index Scan                    |            |
| 2    | SELECT * from Production.WorkOrder where WorkOrderID=1234                                                  |  1    |0,0032833| 26         |   66      |    PK      |     Clustered Index Seek             |            |
| 3.1  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 10000 and 10010                               |   11  |0,0032976|       2   |      74   |       PK   |      Clustered Index Seek    |            |
| 3.2  | SELECT * FROM Production.WorkOrder WHERE WorkOrderID between 1 and 72591                                   | 72591 | 0,488021|    530     |   616      |     PK     |    	Clustered Index Seek    |            |
| 4    | SELECT * FROM Production.WorkOrder WHERE StartDate = '2012-05-14'                                          |    55 |0,522864 |     530     |   151      |    PK      |   Clustered Index Scan      |            |
| 5    | SELECT * FROM Production.WorkOrder WHERE ProductID = 757                                                   |  9    |0,037359|      44    |    115      |ProductID| Non Clustered Index Seek/Clustered Key Lookup      |            
| 6.1  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 757                              |    9  |0,0373568| 44 |   15      | ProductID Covered (StartDate)    | Non Clustered Index/Clustered Key Lookup Seek       |            |
| 6.2  | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945                              |   1105|0,473502 |   554      |     81    |ProductID Covered (StartDate)|Non Clustered Index Seek|            |
| 6.3  | SELECT WorkOrderID FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04'            |   1   |0,473502|556|22|	ProductID Covered(StartDate)|Clustered Index Scan|            |
| 7    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04' |1|0,473502|556|23|ProductID and StartDate|Clustered Index Scan|            |
| 8    | SELECT WorkOrderID, StartDate FROM Production.WorkOrder WHERE ProductID = 945 AND StartDate = '2011-12-04' |1|0,473502|556|21|Composite (ProductID, StartDate)|Clustered Index Scan|            |

## ​9.2.

### a)

```
ALTER TABLE mytemp ADD CONSTRAINT ridPrimary PRIMARY KEY CLUSTERED (rid);
```

### b)

```
Fragmentation Percentage: 99,26 %
Page Fullness: 74,74 %
```

### c)

```
65: 44250ms

80: 57092ms

90: 52620ms

O de 65 é muito mais eficiente em termos de tmepo inserção.
```

### d)

```
65: 47830ms

80: 48342ms

90: 49285ms

Ao utilizarmos para o tipo IDENTITY garante tempos de inserção mais otimizados e eficientes.
```

### e)

```
CREATE NONCLUSTERED INDEX AT1 ON mytemp(at1);
CREATE NONCLUSTERED INDEX AT2 ON mytemp(at2);
CREATE NONCLUSTERED INDEX AT3 ON mytemp(at3);
CREATE NONCLUSTERED INDEX LIXO ON mytemp(lixo);

Sem: 113690 ms
Com: 118312 ms

As operações REMOVE e INSERT demoram mais a serem concluídas ao adicionar INDEXES.
```

## ​9.3.

```
i. CREATE UNIQUE CLUSTERED INDEX IxSsn ON EMPLOYEE(Ssn);
ii. CREATE INDEX IxFnameLname ON EMPLOYEE(Fname, Lname);
iii. CREATE INDEX IxEmpDep ON EMPLOYEE(Dno);
iv. CREATE INDEX IxWorksOnPno on WORKS_ON(Pno);
v. CREATE INDEX IxDpndEssn ON DEPENDENT(Essn);
vi. CREATE INDEX IxProjDnum ON PROJECT(Dnum);
```
