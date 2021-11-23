/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  bielf
 * Created: 23 de nov. de 2021
 */

--
-- Limpesa do BD
-- Obs.: Executar antes o script create_drop_functions_and_tables.sql
--
drop table if exists campeonato cascade;
drop table if exists jogo cascade;
drop table if exists time_ cascade;

CREATE TABLE campeonato (
    codigo text NOT NULL,
    nome TEXT NOT NULL,
    ano integer not null,
    CONSTRAINT campeonato_pk PRIMARY KEY
    (codigo)
);

CREATE TABLE time_ (
    sigla text NOT NULL,
    nome TEXT NOT NULL,
    CONSTRAINT time_pk PRIMARY KEY
    (sigla)
);

CREATE TABLE jogo (
    campeonato text not null,
    numero integer NOT NULL,
    time1 text NOT NULL,
    time2 text NOT NULL,
    gols1 integer not null,
    gols2 integer not null,
    data_ date not null,
    CONSTRAINT jogo_pk PRIMARY KEY
    (campeonato,numero),
    CONSTRAINT jogo_campeonato_fk FOREIGN KEY
    (campeonato) REFERENCES campeonato
    (codigo),
    CONSTRAINT jogo_time_fk1 FOREIGN KEY
    (time1) REFERENCES time_ (sigla),
    CONSTRAINT jogo_time_fk2 FOREIGN KEY
    (time2) REFERENCES time_ (sigla)
);

INSERT INTO campeonato VALUES ('UCL', 'Champions', '2021');

INSERT INTO time_ VALUES ('BAR', 'Barcelona');
INSERT INTO time_ VALUES ('PSG', 'Paris');
INSERT INTO time_ VALUES ('REA', 'Real Madrid');
INSERT INTO time_ VALUES ('FCB', 'Bayern');

INSERT INTO jogo VALUES ('UCL', 1, 'FCB', 'BAR', 8, 2, '20/11/2021');
INSERT INTO jogo VALUES ('UCL', 2, 'PSG', 'REA', 1, 1, '21/11/2021');
INSERT INTO jogo VALUES ('UCL', 3, 'REA', 'FCB', 0, 3, '22/11/2021');
INSERT INTO jogo VALUES ('UCL', 4, 'BAR', 'PSG', 0, 3, '23/11/2021');
INSERT INTO jogo VALUES ('UCL', 5, 'FCB', 'PSG', 3, 2, '24/11/2021');
INSERT INTO jogo VALUES ('UCL', 6, 'BAR', 'REA', 2, 2, '25/11/2021');


CREATE OR REPLACE FUNCTION Tabela(codigo text) 
    RETURNS TABLE(sigla text, pontuacao int, jogos int, vit int, emp int, der int, golspro int, golscon int, saldo int) AS $$

    DECLARE
        partida RECORD;
        timeAtual RECORD;
        qtdJogos int;
        qtdGolsPro int;
        qtdGolsCon int;
        qtdVit int;
        qtdDer int;
        qtdEmp int;
        
    BEGIN
        FOR timeAtual IN SELECT * FROM time_ LOOP
            qtdJogos = 0;
            golsPro = 0;
            golsCon = 0;
            qtdVit = 0;
            qtdDer = 0;
            qtdEmp = 0;

            FOR partida IN SELECT * FROM jogo WHERE campeonato = codigo AND (time1 = timeAtual.sigla OR time2 = timeAtual.sigla) LOOP
                raise notice 'numero da partida %', partida.numero;
                qtdJogos = qtdJogos + 1;

                IF partida.time1 = timeAtual.sigla THEN 
                    IF partida.gols1 > partida.gols2 THEN
                        qtdVit = qtdVit + 1;
                    ELSEIF partida.gols1 = partida.gols2 THEN
                        qtdEmp = qtdEmp + 1;
                    ELSE
                        qtdDer = qtdDer + 1;
                    END IF;
                    golsPro = golsPro + partida.gols1;
                    golsCon = golsCon + partida.gols2;
                
                ELSEIF partida.time2 = timeAtual.sigla THEN
                    IF partida.gols2 > partida.gols1 THEN
                        qtdVit = qtdVit + 1;
                    ELSEIF partida.gols1 = partida.gols2 THEN
                        qtdEmp = qtdEmp + 1;
                    ELSE
                        qtdDer = qtdDer + 1;
                    END IF;
                    golsPro = golsPro + partida.gols2;
                    golsCon = golsCon + partida.gols1;
                END IF;
            END LOOP;

            RETURN QUERY SELECT timeAtual.nome, (qtdVit*3 + qtdEmp), qtdJogos, qtdVit, qtdEmp, qtdDer, golsPro, golsCon, (golsPro - golsCon);

        END LOOP;
        RETURN;
    END

$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION organiza(codigo text, posInicial int, posFinal int) 
    RETURNS TABLE(sigla text, pontuacao int, jogos int, vit int, emp int, der int, golspro int, golscon int, saldo int) AS $$
        
        BEGIN 
            RETURN QUERY SELECT * FROM Tabela(codigo) ORDER BY pontuacao DESC, vit DESC;
        END
$$ LANGUAGE plpgsql;

SELECT * FROM organiza('UCL', 1, 4);