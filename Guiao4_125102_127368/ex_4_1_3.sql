--Tabela Fornecedor:
CREATE TABLE dbo.Fornecedor (
    PK_NIE             CHAR(9)         NOT NULL,
    Nome               VARCHAR(255)    NOT NULL,
    Endereco           VARCHAR(255),
    FAX                VARCHAR(20),
    Condicoes_de_Pagamento VARCHAR(100),
    PRIMARY KEY (PK_NIE)
);

--Tabela Produto:
CREATE TABLE dbo.Produto (
    PK_Codigo          INT             NOT NULL,
    Nome               VARCHAR(255)    NOT NULL,
    IVA                DECIMAL(5, 2),
    Preco              DECIMAL(10, 2),
    PRIMARY KEY (PK_Codigo)
);

--Tabela Tipo:
CREATE TABLE dbo.Tipo (
    PK_Codigo          INT             NOT NULL,
    Designacao         VARCHAR(100)    NOT NULL,
    PRIMARY KEY (PK_Codigo)
);

--Tabela Encomenda:
CREATE TABLE dbo.Encomenda (
    PK_num_Encomenda   INT             NOT NULL,
    Data               DATE,
    FK_NIE             CHAR(9),
    PRIMARY KEY (PK_num_Encomenda),
    FOREIGN KEY (FK_NIE) REFERENCES dbo.Fornecedor(PK_NIE)
);

--Tabela Tipo_Produto:
CREATE TABLE dbo.Tipo_Produto (
    FK_Codigo_Produto  INT             NOT NULL,
    FK_Codigo_Tipo     INT             NOT NULL,
    PRIMARY KEY (FK_Codigo_Produto, FK_Codigo_Tipo),
    FOREIGN KEY (FK_Codigo_Produto) REFERENCES dbo.Produto(PK_Codigo),
    FOREIGN KEY (FK_Codigo_Tipo) REFERENCES dbo.Tipo(PK_Codigo)
);

--Tabela Produto_Encomenda:
CREATE TABLE dbo.Produto_Encomenda (
    FK_Codigo_Produto  INT             NOT NULL,
    FK_num_Encomenda   INT             NOT NULL,
    num_Unidades       INT,
    PRIMARY KEY (FK_Codigo_Produto, FK_num_Encomenda),
    FOREIGN KEY (FK_Codigo_Produto) REFERENCES dbo.Produto(PK_Codigo),
    FOREIGN KEY (FK_num_Encomenda) REFERENCES dbo.Encomenda(PK_num_Encomenda)
);