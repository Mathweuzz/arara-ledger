>>SOURCE FORMAT FREE
*> ------------------------------------------------------------
*> Programa: menu.cob
*> Objetivo:
*>   - TUI (SCREEN SECTION) para menu principal.
*>   - Entrada de dados das contas feita por prompts linha a linha
*>     (mais amigavel em terminais tipo WSL/Windows Terminal).
*>   - Chama o subprograma ACCOUNTS-IO para CRUD.
*> ------------------------------------------------------------
IDENTIFICATION DIVISION.
PROGRAM-ID. MENU.

ENVIRONMENT DIVISION.
CONFIGURATION SECTION.
SPECIAL-NAMES.
    CRT STATUS IS WS-CRT-STATUS.

DATA DIVISION.
WORKING-STORAGE SECTION.

01 WS-CRT-STATUS        PIC 9(4).

01 WS-MENU-OPTION       PIC X.
01 WS-PAUSE             PIC X(80).

01 WS-AC-OP-CODE        PIC X.
01 WS-AC-ACCOUNT-ID     PIC 9(10).
01 WS-AC-PARENT-ID      PIC 9(10).
01 WS-AC-ACCOUNT-NAME   PIC X(40).
01 WS-AC-ACCOUNT-TYPE   PIC X(1).
01 WS-AC-CURRENCY       PIC X(3).
01 WS-AC-OPENED-DATE    PIC 9(8).
01 WS-AC-STATUS         PIC X(1).
01 WS-AC-RETURN-STATUS  PIC XX.

SCREEN SECTION.

01 MAIN-MENU-SCREEN.
   05 BLANK SCREEN.
   05 LINE 2  COLUMN 10 VALUE "AraraLedger - Menu de Contas".
   05 LINE 4  COLUMN 10 VALUE "1 - Cadastrar nova conta".
   05 LINE 5  COLUMN 10 VALUE "2 - Consultar conta por ID".
   05 LINE 6  COLUMN 10 VALUE "3 - Atualizar conta".
   05 LINE 7  COLUMN 10 VALUE "4 - Listar todas as contas".
   05 LINE 9  COLUMN 10 VALUE "0 - Sair".
   05 LINE 11 COLUMN 10 VALUE "Opcao: ".
   05 LINE 11 COLUMN 18 PIC X USING WS-MENU-OPTION.

PROCEDURE DIVISION.
MAIN-PARA.
    PERFORM MAIN-LOOP
    STOP RUN
    .

MAIN-LOOP.
    MOVE " " TO WS-MENU-OPTION

    PERFORM UNTIL WS-MENU-OPTION = "0"
       PERFORM SHOW-MENU
       EVALUATE WS-MENU-OPTION
          WHEN "1"
             PERFORM OPTION-CREATE
          WHEN "2"
             PERFORM OPTION-READ
          WHEN "3"
             PERFORM OPTION-UPDATE
          WHEN "4"
             PERFORM OPTION-LIST
          WHEN "0"
             CONTINUE
          WHEN OTHER
             DISPLAY "Opcao invalida. Pressione ENTER para continuar."
             ACCEPT WS-PAUSE
       END-EVALUATE
    END-PERFORM
    .

SHOW-MENU.
    MOVE SPACE TO WS-MENU-OPTION
    DISPLAY MAIN-MENU-SCREEN
    ACCEPT MAIN-MENU-SCREEN
    .

*> ------------------------------------------------------------
*> Inclusao de nova conta (entrada linha a linha)
*> ------------------------------------------------------------
OPTION-CREATE.
    MOVE 0      TO WS-AC-ACCOUNT-ID WS-AC-PARENT-ID WS-AC-OPENED-DATE
    MOVE "BRL"  TO WS-AC-CURRENCY
    MOVE "A"    TO WS-AC-STATUS
    MOVE SPACE  TO WS-AC-ACCOUNT-NAME WS-AC-ACCOUNT-TYPE WS-AC-RETURN-STATUS

    DISPLAY " "
    DISPLAY "=== Inclusao de nova conta ==="
    DISPLAY "ID da conta (10 digitos, ex 1001): " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-ID

    DISPLAY "Conta pai (0=raiz, ID numerico)..: " WITH NO ADVANCING
    ACCEPT WS-AC-PARENT-ID

    DISPLAY "Nome da conta....................: " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-NAME

    DISPLAY "Tipo (A/P/R/D/E).................: " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-TYPE

    DISPLAY "Moeda (ex BRL)...................: " WITH NO ADVANCING
    ACCEPT WS-AC-CURRENCY

    DISPLAY "Data abertura (AAAAMMDD).........: " WITH NO ADVANCING
    ACCEPT WS-AC-OPENED-DATE

    DISPLAY "Status (A/I).....................: " WITH NO ADVANCING
    ACCEPT WS-AC-STATUS

    MOVE "C" TO WS-AC-OP-CODE

    CALL "ACCOUNTS-IO" USING
         WS-AC-OP-CODE
         WS-AC-ACCOUNT-ID
         WS-AC-PARENT-ID
         WS-AC-ACCOUNT-NAME
         WS-AC-ACCOUNT-TYPE
         WS-AC-CURRENCY
         WS-AC-OPENED-DATE
         WS-AC-STATUS
         WS-AC-RETURN-STATUS

    DISPLAY "Resultado inclusao - STATUS: " WS-AC-RETURN-STATUS
    DISPLAY "(00 = OK, 22 = chave duplicada, 35 = nao encontrado/erro)."
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .

*> ------------------------------------------------------------
*> Consulta de conta por ID
*> ------------------------------------------------------------
OPTION-READ.
    MOVE 0 TO WS-AC-ACCOUNT-ID
    MOVE SPACE TO WS-AC-RETURN-STATUS

    DISPLAY " "
    DISPLAY "=== Consulta de conta ==="
    DISPLAY "Informe o ID da conta (numerico): " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-ID

    MOVE "R" TO WS-AC-OP-CODE

    CALL "ACCOUNTS-IO" USING
         WS-AC-OP-CODE
         WS-AC-ACCOUNT-ID
         WS-AC-PARENT-ID
         WS-AC-ACCOUNT-NAME
         WS-AC-ACCOUNT-TYPE
         WS-AC-CURRENCY
         WS-AC-OPENED-DATE
         WS-AC-STATUS
         WS-AC-RETURN-STATUS

    IF WS-AC-RETURN-STATUS = "00"
       DISPLAY "Conta encontrada:"
       DISPLAY "  ID.........: " WS-AC-ACCOUNT-ID
       DISPLAY "  Pai........: " WS-AC-PARENT-ID
       DISPLAY "  Nome.......: " WS-AC-ACCOUNT-NAME
       DISPLAY "  Tipo.......: " WS-AC-ACCOUNT-TYPE
       DISPLAY "  Moeda......: " WS-AC-CURRENCY
       DISPLAY "  Abertura...: " WS-AC-OPENED-DATE
       DISPLAY "  Status.....: " WS-AC-STATUS
    ELSE
       DISPLAY "Conta nao encontrada. STATUS: " WS-AC-RETURN-STATUS
    END-IF

    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .

*> ------------------------------------------------------------
*> Atualizacao de conta
*> ------------------------------------------------------------
OPTION-UPDATE.
    MOVE 0 TO WS-AC-ACCOUNT-ID
    MOVE SPACE TO WS-AC-RETURN-STATUS

    DISPLAY " "
    DISPLAY "=== Atualizacao de conta ==="
    DISPLAY "Informe o ID da conta (numerico): " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-ID

    *> Primeiro le os dados atuais
    MOVE "R" TO WS-AC-OP-CODE

    CALL "ACCOUNTS-IO" USING
         WS-AC-OP-CODE
         WS-AC-ACCOUNT-ID
         WS-AC-PARENT-ID
         WS-AC-ACCOUNT-NAME
         WS-AC-ACCOUNT-TYPE
         WS-AC-CURRENCY
         WS-AC-OPENED-DATE
         WS-AC-STATUS
         WS-AC-RETURN-STATUS

    IF WS-AC-RETURN-STATUS NOT = "00"
       DISPLAY "Conta nao encontrada. STATUS: " WS-AC-RETURN-STATUS
       DISPLAY "Pressione ENTER para voltar ao menu."
       ACCEPT WS-PAUSE
       EXIT PARAGRAPH
    END-IF

    DISPLAY "Valores atuais:"
    DISPLAY "  Pai........: " WS-AC-PARENT-ID
    DISPLAY "  Nome.......: " WS-AC-ACCOUNT-NAME
    DISPLAY "  Tipo.......: " WS-AC-ACCOUNT-TYPE
    DISPLAY "  Moeda......: " WS-AC-CURRENCY
    DISPLAY "  Abertura...: " WS-AC-OPENED-DATE
    DISPLAY "  Status.....: " WS-AC-STATUS
    DISPLAY " "

    DISPLAY "Informe NOVOS valores (repetir se nao mudar):"

    DISPLAY "Conta pai (0=raiz, ID numerico)..: " WITH NO ADVANCING
    ACCEPT WS-AC-PARENT-ID

    DISPLAY "Nome da conta....................: " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-NAME

    DISPLAY "Tipo (A/P/R/D/E).................: " WITH NO ADVANCING
    ACCEPT WS-AC-ACCOUNT-TYPE

    DISPLAY "Moeda (ex BRL)...................: " WITH NO ADVANCING
    ACCEPT WS-AC-CURRENCY

    DISPLAY "Data abertura (AAAAMMDD).........: " WITH NO ADVANCING
    ACCEPT WS-AC-OPENED-DATE

    DISPLAY "Status (A/I).....................: " WITH NO ADVANCING
    ACCEPT WS-AC-STATUS

    MOVE "U" TO WS-AC-OP-CODE
    MOVE SPACE TO WS-AC-RETURN-STATUS

    CALL "ACCOUNTS-IO" USING
         WS-AC-OP-CODE
         WS-AC-ACCOUNT-ID
         WS-AC-PARENT-ID
         WS-AC-ACCOUNT-NAME
         WS-AC-ACCOUNT-TYPE
         WS-AC-CURRENCY
         WS-AC-OPENED-DATE
         WS-AC-STATUS
         WS-AC-RETURN-STATUS

    DISPLAY "Resultado atualizacao - STATUS: " WS-AC-RETURN-STATUS
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .

*> ------------------------------------------------------------
*> Listagem de todas as contas (saida simples)
*> ------------------------------------------------------------
OPTION-LIST.
    MOVE "L" TO WS-AC-OP-CODE
    MOVE SPACE TO WS-AC-RETURN-STATUS

    DISPLAY " "
    DISPLAY "=== Lista de contas (saida simples) ==="

    CALL "ACCOUNTS-IO" USING
         WS-AC-OP-CODE
         WS-AC-ACCOUNT-ID
         WS-AC-PARENT-ID
         WS-AC-ACCOUNT-NAME
         WS-AC-ACCOUNT-TYPE
         WS-AC-CURRENCY
         WS-AC-OPENED-DATE
         WS-AC-STATUS
         WS-AC-RETURN-STATUS

    DISPLAY "STATUS listagem: " WS-AC-RETURN-STATUS
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .
