/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Other/SQLTemplate.sql to edit this template
 */
/**
 * Author:  bielf
 * Created: 22 de nov. de 2021
 */

--
-- Limpesa do BD
-- Obs.: Executar antes o script create_drop_functions_and_tables.sql
--
DO $$ BEGIN
    PERFORM drop_functions();
    PERFORM drop_tables();
END $$;

-- Exercício diz pra supormos que a matriz Aij já está criada então também 
-- supus que a  matriz original tamabém estava feita.

CREATE OR REPLACE FUNCTION determinante() RETURNS float AS $$

    DECLARE
        det float := 0;

    BEGIN
        FOR i in 1..array_length(mat1, 1) LOOP
            FOR j in 1..array_length(mat1, 2) LOOP
                det = det + (mat1[i][j]*(-1)^(i+j)) * @A[i][j];

    RETURN det;

    END;

$$ LANGUAGE plpgsql;