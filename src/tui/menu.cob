>>SOURCE FORMAT FREE
*> ------------------------------------------------------------
*> Programa: menu.cob (versao simples, sem SCREEN SECTION)
*> Objetivo:
*>   - Menu de texto puro para operar o cadastro de contas.
*>   - Entrada linha a linha, com mensagens explicitas.
*>   - Chama o subprograma ACCOUNTS-IO para CRUD.
*> ------------------------------------------------------------
IDENTIFICATION DIVISION.
PROGRAM-ID. MENU.

DATA DIVISION.
WORKING-STORAGE SECTION.

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

PROCEDURE DIVISION.
MAIN-PARA.
    PERFORM MAIN-LOOP
    STOP RUN
    .

MAIN-LOOP.
    MOVE SPACE TO WS-MENU-OPTION

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
             DISPLAY "Saindo do AraraLedger - Menu de Contas."
          WHEN OTHER
             DISPLAY "Opcao invalida. Pressione ENTER para continuar."
             ACCEPT WS-PAUSE
       END-EVALUATE
    END-PERFORM
    .

SHOW-MENU.
    DISPLAY " "
    DISPLAY "======================================="
    DISPLAY " AraraLedger - Menu de Contas"
    DISPLAY "======================================="
    DISPLAY " 1 - Cadastrar nova conta"
    DISPLAY " 2 - Consultar conta por ID"
    DISPLAY " 3 - Atualizar conta"
    DISPLAY " 4 - Listar todas as contas"
    DISPLAY " 0 - Sair"
    DISPLAY "---------------------------------------"
    DISPLAY "Opcao: " WITH NO ADVANCING
    ACCEPT WS-MENU-OPTION
    .

*> ------------------------------------------------------------
*> Inclusao de nova conta
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

    DISPLAY "DEBUG: chamando ACCOUNTS-IO (C)..."
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

    DISPLAY "DEBUG: retorno ACCOUNTS-IO = " WS-AC-RETURN-STATUS
    DISPLAY "Resultado inclusao - STATUS: " WS-AC-RETURN-STATUS
    DISPLAY "(00 = OK, 22 = chave duplicada, 35 = nao encontrado/erro, outros = problema de I/O)."
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

    DISPLAY "DEBUG: chamando ACCOUNTS-IO (R)..."
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

    DISPLAY "DEBUG: retorno ACCOUNTS-IO = " WS-AC-RETURN-STATUS

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

    DISPLAY "DEBUG: chamando ACCOUNTS-IO (R p/ atualizar)..."
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

    DISPLAY "DEBUG: retorno ACCOUNTS-IO = " WS-AC-RETURN-STATUS

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

    DISPLAY "DEBUG: chamando ACCOUNTS-IO (U)..."
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

    DISPLAY "DEBUG: retorno ACCOUNTS-IO = " WS-AC-RETURN-STATUS
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

    DISPLAY "DEBUG: chamando ACCOUNTS-IO (L)..."
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

    DISPLAY "DEBUG: retorno ACCOUNTS-IO = " WS-AC-RETURN-STATUS
    DISPLAY "STATUS listagem: " WS-AC-RETURN-STATUS
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .