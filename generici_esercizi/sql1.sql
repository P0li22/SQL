/*
AEREO(Aid, ANome, Autonomia)
CERTIFICATO(Did, Aid)
DIPENDENTE(Did, DNome, Stipendio)
*/

/* Trovare i codici e i nomi dei dipendenti abilitati al volo su un aereo in grado di coprire distanze
superiori a 5000 Km (Autonomia ≥ 5000). */

SELECT D.Did, D.DNome
FROM DIPENDENTE D, CERTIFICATO C, AEREO A
WHERE D.Did = C.Did AND C.Aid = A.Aid AND Autonomia >= 5000;

/* Trovare i codici e i nomi dei dipendenti abilitati al volo su almeno due aerei in grado di coprire
distanze superiori a 5000 Km (Autonomia>= 5000). */

SELECT D.Did, D.DNome
FROM DIPENDENTE D, CERTIFICATO C, AEREO A
WHERE D.Did = C.Did AND C.Aid = A.Aid AND Autonomia >= 5000
GROUP BY D.Did, D.DNome
HAVING COUNT(*) >= 2;

/* Trovare i codici e i nomi dei dipendenti abilitati al volo su almeno due aerei in grado di coprire
distanze superiori a 5000 Km e che siano abilitati al volo su qualche Boeing. */

SELECT D1.Did, D1.DNome
FROM DIPENDENTE D1, CERTIFICATO C1, AEREO A1
WHERE D1.Did = C1.Did AND C1.Aid = A1.Aid AND Autonomia >= 5000
AND D1.Did IN (SELECT C2.Did
               FROM CERTIFICATO C2, AEREO A2
               WHERE C2.Aid = A2.Aid AND ANome = "Boeing")
GROUP BY D1.Did, D1.DNome
HAVING COUNT(*) >= 2;
