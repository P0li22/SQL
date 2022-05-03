-- ES 1)
-- a)
SELECT G.CodFiscale, Cognome, COUNT(DISTINCT TipologiaCausa) AS NumTipologiaCausa
FROM GIUDICE G, CAUSA C
WHERE G.CodFiscale = C.CodFiscale AND
G.CodFiscale NOT IN
(SELECT CodFiscale
FROM CAUSA
WHERE TipologiaCausa = 'Diffamazione' AND (DataInizio <= TO_DATE('31/12/2020', 'DD/MM/YYYY')
AND (DataFine >= TO_DATE('01/01/2020', 'DD/MM/YYYY') OR DataFine IS NULL))
)
GROUP BY G.CodFiscale, Cognome;

-- b)
SELECT C.CodCausa, MAX(Data) AS UltimaUdienza
FROM CAUSA C, UDIENZA U
WHERE DataFine IS NULL AND C.CodCausa = U.CodCausa AND CodFiscale IN
(SELECT CodFiscale
FROM CAUSA C, UDIENZA U
WHERE C.CodCausa = U.CodCausa
GROUP BY CodFiscale
HAVING COUNT(DISTINCT CodTribunale) >= 3
)
GROUP BY C.CodCausa;

-- c)
SELECT G.CodFiscale, Nome, Cognome, DataNascita
FROM GIUDICE G, CAUSA C, UDIENZA U
WHERE G.CodFiscale = C.CodFiscale AND C.Codcausa = U.CodCausa AND CodTribunale IN
(SELECT CodTribunale
FROM CAUSA C, UDIENZA U
WHERE C.CodCausa = U.CodCausa AND TipologiaCausa = 'Divorzio'
GROUP BY CodTribunale
HAVING COUNT(DISTINCT CodCausa) >= 50
)
GROUP BY G.CodFiscale, Nome, Cognome, DataNascita
HAVING COUNT(DISTINCT CodTribunale) =
(SELECT COUNT(DISTINCT CodTribunale)
FROM CAUSA C, UDIENZA U
WHERE C.CodCausa = U.CodCausa AND TipologiaCausa = 'Divorzio'
GROUP BY CodTribunale
HAVING COUNT(DISTINCT CodCausa) >= 50
);

--ES 2)
-- a)
SELECT NomeP, COUNT(DISTINCT CodFiscale)
FROM PALESTRA P1, LEZIONE L1
WHERE P1.CodP = L1.CodP  AND P1.Città = 'Torino' AND P1.CodP NOT IN
(SELECT CodP
FROM LEZIONE L2, SPECIALITÀ S1
WHERE L2.CodS = S1.CodS AND NomeS = 'Yoga'
)
AND P1.CodP IN
(SELECT CodP
FROM LEZIONE L3, SPECIALITÀ S2
WHERE L3.CodS = S2.CodS AND NomeS = 'Judo'
GROUP BY CodP
HAVING COUNT(DISTINCT CodFiscale) >= 5
)
GROUP BY P1.CodP, NomeP

-- b)
SELECT CodFiscale, NomeP, Indirizzo, Città
FROM PALESTRA P1, LEZIONE L1
WHERE P1.CodP = L1.CodP AND CodFiscale NOT IN
(SELECT CodFiscale
FROM LEZIONE L2, SPECIALITÀ S1
WHERE L2.CodS = S1.CodS AND NomeS <> 'Yoga'
)
GROUP BY CodFiscale, P1.CodP
HAVING COUNT(*) =
(SELECT MAX(NumLezioni)
FROM
(SELECT CodFiscale, P2.CodP, COUNT(*) AS NumLezioni
FROM PALESTRA P2, LEZIONE L3
WHERE P2.CodP = L3.CodP AND CodFiscale NOT IN
(SELECT CodFiscale
FROM LEZIONE L4, SPECIALITÀ S2
WHERE L4.CodS = S2.CodS AND NomeS <> 'Yoga'
)
GROUP BY CodFiscale, P2.CodP
) AS LxP
WHERE L1.CodFiscale = LxP.CodFiscale AND P1.CodP = LxP.CodP
)

-- c)
SELECT NomeT, Cognome, COUNT(DISTINCT CodS)
FROM ISTRUTTORE I1, LEZIONE L1
WHERE I1.CodFiscale = L1.CodFiscale AND CodP IN
(SELECT CodP
FROM PALESTRA P1
WHERE P1.Città = I1.Città)
GROUP BY I1.CodFiscale, NomeT, Cognome
HAVING COUNT(DISTINCT CodP) =
(SELECT COUNT(*)
FROM PALESTRA P2
WHERE P2.Città = I1.Città)
)
