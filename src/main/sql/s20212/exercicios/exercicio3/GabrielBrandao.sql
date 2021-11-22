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

CREATE TABLE matriz1 (
    mat1
)

CREATE FUNCTION MultMat(mat1 float[][], mat2 float[][], OUT produto float) AS $$
    
    DECLARE 
        num integer := 30;
    BEGIN 
        RAISE NOTICE 'Pia cria %', num;

    END;

$$ LANGUAGE plpgsql;

--SELECT * FROM MultMat(2, 5);