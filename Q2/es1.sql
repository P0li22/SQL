-- a)
SELECT G.CodFiscale, Cognome, COUNT(DISTINCT TipologiaCausa) AS NumTipologiaCausa
FROM GIUDICE G, CAUSA C
WHERE G.CodFiscale = C.CodFiscale AND
G.CodFiscale NOT IN
(SELECT CodFiscale
FROM CAUSA
WHERE TipologiaCausa = 'Diffamazione' AND DataInizio >= TO_DATE('01/01/2020', 'DD/MM/YYYY')
AND (DataFine <= TO_DATE('31/12/2020', 'DD/MM/YYYY') OR DataFine = NULL)
)
GROUP BY G.CodFiscale, Cognome

-- b)
SELECT C.CodCausa, MAX(Data) AS UltimaUdienza
FROM CAUSA C, UDIENZA U
WHERE DataFine = NULL AND C.CodCausa = U.CodCausa AND CodFiscale IN
(SELECT CodFiscale
FROM CAUSA C, UDIENZA U
WHERE C.CodCausa = U.CodCausa
GROUP BY CodFiscale
HAVING COUNT(DISTINCT CodTribunale) >= 3
)
GROUP BY C.CodCausa

-- c)
SELECT
FROM GIUDICE G, ()


SELECT CodTribunale
FROM CAUSA C, UDIENZA U
WHERE C.CodCausa = U.CodCausa AND TipologiaCausa = 'Divorzio'
GROUP BY CodTribunale
HAVING COUNT(DISTINCT CodCausa) >= 50
