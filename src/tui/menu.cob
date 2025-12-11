>>SOURCE FORMAT FREE
*> ------------------------------------------------------------
*> Programa: menu.cob (texto puro, sem SCREEN SECTION)
*> Objetivo:
*>   - Menu de contas (CRUD) e lancamentos (JOURNAL).
*>   - Entrada linha a linha, com mensagens explicitas.
*>   - Usa subprogramas ACCOUNTS-IO e JOURNAL-IO.
*> ------------------------------------------------------------
IDENTIFICATION DIVISION.
PROGRAM-ID. MENU.

DATA DIVISION.
WORKING-STORAGE SECTION.

01 WS-MENU-OPTION       PIC X.
01 WS-PAUSE             PIC X(80).

*> Variaveis para contas
01 WS-AC-OP-CODE        PIC X.
01 WS-AC-ACCOUNT-ID     PIC 9(10).
01 WS-AC-PARENT-ID      PIC 9(10).
01 WS-AC-ACCOUNT-NAME   PIC X(40).
01 WS-AC-ACCOUNT-TYPE   PIC X(1).
01 WS-AC-CURRENCY       PIC X(3).
01 WS-AC-OPENED-DATE    PIC 9(8).
01 WS-AC-STATUS         PIC X(1).
01 WS-AC-RETURN-STATUS  PIC XX.

*> Variaveis para lancamentos (journal)
01 WS-JR-OP-CODE        PIC X.
01 WS-JR-RETURN-STATUS  PIC XX.
01 WS-JR-N-LINES        PIC 9(2).
01 WS-I                 PIC 9(2).
01 WS-TOTAL-DEBIT       PIC S9(18) VALUE 0.
01 WS-TOTAL-CREDIT      PIC S9(18) VALUE 0.
01 WS-DATE-YYYY         PIC 9(4).
01 WS-DATE-MM           PIC 9(2).
01 WS-DATE-DD           PIC 9(2).

COPY "journal.cpy".

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
             PERFORM OPTION-CREATE-ACCOUNT
          WHEN "2"
             PERFORM OPTION-READ-ACCOUNT
          WHEN "3"
             PERFORM OPTION-UPDATE-ACCOUNT
          WHEN "4"
             PERFORM OPTION-LIST-ACCOUNTS
          WHEN "5"
             PERFORM OPTION-JOURNAL-CREATE
          WHEN "0"
             DISPLAY "Saindo do AraraLedger - Menu principal."
          WHEN OTHER
             DISPLAY "Opcao invalida. Pressione ENTER para continuar."
             ACCEPT WS-PAUSE
       END-EVALUATE
    END-PERFORM
    .

SHOW-MENU.
    DISPLAY " "
    DISPLAY "======================================="
    DISPLAY " AraraLedger - Menu principal"
    DISPLAY "======================================="
    DISPLAY " 1 - Cadastrar nova conta"
    DISPLAY " 2 - Consultar conta por ID"
    DISPLAY " 3 - Atualizar conta"
    DISPLAY " 4 - Listar todas as contas"
    DISPLAY " 5 - Registrar lancamento contabile (JOURNAL)"
    DISPLAY " 0 - Sair"
    DISPLAY "---------------------------------------"
    DISPLAY "Opcao: " WITH NO ADVANCING
    ACCEPT WS-MENU-OPTION
    .

*> ============================================================
*>   CONTAS - CRUD
*> ============================================================
OPTION-CREATE-ACCOUNT.
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

    DISPLAY "Resultado inclusao conta - STATUS: " WS-AC-RETURN-STATUS
    DISPLAY "(00 = OK, 22 = chave duplicada, 35 = nao encontrado/erro)."
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .

OPTION-READ-ACCOUNT.
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

OPTION-UPDATE-ACCOUNT.
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

    DISPLAY "Resultado atualizacao conta - STATUS: " WS-AC-RETURN-STATUS
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .

OPTION-LIST-ACCOUNTS.
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

