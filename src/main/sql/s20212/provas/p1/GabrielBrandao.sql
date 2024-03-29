/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  bielf
 * Created: 24 de nov. de 2021
 */

DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

create table cidade(
numero int not null primary key,
nome varchar not null
);

create table bairro(
numero int not null primary key,
nome varchar not null,
cidade int not null,
foreign key (cidade) references cidade(numero)
);

create table pesquisa(
numero int not null,
descricao varchar not null,
primary key (numero)
);

create table pergunta(
pesquisa int not null,
numero int not null,
descricao varchar not null,
primary key (pesquisa,numero),
foreign key (pesquisa) references pesquisa(numero)
);

create table resposta(
pesquisa int not null,
pergunta int not null,
numero int not null,
descricao varchar not null,
primary key (pesquisa,pergunta,numero),
foreign key (pesquisa,pergunta) references pergunta(pesquisa,numero)
);

create table entrevista(
numero int not null primary key,
data_hora timestamp not null,
bairro int not null,
foreign key (bairro) references bairro(numero)
);

create table escolha(
entrevista int not null,
pesquisa int not null,
pergunta int not null,
resposta int not null,
primary key (entrevista,pesquisa,pergunta),
foreign key (entrevista) references entrevista(numero),
foreign key (pesquisa,pergunta,resposta) references resposta(pesquisa,pergunta,numero)
);

insert into cidade values (1,'Rio de Janeiro');
insert into cidade values (2,'Niterói');
insert into cidade values (3,'São Paulo');

insert into bairro values (1,'Tijuca',1);
insert into bairro values (2,'Centro',1);
insert into bairro values (3,'Lagoa',1);
insert into bairro values (4,'Icaraí',2);
insert into bairro values (5,'São Domingos',2);
insert into bairro values (6,'Santa Rosa',2);
insert into bairro values (7,'Moema',3);
insert into bairro values (8,'Jardim Paulista',3);
insert into bairro values (9,'Higienópolis',3);


insert into pesquisa values (1,'Pesquisa 1');

insert into pergunta values (1,1,'Pergunta 1');
insert into pergunta values (1,2,'Pergunta 2');
insert into pergunta values (1,3,'Pergunta 3');
insert into pergunta values (1,4,'Pergunta 4');

insert into resposta values (1,1,1,'Resposta 1 da pergunta 1');
insert into resposta values (1,1,2,'Resposta 2 da pergunta 1');
insert into resposta values (1,1,3,'Resposta 3 da pergunta 1');
insert into resposta values (1,1,4,'Resposta 4 da pergunta 1');
insert into resposta values (1,1,5,'Resposta 5 da pergunta 1');

insert into resposta values (1,2,1,'Resposta 1 da pergunta 2');
insert into resposta values (1,2,2,'Resposta 2 da pergunta 2');
insert into resposta values (1,2,3,'Resposta 3 da pergunta 2');
insert into resposta values (1,2,4,'Resposta 4 da pergunta 2');
insert into resposta values (1,2,5,'Resposta 5 da pergunta 2');
insert into resposta values (1,2,6,'Resposta 5 da pergunta 2');

insert into resposta values (1,3,1,'Resposta 1 da pergunta 3');
insert into resposta values (1,3,2,'Resposta 2 da pergunta 3');
insert into resposta values (1,3,3,'Resposta 3 da pergunta 3');

insert into resposta values (1,4,1,'Resposta 1 da pergunta 4');
insert into resposta values (1,4,2,'Resposta 2 da pergunta 4');

insert into entrevista values (1,'2020-03-01'::timestamp,1);
insert into escolha values (1,1,1,2);
insert into escolha values (1,1,2,2);
insert into escolha values (1,1,3,1);

insert into entrevista values (2,'2020-03-01'::timestamp,1);
insert into escolha values (2,1,1,3);
insert into escolha values (2,1,2,1);
insert into escolha values (2,1,3,2);

insert into entrevista values (3,'2020-03-01'::timestamp,1);
insert into escolha values (3,1,1,4);
insert into escolha values (3,1,2,1);
insert into escolha values (3,1,3,1);

insert into entrevista values (4,'2020-03-01'::timestamp,1);
insert into escolha values (4,1,1,2);
insert into escolha values (4,1,2,1);
insert into escolha values (4,1,3,1);

insert into entrevista values (5,'2020-03-01'::timestamp,1);
insert into escolha values (5,1,1,2);
insert into escolha values (5,1,2,1);
insert into escolha values (5,1,3,1);


CREATE OR REPLACE FUNCTION formata(pergunta_ int, respostas int[], totalRespostas int) RETURNS float[][] AS $$
    
    DECLARE
        respostaFinal float[][];
        linha1 float[];
        linha2 float[];
        respostaFinalAux float[][];
    BEGIN
        FOR i IN 1.. totalRespostas LOOP
            linha1 = array_append(linha1, i);
            raise notice 'linha1 :%', linha1;
            linha2 = array_append(linha2, (respostas[i]::float)/(totalRespostas::float));
            raise notice 'linha2 :%', linha2;
            respostaFinal = linha1 || linha2;
            raise notice 'Resp :%', respostaFinal;--Consegui botar índice e o resultado porém não estou conseguindo intercalar as tuplas
        END LOOP;
        RETURN respostaFinal;
    END;
$$
LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION resultado(p_pesquisa int, p_bairros varchar[], p_cidades varchar[])
RETURNS TABLE(pergunta_ int, histograma float[])AS $$
    DECLARE
        cidades CURSOR FOR SELECT * FROM cidade WHERE numero = ANY(p_cidades);
        bairros CURSOR FOR SELECT * FROM bairro WHERE numero = ANY(p_bairros);
        perguntas CURSOR FOR SELECT * FROM pergunta WHERE pesquisa = p_pesquisa;
        qtdRespostas int default 0;
        respsPerguntaAux int[];
        escolhaAtual RECORD;
    BEGIN
        FOR perguntaAtual IN perguntas LOOP
            SELECT COUNT(*) FROM resposta WHERE pesquisa = p_pesquisa AND pergunta = perguntaAtual.numero INTO qtdRespostas;
            SELECT array_fill(0, ARRAY[qtdRespostas]) INTO respsPerguntaAux;

            FOR escolhaAtual IN SELECT * FROM escolha WHERE pesquisa = p_pesquisa AND pergunta = perguntaAtual.numero LOOP
                respsPerguntaAux[escolhaAtual.resposta] := respsPerguntaAux[escolhaAtual.resposta] + 1;
            END LOOP;
            RETURN QUERY SELECT perguntaAtual.numero, formata(perguntaAtual.numero, respsPerguntaAux, qtdRespostas);

        END LOOP;
        RETURN;
    END;
$$
LANGUAGE PLPGSQL;

SELECT * FROM resultado(1, ARRAY[ 'Tijuca', 'Centro', 'Lagoa', 'Icaraí', 'São Domingos', 'Santa Rosa', 'Moema', 'Jardim Paulista', 'Higienópolis'] ,ARRAY[ 'Rio de Janeiro', 'Niteroi', 'Sao Paulo']);
