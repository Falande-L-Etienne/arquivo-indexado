      $set sourceformat"free"
      *>Divisão de identificação do programa
       identification division.
       program-id. "arquivo_indexado_exc1V1".
       author. "Falande Loiseau Etienne".
       installation. "PC".
       date-written. 28/07/2020.
       date-compiled. 28/07/2020.



      *>Divisão para configuração do ambiente
       environment division.
       configuration section.
           special-names. decimal-point is comma.

      *>-----Declaração dos recursos externos
       input-output section.
       file-control.

           select arqRegistroAluno assign to "arqRegistroAluno.txt"
           organization is indexed
           access mode is dynamic
           lock mode is automatic
           record key is fd-cod-aluno
           file status is ws-fs-arqRegistroAluno.

       i-o-control.

      *>Declaração de variáveis
       data division.

      *>----Variaveis de arquivos
       file section.
       fd arqRegistroAluno.
       01  fd-cad-alunos.
           05  fd-cod-aluno                        pic 9(03).
           05  fd-nome-aluno                       pic x(25).
           05  fd-endereco-alu                         pic x(35).
           05  fd-nome-mae                         pic x(25).
           05  fd-nome-pai                         pic x(25).
           05  fd-telefone-alu                         pic x(15).
           05  fd-notas.
               10  fd-nota1                        pic 9(02)v99 value zero.
               10  fd-nota2                        pic 9(02)v99 value zero.
               10  fd-nota3                        pic 9(02)v99 value zero.
               10  fd-nota4                        pic 9(02)v99 value zero.


      *>----Variaveis de trabalho
       working-storage section.

       77  ws-fs-arqRegistroAluno                  pic  9(02).

       01  ws-cad-alunos.
           05  ws-cod-aluno                        pic 9(03).
           05  ws-nome-aluno                       pic x(25).
           05  ws-endereco-alu                     pic x(35).
           05  ws-nome-mae                         pic x(25).
           05  ws-nome-pai                         pic x(25).
           05  ws-telefone-alu                     pic x(15).
           05  ws-notas.
               10  ws-nota1                        pic 9(02)v99 value zero.
               10  ws-nota2                        pic 9(02)v99 value zero.
               10  ws-nota3                        pic 9(02)v99 value zero.
               10  ws-nota4                        pic 9(02)v99 value zero.

       77  ws-menu                                 pic x(02).
       77  aux                                     pic x(01).

       77 ws-sair                                  pic  x(01).
          88  fechar-programa                      value "S" "s".
          88  voltar-tela                          value "V" "v".

       01 ws-msn-erro.
          05 ws-msn-erro-ofsset                    pic 9(04).
          05 filler                                pic x(01) value "-".
          05 ws-msn-erro-cod                       pic 9(02).
          05 filler                                pic x(01) value space.
          05 ws-msn-erro-text                      pic x(42).



      *>----Variaveis para comunicação entre programas
       linkage section.


      *>----Declaração de tela
       screen section.


      *>Declaração do corpo do programa
       procedure division.


           perform inicializa.
           perform processamento.
           perform finaliza.

      *>------------------------------------------------------------------------
      *>  procedimentos de inicialização
      *>------------------------------------------------------------------------
       inicializa section.
      *>    inicializa menu
           move  spaces      to     ws-menu

           open i-o arqRegistroAluno   *> open i-o abre o arquivo para leitura e escrita
           if ws-fs-arqRegistroAluno  <> 00
           and ws-fs-arqRegistroAluno <> 05 then
               move 1                                         to ws-msn-erro-ofsset
               move ws-fs-arqRegistroAluno                    to ws-msn-erro-cod
               move "Erro ao abrir arq. arqRegistroAluno "    to ws-msn-erro-text
               perform finaliza-anormal
           end-if

           .
       inicializa-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Processamento Principal
      *>------------------------------------------------------------------------
       processamento section.

           perform until fechar-programa

               move space to ws-sair

               display "'1' Cadastrar Aluno"
               display "'2' Cadastrar Notas "
               display "'3' consulta indexada"
               display "'4' consulta sequencial"
               display "'5' Deletar"
               display "'6' Alterar"

               accept ws-menu

               evaluate ws-menu
                   when = "1"
                       perform cadastrar-aluno

                   when = "2"
                       perform cadastrar-notas

                   when = "3"
                       perform consultar-indexada

                   when = "4"
                       perform consultar-sequencial

                   when = "5"
                       perform deletar-cadastro

                    when = "6"
                       perform alterar-cadastro

                   when other
                       display "opcao invalida"
               end-evaluate

               display " Deseja sair do programa ? 'S'/'N' "
               accept ws-sair


           end-perform


           .
       processamento-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  cadastro de aluno
      *>------------------------------------------------------------------------
       cadastrar-aluno section.

           perform buscar-prox-cod

           perform until voltar-tela

               move zeros to ws-notas

               display "-------  cadastro de alunos -------"

               display "Codigo: "
               accept ws-cod-aluno

               display "Nome Aluno: "
               accept ws-nome-aluno

               display "Endereco: "
               accept ws-endereco-alu

               display "Nome da mae: "
               accept ws-nome-mae

               display "Nome do pai: "
               accept ws-nome-pai

               display "Telefone: "
               accept ws-telefone-alu

      *> -------------  Salvar dados no arquivo

               write fd-cad-alunos       from ws-cad-alunos
               if ws-fs-arqRegistroAluno <> 0 then
                   move 7                                            to ws-msn-erro-ofsset
                   move ws-fs-arqRegistroAluno                       to ws-msn-erro-cod
                   move "Erro ao escrever arq. arqRegistroAluno "    to ws-msn-erro-text
                   perform finaliza-anormal
               end-if
      *> -------------
               display "Deseja cadastrar mais um aluno? 'S' ou 'V'oltar "
               accept ws-sair

           end-perform

           display erase
           .
       cadastrar-aluno-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  cadastro de notas
      *>------------------------------------------------------------------------
       cadastrar-notas section.

           perform until voltar-tela

               display erase

               move zeros to ws-notas

               display "------ Cadastro de notas ------"

               display "Informe o cod. do aluno: "
               accept ws-cod-aluno

               display "Informe a nota: "
               accept ws-nota1

               display "Informe a nota: "
               accept ws-nota2

               display "Informe a nota: "
               accept ws-nota3

               display "Informe a nota: "
               accept ws-nota4

       *>----- preenche a chave
               move ws-cod-aluno to fd-cod-aluno

       *>----- ler o registro do aluno
               read arqRegistroAluno

               if  ws-fs-arqRegistroAluno <> 0
               and ws-fs-arqRegistroAluno <> 10 then
                   if ws-fs-arqRegistroAluno = 23 then
                       display "Codigo informado invalido!"
                   else
                       move 2                                   to ws-msn-erro-ofsset
                       move ws-fs-arqRegistroAluno              to ws-msn-erro-cod
                       move "Erro ao ler arq. arqTemp "         to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

              move ws-notas to fd-notas

              rewrite fd-cad-alunos

               display "Deseja cadastrar mais notas? 'S' ou 'V'oltar"
               accept ws-sair

           end-perform
           .
       cadastrar-notas-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Rotina de busca do proximo aluno a ser cadastrado
      *>------------------------------------------------------------------------
       buscar-prox-cod section.

           move 1 to fd-cod-aluno

           read arqRegistroAluno

           if  ws-fs-arqRegistroAluno = 23  then
               move 1 to ws-cod-aluno

           else
               perform until ws-fs-arqRegistroAluno = 10
               *> ler o arquivo ate o ultimo registro
                     read arqRegistroAluno next
               end-perform

               move fd-cad-alunos to  ws-cad-alunos
               display " "
               display " O proximo codigo eh : "
               add 1 to ws-cod-aluno
               *> Mostrar o proximo codigo a ser cadastrado
               display ws-cod-aluno
           end-if

           .
       buscar-prox-cod-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Rotina de consulta de aluno  - lê o arquivo de forma indexada
      *>------------------------------------------------------------------------
       consultar-indexada section.

           perform until voltar-tela
      *> -------------  Ler dados do arquivo
               display "informe o codigo do aluno a ser consultado :"
               accept ws-cod-aluno

               move ws-cod-aluno to fd-cod-aluno

               read arqRegistroAluno

               if  ws-fs-arqRegistroAluno <> 0
               and ws-fs-arqRegistroAluno <> 10 then
                   if ws-fs-arqRegistroAluno = 23 then
                       display "Codigo informado invalido!"
                   else
                       move 2                                            to ws-msn-erro-ofsset
                       move ws-fs-arqRegistroAluno                       to ws-msn-erro-cod
                       move "Erro ao ler arq. arqRegistroAluno "         to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

               move  fd-cad-alunos       to  ws-cad-alunos

      *> -------------
               display "Codigo: "      ws-cod-aluno
               display "Nome Aluno: "  ws-nome-aluno
               display "Endereco: "    ws-endereco-alu
               display "Nome Mae: "    ws-nome-mae
               display "Nome Pai: "    ws-nome-pai
               display "Telefone: "    ws-telefone-alu
               display " Notas "
               display " Nota 1 : "    ws-nota1
               display " Nota 2 : "    ws-nota2
               display " Nota 3 : "    ws-nota3
               display " Nota 4 : "    ws-nota4

               display "Deseja consultar mais um aluno? 'S' ou 'V'oltar"
               accept ws-sair

           end-perform
           .
       consultar-indexada-exit.
           exit.


      *>------------------------------------------------------------------------------
      *>  Rotina de consulta do cadastro do aluno  - lê o arquivo de forma sequencial
      *>------------------------------------------------------------------------------
       consultar-sequencial section.

               display "informe o codigo onde voce quer comecar a consulta :"
               accept ws-cod-aluno

               move ws-cod-aluno to fd-cod-aluno

               read arqRegistroAluno

               move  fd-cad-alunos       to  ws-cad-alunos

      *> ------------- Mostrar a consulta na tela
                   display "Codigo: "  ws-cod-aluno
                   display "Nome Aluno: "  ws-nome-aluno
                   display "Endereco: "  ws-endereco-alu
                   display "Nome Mae: "  ws-nome-mae
                   display "Nome Pai: "  ws-nome-pai
                   display "Telefone: "  ws-telefone-alu
                   display " Notas "
                   display " Nota 1 : "    ws-nota1
                   display " Nota 2 : "    ws-nota2
                   display " Nota 3 : "    ws-nota3
                   display " Nota 4 : "    ws-nota4

                   display "Deseja consultar mais um aluno? 'S' ou 'V'oltar"
                   accept ws-sair


               perform until voltar-tela

                   read arqRegistroAluno next

                   if  ws-fs-arqRegistroAluno <> 0  then
                   if ws-fs-arqRegistroAluno = 10 then
                       perform consultar-sequencial-prev
                   else
                       move 3                                            to ws-msn-erro-ofsset
                       move ws-fs-arqRegistroAluno                       to ws-msn-erro-cod
                       move "Erro ao ler arq. arqRegistroAluno "         to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
                   end-if

                   move  fd-cad-alunos       to  ws-cad-alunos

      *> ------------- Mostrar a consulta na tela
                   display "Codigo: "  ws-cod-aluno
                   display "Nome Aluno: "  ws-nome-aluno
                   display "Endereco: "  ws-endereco-alu
                   display "Nome Mae: "  ws-nome-mae
                   display "Nome Pai: "  ws-nome-pai
                   display "Telefone: "  ws-telefone-alu
                   display " Notas "
                   display " Nota 1 : "    ws-nota1
                   display " Nota 2 : "    ws-nota2
                   display " Nota 3 : "    ws-nota3
                   display " Nota 4 : "    ws-nota4


                   display "Deseja consultar mais um aluno? 'S' ou 'V'oltar"
                   accept ws-sair

               end-perform


           .
       consultar-sequencial-exit.
           exit.

      *>------------------------------------------------------------------------
      *>  Rotina de consulta do cadastro  - lê o arquivo de traz pra frente
      *>------------------------------------------------------------------------
       consultar-sequencial-prev section.


           perform until voltar-tela

               read arqRegistroAluno previous

               if  ws-fs-arqRegistroAluno <> 0  then
                  if ws-fs-arqRegistroAluno = 10 then
                      perform consultar-sequencial
                  else
                      move 4                                            to ws-msn-erro-ofsset
                      move ws-fs-arqRegistroAluno                       to ws-msn-erro-cod
                      move "Erro ao ler arq. arqRegistroAluno "         to ws-msn-erro-text
                      perform finaliza-anormal
                  end-if
               end-if

               move  fd-cad-alunos       to  ws-cad-alunos

      *> -------------
               display "Codigo: "  ws-cod-aluno
               display "Nome Aluno: "  ws-nome-aluno
               display "Endereco: "  ws-endereco-alu
               display "Nome Mae: "  ws-nome-mae
               display "Nome Pai: "  ws-nome-pai
               display "Telefone: "  ws-telefone-alu
               display " Notas "
               display " Nota 1 : "    ws-nota1
               display " Nota 2 : "    ws-nota2
               display " Nota 3 : "    ws-nota3
               display " Nota 4 : "    ws-nota4


               display "Deseja consultar mais um aluno? 'S' ou 'V'oltar"
               accept ws-sair

           end-perform


           .
       consultar-sequencial-prev-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Rotina de apagamento / Delete
      *>------------------------------------------------------------------------
       deletar-cadastro section.

           perform until voltar-tela

      *> -------------  Apagar dados do registro do arquivo
               display "informe o codigo do aluno a ser excluido :"
               accept ws-cod-aluno

               move ws-cod-aluno to fd-cod-aluno

               delete arqRegistroAluno

               if  ws-fs-arqRegistroAluno = 0 then
                   display "Cadastro do aluno " ws-cod-aluno " apagado com sucesso!"
               else
                   if ws-fs-arqRegistroAluno = 23 then
                       display "Codigo informado invalido!"
                   else
                       move 5                                            to ws-msn-erro-ofsset
                       move ws-fs-arqRegistroAluno                       to ws-msn-erro-cod
                       move "Erro ao apagar arq. arqRegistroAluno "      to ws-msn-erro-text
                       perform finaliza-anormal
                   end-if
               end-if

               display "Deseja deletar mais um registro? 'S' ou 'V'oltar"
               accept ws-sair

           end-perform

           .
       deletar-cadastro-exit.
           exit.


      *>------------------------------------------------------------------------
      *>  Rotina de alteração de temperatura
      *>------------------------------------------------------------------------
       alterar-cadastro section.

           perform until voltar-tela

               display "informe o codigo do aluno a ser alterado :"
               accept ws-cod-aluno

               move ws-cod-aluno to fd-cod-aluno

               read arqRegistroAluno

      *> -------------  Alterar dados do registro do arquivo
               display "informe qual item no registro voce quer alterar:"

               display "'1' Nome Aluno"
               display "'2' Endereco "
               display "'3' Nome Mae"
               display "'4' Nome pai"
               display "'5' Telefone"
               display "'6' Nota 1"
               display "'7' Nota 2"
               display "'8' Nota 3"
               display "'9' Nota 4"

               accept ws-menu

               evaluate ws-menu

                   when = "1"
                         display "Informe o novo nome : "
                         accept ws-nome-aluno
                         move ws-nome-aluno to fd-nome-aluno

                   when = "2"
                         display "Informe o novo endereco : "
                         accept ws-endereco-alu
                         move ws-endereco-alu to fd-endereco-alu

                   when = "3"
                         display "Informe o novo nome da mae: "
                         accept ws-nome-mae
                         move ws-nome-mae to fd-nome-mae

                   when = "4"
                         display "Informe o novo nome do pai : "
                         accept ws-nome-pai
                         move ws-nome-pai to fd-nome-pai

                   when = "5"
                         display "Informe o novo telefone : "
                         accept ws-telefone-alu
                         move ws-telefone-alu to fd-telefone-alu

                   when = "6"
                         display "Informe a nova nota : "
                         accept ws-nota1
                         move ws-nota1 to fd-nota1

                   when = "7"
                         display "Informe a nova nota : "
                         accept ws-nota2
                         move ws-nota2 to fd-nota2

                   when = "8"
                         display "Informe a nova nota : "
                         accept ws-nota3
                         move ws-nota3 to fd-nota3

                   when = "9"
                         display "Informe a nova nota : "
                         accept ws-nota4
                         move ws-nota4 to fd-nota4

                   when other
                       display "opcao invalida"

               end-evaluate


               rewrite fd-cad-alunos

               if  ws-fs-arqRegistroAluno = 0 then
                   display "Codigo do aluno " ws-cod-aluno " alterado com sucesso !"
                   display " "
                   display " Precisa sair do programa para atualizar o arquivo !!! "
               else
                   move 6                                            to ws-msn-erro-ofsset
                   move ws-fs-arqRegistroAluno                       to ws-msn-erro-cod
                   move "Erro ao alterar arq. arqRegistroAluno "     to ws-msn-erro-text
                   perform finaliza-anormal
               end-if

               display "Deseja alterar mais um item no registro? 'S' ou 'V'oltar"
               accept ws-sair

           end-perform

           .
       alterar-cadastro-exit.
           exit.



      *>------------------------------------------------------------------------
      *>  Finalização  Anormal
      *>------------------------------------------------------------------------
       finaliza-anormal section.
           display erase
           display ws-msn-erro.
           Stop run
           .
       finaliza-anormal-exit.
           exit.



      *>------------------------------------------------------------------------
      *>  Finalização
      *>------------------------------------------------------------------------
       finaliza section.
           Stop run
           .
       finaliza-exit.
           exit.













