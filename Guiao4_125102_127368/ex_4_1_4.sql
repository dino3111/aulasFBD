-- Criação da tabela Companhia Farmacêutica
CREATE TABLE CompanhiaFarmaceutica (
    PK_Nome VARCHAR(255) PRIMARY KEY,
    Numero_Registo_Nacional VARCHAR(50) UNIQUE NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20)
);

-- Criação da tabela Fármaco
CREATE TABLE Farmaco (
    PK_Formula VARCHAR(255) PRIMARY KEY,
    Nome_Comercial VARCHAR(255) NOT NULL,
    FK_Nome_Companhia VARCHAR(255),
    FOREIGN KEY (FK_Nome_Companhia) REFERENCES CompanhiaFarmaceutica(PK_Nome)
);

-- Criação da tabela Farmácia
CREATE TABLE Farmacia (
    PK_NIF VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20),
    FK_Formula VARCHAR(255),
    FOREIGN KEY (FK_Formula) REFERENCES Farmaco(PK_Formula)
);

-- Criação da tabela Médico
CREATE TABLE Medico (
    PK_Nr_Identificacao VARCHAR(50) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Especialidade VARCHAR(100)
);

-- Criação da tabela Paciente
CREATE TABLE Paciente (
    PK_Num_Utente VARCHAR(50) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Data_Nascimento DATE
);

-- Criação da tabela Prescrição
CREATE TABLE Prescricao (
    ID_Prescricao INT IDENTITY(1,1) PRIMARY KEY, 
    Data DATE NOT NULL,
    FK_Nr_Identificacao VARCHAR(50),
    FK_Num_Utente VARCHAR(50),
    FK_NIF_Farmacia VARCHAR(20),
    FK_Formula VARCHAR(255),
    FOREIGN KEY (FK_Nr_Identificacao) REFERENCES Medico(PK_Nr_Identificacao),
    FOREIGN KEY (FK_Num_Utente) REFERENCES Paciente(PK_Num_Utente),
    FOREIGN KEY (FK_NIF_Farmacia) REFERENCES Farmacia(PK_NIF),
    FOREIGN KEY (FK_Formula) REFERENCES Farmaco(PK_Formula)
);