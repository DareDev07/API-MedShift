algoritmo "Hospital Aurora"

var
   opcaoMenu : inteiro

   cadMedicos : logico
   opcaoCad : inteiro
   opcaoEspecialidade : inteiro

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

   i : inteiro
   duplicado : logico
   turnoInserido : caractere
   nomeInserido : caractere

   // Variáveis adicionadas para os itens 8 e 9
   j : inteiro
   k : inteiro
   idEscolhido : inteiro
   posMedico : inteiro
   especialidadeNecessaria : caractere
   medicoEncontrado : logico
   medicoValido : logico
   duplicadoEscala : logico
   escalaPos : vetor[1..20] de inteiro

inicio
   // inicialização de variáveis com valores definidos
   cadMedicos <- falso
   cadPlantao <- falso
   continuarPlan <- falso
   posicao <- 0
   opcaoMenu <- 0

   // menu inicial, onde o usuário escolhe o que fazer
   enquanto opcaoMenu <> 4 faca

      escreval("=== MedShift - Hospital Aurora ===")
      escreval("1 - Cadastrar médicos")
      escreval("2 - Criar plantão")
      escreval("3 - Consultar médicos cadastrados")
      escreval("4 - Encerrar")
      escreva("Escolha uma opção: ")
      leia(opcaoMenu)

      // opção 1 do menu: cadastrar médicos
      se opcaoMenu = 1 entao

         limpatela
         cadMedicos <- verdadeiro

         enquanto cadMedicos = verdadeiro faca

            // se o limite de médicos não foi atingido, faz:
            se posicao < 20 entao

               escreval("=== CADASTRAR MÉDICO ===")

               escreva("Nome: ")
               leia(nomeInserido)

               escreval("")
               escreval("Disponibilidade: ")
               escreval("1 - Manhã")
               escreval("2 - Tarde")
               escreval("3 - Noite")
               escreva("Escolha uma opção: ")
               leia(opcaoTurno)

               se opcaoTurno = "1" entao
                  turnoInserido <- "Manhã"
               senao
                  se opcaoTurno = "2" entao
                     turnoInserido <- "Tarde"
                  senao
                     se opcaoTurno = "3" entao
                        turnoInserido <- "Noite"
                     senao
                        turnoInserido <- ""
                     fimse
                  fimse
               fimse

               se turnoInserido = "" entao
                  escreval("")
                  escreval("ERRO: Opção inválida.")
               senao
                  // Verificar duplicidade
                  duplicado <- falso

                  se posicao > 0 entao
                     para i de 1 ate posicao faca
                        se medicoNome[i] = nomeInserido entao
                           se medicoDisp[i] = turnoInserido entao
                              duplicado <- verdadeiro
                           fimse
                        fimse
                     fimpara
                  fimse

                  se duplicado = verdadeiro entao

                     escreval("")
                     escreval("ERRO: Este médico já está cadastrado neste turno.")
                     escreval("O cadastro não será repetido.")

                  senao

                     // Cadastrar somente se não houver duplicidade
                     posicao <- posicao + 1
                     medicoNome[posicao] <- nomeInserido
                     medicoDisp[posicao] <- turnoInserido

                     // especialidade é registrada como número
                     escreval("")
                     escreval("Especialidade: ")
                     escreval("1 - Clínico geral")
                     escreval("2 - Pediatra")
                     escreval("3 - Cirurgião")
                     escreva("Escolha uma opção: ")
                     leia(opcaoEspecialidade)

                     // especialidade é convertida de número para texto
                     // o ID é gerado automaticamente
                     se opcaoEspecialidade = 1 entao
                        medicoEspec[posicao] <- "Clínico geral"
                        medicoID[posicao] <- 100 + posicao
                     senao
                        se opcaoEspecialidade = 2 entao
                           medicoEspec[posicao] <- "Pediatra"
                           medicoID[posicao] <- 200 + posicao
                        senao
                           se opcaoEspecialidade = 3 entao
                              medicoEspec[posicao] <- "Cirurgião"
                              medicoID[posicao] <- 300 + posicao
                           senao
                              medicoEspec[posicao] <- "Inválida"
                              medicoID[posicao] <- posicao
                           fimse
                        fimse
                     fimse

                     escreval("")
                     escreval("ID gerado: ", medicoID[posicao])

                  fimse
               fimse

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
                  se qtdClinicos >= minClinicos entao

                     se qtdPediatras >= minPediatras entao
                        se qtdCirurgioes >= minCirurgioes entao

                           // validação do limite de 20 médicos num plantão
                           se totalEspec <= limiteMax entao

                              se posicao = 0 entao
                                 escreval("")
                                 escreval("ERRO: Não há médicos cadastrados para criar o plantão.")
                                 continuarPlan <- verdadeiro
                              senao

                                 medicoValido <- verdadeiro

                                 // Verificar se existem médicos suficientes para cada especialidade e turno
                                 para i de 1 ate totalEspec faca

                                    se i <= qtdClinicos entao
                                       especialidadeNecessaria <- "Clínico geral"
                                    senao
                                       se i <= qtdClinicos + qtdPediatras entao
                                          especialidadeNecessaria <- "Pediatra"
                                       senao
                                          especialidadeNecessaria <- "Cirurgião"
                                       fimse
                                    fimse

                                    medicoValido <- falso

                                    enquanto medicoValido = falso faca

                                       escreval("")
                                       escreval("Especialidade necessária: ", especialidadeNecessaria)
                                       escreval("Turno necessário: ", opcaoTurno)
                                       escreva("Informe o ID do médico: ")
                                       leia(idEscolhido)

                                       posMedico <- 0
                                       medicoEncontrado <- falso

                                       para j de 1 ate posicao faca
                                          se medicoID[j] = idEscolhido entao
                                             posMedico <- j
                                             medicoEncontrado <- verdadeiro
                                          fimse
                                       fimpara

                                       se medicoEncontrado = falso entao
                                          escreval("ERRO: ID de médico não encontrado.")
                                       senao
                                          se medicoEspec[posMedico] <> especialidadeNecessaria entao
                                             escreval("ERRO: A especialidade do médico não corresponde ao plantão.")
                                          senao
                                             se medicoDisp[posMedico] <> opcaoTurno entao
                                                escreval("ERRO: A disponibilidade do médico não corresponde ao turno selecionado.")
                                             senao

                                                duplicadoEscala <- falso

                                                se i > 1 entao
                                                   para k de 1 ate i - 1 faca
                                                      se escalaPos[k] = posMedico entao
                                                         duplicadoEscala <- verdadeiro
                                                      fimse
                                                   fimpara
                                                fimse

                                                se duplicadoEscala = verdadeiro entao
                                                   escreval("ERRO: Este médico já foi selecionado para este plantão.")
                                                senao
                                                   escalaPos[i] <- posMedico
                                                   medicoValido <- verdadeiro
                                                fimse

                                             fimse
                                          fimse
                                       fimse

                                    fimenquanto

                                 fimpara

                                 escreval("")
                                 escreval("SUCESSO: Plantão pronto para ser publicado!")
                                 escreval("")
                                 escreval("=== MÉDICOS SELECIONADOS ===")

                                 para i de 1 ate totalEspec faca
                                    escreval("ID: ", medicoID[escalaPos[i]])
                                    escreval("Nome: ", medicoNome[escalaPos[i]])
                                    escreval("Especialidade: ", medicoEspec[escalaPos[i]])
                                    escreval("Disponibilidade: ", medicoDisp[escalaPos[i]])
                                    escreval("")
                                 fimpara

                                 escreval("Pressione Enter para voltar ao menu.")
                                 leia(opcaoCad)
                                 continuarPlan <- verdadeiro

                              fimse

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

                  se continuarPlan = falso entao
                     escreval("Pressione Enter para tentar novamente.")
                     leia(opcaoCad)
                  fimse

               fimenquanto

               cadPlantao <- falso

            fimenquanto

            limpatela

         senao
            // opção 3 do menu: consultar médicos cadastrados
            se opcaoMenu = 3 entao

               limpatela
               escreval("=== MÉDICOS CADASTRADOS ===")

               se posicao = 0 entao
                  escreval("ERRO: Não há médicos cadastrados para serem apresentados.")
               senao
                  para i de 1 ate posicao faca
                     escreval("")
                     escreval("Identificador: ", medicoID[i])
                     escreval("Nome: ", medicoNome[i])
                     escreval("Especialidade: ", medicoEspec[i])
                     escreval("Disponibilidade: ", medicoDisp[i])
                  fimpara
               fimse

               escreval("")
               escreval("Pressione Enter para voltar ao menu.")
               leia(opcaoCad)
               limpatela

            senao
               se opcaoMenu <> 4 entao
                  limpatela
                  escreval("ERRO: Opção inválida.")
                  escreval("")
               fimse
            fimse
         fimse
      fimse

   fimenquanto

   // opção 4 do menu: encerrar programa
   escreval("")
   escreval("Sistema encerrado.")

fimalgoritmo