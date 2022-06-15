/* MECCANICO(MatrM, NomeM)
SA-RIPARARE(MatrM, TipoGuasto)
EFFETTUA-RIPARAZIONE(CodR, MatrM, Targa, Data, Durata,
TipoGuasto) */

/* Trovare il nome dei meccanici che hanno effettuato almeno una
riparazione di un guasto che non sapevano riparare */

SELECT DISTINCT M1.NomeM
FROM MECCANICO M1, EFFETTUA_RIPARAZIONE E1
WHERE M1.MatrM = E1.MatrM AND
E1.MatrM NOT IN (SELECT S1.MatrM
                  FROM SA_RIPARARE S1
                  WHERE S1.TipoGuasto = E1.TipoGuasto);

SELECT DISTINCT M1.NomeM
FROM MECCANICO M1, EFFETTUA_RIPARAZIONE E1
WHERE M1.MatrM = E1.MatrM AND
E1.TipoGuasto NOT IN (SELECT S1.TipoGuasto
                       FROM SA_RIPARARE S1
                       WHERE S1.MatrM = E1.MatrM);

SELECT DISTINCT M1.NomeM
FROM MECCANICO M1, EFFETTUA_RIPARAZIONE E1
WHERE M1.MatrM = E1.MatrM AND
(E1.MatrM, E1.Tipoguasto) NOT IN (SELECT S1.MatrM, S1.TipoGuasto
                                    FROM SA_RIPARARE S1)

/* Per le autovetture per cui sono state necessarie riparazioni
effettuate da almeno 3 meccanici diversi nello stesso giorno,
visualizzare la targa dell’autovettura, la data delle riparazioni e i
tipi di guasto che si sono verificati, ordinando il risultato in
ordine crescente di targa e decrescente di data. */

SELECT E1.Targa, E1.Data, E1.TipoGuasto
FROM EFFETTUA_RIPARAZIONE E1
WHERE (E1.Targa, E1.Data) IN (SELECT E2.Targa, E2.Data
                              FROM EFFETTUA_RIPARAZIONE E2
                              GROUP BY E2.Targa, E2.Data
                              HAVING COUNT(DISTINCT MatrM) >= 3)
ORDER BY E1.Targa ASC, E1.Data DESC

/* SALA RIUNIONI(CodS, NumeroMaxPosti, Proiettore)
PRENOTAZIONE_SALA(CodS, Data, OraInizio, OraFine, CodDip)
DIPENDENTE(CodDip, Nome, Cognome, DataNascita, Città) */

/* Visualizzare per ogni sala il codice della sala, il numero massimo
di posti e il numero di prenotazioni considerando solo l’ultima
data in cui la sala è stata prenotata */

SELECT S1.CodS, S1.NumeroMaxPosti, COUNT(*)
FROM SALA S1, PRENOTAZIONE_SALA P1
WHERE S1.CodS = P1.CodS AND P1.Data = (SELECT MAX(P2.Data)
                                       FROM PRENOTAZIONE_SALA P2
                                       WHERE P2.CodS = P1.CodS)
GROUP BY S1.CodS, S1.NumeroMaxPosti

/* Visualizzare il codice e il numero massimo di posti delle sale
dotate di proiettore che sono state prenotate almeno 15 volte per
riunioni che iniziano prima delle ore 15:00, ma non sono mai
state prenotate per riunioni che cominciano dopo le ore 20:00 */

SELECT S1.CodS, S1.NumeroMaxPosti
FROM SALA S1, PRENOTAZIONE_SALA P1
WHERE S1.CodS = P1.CodS AND S1.Proiettore = "sì"
AND S1.CodS NOT IN(SELECT P2.CodS
                   FROM PRENOTAZIONE_SALA P2
                   WHERE P2.OraInizio > "20:00")
AND P1.OraInizio < "15:00"
GROUP BY S1.CodS, S1.NumeroMaxPosti
HAVING COUNT(*) >= 15
