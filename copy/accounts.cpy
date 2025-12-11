*> ------------------------------------------------------------
*> Copybook: accounts.cpy
*> Layout do registro de contas (ACCOUNTS)
*> Chave: AC-ACCOUNT-ID
*> ------------------------------------------------------------

01 AC-RECORD.
   05 AC-ACCOUNT-ID   PIC 9(10).
   05 AC-PARENT-ID    PIC 9(10).
   05 AC-ACCOUNT-NAME PIC X(40).
   05 AC-ACCOUNT-TYPE PIC X(1).
      *> 'A' ativo, 'P' passivo, 'R' receita, 'D' despesa, 'E' PL
   05 AC-CURRENCY     PIC X(3).
      *> "BRL"
   05 AC-OPENED-DATE  PIC 9(8).
      *> AAAAMMDD
   05 AC-STATUS       PIC X(1).
      *> 'A' ativo, 'I' inativo