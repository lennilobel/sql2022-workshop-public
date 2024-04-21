/* =================== TRIM =================== */

SELECT TRIM('     test   ') + '!'
SELECT TRIM(' ' FROM '     test   ') + '!'

SELECT TRIM('<>' FROM '<<< test >>>') + '!'
SELECT TRIM('<> ' FROM '<<< test >>>') + '!'

SELECT TRIM('.,' FROM '     #  test  . ') + '!'
SELECT TRIM('., ' FROM '     #  test  . ') + '!'
