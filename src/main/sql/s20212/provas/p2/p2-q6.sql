/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  bielf
 * Created: 26 de jan. de 2022
 */

CREATE OR REPLACE FUNCTION Disponibilidade() RETURNS TRIGGER AS $$
    BEGIN
        PERFORM artista, arena, inicio, fim
        FROM concerto
        WHERE
            (
                NEW.artista = artista
                OR
                NEW.arena = arena
            )
            AND
            (
                NEW.inicio BETWEEN inicio AND fim
                OR
                NEW.fim BETWEEN inicio AND fim
            );
        IF FOUND THEN
            RAISE EXCEPTION 'Artista ou Arena indisponivel';
        ELSE
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER checagem_disponivel
BEFORE INSERT OR UPDATE ON concerto
FOR EACH ROW EXECUTE FUNCTION Disponibilidade();

----------------------------------------------------------

CREATE OR replace FUNCTION Mantem_artista() returns TRIGGER AS $$
  DECLARE
    total_artistas INTEGER;
  BEGIN
    SELECT     count(nome)
    INTO       total_artistas
    FROM       artista
    inner join atividade
    ON         artista.atividade = atividade.id
    WHERE      atividade.id = OLD.atividade;

    IF total_artistas > 1 THEN
      IF (tg_op = 'DELETE') THEN
        RETURN OLD;
      ELSE
        RETURN NEW;
      END IF;
    ELSE
      RAISE EXCEPTION 'Exclui da atividade % o ultimo artista', OLD.atividade;
    END IF;
  END;
  $$ LANGUAGE plpgsql;
  CREATE TRIGGER checagem_artista BEFORE
  DELETE
  OR
  UPDATE
  ON artista FOR EACH ROW EXECUTE FUNCTION Mantem_artista();
