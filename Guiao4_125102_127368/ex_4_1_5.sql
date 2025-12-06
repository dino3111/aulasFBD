-- Tabela Instituição:
CREATE TABLE Instituicao (
    PK_Nome VARCHAR(255) PRIMARY KEY,
    Endereco VARCHAR(255)
);

-- Tabela Pessoa:
CREATE TABLE Pessoa (
    PK_Nome VARCHAR(255) PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL
);

-- Tabela Autor:
CREATE TABLE Autor (
    PK_Nome_Pessoa VARCHAR(255) PRIMARY KEY,
    FK_Nome_Instituicao VARCHAR(255),
    FOREIGN KEY (PK_Nome_Pessoa) REFERENCES Pessoa(PK_Nome),
    FOREIGN KEY (FK_Nome_Instituicao) REFERENCES Instituicao(PK_Nome)
);

-- Tabela Participante:
CREATE TABLE Participante (
    PK_Nome_Pessoa VARCHAR(255) PRIMARY KEY,
    Morada VARCHAR(255),
    Data_de_Inscricao DATE,
    FOREIGN KEY (PK_Nome_Pessoa) REFERENCES Pessoa(PK_Nome)
);

-- Tabela Estudante:
CREATE TABLE Estudante (
    PK_Nome_Participante VARCHAR(255) PRIMARY KEY,
    FK_Nome_Instituicao VARCHAR(255),
    FOREIGN KEY (PK_Nome_Participante) REFERENCES Participante(PK_Nome_Pessoa),
    FOREIGN KEY (FK_Nome_Instituicao) REFERENCES Instituicao(PK_Nome)
);

-- Tabela Não Estudante:
CREATE TABLE NaoEstudante (
    PK_Nome_Participante VARCHAR(255) PRIMARY KEY,
    Transacao_Bancaria VARCHAR(100), 
    FOREIGN KEY (PK_Nome_Participante) REFERENCES Participante(PK_Nome_Pessoa)
);

-- Tabela Artigo:
CREATE TABLE Artigo (
    PK_Nr_Registo INT PRIMARY KEY,
    Titulo VARCHAR(255) NOT NULL
);

-- Tabela Relação Escrito Por:
CREATE TABLE Escrito_Por (
    FK_Numero_de_Registo INT,
    FK_Nome_Pessoa VARCHAR(255),
    PRIMARY KEY (FK_Numero_de_Registo, FK_Nome_Pessoa),
    FOREIGN KEY (FK_Numero_de_Registo) REFERENCES Artigo(PK_Nr_Registo),
    FOREIGN KEY (FK_Nome_Pessoa) REFERENCES Autor(PK_Nome_Pessoa)
);

-- Tabela Relação Pertence:
CREATE TABLE Pertence (
    PK_Comprovativo INT IDENTITY(1,1) PRIMARY KEY,
    FK_Nome_Instituicao VARCHAR(255),
    FK_Nome_Participante VARCHAR(255),
    FOREIGN KEY (FK_Nome_Instituicao) REFERENCES Instituicao(PK_Nome),
    FOREIGN KEY (FK_Nome_Participante) REFERENCES Participante(PK_Nome_Pessoa)
);

-- Tabela Conferência:
CREATE TABLE Conferencia (
    FK_Nr_Registo INT PRIMARY KEY, 
    FOREIGN KEY (FK_Nr_Registo) REFERENCES Artigo(PK_Nr_Registo)
);