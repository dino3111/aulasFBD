USE Saude;
GO

CREATE TABLE medico (
    numSNS          INT             NOT NULL,
    nome            VARCHAR(100)    NOT NULL,
    especialidade   VARCHAR(50),
    PRIMARY KEY (numSNS)
);

CREATE TABLE paciente (
    numUtente       INT             NOT NULL,
    nome            VARCHAR(100)    NOT NULL,
    dataNasc        DATE,
    endereco        VARCHAR(255),
    PRIMARY KEY (numUtente)
);

CREATE TABLE farmacia (
    nome            VARCHAR(100)    NOT NULL,
    telefone        INT,
    endereco        VARCHAR(255),
    PRIMARY KEY (nome)
);

CREATE TABLE farmaceutica (
    numReg          INT             NOT NULL,
    nome            VARCHAR(100)    NOT NULL,
    endereco        VARCHAR(255),
    PRIMARY KEY (numReg)
);

CREATE TABLE farmaco (
    numRegFarm      INT             NOT NULL,
    nome            VARCHAR(100)    NOT NULL,
    formula         VARCHAR(255),
    numRegFarmaceutica INT,
    PRIMARY KEY (numRegFarm),
    FOREIGN KEY (numRegFarmaceutica) REFERENCES farmaceutica(numReg)
);

CREATE TABLE prescricao (
    numPresc        INT             NOT NULL,
    numUtente       INT             NOT NULL,
    numMedico       INT             NOT NULL,
    farmacia        VARCHAR(100)    NOT NULL,
    dataProc        DATE,
    PRIMARY KEY (numPresc),
    FOREIGN KEY (numUtente) REFERENCES paciente(numUtente),
    FOREIGN KEY (numMedico) REFERENCES medico(numSNS),
    FOREIGN KEY (farmacia) REFERENCES farmacia(nome)
);

CREATE TABLE presc_farmaco (
    numPresc        INT             NOT NULL,
    numRegFarm      INT             NOT NULL,
    nomeFarmaco     VARCHAR(100),
    PRIMARY KEY (numPresc, numRegFarm),
    FOREIGN KEY (numPresc) REFERENCES prescricao(numPresc),
    FOREIGN KEY (numRegFarm) REFERENCES farmaco(numRegFarm)
);