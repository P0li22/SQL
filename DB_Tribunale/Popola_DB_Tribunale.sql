SET storage_engine=InnoDB;
SET FOREIGN_KEY_CHECKS=1;

INSERT INTO GIUDICE(CodFiscale, Nome, Cognome, DataNascita)
VALUES('G1', 'Gigi', 'Finizio', '1965/05/31');
INSERT INTO GIUDICE(CodFiscale, Nome, Cognome, DataNascita)
VALUES('G2', 'Magicuomo', 'Aspiraseta', '1947/11/11');
INSERT INTO GIUDICE(CodFiscale, Nome, Cognome, DataNascita)
VALUES('G3', 'Guerina', 'Danti', '1958/12/21');
INSERT INTO GIUDICE(CodFiscale, Nome, Cognome, DataNascita)
VALUES('G4', 'Nilvo', 'Stirpe', '1980/07/25');
INSERT INTO GIUDICE(CodFiscale, Nome, Cognome, DataNascita)
VALUES('G5', 'Feliziana', 'Dorizzi', '1977/03/04');
INSERT INTO GIUDICE(CodFiscale, Nome, Cognome, DataNascita)
VALUES('G6', 'Liutprando', 'Vinai', '1950/10/10');

INSERT INTO TRIBUNALE (CodTribunale, NomeTribunale, Citta)
VALUES('T1', 'TribunaleUno', 'Torino');
INSERT INTO TRIBUNALE (CodTribunale, NomeTribunale, Citta)
VALUES('T2', 'TribunaleDue', 'Napoli');
INSERT INTO TRIBUNALE (CodTribunale, NomeTribunale, Citta)
VALUES('T3', 'TribunaleTre', 'Arezzo');
INSERT INTO TRIBUNALE (CodTribunale, NomeTribunale, Citta)
VALUES('T4', 'TribunaleQuattro', 'Gerbole');
INSERT INTO TRIBUNALE (CodTribunale, NomeTribunale, Citta)
VALUES('T5', 'TribunaleCinque', 'Poggibonsi');

INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T1', 'A1_T1', 'AulaUnoT1');
INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T1', 'A2_T1', 'AulaDueT1');
INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T2', 'A1_T2', 'AulaUnoT2');
INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T2', 'A2_T2', 'AulaDueT2');
INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T3', 'A1_T3', 'AulaUnoT3');
INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T4', 'A1_T4', 'AulaUnoT4');
INSERT INTO AULA_TRIBUNALE (CodTribunale, CodAula, NomeAula)
VALUES('T5', 'A1_T5', 'AulaUnoT5');

INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C1', 'Divorzio', '2020/02/02', NULL, 'G2');
INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C2', 'Diffamazione', '1999/10/22', '2000/11/14', 'G1');
INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C3', 'Divorzio', '2010/10/10', '2011/11/11', 'G3');
INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C4', 'Divorzio', '2020/11/12', NULL, 'G5');
INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C5', 'Diffamazione', '2020/12/10', '2020/12/21', 'G3');
INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C6', 'Diffamazione', '2019/04/22', '2021/05/15', 'G1');
INSERT INTO CAUSA(CodCausa, TipologiaCausa, DataInizio, DataFine, CodFiscale)
VALUES('C7', 'Divorzio', '2021/11/14', NULL, 'G4');

INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T1', 'A1_T1', '2020/02/03', '13:15:05', '14:42:27', 'C1');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T2', 'A2_T2', '2020/03/06', '14:05:22', '16:13:47', 'C1');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T3', 'A1_T3', '1999/11/04', '13:02:32', '14:12:12', 'C2');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T3', 'A1_T3', '2011/05/05', '22:22:22', '23:23:23', 'C3');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T5', 'A1_T5', '2021/06/06', '12:12:12', '13:13:13', 'C4');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T4', 'A1_T4', '2020/12/12', '15:15:15', '16:16:16', 'C5');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T1', 'A1_T1', '2019/04/13', '12:14:13', '13:14:12', 'C6');
INSERT INTO UDIENZA(CodTribunale, CodAula, Data, OraInizio, OraFine, CodCausa)
VALUES('T3', 'A1_T3', '2021/12/18', '17:18:19', '18:19:20', 'C7');
