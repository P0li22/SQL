/* APPARTAMENTO(CodA, Superficie, Indirizzo, Citt`a)
CONTRATTO-AFFITTO(CodA, DataInizio, DataFine, NomePersona,
RettaMensile) */

/* Trovare il nome delle persone che hanno stipulato pi`u di due contratti
di affitto per lo stesso appartamento (in tempi diversi). */

SELECT CA1.NomePersona
FROM CONTRATTO_AFFITTO CA1
GROUP BY CA1.CodA, CA1.NomePersona
HAVING COUNT(*) > 2

/* Trovare il codice e l’indirizzo degli appartamenti di Torino in cui la
retta mensile `e sempre stata superiore a 500 euro e per cui sono stati
stipulati al pi`u 5 contratti. */

SELECT A1.CodA, A1.Indirizzo
FROM APPARTAMENTO A1, CONTRATTO_AFFITTO CA1
WHERE A1.CodA = CA1.CodA AND A1.Citta = "Torino"
AND A1.CodA NOT IN (SELECT CA2.CodA
                    FROM CONTRATTO_AFFITTO CA2
                    WHERE CA2.RettaMensile <= 500)
GROUP BY A1.CodA, A1.Indirizzo
HAVING COUNT(*) <= 5

/* GARA(CodG, Luogo, Data, Disciplina)
ATLETA(CodA, Nome, Nazione, DataNascita)
PARTECIPAZIONE(CodG, CodA,PosizioneArrivo, Tempo */

/* Trovare il nome e la data di nascita degli atleti italiani che non hanno
partecipato a nessuna gara di discesa libera. */

SELECT A1.Nome, A1.DataNascita
FROM ATLETA A1
WHERE A1.Nazione = "italia" AND A1.CodA NOT IN (SELECT P1.CodA
                                                FROM PARTECIPAZIONE P1, GARA G1
                                                WHERE P1.CodG = G1.CodG
                                                AND G1.Disciplina = "discesa libera")

/* Trovare le nazioni per cui concorrono almeno 5 atleti nati prima del
1980, ciascuno dei quali abbia partecipato ad almeno 10 gare di sci
di fondo. */

SELECT A1.Nazione
FROM ATLETA A1
WHERE DataNascita < "01/01/1980"
AND A1.CodA IN (SELECT P1.CodA
                FROM PARTECIPAZIONE P1, GARA G1
                WHERE P1.CodG = G1.CodG AND G1.Disciplina = "sci di fondo"
                GROUP BY P1.CodA
                HAVING COUNT(*) >= 10)
GROUP BY A1.Nazione
HAVING COUNT(*) >= 5

/* EDITORE(CodE, NomeEditore, Indirizzo, Citt`a)
PUBBLICAZIONE(CodP, Titolo, NomeAutore, CodE)
LIBRERIA(CodL, NomeLibreria, Indirizzo, Citt`a)
VENDITA(CodP, CodL, Data, CopieVendute) */

/* Trovare il nome delle librerie in cui non `e stata venduta nessuna
pubblicazione di editori con sede a Torino. */

SELECT L1.NomeLibreria
FROM LIBRARIA L1
WHERE L1.CodL NOT IN (SELECT V1.CodL
                      FROM VENDITA V1, PUBBLICAZIONE P1, EDITORE E1
                      WHERE V1.CodP = P1.CodP AND P1.CodE = E1.CodE
                      AND E1.CITTA = "Torino")

/* Trovare il nome degli editori per cui almeno 10 pubblicazioni sono
state vendute nel 2002 nelle librerie di Roma in pi`u di 2.000 copie. */

SELECT E1.NomeEditore
FROM EDITORE E1, PUBBLICAZIONE P1
WHERE E1.CodE = P1.CodE
AND P1.CodP IN(SELECT V1.CodP
               FROM VENDITA V1, LIBRERIA L1
               WHERE V1.CodL = L1.CodL AND V1.Data >= "01/01/2002"
               AND V1.Data <= "31/12/2002"
               AND L1.Citta = "Roma"
               GROUP BY V1.CodP
               HAVING SUM(V1.CopieVendute) > 2000)
GROUP BY E1.CodE, E1.NomeEditore
HAVING COUNT(*) >= 10

/* QUIZ(CodQuiz, Argomento, Punteggio)
STUDENTE(Matricola, Nome, Indirizzo, Citt`a)
RISULTATO TEST(Matricola, CodQuiz,RispostaCorretta) */

/* Trovare il nome degli studenti che non hanno risposto correttamente
a nessun quiz di matematica */

SELECT S1.Nome
FROM STUDENTE S1
WHERE S1.Matricola NOT IN (SELECT R1.Matricola
                           FROM RISULTATO_TEST R1, QUIZ Q1
                           WHERE R1.CodQuiz = Q1.CodQuiz
                           AND Q1.Argomento = "matematica"
                           AND R1.RispostaCorretta = "si")

/* Trovare il nome degli studenti di Torino che hanno conseguito il pun-
teggio massimo possibile nei quiz di matematica. */

SELECT S1.Nome
FROM STUDENTE S1, RISULTATO_TEST R1, QUIZ Q1
WHERE S1.Matricola = R1.Matricola AND R1.CodQuiz = Q1.CodQuiz
AND S1.Citta = "Torino" AND Q1.Argomento = "matematica"
AND R1.RispostaCorretta
GROUP BY S1.Matricola, S1.Nome
HAVING SUM(Q1.Punteggio) = (SELECT SUM(Q2.Punteggio)
                            FROM QUIZ Q2
                            WHERE Q2.Argomento = "matematica")

/* AEREI (Matr, Modello, NumPosti)
ORARIO (Sigla, ParteDa, Destinaz, OraPart, OraArr)
VOLI (Sigla, Matr, Data, PostiPren) */

/* Trovare le tratte (citt`a di partenza, citt`a di arrivo) che non sono state
mai effettuate con un aereo modello Boing-747.*/

SELECT O1.ParteDa, O1.Destinaz
FROM ORARIO O1
WHERE (O1.ParteDa, O1.Destinaz) NOT IN (SELECT O2.ParteDA, O2.Destinaz
                                        FROM ORARIO O2, AEREI A1, VOLI V1
                                        WHERE O2.Sigla = V1.Sigla
                                        AND V1.Matr = A1.Matr
                                        AND A1.Modello = "Boeing-747")
