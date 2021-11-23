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
    mat2 float[][]
);

INSERT INTO matriz VALUES ('{{1,2,3}, {4,5,6}, {7,8,9}}', '{{1, 2, 3}}');

CREATE FUNCTION multmat(mat1 float[][], mat2 float[][]) RETURNS float[][] AS $$
    
    DECLARE 
        mat3 float[][];
    BEGIN 
        for i in 1..array_length(mat1, 2) LOOP
            for j in 1..array_length(mat2, 2) LOOP
                for k in 1..array_length(mat2, 1) LOOP
                    mat3[][] = mat1[i][k] * mat2[k][j];
                    RETURN mat3[][];
                END LOOP;
            END LOOP;
        END LOOP;

    EXCEPTION
        WHEN array_length(mat1, 2) != array_length(mat2, 1) 
        THEN 
            RAISE NOTICE 'Imcompativeis';
            RETURN;
    END;

$$ LANGUAGE plpgsql;

DO $$ BEGIN
    SELECT multmat(SELECT mat1 FROM matriz, SELECT mat2 FROM matriz);
END $$;

