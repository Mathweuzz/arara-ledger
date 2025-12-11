*> ------------------------------------------------------------
*> Copybook: journal.cpy
*> Layout do registro de lançamentos (JOURNAL)
*> Chave principal: JR-TXN-ID
*> Chave alternativa: JR-ALT-KEY (conta+data)
*> ------------------------------------------------------------

01 JR-RECORD.
   05 JR-TXN-ID      PIC 9(12).
   05 JR-DATE        PIC 9(8).
      *> AAAAMMDD - data do lançamento

   *> Chave alternativa principal para acesso rápido por conta+data
   05 JR-ALT-KEY.
      10 JR-ALT-ACCOUNT-ID PIC 9(10).
      10 JR-ALT-DATE       PIC 9(8).
      *> Em versões futuras vamos preencher isso coerentemente
      *> (por exemplo, com a conta “principal” do lançamento).

   *> Linhas de débito/crédito (até 10 linhas por lançamento)
   05 JR-LINES OCCURS 10 TIMES.
      10 JR-LINE-NO           PIC 9(2).
      10 JR-LINE-ACCOUNT-ID   PIC 9(10).
      10 JR-LINE-DC           PIC X(1).
         *> 'D' débito, 'C' crédito
      10 JR-LINE-AMOUNT-CENTS PIC 9(15).

   05 JR-MEMO        PIC X(60).
   05 JR-POSTED-FLAG PIC X(1).
      *> 'N' não postado, 'Y' postado no LEDGER