algoritmo "Hospital Aurora"

var
   opcaoMenu : inteiro

   cadMedicos : logico
   opcaoCad : inteiro
   opcaoEspecialidade : inteiro
   especValida : logico

   posicao : inteiro
   qtdMedicos : inteiro
   medicoNome : vetor[1..60] de caractere
   medicoEspec : vetor[1..60] de caractere
   medicoDisp : vetor[1..60] de caractere
   medicoID : vetor[1..60] de inteiro

   cadPlantao : logico
   continuarPlan : logico

   opcaoTurno : caractere
   teclaEnter : caractere

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
   qtdTurnosMedico : inteiro
   posPrimeiro : inteiro
   turnoInserido : caractere
   nomeInserido : caractere

   j : inteiro
   k : inteiro
   idEscolhido : inteiro
   posMedico : inteiro
   especialidadeNecessaria : caractere
   medicoEncontrado : logico
   medicoValido : logico
   duplicadoEscala : logico
   escalaPos : vetor[1..20] de inteiro

   // Variáveis da verificação de cobertura
   nomeTurno : vetor[1..3] de caractere
   nomeEsp : vetor[1..3] de caractere
   minEsp : vetor[1..3] de inteiro
   // posições 1-3 = Manhã, 4-6 = Tarde, 7-9 = Noite
   // dentro de cada turno: 1 = clínico, 2 = pediatra, 3 = cirurgião
   // índice = (turno - 1) * 3 + especialidade
   cobertura : vetor[1..9] de inteiro
   turnoInsuf : vetor[1..3] de logico
   espInsuf : vetor[1..3] de logico
   coberturaCompleta : logico
   iTurno : inteiro
   iEsp : inteiro
   idxTurno : inteiro
   faltam : inteiro
   faltaMedico : logico

   //dados dos plantoes concluidos para o resumo diario
   totalPlantoesResumo : inteiro
   totalAlocacoesResumo : inteiro
   turnoPlantaoResumo : vetor[1..300] de caractere
   medicoAlocadoResumo : vetor[1..6000] de inteiro
   turnoAlocadoResumo : vetor[1..6000] de caractere
   resumoTurno : inteiro
   resumoPlantoesTurno : inteiro
   resumoMedicosTurno : inteiro

