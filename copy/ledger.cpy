*> ------------------------------------------------------------
*> Copybook: ledger.cpy
*> Layout do registro de saldos por período (LEDGER)
*> Chave composta: LG-KEY (conta + período AAAAMM)
*> ------------------------------------------------------------

01 LG-RECORD.
   05 LG-KEY.
      10 LG-ACCOUNT-ID PIC 9(10).
      10 LG-PERIOD     PIC 9(6).
      *> AAAAMM

   05 LG-OPENING-CENTS PIC S9(18) SIGN LEADING SEPARATE.
   05 LG-DEBIT-CENTS   PIC S9(18) SIGN LEADING SEPARATE.
   05 LG-CREDIT-CENTS  PIC S9(18) SIGN LEADING SEPARATE.
   05 LG-CLOSING-CENTS PIC S9(18) SIGN LEADING SEPARATE.