*> ============================================================
*>   JOURNAL - Inclusao de lancamento com validacao DC
*> ============================================================
OPTION-JOURNAL-CREATE.
    MOVE SPACE TO WS-JR-RETURN-STATUS
    MOVE SPACE TO JR-RECORD
    MOVE 0     TO JR-TXN-ID JR-DATE JR-ALT-ACCOUNT-ID JR-ALT-DATE
    MOVE 0     TO WS-TOTAL-DEBIT WS-TOTAL-CREDIT
    MOVE 0     TO WS-JR-N-LINES WS-I

    DISPLAY " "
    DISPLAY "=== Registro de lancamento contabile (JOURNAL) ==="
    DISPLAY "ID do lancamento (12 digitos, ex 1): " WITH NO ADVANCING
    ACCEPT JR-TXN-ID

    DISPLAY "Data do lancamento (AAAAMMDD).....: " WITH NO ADVANCING
    ACCEPT JR-DATE

    *> Validacao simples de data AAAAMMDD
    MOVE JR-DATE (1:4) TO WS-DATE-YYYY
    MOVE JR-DATE (5:2) TO WS-DATE-MM
    MOVE JR-DATE (7:2) TO WS-DATE-DD

    IF WS-DATE-YYYY < 1900 OR WS-DATE-YYYY > 2099
       DISPLAY "Data invalida (ano fora de 1900-2099)."
       DISPLAY "Pressione ENTER para voltar ao menu."
       ACCEPT WS-PAUSE
       EXIT PARAGRAPH
    END-IF

    IF WS-DATE-MM < 1 OR WS-DATE-MM > 12
       DISPLAY "Data invalida (mes deve ser 01-12)."
       DISPLAY "Pressione ENTER para voltar ao menu."
       ACCEPT WS-PAUSE
       EXIT PARAGRAPH
    END-IF

    IF WS-DATE-DD < 1 OR WS-DATE-DD > 31
       DISPLAY "Data invalida (dia deve ser 01-31)."
       DISPLAY "Pressione ENTER para voltar ao menu."
       ACCEPT WS-PAUSE
       EXIT PARAGRAPH
    END-IF

    DISPLAY "Historico / memo (ate 60 chars)...: " WITH NO ADVANCING
    ACCEPT JR-MEMO

    DISPLAY "Numero de linhas (1 a 10).........: " WITH NO ADVANCING
    ACCEPT WS-JR-N-LINES

    IF WS-JR-N-LINES < 1 OR WS-JR-N-LINES > 10
       DISPLAY "Numero de linhas invalido."
       DISPLAY "Pressione ENTER para voltar ao menu."
       ACCEPT WS-PAUSE
       EXIT PARAGRAPH
    END-IF

    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > WS-JR-N-LINES
       MOVE WS-I TO JR-LINE-NO (WS-I)

       DISPLAY " "
       DISPLAY "Linha " WS-I " - conta (ID numerico).........: " WITH NO ADVANCING
       ACCEPT JR-LINE-ACCOUNT-ID (WS-I)

       *> Validar se a conta existe usando ACCOUNTS-IO
       MOVE "R" TO WS-AC-OP-CODE
       MOVE JR-LINE-ACCOUNT-ID (WS-I) TO WS-AC-ACCOUNT-ID
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

       IF WS-AC-RETURN-STATUS NOT = "00"
          DISPLAY "Conta inexistente para linha " WS-I
                  " (STATUS: " WS-AC-RETURN-STATUS ")"
          DISPLAY "Pressione ENTER para voltar ao menu."
          ACCEPT WS-PAUSE
          EXIT PARAGRAPH
       END-IF

       DISPLAY "Linha " WS-I " - tipo (D/C)...................: " WITH NO ADVANCING
       ACCEPT JR-LINE-DC (WS-I)

       IF JR-LINE-DC (WS-I) NOT = "D" AND JR-LINE-DC (WS-I) NOT = "C"
          DISPLAY "Tipo D/C invalido na linha " WS-I
          DISPLAY "Pressione ENTER para voltar ao menu."
          ACCEPT WS-PAUSE
          EXIT PARAGRAPH
       END-IF

       DISPLAY "Linha " WS-I " - valor em centavos (ex 12345=R$123,45): " WITH NO ADVANCING
       ACCEPT JR-LINE-AMOUNT-CENTS (WS-I)

       IF JR-LINE-DC (WS-I) = "D"
          ADD JR-LINE-AMOUNT-CENTS (WS-I) TO WS-TOTAL-DEBIT
       ELSE
          ADD JR-LINE-AMOUNT-CENTS (WS-I) TO WS-TOTAL-CREDIT
       END-IF
    END-PERFORM

    *> Preenche chave alternativa (conta+data) com base na primeira linha
    MOVE JR-LINE-ACCOUNT-ID (1) TO JR-ALT-ACCOUNT-ID
    MOVE JR-DATE                  TO JR-ALT-DATE

    *> Validacao de partidas dobradas
    IF WS-TOTAL-DEBIT NOT = WS-TOTAL-CREDIT
       DISPLAY "Lancamento desequilibrado: "
       DISPLAY "  Total Debito : " WS-TOTAL-DEBIT
       DISPLAY "  Total Credito: " WS-TOTAL-CREDIT
       DISPLAY "Lancamento NAO sera gravado."
       DISPLAY "Pressione ENTER para voltar ao menu."
       ACCEPT WS-PAUSE
       EXIT PARAGRAPH
    END-IF

    MOVE "N" TO JR-POSTED-FLAG

    MOVE "C" TO WS-JR-OP-CODE
    MOVE SPACE TO WS-JR-RETURN-STATUS

    CALL "JOURNAL-IO" USING
         WS-JR-OP-CODE
         JR-RECORD
         WS-JR-RETURN-STATUS

    DISPLAY "Resultado gravacao JOURNAL - STATUS: " WS-JR-RETURN-STATUS
    DISPLAY "(00 = OK; 22 = chave duplicada; outros = erro de I/O)."
    DISPLAY "Pressione ENTER para voltar ao menu."
    ACCEPT WS-PAUSE
    .