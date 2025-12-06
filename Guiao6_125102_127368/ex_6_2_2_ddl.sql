USE GetStock;
GO

CREATE TABLE tipo_fornecedor (
    codigo      INT             NOT NULL,
    designacao  VARCHAR(50),
    PRIMARY KEY (codigo)
);

CREATE TABLE fornecedor (
    nif         INT             NOT NULL,
    nome        VARCHAR(100)    NOT NULL,
    fax         INT,
    endereco    VARCHAR(255),
    condpag     INT,
    tipo        INT,
    PRIMARY KEY (nif),
    FOREIGN KEY (tipo) REFERENCES tipo_fornecedor(codigo)
);

CREATE TABLE produto (
    codigo      INT             NOT NULL,
    nome        VARCHAR(100)    NOT NULL,
    preco       DECIMAL(10, 2), 
    iva         DECIMAL(5, 2),
    unidades    INT,
    PRIMARY KEY (codigo)
);

CREATE TABLE encomenda (
    numero      INT             NOT NULL,
    data        DATE,
    fornecedor  INT,          
    PRIMARY KEY (numero),
    FOREIGN KEY (fornecedor) REFERENCES fornecedor(nif)
);

CREATE TABLE item (
    numEnc      INT             NOT NULL,
    codProd     INT             NOT NULL,
    unidades    INT,
    PRIMARY KEY (numEnc, codProd),
    FOREIGN KEY (numEnc) REFERENCES encomenda(numero),
    FOREIGN KEY (codProd) REFERENCES produto(codigo)
);