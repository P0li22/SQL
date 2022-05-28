CREATE OR REPLACE TRIGGER AGGIORNA_ARRIVO_SQUADRA
AFTER INSERT ON ARRIVO_ATLETI
FOR EACH ROW
DECLARE
n NUMBER;
squadra CHAR;
BEGIN

-- nome della squadra dell'atleta appena arrivato
  SELECT NomeSquadra INTO squadra
  FROM ATLETA
  WHERE CodAtleta = :NEW.CodAtleta;

/* controllo se la squadra è già presente nella tabella e
inserimento / aggiornamento */
  SELECT COUNT(*) INTO n
  FROM ARRIVO_SQUADRE
  WHERE NomeSquadra = squadra;
  IF(n = 0) THEN
    INSERT INTO ARRIVO_SQUADRE
    VALUES(squadra, 1);
  ELSE
    UPDATE ARRIVO_SQUADRE
    SET NumeroAtletiArrivati = NumeroAtletiArrivati + 1;
    WHERE NomeSquadra = squadra
  END IF;
END;

CREATE OR REPLACE TRIGGER AGGIORNA_CLASSIFICA
AFTER INSERT ON ARRIVO_ATLETI
FOR EACH ROW
DECLARE
pos NUMBER;
t NUMBER;
BEGIN

-- calcolo posizione in classifica atleta
  SELECT COUNT(*) + 1 INTO pos
  FROM CLASSIFICA
  WHERE Tempo < :NEW.Tempo;

-- inserimento in CLASSIFICA
  INSERT INTO CLASSIFICA
  VALUES(pos, :NEW.CodAtleta, :NEW.Tempo)

-- aggiornamento posizione atleti arrivati dopo l'atleta appena inserito
  UPDATE CLASSIFICA
  SET Posizione = Posizione + 1
  WHERE Tempo > :NEW.Tempo
END;
