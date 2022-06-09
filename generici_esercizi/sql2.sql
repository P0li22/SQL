/* CORSO (CodCorso, NomeC, Anno, Semestre)
ORARIO-LEZIONI (CodCorso, GiornoSettimana, OraInizio, OraFine, Aula)
/*

/* Trovare le aule in cui non si tengono mai lezioni di corsi del primo anno. */
SELECT DISTINCT Aula
FROM ORARIO_LEZIONI O1
WHERE O1.Aula NOT IN (SELECT Aula
                      FROM ORARIO_LEZIONI O2, CORSO C1
                      WHERE O2.CodCorso = C1.CodCorso
                      AND C1.Anno = 1)

/* Trovare codice corso, nome corso e numero totale di ore di lezione setti-
manali per i corsi del terzo anno per cui il numero complessivo di ore di
lezione settimanali `e superiore a 10 e le lezioni sono in pi`u di tre giorni
diversi della settimana. */
SELECT C1.CodCorso, C1.NomeC, SUM(O1.OraFine-O1.OraInizio)
FROM CORSO C1, ORARIO_LEZIONI O1
WHERE C1.CodCorso = ORARIO_LEZIONI.CodCorso
AND C1.CodCorso = 3 AND C1.CodCorso
GROUP BY C1.CodCorso, C1.Nome
HAVING SUM(O1.OraFine-O1.OraInizio) > 10 AND COUNT(DISTINCT O1.GiornoSettimana) > 3

/* ALLOGGIO (CodA, Indirizzo, Citt`a, Superficie, CostoAffittoMensile)
CONTRATTO-AFFITTO (CodC, DataInizio, DataFine, NomePersona,
CodA)
N.B. Superficie espressa in metri quadri. Per i contratti in corso, DataFine
`e NULL. */

/* Trovare, per le citt`a in cui sono stati stipulati almeno 100 contratti, la
citt`a, il costo mensile massimo degli affitti, il costo mensile medio degli
affitti, la durata massima dei contratti, la durata media dei contratti e il
numero totale di contratti stipulati. */
SELECT Citta, MAX(A1.CostoAffittoMensile), AVG(A1.CostoAffittoMensile),
MAX(A1.DataFine-A1.DataInizio), AVG(A1.DataFine-A1.DataInizio), COUNT(*)
FROM ALLOGGIO A1, CONTRATTO_AFFITTO CA1
WHERE A1.CodA = CA1.CodA
GROUP BY A1.Citta
HAVING COUNT(*) >= 100

/* Trovare il nome delle persone che non hanno mai affittato alloggi con su-
perficie superiore a 80 metri quadri */

SELECT CA1.NomePersona
FROM CONTRATTO_AFFITTO CA1
WHERE CA1.NomePersona NOT IN(SELECT CA2.NomePersona
                             FROM ALLOGGIO A1, CONTRATTO_AFFITTO CA2
                             WHERE A1.CodA = CA2.CodA
                             AND A1.Superficie > 80)

/* AEREI (Matr, Modello, NumPosti)
ORARIO (Sigla, ParteDa, Destinaz, OraPart, OraArr)
VOLI (Sigla, Matr, Data, PostiPren) */

/* Trovare la sigla e l’ora di partenza dei voli in partenza da Milano per
Napoli il 1 ottobre 1993, che dispongono ancora di posti liberi la cui du-
rata (differenza tra l’ora di arrivo e l’ora di partenza) `e inferiore alla durata
media dei voli da Milano a Napoli */
SELECT V1.Sigla, O1.OraPart
FROM VOLI V1, ORARIO O1, AEREI A1
WHERE V1.Matr = A1.Matr AND O1.Sigla = V1.Sigla AND O1.Data = "01/10/1993"
AND O1.ParteDa = "Milano" AND O1.Destinaz = "Napoli" AND
V1.PostiPren < A1.NumPosti AND
(O1.OraArr - O1.OraPart) < (SELECT AVG(O2.OraArr - O2.OraPart)
                            FROM ORARIO O2
                            WHERE AND O2.ParteDa = "Milano" AND O2.Destinaz = "Napoli")