inicio
   // inicialização de variáveis com valores definidos
   cadMedicos <- falso
   cadPlantao <- falso
   continuarPlan <- falso
   posicao <- 0
   qtdMedicos <- 0
   opcaoMenu <- 0

   //inicializar os registros do resumo diario
   totalPlantoesResumo <- 0
   totalAlocacoesResumo <- 0

   nomeTurno[1] <- "Manhã"
   nomeTurno[2] <- "Tarde"
   nomeTurno[3] <- "Noite"

   nomeEsp[1] <- "Clínico geral"
   nomeEsp[2] <- "Pediatra"
   nomeEsp[3] <- "Cirurgião"

   // definição de limites (usados no plantão e na cobertura)
   limiteMax <- 20
   minClinicos <- 4
   minPediatras <- 2
   minCirurgioes <- 3

   minEsp[1] <- minClinicos
   minEsp[2] <- minPediatras
   minEsp[3] <- minCirurgioes

   // menu inicial, onde o usuário escolhe o que fazer
   enquanto opcaoMenu <> 6 faca

      escreval("=== MedShift - Hospital Aurora ===")
      escreval("1 - Cadastrar médicos")
      escreval("2 - Criar plantão")
      escreval("3 - Consultar médicos cadastrados")
      escreval("4 - Verificar cobertura mínima")
      escreval("5 - Resumo diario dos plantoes")
      escreval("6 - Encerrar")
      escreva("Escolha uma opção: ")
      leia(opcaoMenu)

      // atualiza a contagem de médicos por turno e especialidade
      // índice da cobertura = (turno - 1) * 3 + especialidade
      para iTurno de 1 ate 3 faca
         para iEsp de 1 ate 3 faca
            cobertura[(iTurno - 1) * 3 + iEsp] <- 0
         fimpara
      fimpara

      se posicao > 0 entao
         para i de 1 ate posicao faca
            para iTurno de 1 ate 3 faca
               se medicoDisp[i] = nomeTurno[iTurno] entao
                  para iEsp de 1 ate 3 faca
                     se medicoEspec[i] = nomeEsp[iEsp] entao
                        cobertura[(iTurno - 1) * 3 + iEsp] <- cobertura[(iTurno - 1) * 3 + iEsp] + 1
                     fimse
                  fimpara
               fimse
            fimpara
         fimpara
      fimse

      // ------------------------------------------------------------
      // opção 1: cadastrar médicos
      // ------------------------------------------------------------
      se opcaoMenu = 1 entao

         limpatela
         cadMedicos <- verdadeiro

         enquanto cadMedicos = verdadeiro faca

            se posicao < 60 entao

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
                  // verifica duplicidade e conta turnos já cadastrados do médico
                  duplicado <- falso
                  qtdTurnosMedico <- 0
                  posPrimeiro <- 0

                  se posicao > 0 entao
                     para i de 1 ate posicao faca
                        se medicoNome[i] = nomeInserido entao
                           qtdTurnosMedico <- qtdTurnosMedico + 1

                           se posPrimeiro = 0 entao
                              posPrimeiro <- i
                           fimse

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

                     // cada médico pode ser alocado em no máximo 2 turnos
                     se qtdTurnosMedico >= 2 entao
                        escreval("")
                        escreval("ERRO: Este médico já está cadastrado em 2 turnos.")
                        escreval("Não é permitido cadastrar um terceiro turno para o mesmo médico.")
                     senao

                        se posPrimeiro > 0 entao
                           // mesmo médico em outro turno: mantém a especialidade
                           escreval("")
                           escreval("Médico já cadastrado como ", medicoEspec[posPrimeiro], ".")
                           escreval("A especialidade será mantida.")
                           para i de 1 ate 3 faca
                              se nomeEsp[i] = medicoEspec[posPrimeiro] entao
                                 opcaoEspecialidade <- i
                              fimse
                           fimpara
                        senao
                           // médico novo: valida a especialidade antes de cadastrar
                           especValida <- falso
                           enquanto especValida = falso faca
                              escreval("")
                              escreval("Especialidade: ")
                              escreval("1 - Clínico geral")
                              escreval("2 - Pediatra")
                              escreval("3 - Cirurgião")
                              escreva("Escolha uma opção: ")
                              leia(opcaoEspecialidade)

                              se opcaoEspecialidade < 1 entao
                                 escreval("ERRO: Opção inválida.")
                              senao
                                 se opcaoEspecialidade > 3 entao
                                    escreval("ERRO: Opção inválida.")
                                 senao
                                    especValida <- verdadeiro
                                 fimse
                              fimse
                           fimenquanto
                        fimse

                        // só grava depois de tudo validado
                        posicao <- posicao + 1
                        medicoNome[posicao] <- nomeInserido
                        medicoDisp[posicao] <- turnoInserido
                        medicoEspec[posicao] <- nomeEsp[opcaoEspecialidade]
                        // um ID por médico: 1xx clínico, 2xx pediatra, 3xx cirurgião
                        se posPrimeiro > 0 entao
                           // médico já conhecido: reaproveita o ID
                           medicoID[posicao] <- medicoID[posPrimeiro]
                           escreval("")
                           escreval("ID do médico (mantido): ", medicoID[posicao])
                        senao
                           // médico novo: gera um ID novo
                           qtdMedicos <- qtdMedicos + 1
                           medicoID[posicao] <- opcaoEspecialidade * 100 + qtdMedicos
                           escreval("")
                           escreval("ID gerado: ", medicoID[posicao])
                        fimse

                     fimse
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
                     leia(teclaEnter)
                     cadMedicos <- falso
                  fimse
               fimse

            senao
               escreval("Limite de 60 cadastros atingido.")
               escreval("")
               escreval("Pressione Enter para voltar ao menu.")
               leia(teclaEnter)
               cadMedicos <- falso
            fimse

         fimenquanto

         limpatela

      fimse

      // ------------------------------------------------------------
      // opção 2: criar plantão
      // ------------------------------------------------------------
      se opcaoMenu = 2 entao

         limpatela
         cadPlantao <- verdadeiro

         enquanto cadPlantao = verdadeiro faca

            continuarPlan <- falso

            enquanto continuarPlan = falso faca

               escreval("=== ESCOLHER TURNO ===")
               escreval("1 - Manhã")
               escreval("2 - Tarde")
               escreval("3 - Noite")
               escreva("Escolha uma opção: ")
               leia(opcaoTurno)

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

            // descobre o índice do turno escolhido (1 a 3)
            para iTurno de 1 ate 3 faca
               se nomeTurno[iTurno] = opcaoTurno entao
                  idxTurno <- iTurno
               fimse
            fimpara

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

               totalEspec <- qtdClinicos + qtdPediatras + qtdCirurgioes

               // validação do mínimo de médicos selecionados
               se qtdClinicos >= minClinicos entao

                  se qtdPediatras >= minPediatras entao
                     se qtdCirurgioes >= minCirurgioes entao

                        // validação do limite de 20 médicos num plantão
                        se totalEspec <= limiteMax entao

                           // confere se há médicos cadastrados suficientes no turno

                           faltaMedico <- falso

                           se cobertura[(idxTurno - 1) * 3 + 1] < qtdClinicos entao
                              faltaMedico <- verdadeiro
                           fimse
                           se cobertura[(idxTurno - 1) * 3 + 2] < qtdPediatras entao
                              faltaMedico <- verdadeiro
                           fimse
                           se cobertura[(idxTurno - 1) * 3 + 3] < qtdCirurgioes entao
                              faltaMedico <- verdadeiro
                           fimse

                           se faltaMedico = verdadeiro entao

                              limpatela
                              escreval("ERRO: Não há médicos cadastrados suficientes no turno ", opcaoTurno, ".")
                              escreval("Clínicos gerais: ", cobertura[(idxTurno - 1) * 3 + 1], " cadastrados / ", qtdClinicos, " solicitados")
                              escreval("Pediatras: ", cobertura[(idxTurno - 1) * 3 + 2], " cadastrados / ", qtdPediatras, " solicitados")
                              escreval("Cirurgiões: ", cobertura[(idxTurno - 1) * 3 + 3], " cadastrados / ", qtdCirurgioes, " solicitados")
                              escreval("")
                              escreval("Pressione Enter para voltar ao menu.")
                              leia(teclaEnter)
                              continuarPlan <- verdadeiro

                           senao

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

                                    // o mesmo ID pode aparecer em 2 linhas (2 turnos):
                                    // dá preferência à linha do turno escolhido
                                    para j de 1 ate posicao faca
                                       se medicoID[j] = idEscolhido entao
                                          medicoEncontrado <- verdadeiro
                                          se posMedico = 0 entao
                                             posMedico <- j
                                          senao
                                             se medicoDisp[j] = opcaoTurno entao
                                                posMedico <- j
                                             fimse
                                          fimse
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

                               // NOVO: registrar somente um plantao validado e concluido
                               se (totalPlantoesResumo < 300) e (totalAlocacoesResumo + totalEspec <= 6000) entao
                                  totalPlantoesResumo <- totalPlantoesResumo + 1
                                  turnoPlantaoResumo[totalPlantoesResumo] <- opcaoTurno
                                  para i de 1 ate totalEspec faca
                                     totalAlocacoesResumo <- totalAlocacoesResumo + 1
                                     medicoAlocadoResumo[totalAlocacoesResumo] <- escalaPos[i]
                                     turnoAlocadoResumo[totalAlocacoesResumo] <- opcaoTurno
                                  fimpara
                               senao
                                  escreval("AVISO: Limite do historico do resumo atingido.")
                               fimse
                               // FIM NOVO: registro do plantao

                              escreval("Pressione Enter para voltar ao menu.")
                              leia(teclaEnter)
                              continuarPlan <- verdadeiro

                           fimse

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
                  leia(teclaEnter)
               fimse

            fimenquanto

            cadPlantao <- falso

         fimenquanto

         limpatela

      fimse

      // ------------------------------------------------------------
      // opção 3: consultar médicos cadastrados
      // ------------------------------------------------------------
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
         leia(teclaEnter)
         limpatela

      fimse

      // ------------------------------------------------------------
      // opção 4: verificar cobertura mínima
      // ------------------------------------------------------------
      se opcaoMenu = 4 entao

         limpatela
         coberturaCompleta <- verdadeiro

         para iTurno de 1 ate 3 faca
            turnoInsuf[iTurno] <- falso
            espInsuf[iTurno] <- falso
         fimpara

         escreval("=== COBERTURA MÍNIMA POR TURNO ===")
         escreval("Mínimo por turno -> ", nomeEsp[1], ": ", minEsp[1], " | ", nomeEsp[2], ": ", minEsp[2], " | ", nomeEsp[3], ": ", minEsp[3])
         escreval("")

         para iTurno de 1 ate 3 faca
            escreval("Turno: ", nomeTurno[iTurno])

            para iEsp de 1 ate 3 faca
               se cobertura[(iTurno - 1) * 3 + iEsp] >= minEsp[iEsp] entao
                  escreval("   ", nomeEsp[iEsp], ": ", cobertura[(iTurno - 1) * 3 + iEsp], "/", minEsp[iEsp], " - OK")
               senao
                  faltam <- minEsp[iEsp] - cobertura[(iTurno - 1) * 3 + iEsp]
                  escreval("   ", nomeEsp[iEsp], ": ", cobertura[(iTurno - 1) * 3 + iEsp], "/", minEsp[iEsp], " - INSUFICIENTE (faltam ", faltam, ")")
                  turnoInsuf[iTurno] <- verdadeiro
                  espInsuf[iEsp] <- verdadeiro
                  coberturaCompleta <- falso
               fimse
            fimpara

            escreval("")
         fimpara

         escreval("=== RESULTADO DA ANÁLISE ===")

         se coberturaCompleta = verdadeiro entao
            escreval("COBERTURA COMPLETA: todos os turnos atendem o mínimo de todas as especialidades.")
         senao
            escreval("COBERTURA INCOMPLETA.")

            escreval("Turnos insuficientes:")
            para iTurno de 1 ate 3 faca
               se turnoInsuf[iTurno] = verdadeiro entao
                  escreval("   - ", nomeTurno[iTurno])
               fimse
            fimpara

            escreval("Especialidades insuficientes:")
            para iEsp de 1 ate 3 faca
               se espInsuf[iEsp] = verdadeiro entao
                  escreval("   - ", nomeEsp[iEsp])
               fimse
            fimpara
         fimse

         escreval("")
         escreval("Pressione Enter para voltar ao menu.")
         leia(teclaEnter)
         limpatela

      fimse

      //opcao 5 - resumo diario dos plantoes concluidos
      se opcaoMenu = 5 entao
         limpatela
         escreval("=== RESUMO DIARIO DOS PLANTOES ===")

         se totalPlantoesResumo = 0 entao
            escreval("Nenhum plantao concluido para apresentar no resumo.")
         senao
            para resumoTurno de 1 ate 3 faca
               resumoPlantoesTurno <- 0
               resumoMedicosTurno <- 0
               escreval("")
               escreval("=== TURNO: ", nomeTurno[resumoTurno], " ===")

               //contar os plantoes deste turno
               para j de 1 ate totalPlantoesResumo faca
                  se turnoPlantaoResumo[j] = nomeTurno[resumoTurno] entao
                     resumoPlantoesTurno <- resumoPlantoesTurno + 1
                  fimse
               fimpara

               //mostrar os medicos escalados neste turno
               para j de 1 ate totalAlocacoesResumo faca
                  se turnoAlocadoResumo[j] = nomeTurno[resumoTurno] entao
                     resumoMedicosTurno <- resumoMedicosTurno + 1
                     escreval("ID: ", medicoID[medicoAlocadoResumo[j]])
                     escreval("Nome: ", medicoNome[medicoAlocadoResumo[j]])
                     escreval("Especialidade: ", medicoEspec[medicoAlocadoResumo[j]])
                     escreval("")
                  fimse
               fimpara

               escreval("Plantoes concluidos: ", resumoPlantoesTurno)
               escreval("Alocacoes de medicos: ", resumoMedicosTurno)
            fimpara

            escreval("")
            escreval("TOTAL DE PLANTOES: ", totalPlantoesResumo)
            escreval("TOTAL DE ALOCACOES: ", totalAlocacoesResumo)
         fimse

         escreval("")
         escreval("Pressione Enter para voltar ao menu.")
         leia(teclaEnter)
         limpatela
      fimse
      // FIM NOVO: resumo diario

      // opção inválida do menu
      se opcaoMenu < 1 entao
         limpatela
         escreval("ERRO: Opção inválida.")
         escreval("")
      fimse

      se opcaoMenu > 6 entao
         limpatela
         escreval("ERRO: Opção inválida.")
         escreval("")
      fimse

   fimenquanto

   // opção 6 do menu: encerrar programa
   escreval("")
   escreval("Sistema encerrado.")

fimalgoritmo
