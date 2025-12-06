# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
SELECT * FROM authors;
```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
SELECT au_lname, au_fname, phone from authors;
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
SELECT au_lname, au_fname, phone 
FROM authors
ORDER BY au_lname ASC, au_fname DESC;
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
SELECT au_lname as 'first_name', au_fname as 'last_name', phone as 'telephone' 
FROM authors
ORDER BY au_lname ASC, au_fname DESC;
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
SELECT au_lname AS 'first_name', au_fname AS 'last_name', phone AS 'telephone' 
FROM authors
WHERE state = 'CA'
  AND au_lname <> 'Ringer'
ORDER BY au_lname ASC, au_fname DESC;
```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
SELECT pub_name 
FROM publishers
WHERE pub_name LIKE '%Bo%';
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
SELECT DISTINCT publishers.pub_name
FROM
	publishers INNER JOIN titles on publishers.pub_id = titles.pub_id
WHERE 
    titles.type='Business';
```

### *h)* Número total de vendas de cada editora; 

```
SELECT p.pub_name AS "Editora", SUM(s.qty) AS "Total de Vendas"
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id 
JOIN sales s ON t.title_id = s.title_id  
GROUP BY p.pub_name;
```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
SELECT p.pub_name AS "Editora", t.title AS "Título", SUM(s.qty) AS "Total de Vendas"
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id 
JOIN sales s ON t.title_id = s.title_id  
GROUP BY p.pub_name, t.title
ORDER BY p.pub_name, t.title;
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
SELECT DISTINCT t.title AS "Título"
FROM titles t
JOIN sales s ON t.title_id = s.title_id
JOIN stores st ON s.stor_id = st.stor_id
WHERE st.stor_name = 'Bookbeat';
```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
SELECT a.au_fname AS "Nome", a.au_lname AS "Sobrenome"
FROM authors a
JOIN titleauthor ta ON a.au_id = ta.au_id
JOIN titles t ON ta.title_id = t.title_id
GROUP BY a.au_id, a.au_fname, a.au_lname
HAVING COUNT(DISTINCT t.type) > 1;
```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
SELECT t.type AS "Tipo", p.pub_name AS "Editora", AVG(t.price) AS "Preço Médio", SUM(s.qty) AS "Total de Vendas"
FROM titles t
JOIN publishers p ON t.pub_id = p.pub_id
LEFT JOIN sales s ON t.title_id = s.title_id
GROUP BY t.type, p.pub_id, p.pub_name;

```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
SELECT type
FROM titles
GROUP BY type
HAVING MAX(advance) > 1.5 * AVG(advance);
```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
SELECT 
    t.title AS "Título",
    a.au_fname AS "Nome Autor",
    a.au_lname AS "Sobrenome Autor",
    (t.ytd_sales * t.price * ta.royaltyper / 100.0) AS "Valor Arrecadado"
FROM titles t
JOIN titleauthor ta ON t.title_id = ta.title_id
JOIN authors a ON ta.au_id = a.au_id
WHERE t.ytd_sales IS NOT NULL
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```
SELECT 
    t.title AS "Título",
    t.ytd_sales AS "Número de Vendas",
    (t.ytd_sales * t.price) AS "Faturação Total",
    (t.ytd_sales * t.price * t.royalty / 100.0) AS "Faturação Autores",
    (t.ytd_sales * t.price * (100 - t.royalty) / 100.0) AS "Faturação Editora"
FROM titles t
WHERE t.ytd_sales IS NOT NULL AND t.price IS NOT NULL;
```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```
SELECT 
    t.title AS "Título",
    t.ytd_sales AS "Número de Vendas",
    a.au_fname + ' ' + a.au_lname AS "Autor",
    (t.ytd_sales * t.price * ta.royaltyper / 100.0) AS "Faturação Autor",
    (t.ytd_sales * t.price * (100 - ta.royaltyper) / 100.0) AS "Faturação Editora"
FROM titles t
JOIN titleauthor ta ON t.title_id = ta.title_id
JOIN authors a ON ta.au_id = a.au_id
WHERE t.ytd_sales IS NOT NULL AND t.price IS NOT NULL;
```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
SELECT S.stor_name, COUNT(DISTINCT T.title_id) AS different_titles_sold FROM stores S
JOIN sales SALS ON S.stor_id = SALS.stor_id
JOIN titles T ON SALS.title_id = T.title_id
GROUP BY S.stor_name;
```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
SELECT stor_name, sum(qty) AS sum_qty FROM sales 
JOIN stores ON sales.stor_id=stores.stor_id
GROUP BY stor_name 
	HAVING sum(qty) > ( select avg(sum_qty) 
		FROM (  select sum(qty) 
			AS sum_qty, stor_id 
				AS stid FROM sales
GROUP BY stor_id) as T);
```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
select title FROM titles
EXCEPT
select title FROM titles, stores, sales
WHERE stores.stor_id = sales.stor_id AND titles.title_id = sales.title_id AND stores.stor_name = 'Bookbeat';
```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```
(select pub_name, stor_name FROM stores, publishers )
EXCEPT
(select pub_name, stor_name FROM publishers 
JOIN ( select pub_id AS ppid, sales.stor_id, stor_name FROM titles JOIN sales
ON titles.title_id=sales.title_id
JOIN stores
ON sales.stor_id=stores.stor_id) AS T
ON pub_id=ppid);
```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT employee.Ssn, employee.Fname, employee.Lname, project.Pname FROM employee 
JOIN works_on ON employee.Ssn=works_on.Essn
JOIN project ON works_on.Pno=project.Pnumber
```

##### *b)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname FROM employee 
JOIN 
					(SELECT employee.Ssn AS Ssn_carlos FROM employee
					WHERE employee.Fname='Carlos' 
	 				AND employee.Minit='D' 
	 				AND employee.Lname='Gomes') 

AS T ON employee.Super_ssn=T.Ssn_carlos
```

