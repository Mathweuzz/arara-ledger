>>SOURCE FORMAT FREE
*> ------------------------------------------------------------
*> Programa: journal-io.cob
*> Objetivo:
*>   - Subprograma para gravar lancamentos no arquivo JOURNAL.
*>   - Operacoes:
*>       'C' = Create (incluir lancamento)
*>   - Forca posted-flag = 'N' no registro gravado.
*>   - A chave alternativa (JR-ALT-KEY) deve ser preenchida
*>     pelo chamador (ex.: menu.cob).
*> ------------------------------------------------------------
IDENTIFICATION DIVISION.
PROGRAM-ID. JOURNAL-IO.

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT JOURNAL-FILE ASSIGN TO "data/journal.dat"
        ORGANIZATION IS INDEXED
        ACCESS MODE   IS DYNAMIC
        RECORD KEY    IS JR-TXN-ID
        ALTERNATE RECORD KEY IS JR-ALT-KEY WITH DUPLICATES
        FILE STATUS   IS FS-JOURNAL.

DATA DIVISION.
FILE SECTION.

FD  JOURNAL-FILE.
COPY "journal.cpy".

WORKING-STORAGE SECTION.
COPY "common.cpy".

01 FS-JOURNAL PIC XX.

LINKAGE SECTION.
01 L-JR-OP-CODE        PIC X.
COPY "journal.cpy" REPLACING ==JR-RECORD== BY ==L-JR-RECORD==.
01 L-JR-RETURN-STATUS  PIC XX.

PROCEDURE DIVISION USING
    L-JR-OP-CODE
    L-JR-RECORD
    L-JR-RETURN-STATUS
    .

MAIN-PARA.
    MOVE SPACES TO L-JR-RETURN-STATUS
    MOVE SPACES TO FS-JOURNAL

    OPEN I-O JOURNAL-FILE
    IF FS-JOURNAL NOT = FS-OK
       MOVE FS-JOURNAL TO L-JR-RETURN-STATUS
       GOBACK
    END-IF

    EVALUATE L-JR-OP-CODE
       WHEN "C"
          PERFORM CREATE-JOURNAL
       WHEN OTHER
          MOVE "OP" TO L-JR-RETURN-STATUS
    END-EVALUATE

    CLOSE JOURNAL-FILE
    GOBACK
    .

CREATE-JOURNAL.
    *> Copia o registro recebido do chamador para o registro do arquivo
    MOVE L-JR-RECORD TO JR-RECORD

    *> Garante posted-flag = 'N' no registro do arquivo
    MOVE "N" TO JR-POSTED-FLAG OF JR-RECORD

    WRITE JR-RECORD
    MOVE FS-JOURNAL TO L-JR-RETURN-STATUS
    .
