SET storage_engine=InnoDB;
CREATE DATABASE IF NOT EXISTS Palestra;
USE Palestra;
SET FOREIGN_KEY_CHECKS=1;

DROP TABLE IF EXISTS Programma;
DROP TABLE IF EXISTS Corsi;
DROP TABLE IF EXISTS Istruttore;

CREATE TABLE ISTRUTTORE
(CodFisc CHAR(16),
Nome VARCHAR(20) NOT NULL,
Cognome VARCHAR(20) NOT NULL,
DataNascita DATE NOT NULL,
Email VARCHAR(50) NOT NULL
CHECK(Email LIKE '%@%'),
Telefono CHAR(13) NULL,
PRIMARY KEY(CodFisc));

CREATE TABLE CORSI
(CodC CHAR(5),
Nome VARCHAR(50) NOT NULL,
Tipo VARCHAR(50) NOT NULL,
Livello SMALLINT NOT NULL
CHECK (Livello > 0 and Livello < 5),
PRIMARY KEY(CodC));

CREATE TABLE PROGRAMMA
(CodFisc CHAR(16) NOT NULL,
Giorno VARCHAR(15) NOT NULL,
OrarioInizio TIME,
Durata SMALLINT NOT NULL
CHECK(Durata > 0),
CodC CHAR(5) NOT NULL,
Sala CHAR(2) NOT NULL,
PRIMARY KEY(CodFisc, Giorno, OrarioInizio),
FOREIGN KEY(CodFisc) REFERENCES ISTRUTTORE(CodFisc)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY(CodC) REFERENCES CORSI(CodC)
ON DELETE CASCADE
ON UPDATE CASCADE);
