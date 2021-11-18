/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  bielf
 * Created: 18 de nov. de 2021
 */

--
-- Limpesa do BD
-- Obs.: Executar antes o script create_drop_functions_and_tables.sql
--
DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

-- Criação da tabela

create table Pessoa(
    nome varchar,
    endereco varchar
);

insert into Pessoa values ('Gabriel', 'Niterói');
insert into Pessoa values ('João', 'França');
insert into Pessoa values ('Ana', 'Bélgica');

-- Funções

select * from Pessoa;

create or replace MATERIALIZED view view_Pessoa as select * from Pessoa where endereco > 'endereco1';

select * from view_Pessoa where endereco > 'endereco2';