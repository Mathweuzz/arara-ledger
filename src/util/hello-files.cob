>>SOURCE FORMAT FREE
*> ------------------------------------------------------------
*> AraraLedger - Passo 1
*> Programa de teste para abrir/fechar um arquivo INDEXED
*> e exibir o FILE STATUS das operações.
*> ------------------------------------------------------------
IDENTIFICATION DIVISION.
PROGRAM-ID. HELLO-FILES.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT HELLO-FILE ASSIGN TO "data/hello-indexed.dat"
        ORGANIZATION IS INDEXED
        ACCESS MODE   IS DYNAMIC
        RECORD KEY    IS HELLO-KEY
        FILE STATUS   IS WS-FILE-STATUS.

DATA DIVISION.
FILE SECTION.
FD  HELLO-FILE.
01  HELLO-RECORD.
    05 HELLO-KEY   PIC 9(4).
    05 HELLO-TEXT  PIC X(76).

WORKING-STORAGE SECTION.
01  WS-FILE-STATUS       PIC XX.
01  WS-DISPLAY-LABEL     PIC X(30).

PROCEDURE DIVISION.
MAIN-PARA.
    DISPLAY "ARARA LEDGER - HELLO INDEXED FILE".
    DISPLAY "------------------------------------".

    *> Abrir o arquivo em modo OUTPUT (cria/trunca o arquivo indexado)
    MOVE SPACES TO WS-FILE-STATUS
    OPEN OUTPUT HELLO-FILE
    MOVE "OPEN OUTPUT STATUS: " TO WS-DISPLAY-LABEL
    PERFORM DISPLAY-STATUS

    *> Escrever um registro de teste
    MOVE 1                     TO HELLO-KEY
    MOVE "Primeiro registro de teste." TO HELLO-TEXT
    WRITE HELLO-RECORD
    MOVE "WRITE RECORD STATUS: " TO WS-DISPLAY-LABEL
    PERFORM DISPLAY-STATUS

    *> Fechar o arquivo
    CLOSE HELLO-FILE
    MOVE "CLOSE STATUS: " TO WS-DISPLAY-LABEL
    PERFORM DISPLAY-STATUS

    DISPLAY "Fim do teste de arquivo indexado.".
    STOP RUN.

DISPLAY-STATUS.
    DISPLAY WS-DISPLAY-LABEL WS-FILE-STATUS.
    EXIT PARAGRAPH.
