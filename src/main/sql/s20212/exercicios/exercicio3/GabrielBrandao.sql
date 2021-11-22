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

CREATE TABLE matriz (
    mat1 float[][],
    mat2 float[][],
    mat3 float[][]
);

insert into

CREATE FUNCTION multmat(mat1 float[][], mat2 float[][], OUT float[][]) AS $$
    
    BEGIN 
        for i in 1..array_length(mat1, 2) LOOP
            for j in 1..array_length(mat1, 2) LOOP
                for k in 1..aray_length(mat2, 1) LOOP
                    for l in 1..array_length(mat2, 2) LOOP
                        mat3[][]

    EXCEPTION
        WHEN array_length(mat1, 2) != array_length(mat2, 1) 
        THEN 
            RAISE NOTICE 'Imcompativeis';
            RETURN 0;
    END;

$$ LANGUAGE plpgsql;

--SELECT * FROM MultMat(2, 5);

DO $$ BEGIN    
      raise notice 'Mensagem teste';
      SELECT multmat();
END $$;
