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

CREATE FUNCTION multmat(mat1 float[][], mat2 float[][]) RETURNS float[][] AS $$
    
    DECLARE 
        mat3 float[][] := '{}';
        linha float[] := '{}';
        elem float;
    BEGIN 
        if array_length(mat1, 2) != array_length(mat2, 1) 
        THEN 
            RAISE NOTICE 'Imcompativeis';
            RETURN;

        for i in 1..array_length(mat1, 2) LOOP
            for j in 1..array_length(mat2, 2) LOOP
                for k in 1..array_length(mat2, 1) LOOP
                    elem = elem + mat1[i][k] * mat2[k][j];
                END LOOP;
                linha = array_append(linha, elem);
            END LOOP;
            mat3 = array_cat(mat3, array[linha]);
        END LOOP;

        RETURN mat3;
    END;

$$ LANGUAGE plpgsql;

