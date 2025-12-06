CREATE TABLE TIPOVEICULO (
    Codigo          INT             NOT NULL,
    ArCondicionado  BIT             NOT NULL,
    Designacao      VARCHAR(100)    NOT NULL,
    PRIMARY KEY (Codigo)
);

CREATE TABLE VEICULO (
    Matricula   VARCHAR(30)     NOT NULL,
    Ano         INT             NOT NULL,
    Marca       VARCHAR(100)    NOT NULL,
    Codigo      INT             NOT NULL,
    PRIMARY KEY (Matricula),
    FOREIGN KEY (Codigo) REFERENCES TIPOVEICULO(Codigo)
);

CREATE TABLE CLIENTE (
    Nome        VARCHAR(256)    NOT NULL,
    Endereco    VARCHAR(256)    NOT NULL,
    Num_Carta   INT             NOT NULL,
    NIF         CHAR(9)         NOT NULL,
    PRIMARY KEY (NIF)
);

CREATE TABLE BALCAO (
    Nome        VARCHAR(256)    NOT NULL,
    Numero      INT             NOT NULL,
    Endereco    VARCHAR(256)    NOT NULL,
    PRIMARY KEY (Numero)
);

CREATE TABLE ALUGUER (
    Numero      INT             NOT NULL,
    Duracao     INT             NOT NULL,
    DataA       datetime        NOT NULL,
    NIF2        CHAR(9)         NOT NULL,
    NR_Balcao   INT             NOT NULL,
    NR_Matri    VARCHAR(30)     NOT NULL,
    PRIMARY KEY (Numero),
    FOREIGN KEY (NIF2)      REFERENCES CLIENTE(NIF),
    FOREIGN KEY (NR_Balcao) REFERENCES BALCAO(Numero),
    FOREIGN KEY (NR_Matri)  REFERENCES VEICULO(Matricula)
);

CREATE TABLE LIGEIRO (
    numLugares      INT         NOT NULL,
    Portas          INT         NOT NULL,
    Combustivel     VARCHAR(50) NOT NULL,
    Codigo          INT         NOT NULL,
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo) REFERENCES TIPOVEICULO(Codigo)
);

CREATE TABLE PESADO (
    Peso            FLOAT       NOT NULL,
    Passageiros     INT         NOT NULL,
    Codigo          INT         NOT NULL,
    PRIMARY KEY (Codigo),
    FOREIGN KEY (Codigo) REFERENCES TIPOVEICULO(Codigo)
);

CREATE TABLE SIMILARIDADE (
    Cod1    INT     NOT NULL,
    Cod2    INT     NOT NULL,
    PRIMARY KEY (Cod1, Cod2),
    FOREIGN KEY (Cod1) REFERENCES TIPOVEICULO(Codigo),
    FOREIGN KEY (Cod2) REFERENCES TIPOVEICULO(Codigo)
);
