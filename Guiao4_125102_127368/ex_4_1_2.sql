-- Tabela Pessoa:
CREATE TABLE Pessoa (
    PK_CC VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Morada VARCHAR(255),
    Data_de_Nascimento DATE
);

-- Tabela Professor: 
CREATE TABLE Professor (
    PK_Numero_de_Funcionario VARCHAR(50) PRIMARY KEY,
    Email VARCHAR(255) UNIQUE,
    N_Telefone VARCHAR(20),
    FK_CC VARCHAR(20) NOT NULL UNIQUE,
    FOREIGN KEY (FK_CC) REFERENCES Pessoa(PK_CC)
);

-- Tabela Turma: 
CREATE TABLE Turma (
    PK_Identificador INT PRIMARY KEY,
    Ano_Letivo VARCHAR(10) NOT NULL,
    Designacao VARCHAR(100) NOT NULL,
    N_Maximo_de_Alunos INT,
    Escolaridade VARCHAR(100),
    FK_Numero_de_Funcionario VARCHAR(50),
    FOREIGN KEY (FK_Numero_de_Funcionario) REFERENCES Professor(PK_Numero_de_Funcionario)
);

-- Tabela Atividade:
CREATE TABLE Atividade (
    PK_Identificador INT PRIMARY KEY,
    Designacao VARCHAR(100) NOT NULL,
    Custo DECIMAL(10, 2)
);

-- Tabela AdultoResponsável:
CREATE TABLE AdultoResponsavel (
    PK_CC VARCHAR(20) PRIMARY KEY,
    Contacto VARCHAR(20),
    Email VARCHAR(255),
    Relacao VARCHAR(50),
    FOREIGN KEY (PK_CC) REFERENCES Pessoa(PK_CC)
);

-- Tabela PessoaAutorizada:
CREATE TABLE PessoaAutorizada (
    PK_CC VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (PK_CC) REFERENCES Pessoa(PK_CC)
);

-- Tabela EncarregadoDeEducação:
CREATE TABLE EncarregadoDeEducacao (
    PK_CC VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (PK_CC) REFERENCES Pessoa(PK_CC)
);

-- Tabela Aluno:
CREATE TABLE Aluno (
    PK_CC VARCHAR(20) PRIMARY KEY,
    FK_Identificador_Turma INT,
    FK_CC_Enc_Educacao VARCHAR(20),
    FOREIGN KEY (PK_CC) REFERENCES Pessoa(PK_CC),
    FOREIGN KEY (FK_Identificador_Turma) REFERENCES Turma(PK_Identificador),
    FOREIGN KEY (FK_CC_Enc_Educacao) REFERENCES EncarregadoDeEducacao(PK_CC)
);

-- Tabela TurmaEscolaridade:
CREATE TABLE TurmaEscolaridade (
    FK_Identificador_Turma INT,
    Diferentes_Escolaridades VARCHAR(100),
    PRIMARY KEY (FK_Identificador_Turma, Diferentes_Escolaridades),
    FOREIGN KEY (FK_Identificador_Turma) REFERENCES Turma(PK_Identificador)
);

-- Tabela Relação Aluno:
CREATE TABLE RelacaoAluno (
    FK_CC_Aluno VARCHAR(20),
    FK_CC_Adulto_Responsavel VARCHAR(20),
    Grau_de_parentesco VARCHAR(50),
    PRIMARY KEY (FK_CC_Aluno, FK_CC_Adulto_Responsavel),
    FOREIGN KEY (FK_CC_Aluno) REFERENCES Aluno(PK_CC),
    FOREIGN KEY (FK_CC_Adulto_Responsavel) REFERENCES AdultoResponsavel(PK_CC)
);

-- Tabela Disponível:
CREATE TABLE Disponivel (
    FK_Identificador_Turma INT,
    FK_Identificador_Atividade INT,
    PRIMARY KEY (FK_Identificador_Turma, FK_Identificador_Atividade),
    FOREIGN KEY (FK_Identificador_Turma) REFERENCES Turma(PK_Identificador),
    FOREIGN KEY (FK_Identificador_Atividade) REFERENCES Atividade(PK_Identificador)
);

-- Tabela EntregaLevanta:
CREATE TABLE EntregaLevanta (
    FK_CC_Pessoa_Autorizada VARCHAR(20),
    FK_CC_Aluno VARCHAR(20),
    PRIMARY KEY (FK_CC_Pessoa_Autorizada, FK_CC_Aluno),
    FOREIGN KEY (FK_CC_Pessoa_Autorizada) REFERENCES PessoaAutorizada(PK_CC),
    FOREIGN KEY (FK_CC_Aluno) REFERENCES Aluno(PK_CC)
);

-- Tabela Participa:
CREATE TABLE Participa (
    FK_Identificador_Atividade INT,
    FK_CC_Aluno VARCHAR(20),
    PRIMARY KEY (FK_Identificador_Atividade, FK_CC_Aluno),
    FOREIGN KEY (FK_Identificador_Atividade) REFERENCES Atividade(PK_Identificador),
    FOREIGN KEY (FK_CC_Aluno) REFERENCES Aluno(PK_CC)
);