##### *c)* 

```
SELECT P.Pname, T.Sum_hours FROM project AS P 
JOIN (SELECT works_on.Pno , SUM(Horas) as Sum_hours FROM works_on GROUP BY works_on.Pno) AS T 
ON P.Pnumber = T.Pno
```

##### *d)* 

```
SELECT employee.Fname, employee.Minit, employee.Lname FROM employee 
JOIN works_on ON employee.Ssn=works_on.Essn
WHERE employee.Dno=3 AND works_on.Horas>20
```

##### *e)* 

```
SELECT employee.Fname,	employee.Minit, employee.Lname FROM employee 
LEFT JOIN works_on ON employee.Ssn=works_on.Essn 
WHERE works_on.Essn IS NULL
```

##### *f)* 

```
SELECT department.Dname, employee.Fname, employee.Lname, employee.Salary, T.average_salary FROM employee
JOIN department ON employee.Dno = department.Dnumber
JOIN
    (SELECT Dno, AVG(Salary) AS average_salary
     FROM employee
     WHERE Sex = 'F'
     GROUP BY Dno) AS T ON employee.Dno = T.Dno
WHERE employee.Sex = 'F'
ORDER BY department.Dname, employee.Lname;
```

##### *g)* 

```
SELECT employee.Ssn, employee.Fname, employee.Minit, employee.Lname, COUNT(dependent.Essn) AS cont
FROM employee
JOIN dependent ON employee.Ssn = dependent.Essn
GROUP BY employee.Ssn, employee.Fname, employee.Minit, employee.Lname
HAVING COUNT(dependent.Essn) > 2;
```

##### *h)* 

```
SELECT Ssn, Fname, Minit, Lname FROM dependent 
RIGHT JOIN (SELECT Ssn, Fname, Minit, Lname FROM employee JOIN department ON Ssn = Mgr_ssn) AS T ON Ssn = Essn
WHERE Essn IS NULL
```

##### *i)* 

```
SELECT DISTINCT e.Fname, e.Lname, e.Morada FROM employee e
JOIN works_on w ON e.Ssn = w.Essn
JOIN project pr ON w.Pno = pr.Pnumber
JOIN department d ON e.Dno = d.Dnumber
JOIN dept_location dl ON d.Dnumber = dl.Dnumber -- Junção correta
WHERE pr.Plocation = 'Aveiro' AND dl.Dlocation != 'Aveiro'
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT fornecedor.nif, fornecedor.nome FROM encomenda 
RIGHT OUTER JOIN fornecedor on encomenda.fornecedor = fornecedor.nif
WHERE encomenda.numero is NULL
```

##### *b)* 

```
SELECT produto.nome, AVG(item.unidades) AS avg_units FROM produto 
JOIN item ON produto.codigo = item.codProd
GROUP BY produto.nome
```


##### *c)* 

```
SELECT AVG(subquery.count_products) AS avg_products
FROM (
  SELECT numEnc, COUNT(*) AS count_products
  FROM item
  GROUP BY numEnc
) AS subquery;
```


##### *d)* 

```
SELECT
    fornecedor.nome,
    produto.nome,
    SUM(item.unidades) 
FROM fornecedor
JOIN encomenda ON fornecedor.nif = encomenda.fornecedor
JOIN item ON encomenda.numero = item.numEnc
JOIN produto ON item.codProd = produto.codigo
GROUP BY fornecedor.nome, produto.nome
ORDER BY fornecedor.nome, produto.nome;
```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
SELECT paciente.nome FROM paciente 
LEFT JOIN prescricao ON paciente.numUtente = prescricao.numUtente
WHERE prescricao.numUtente IS NULL
```

##### *b)* 

```
SELECT medico.especialidade, COUNT(prescricao.numPresc) AS cout_numPresc FROM medico 
JOIN prescricao ON medico.numSNS = prescricao.numMedico
GROUP BY medico.especialidade
```


##### *c)* 

```
SELECT farmacia.nome, COUNT(prescricao.numPresc) AS cout_numPresc FROM farmacia 
JOIN prescricao ON farmacia.nome = prescricao.farmacia
GROUP BY farmacia.nome
```


##### *d)* 

```
SELECT farmaco.nome
FROM farmaco
WHERE farmaco.numRegFarm = 906 

EXCEPT 

SELECT presc_farmaco.nomeFarmaco
FROM presc_farmaco
WHERE presc_farmaco.numRegFarm = 906
```

##### *e)* 

```
SELECT farmacia.nome, farmaceutica.nome, COUNT(farmaceutica.nome) AS count_farm FROM prescricao
JOIN farmacia ON prescricao.farmacia = farmacia.nome
JOIN presc_farmaco ON prescricao.numPresc = presc_farmaco.numPresc
JOIN farmaceutica ON presc_farmaco.numRegFarm = farmaceutica.numReg 
GROUP BY farmacia.nome, farmaceutica.nome
```

##### *f)* 

```
SELECT paciente.nome FROM paciente
JOIN prescricao ON paciente.numUtente = prescricao.numUtente
GROUP BY paciente.numUtente, paciente.nome
HAVING COUNT(DISTINCT prescricao.numMedico) > 1
```
