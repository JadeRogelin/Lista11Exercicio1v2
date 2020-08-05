      $set sourceformat "free"

      *>Divisão de identificação de programa
       Identification Division.
       Program-id. "Lista11Exercicio1v2".
       Author. "Jade Rogelin".
       Installation. "PC".
       Date-written. 14/07/2020.
       Date-compiled. 14/07/2020.


      *>Divisão para configuração do ambiente
       Environment Division.
       Configuration section.
           special-names. decimal-point is comma.

      *>--Declaração de recursos externos (faz parte da de cima ainda)
       Input-output section.
       File-control.

           select arqTemp assign to "arqTemp.txt"  *> adiciona nome ao arquivo
           organization is line sequential         *> modo de acesso é sequencial
           access mode is sequential
           lock mode is automatic
           file status is ws-fs-arqTemp.

       I-O-Control.

      *>Declaração de variáveis
       Data Division.

      *>--Variáveis de arquivos
       File section.
       fd arqTemp.
       01  fd-rela-temp.
           05 fd-temp                              pic S9(02)V99.


      *>--Variáveis de trabalho
       Working-storage section.

       77 ws-fs-arqTemp                            pic 9(02).

       01 ws-temepraturas occurs 30.
          05 ws-temp                               pic S9(02)V99.

       01 ws-variaveis_num.
          05 ws-temp-tt                            pic S9(04)V99.
          05 ws-media-temp                         pic S9(02)V99.

       01 ws-msn-erro.
           05 ws-msn-erro-offset                   pic  x(04).
           05 filler                               pic  x(01) value '-'.
           05 ws-msn-erro-cod                      pic  x(1).
           05 filler                               pic  x(02) value '-'.
           05 ws-msn-erro-text                     pic  x(42).

       77 ws-sair                                  pic  x(01).
       77 ws-ind                                   pic 9(02).
       77 ws-dia                                   pic 9(02).

      *>--Variáveis para comunicação entre programas
       Linkage section.

      *>--Declaração de tela
       Screen section.

      *>Declaração do corpo programa
       Procedure Division.

           perform inicializa.
           perform processamento.
           perform finaliza.

      *>-------------------------------------------------------------------
       inicializa section.

           open input arqTemp.
           if ws-fs-arqTemp <> 0 then
               move 1 to ws-msn-erro-offset
               move ws-fs-arqTemp                          to ws-msn-erro-cod
               move "Erro ao Abrir Arquivo arqTemp"        to ws-msn-erro-text
               perform finaliza-anormal
           end-if


          perform varying ws-ind from 1 by 1 until ws-fs-arqTemp = 10
                                                or ws-fs-arqTemp > 30
            .
       inicializa-exit.
           exit.
      *>-------------------------------------------------------------------
      *> Processamneto
      *>-------------------------------------------------------------------
       processamento section.

           perform until ws-sair = 'S'
                      or ws-sair = 's'

               display erase
               display "Informe o dia que voce Deseja Consultar: "
               accept ws-dia

               if ws-dia <= 30
               or ws-dia >= 1 then
                   display "Dia Inexixtente"
                   display "Intervalo de Dias Disponiveis: 1 - 30 "
               else
                   if ws-temp(ws-dia) > ws-media-temp then
                       display "A Temeperatura Esta Acima da Media"
                   else
                       if ws-temp(ws-dia) < ws-media-temp then
                           display "A Temeperatura Esta Abaixo da Media"
                       else
                           display "A Temperatura Esta Igual a Media"
                       end-if
                   end-if

                   display "Dia: " ws-dia "Temp: " ws-temp(ws-dia) "C"
               end-if

               display "Informe ou 'Enter' para Continuar ou 'S' para sair"
               accept ws-sair

           end-perform

           .
       processamento-exit.
           exit.
      *>-------------------------------------------------------------------
      *>  Calculo da media das temperaturas
      *>-------------------------------------------------------------------
       calculo-temp-media-section.

            move 0 to ws-temp-tt
      *> --- cuida de executar as 30 vzs ate q ind seja >30
           perform varying ws-ind from 1 by 1 until ws-ind > 30
               compute ws-temp-tt = ws-temp-tt + ws-temp(ws-ind)
           end-perform

           compute ws-media-temp =  ws-temp-tt / 30

           .
       calculo-temp-media-exit.
           exit.

      *>-------------------------------------------------------------------
      *> Finaliza Anormal
      *>-------------------------------------------------------------------
       finaliza-anormal section.

           display erase
           display ws-msn-erro

           stop run
           .
       finaliza-anormal-exit.
           exit.

      *>-------------------------------------------------------------------
      *> Finaliza Normal
      *>-------------------------------------------------------------------
       finaliza section.

           close arqTemp.
           if ws-fs-arqTemp <> 0 then
               move 3 to ws-msn-erro-offset
               move ws-fs-arqTemp                           to ws-msn-erro-cod
               move "Erro ao Fechar Arquivo arqTemp"        to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           stop run.
            .
       finaliza-exit.
           exit.




























