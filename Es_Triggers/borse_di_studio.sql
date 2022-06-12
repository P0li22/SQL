CREATE OR REPLACE TRIGGER VINCOLO_GRADUATORIA_STUDENTI
AFTER INSERT ON DOMANDA_INSERIMENTO_GRADUATORIA
FOR EACH ROW
DECLARE
n NUMBER;
media NUMBER;
crediti Number;
anno_immatricolazione NUMBER;
punteggio NUMBER;
BEGIN

  /* controlla se lo studente è già presente */
  SELECT COUNT(*) INTO n
  FROM GRADUATORIA_STUDENTI
  WHERE Matricola = :NEW:Matricola;

  /* calcola numero crediti */
  SELECT SUM(C.NumeroCrediti), AVG(E.Voto) INTO crediti, media
  FROM ESAMI_SOSTENUTI E, CORSO C
  WHERE E.Matricola = :NEW.Matricola AND E.CodCorso = C.CodCorso
  AND E.Voto >= 18;

  IF(n <> 0 OR crediti IS NULL OR crediti < 120) THEN:
    raise_application_error((XXX, «domanda rifiutata»);
  ELSE:
    SELECT Annoimmatricolazione INTO anno_immatricolazione
    FROM STUDENTE
    WHERE Matricola = :NEW.Matricola;

    punteggio = (SYSDATE-anno_immatricolazione)*media;

    INSERT INTO GRADUATORIA_STUDENTI
    VALUES(:NEW.Matricola, punteggio);
  END IF;
END;

CREATE OR REPLACE TRIGGER ASSEGNAZIONE_BORSA_DI_STUDIO
AFTER INSERT ON OFFERTA_BORSA_STUDIO
FOR EACH ROW
DECLARE
matricola CHAR;
numero_notifica NUMBER;
BEGIN
  SELECT G1.Matricola INTO matricola
  FROM GRADUATORIA_STUDENTI G1, BORSE_STUDIO_ASSEGNATE B1
  WHERE G1.Matricola = B1.Matricola
  AND G1.Matricola IN (SELECT E1.Matricola
                       FROM ESAMI_SOSTENUTI E1
                       WHERE E1.CodCorso = :NEW.CodCorso
                       AND E1.Voto = 18)
  GROUP BY G1.Matricola
  HAVING (SUM(B1.NumeroOre) + :NEW.NumeroOre) <= 150 AND
  G1.Punteggio = (SELECT MAX(G2.Punteggio)
                  FROM GRADUATORIA_STUDENTI G2, BORSE_STUDIO_ASSEGNATE B2
                  WHERE G2.Matricola = B2.Matricola
                  AND G2.Matricola IN (SELECT E2.Matricola
                                       FROM ESAMI_SOSTENUTI E2
                                       WHERE E2.CodCorso = :NEW.CodCorso
                                       AND E2.Voto = 18)
                  GROUP BY G2.Matricola
                  HAVING (SUM(B1.NumeroOre) + :NEW.NumeroOre) <= 150);

  SELECT MAX(CodN) INTO numero_notifica
  FROM NOTIFICA_INFORMAZIONI;

  IF(matricola IS NOT NULL) THEN:
    INSERT INTO BORSE_STUDIO_ASSEGNATE
    VALUES(:NEW.CodBorsa, matricola, :NEW.NumeroOre);

    INSERT INTO NOTIFICA_INFORMAZIONI
    VALUES(numero_notifica+1, :NEW.CodBorsa, matricola, "borsa di studio assegnata");
  ELSE:
    INSERT INTO NOTIFICA_INFORMAZIONI
    VALUES(numero_notifica+1, :NEW.CodBorsa, matricola, "borsa di studio non assegnata");
  END IF;
END;

CREATE OR REPLACE TRIGGER MIN_ORE_BORSA
BEFORE INSERT OR UPDATE ON OFFERTA_BORSA_STUDIO
FOR EACH ROW
WHEN :NEW.NumeroOre < 15
BEGIN
  :NEW:NumeroOre := 15;
END;

CREATE OR REPLACE TRIGGER MIN_ORE_BORSA
AFTER INSERT OR UPDATE ON OFFERTA_BORSA_STUDIO
FOR EACH STATEMENT
DECLARE
n NUMBER;
BEGIN;

  SELECT COUNT(*) INTO n
  FROM OFFERTA_BORSA_STUDIO
  GROUP BY CodCorso
  HAVING SUM(NumeroOre) > 300

  IF(n <> 0) THEN:
    raise_application_error(XXX, «le
      borse di studio offerte per il corso non possono superare
      complessivamente un monte ore pari a 300»);
  END IF;
END;
