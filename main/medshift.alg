algoritmo "Hospital Aurora"

var
   opcaoMenu : inteiro

   cadMedicos : logico
   opcaoCad : inteiro

   posicao : inteiro
   medicoNome : vetor[1..20] de caractere
   medicoEspec : vetor[1..20] de caractere
   medicoDisp : vetor[1..20] de caractere
   medicoID : vetor[1..20] de inteiro

   cadPlantao : logico
   continuarPlan : logico

   opcaoTurno : caractere

   qtdClinicos : inteiro
   qtdPediatras : inteiro
   qtdCirurgioes : inteiro

   limiteMax : inteiro
   minClinicos : inteiro
   minPediatras : inteiro
   minCirurgioes : inteiro

   totalEspec : inteiro

inicio
   // inicialização de variáveis com valores definidos
   cadMedicos <- falso
   cadPlantao <- falso
   continuarPlan <- falso
   posicao <- 0
   opcaoMenu <- 0

   // menu inicial, onde o usuário escolhe o que fazer
   enquanto opcaoMenu <> 3 faca

      escreval("=== MedShift - Hospital Aurora ===")
      escreval("1 - Cadastrar médicos")
      escreval("2 - Criar plantão")
      escreval("3 - Encerrar")
      escreva("Escolha uma opção: ")
      leia(opcaoMenu)

      // opção 1 do menu: cadastrar médicos
      se opcaoMenu = 1 entao

         limpatela
         cadMedicos <- verdadeiro

         enquanto cadMedicos = verdadeiro faca

            // se o limite de médicos não foi atingido, faz:
            se posicao < 20 entao

               posicao <- posicao + 1

               escreval("=== CADASTRAR MÉDICO ===")

               escreva("Nome: ")
               leia(medicoNome[posicao])

               // especialidade é registrada como "número" em sua posição atual do vetor
               escreval("")
               escreval("Especialidade: ")
               escreval("1 - Clínico geral")
               escreval("2 - Pediatra")
               escreval("3 - Cirurgião")
               escreva("Escolha uma opção: ")
               leia(medicoEspec[posicao])

               // disponibilidade é registrada como "número" em sua posição atual do vetor
               escreval("")
               escreval("Disponibilidade: ")
               escreval("1 - Manhã")
               escreval("2 - Tarde")
               escreval("3 - Noite")
               escreva("Escolha uma opção: ")
               leia(medicoDisp[posicao])

               // especialidade é convertida de "número" para texto
               // o ID é gerado automaticamente
               se medicoEspec[posicao] = "1" entao
                  medicoEspec[posicao] <- "Clínico geral"
                  medicoID[posicao] <- 100 + posicao
               senao
                  se medicoEspec[posicao] = "2" entao
                     medicoEspec[posicao] <- "Pediatra"
                     medicoID[posicao] <- 200 + posicao
                  senao
                     se medicoEspec[posicao] = "3" entao
                        medicoEspec[posicao] <- "Cirurgião"
                        medicoID[posicao] <- 300 + posicao
                     senao
                        medicoID[posicao] <- posicao
                     fimse
                  fimse
               fimse

               // disponibilidade é convertida de "número" para texto
               se medicoDisp[posicao] = "1" entao
                  medicoDisp[posicao] <- "Manhã"
               senao
                  se medicoDisp[posicao] = "2" entao
                     medicoDisp[posicao] <- "Tarde"
                  senao
                     se medicoDisp[posicao] = "3" entao
                        medicoDisp[posicao] <- "Noite"
                     fimse
                  fimse
               fimse

               escreval("")
               escreval("ID gerado: ", medicoID[posicao])
               escreval("")
               escreval("Continuar cadastrando?")
               escreval("1 - Continuar")
               escreval("2 - Sair")
               escreva("Escolha uma opção: ")
               leia(opcaoCad)

               se opcaoCad = 2 entao
                  cadMedicos <- falso
               senao
                  se opcaoCad = 1 entao
                     cadMedicos <- verdadeiro
                     limpatela
                  senao
                     escreval("")
                     escreval("ERRO: Opção inválida. Cadastro encerrado.")
                     escreval("Pressione Enter para voltar ao menu.")
                     leia(opcaoCad)
                     cadMedicos <- falso
                  fimse
               fimse

            senao
               escreval("Limite de 20 médicos atingido.")
               escreval("")
               escreval("Pressione Enter para voltar ao menu.")
               leia(opcaoCad)
               cadMedicos <- falso
            fimse

         fimenquanto

         limpatela

      senao
         // opção 2 do menu: criar plantão
         se opcaoMenu = 2 entao

            limpatela
            cadPlantao <- verdadeiro

            enquanto cadPlantao = verdadeiro faca

               continuarPlan <- falso

               enquanto continuarPlan = falso faca

                  // turno é registrado como "número" na variável
                  escreval("=== ESCOLHER TURNO ===")
                  escreval("1 - Manhã")
                  escreval("2 - Tarde")
                  escreval("3 - Noite")
                  escreva("Escolha uma opção: ")
                  leia(opcaoTurno)

                  // turno é convertido de "número" para texto
                  se opcaoTurno = "1" entao
                     opcaoTurno <- "Manhã"
                     continuarPlan <- verdadeiro
                  senao
                     se opcaoTurno = "2" entao
                        opcaoTurno <- "Tarde"
                        continuarPlan <- verdadeiro
                     senao
                        se opcaoTurno = "3" entao
                           opcaoTurno <- "Noite"
                           continuarPlan <- verdadeiro
                        senao
                           limpatela
                           escreval("ERRO: Opção inválida.")
                           escreval("")
                        fimse
                     fimse
                  fimse

               fimenquanto

               limpatela
               continuarPlan <- falso

               enquanto continuarPlan = falso faca

                  escreval("=== PLANTÃO ===")
                  escreval("Turno selecionado: ", opcaoTurno)
                  escreval("")

                  escreva("Quantidade de Clínicos Gerais: ")
                  leia(qtdClinicos)

                  escreva("Quantidade de Pediatras: ")
                  leia(qtdPediatras)

                  escreva("Quantidade de Cirurgiões: ")
                  leia(qtdCirurgioes)

                  // definição de limites para a quantidade dos médicos
                  limiteMax <- 20
                  minClinicos <- 4
                  minPediatras <- 2
                  minCirurgioes <- 3

                  totalEspec <- qtdClinicos + qtdPediatras + qtdCirurgioes

                  // validação do mínimo de médicos selecionados
                  se (qtdClinicos > 0) e (qtdPediatras > 0) e (qtdCirurgioes > 0) entao

                     se qtdClinicos >= minClinicos entao

                        se qtdPediatras >= minPediatras entao

                           se qtdCirurgioes >= minCirurgioes entao

                              // validação do limite de 20 médicos num plantão
                              se totalEspec <= limiteMax entao
                                 escreval("")
                                 escreval("SUCESSO: Plantão pronto para ser publicado!")
                                 escreval("Pressione Enter para voltar ao menu.")
                                 leia(opcaoCad)
                                 continuarPlan <- verdadeiro
                              senao
                                 limpatela
                                 escreval("ERRO: O plantão excede o limite máximo de 20 médicos.")
                              fimse

                           senao
                              limpatela
                              escreval("ERRO: O plantão exige no mínimo 3 cirurgiões.")
                           fimse

                        senao
                           limpatela
                           escreval("ERRO: O plantão exige no mínimo 2 pediatras.")
                        fimse

                     senao
                        limpatela
                        escreval("ERRO: O plantão exige no mínimo 4 clínicos.")
                     fimse

                  senao
                     limpatela
                     escreval("ERRO: Todas as quantidades devem ser maiores que zero.")
                  fimse

                  se continuarPlan = falso entao
                     escreval("Pressione Enter para tentar novamente.")
                     leia(opcaoCad)
                  fimse

               fimenquanto

               cadPlantao <- falso

            fimenquanto

            limpatela

         senao
            se opcaoMenu <> 3 entao
               limpatela
               escreval("ERRO: Opção inválida.")
               escreval("")
            fimse
         fimse
      fimse

   fimenquanto

   // opção 3 do menu: encerrar programa
   escreval("")
   escreval("Sistema encerrado.")

fimalgoritmo