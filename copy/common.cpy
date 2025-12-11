*> ------------------------------------------------------------
*> Copybook: common.cpy
*> Constantes, PICs comuns e códigos de FILE STATUS
*> ------------------------------------------------------------

01 FS-OK            PIC XX VALUE "00".
01 FS-NOT-FOUND     PIC XX VALUE "35".
01 FS-INVALID-KEY   PIC XX VALUE "23".
01 FS-DUPLICATE-KEY PIC XX VALUE "22".
01 FS-ALREADY-OPEN  PIC XX VALUE "41".

*> Tipos comuns para datas, períodos e valores monetários em centavos

01 WS-COMMON-DATE-YYYYMMDD  PIC 9(8).
01 WS-COMMON-PERIOD-YYYYMM  PIC 9(6).
01 WS-COMMON-AMOUNT-CENTS   PIC 9(18).

*> Constante de moeda padrão
78 CURRENCY-BRL VALUE "BRL".