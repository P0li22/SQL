/* EVENTO(CodE, NomeEvento, CategoriaEvento, CostoEvento, DurataEvento)
CALENDARIO_EVENTI(CodE, Data, OraInizio, Luogo)
SOMMARIO_CATEGORIA(CategoriaEvento, Data, NumeroTotaleEventi, CostoComplessivoEventi) */

CREATE OR REPLACE TRIGGER AGGIORNA_SOMMARIO
AFTER INSERT ON CALENDARIO_EVENTI
FOR EACH ROW
DECLARE
n NUMBER;
categoria CHAR;
costo NUMBER;
BEGIN

  /* cerca la categoria dell'evento appena inserito */
  SELECT CategoriaEvento INTO categoria, CostoEvento INTO costo
  FROM EVENTO
  WHERE CodE = :NEW.CodE;

  /* cerca se la categoria dell'evento appena inserito è già presente
  nella tabella SOMMARIO_CATEGORIA */
   SELECT COUNT(*) INTO n
   FROM SOMMARIO_CATEGORIA SC
   WHERE CategoriaEvento = categoria AND Data = :NEW.Data;

   IF(n = 0) THEN:
      INSERT INTO SOMMARIO_CATEGORIA
      VALUES(categoria, :NEW.Data, 1, costo);
   ELSE:
      UPDATE SOMMARIO_CATEGORIA
      SET NumeroTotaleEventi = NumeroTotaleEventi + 1,
      CostoComplessivoEventi = CostoComplessivoEventi + costo
      WHERE CategoriaEvento = categoria AND Data = :New.Data;
   END IF;
END;

CREATE OR REPLACE TRIGGER MAX_COSTO
BEFORE INSERT OR UPDATE ON EVENTO
FOR EACH ROW
WHEN (:NEW.CostoEvento > 1500)
BEGIN
  :NEW.CostoEvento := 1500;
END;

CREATE OR REPLACE TRIGGER MAX_EVENTI
AFTER INSERT OR UPDATE ON CALENDARIO_EVENTI
FOR EACH STATEMENT
DECLARE
n NUMBER;
BEGIN

  /* calcola numero di eventi già presenti il giorno in cui si vuole
  inserire l'evento */
  SELECT COUNT(*) INTO n
  FROM CALENDARIO_EVENTI
  WHERE Data IN (SELECT Data
                 FROM CALENDARIO_EVENTI
                 GROUP BY Data
                 HAVING COUNT(*) > 10);

  IF(n <> 0) THEN:
    raise_application_error (XXX, «Troppi eventi in una data»);
  END IF;
END;
