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

   // Controle para pausar e retomar o plantão em andamento
   plantaoPendente : logico
   pausarPlantao : logico
   qtdSalva : inteiro
   inicioSelecao : inteiro
   opcaoRetomar : inteiro
   turnoSalvo : caractere
   clinicosSalvo : inteiro
   pediatrasSalvo : inteiro
   cirurgioesSalvo : inteiro

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

   // Dados dos plantões concluídos para o resumo diário
   totalPlantoesResumo : inteiro
   totalAlocacoesResumo : inteiro
   turnoPlantaoResumo : vetor[1..300] de caractere
   medicoAlocadoResumo : vetor[1..6000] de inteiro
   turnoAlocadoResumo : vetor[1..6000] de caractere
   resumoTurno : inteiro
   resumoPlantoesTurno : inteiro
   resumoMedicosTurno : inteiro

   // Tarefas 17 e 18: escala semanal
   nomeDia : vetor[1..5] de caractere
   // 15 turnos x postosPorTurno = 60 postos
   // índice do turno = (dia - 1) * 3 + turno
   // índice do posto = (índice do turno - 1) * postosPorTurno + posto
   escalaSemana : vetor[1..60] de inteiro
   postosPorTurno : inteiro
   limiteSemanal : inteiro
   opcaoSemana : inteiro
   semanaAtiva : logico
   diaEscolhido : inteiro
   turnoEscolhido : inteiro
   idxSemana : inteiro
   idxOutro : inteiro
   postoLivre : inteiro
   p : inteiro
   s : inteiro
   qtdPlantoesMedico : inteiro
   regraOk : logico

   // Tarefas 19 e 20: cobertura da escala semanal
   qtdEscalaEsp : vetor[1..3] de inteiro
   falhasEsp : vetor[1..3] de inteiro
   totalFalhas : inteiro
   falhaTurno : logico

   // ------------------------------------------------------------
   // FUNÇÃO: IDENTIFICAR MÉDICO PELO ID
   // Retorna a posição do médico no vetor.
   // Se o ID não existir, retorna 0.
   // Se houver mais de uma ocorrência do ID,
   // dá preferência à posição do turno escolhido.
   // ------------------------------------------------------------

funcao identificarMedico(idBusca: inteiro; turnoBusca: caractere): inteiro
var
   jBusca : inteiro
   posBusca : inteiro
inicio
   posBusca <- 0

   para jBusca de 1 ate posicao faca
      se medicoID[jBusca] = idBusca entao

         se posBusca = 0 entao
            posBusca <- jBusca
         fimse

         se medicoDisp[jBusca] = turnoBusca entao
            posBusca <- jBusca
         fimse

      fimse
   fimpara

   retorne posBusca
fimfuncao

// Tarefa 23 : Verificar percentual de turnos cobertos por dias da semana
turnosCobertos : inteiro
percentCobertura : real

inicio
   // Inicialização de variáveis com valores definidos
   cadMedicos <- falso
   cadPlantao <- falso
   continuarPlan <- falso
   plantaoPendente <- falso
   qtdSalva <- 0
   posicao <- 0
   qtdMedicos <- 0
   opcaoMenu <- 0

   // Inicializar os registros do resumo diário
   totalPlantoesResumo <- 0
   totalAlocacoesResumo <- 0

   nomeTurno[1] <- "Manhã"
   nomeTurno[2] <- "Tarde"
   nomeTurno[3] <- "Noite"

   nomeEsp[1] <- "Clínico geral"
   nomeEsp[2] <- "Pediatra"
   nomeEsp[3] <- "Cirurgião"

   // Definição de limites
   limiteMax <- 20
   minClinicos <- 4
   minPediatras <- 2
   minCirurgioes <- 3

   minEsp[1] <- minClinicos
   minEsp[2] <- minPediatras
   minEsp[3] <- minCirurgioes

   // Tarefas 17 e 18
   nomeDia[1] <- "Segunda"
   nomeDia[2] <- "Terça"
   nomeDia[3] <- "Quarta"
   nomeDia[4] <- "Quinta"
   nomeDia[5] <- "Sexta"
   postosPorTurno <- 4
   limiteSemanal <- 5

   para s de 1 ate 60 faca
      escalaSemana[s] <- 0
   fimpara

   // menu inicial, onde o usuário escolhe o que fazer
   enquanto opcaoMenu <> 7 faca

      escreval("=== MedShift - Hospital Aurora ===")
      escreval("1 - Cadastrar médicos")
      escreval("2 - Criar plantão")
      escreval("3 - Consultar médicos cadastrados")
      escreval("4 - Verificar cobertura mínima")
      escreval("5 - Resumo diario dos plantoes")
      escreval("6 - Escala semanal")
      escreval("7 - Encerrar")
      escreva("Escolha uma opção: ")
      leia(opcaoMenu)

      // Atualiza a contagem de médicos por turno e especialidade
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
      // OPÇÃO 1: CADASTRAR MÉDICOS
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

                     se qtdTurnosMedico >= 2 entao
                        escreval("")
                        escreval("ERRO: Este médico já está cadastrado em 2 turnos.")
                        escreval("Não é permitido cadastrar um terceiro turno para o mesmo médico.")
                     senao

                        se posPrimeiro > 0 entao
                           escreval("")
                           escreval("Médico já cadastrado como ", medicoEspec[posPrimeiro], ".")
                           escreval("A especialidade será mantida.")
                           para i de 1 ate 3 faca
                              se nomeEsp[i] = medicoEspec[posPrimeiro] entao
                                 opcaoEspecialidade <- i
                              fimse
                           fimpara
                        senao
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

                        posicao <- posicao + 1
                        medicoNome[posicao] <- nomeInserido
                        medicoDisp[posicao] <- turnoInserido
                        medicoEspec[posicao] <- nomeEsp[opcaoEspecialidade]

                        se posPrimeiro > 0 entao
                           medicoID[posicao] <- medicoID[posPrimeiro]
                           escreval("")
                           escreval("ID do médico (mantido): ", medicoID[posicao])
                        senao
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
      // OPÇÃO 2: CRIAR PLANTÃO
      // ------------------------------------------------------------
      se opcaoMenu = 2 entao

         limpatela
         cadPlantao <- verdadeiro
         pausarPlantao <- falso
         opcaoRetomar <- 2

         // Verifica se existe um plantão pausado anteriormente
         se plantaoPendente = verdadeiro entao
            opcaoRetomar <- 0
            enquanto (opcaoRetomar <> 1) e (opcaoRetomar <> 2) faca
               escreval("=== PLANTÃO EM ANDAMENTO ===")
               escreval("Turno: ", turnoSalvo, " | Médicos já selecionados: ", qtdSalva)
               escreval("1 - Continuar de onde parou")
               escreval("2 - Descartar e iniciar novo")
               escreva("Escolha uma opção: ")
               leia(opcaoRetomar)

               se (opcaoRetomar <> 1) e (opcaoRetomar <> 2) entao
                  limpatela
                  escreval("ERRO: Opção inválida.")
                  escreval("")
               fimse
            fimenquanto

            se opcaoRetomar = 2 entao
               plantaoPendente <- falso
               qtdSalva <- 0
            fimse
            limpatela
         fimse

         enquanto cadPlantao = verdadeiro faca

            se opcaoRetomar = 1 entao
               // Restaura os dados salvos do plantão pausado
               opcaoTurno <- turnoSalvo
               qtdClinicos <- clinicosSalvo
               qtdPediatras <- pediatrasSalvo
               qtdCirurgioes <- cirurgioesSalvo
               totalEspec <- qtdClinicos + qtdPediatras + qtdCirurgioes
               inicioSelecao <- qtdSalva + 1

               para iTurno de 1 ate 3 faca
                  se nomeTurno[iTurno] = opcaoTurno entao
                     idxTurno <- iTurno
                  fimse
               fimpara

               continuarPlan <- falso

               enquanto continuarPlan = falso faca

                  escreval("=== RETOMANDO PLANTÃO ===")
                  escreval("Turno: ", opcaoTurno, " | Já selecionados: ", qtdSalva, " de ", totalEspec)

                  para i de inicioSelecao ate totalEspec faca

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
                        escreval("(Digite 0 para pausar e voltar ao menu)")
                        escreva("Informe o ID do médico: ")
                        leia(idEscolhido)

                        se idEscolhido = 0 entao
                           pausarPlantao <- verdadeiro
                           plantaoPendente <- verdadeiro
                           qtdSalva <- i - 1
                           turnoSalvo <- opcaoTurno
                           clinicosSalvo <- qtdClinicos
                           pediatrasSalvo <- qtdPediatras
                           cirurgioesSalvo <- qtdCirurgioes
                           medicoValido <- verdadeiro
                        senao
                           posMedico <- identificarMedico(idEscolhido, opcaoTurno)
                           medicoEncontrado <- posMedico <> 0

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
                        fimse

                     fimenquanto

                     se pausarPlantao = verdadeiro entao
                        i <- totalEspec
                     fimse

                  fimpara

                  se pausarPlantao = verdadeiro entao
                     escreval("")
                     escreval("Plantão pausado! ", qtdSalva, " médico(s) mantido(s) em rascunho.")
                     escreval("Pressione Enter para voltar ao menu.")
                     leia(teclaEnter)
                     continuarPlan <- verdadeiro
                  senao
                     plantaoPendente <- falso
                     qtdSalva <- 0

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

                     escreval("Pressione Enter para voltar ao menu.")
                     leia(teclaEnter)
                     continuarPlan <- verdadeiro
                  fimse

               fimenquanto

            senao

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

                  se qtdClinicos >= minClinicos entao

                     se qtdPediatras >= minPediatras entao
                        se qtdCirurgioes >= minCirurgioes entao

                           se totalEspec <= limiteMax entao

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
                                       escreval("(Digite 0 para pausar e voltar ao menu)")
                                       escreva("Informe o ID do médico: ")
                                       leia(idEscolhido)

                                       se idEscolhido = 0 entao
                                          pausarPlantao <- verdadeiro
                                          plantaoPendente <- verdadeiro
                                          qtdSalva <- i - 1
                                          turnoSalvo <- opcaoTurno
                                          clinicosSalvo <- qtdClinicos
                                          pediatrasSalvo <- qtdPediatras
                                          cirurgioesSalvo <- qtdCirurgioes
                                          medicoValido <- verdadeiro
                                       senao
                                          posMedico <- identificarMedico(idEscolhido, opcaoTurno)
                                          medicoEncontrado <- posMedico <> 0

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
                                       fimse

                                    fimenquanto

                                    se pausarPlantao = verdadeiro entao
                                       i <- totalEspec
                                    fimse

                                 fimpara

                                 se pausarPlantao = verdadeiro entao
                                    escreval("")
                                    escreval("Plantão pausado! ", qtdSalva, " médico(s) mantido(s) em rascunho.")
                                    escreval("Pressione Enter para voltar ao menu.")
                                    leia(teclaEnter)
                                    continuarPlan <- verdadeiro
                                 senao
                                    plantaoPendente <- falso
                                    qtdSalva <- 0

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

                                    escreval("Pressione Enter para voltar ao menu.")
                                    leia(teclaEnter)
                                    continuarPlan <- verdadeiro
                                 fimse

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

            fimse

            cadPlantao <- falso

         fimenquanto

         limpatela

      fimse

      // ------------------------------------------------------------
      // OPÇÃO 3: CONSULTAR MÉDICOS CADASTRADOS
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
      // OPÇÃO 4: VERIFICAR COBERTURA MÍNIMA
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

      // ------------------------------------------------------------
      // OPÇÃO 5: RESUMO DIÁRIO DOS PLANTÕES
      // ------------------------------------------------------------
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

               para j de 1 ate totalPlantoesResumo faca
                  se turnoPlantaoResumo[j] = nomeTurno[resumoTurno] entao
                     resumoPlantoesTurno <- resumoPlantoesTurno + 1
                  fimse
               fimpara

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

      // ------------------------------------------------------------
      // opção 6: escala semanal (tarefas 17 e 18)
      // ------------------------------------------------------------
      se opcaoMenu = 6 entao
         limpatela
         semanaAtiva <- verdadeiro

         enquanto semanaAtiva = verdadeiro faca

            escreval("=== ESCALA SEMANAL ===")
            escreval("1 - Visualizar escala semanal")
            escreval("2 - Alocar médico em um turno")
            escreval("3 - Voltar ao menu")
            escreval("4 - Visualizar cobertura semanal")
            escreval("5 - Diagnóstico de falhas na cobertura")
            escreva("Escolha uma opção: ")
            leia(opcaoSemana)
            limpatela

            // TAREFA 17: VISUALIZAR A SEMANA COMPLETA
            se opcaoSemana = 1 entao

               escreval("=== ESCALA DA SEMANA (SEG A SEX) ===")

               para diaEscolhido de 1 ate 5 faca
                  escreval("")
                  escreval("##### ", nomeDia[diaEscolhido], " #####")

                  para turnoEscolhido de 1 ate 3 faca
                     idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido
                     escreval("--- Turno: ", nomeTurno[turnoEscolhido], " ---")

                     para p de 1 ate postosPorTurno faca
                        s <- (idxSemana - 1) * postosPorTurno + p
                        se escalaSemana[s] = 0 entao
                           escreval("   Posto ", p, ": VAGO")
                        senao
                           escreval("   Posto ", p, ": ID ", medicoID[escalaSemana[s]], " - ", medicoNome[escalaSemana[s]], " (", medicoEspec[escalaSemana[s]], ")")
                        fimse
                     fimpara
                  fimpara
               fimpara

               escreval("")
               escreval("Pressione Enter para voltar.")
               leia(teclaEnter)
               limpatela

            fimse

            // TAREFA 18: ALOCAR MÉDICO
            se opcaoSemana = 2 entao

               escreval("=== ALOCAR MÉDICO NA ESCALA ===")

               diaEscolhido <- 0
               enquanto (diaEscolhido < 1) ou (diaEscolhido > 5) faca
                  escreval("Dia: 1-Segunda | 2-Terça | 3-Quarta | 4-Quinta | 5-Sexta")
                  escreva("Escolha o dia: ")
                  leia(diaEscolhido)
                  se (diaEscolhido < 1) ou (diaEscolhido > 5) entao
                     escreval("ERRO: Opção inválida.")
                  fimse
               fimenquanto

               turnoEscolhido <- 0
               enquanto (turnoEscolhido < 1) ou (turnoEscolhido > 3) faca
                  escreval("Turno: 1-Manhã | 2-Tarde | 3-Noite")
                  escreva("Escolha o turno: ")
                  leia(turnoEscolhido)
                  se (turnoEscolhido < 1) ou (turnoEscolhido > 3) entao
                     escreval("ERRO: Opção inválida.")
                  fimse
               fimenquanto

               idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido

               postoLivre <- 0
               para p de 1 ate postosPorTurno faca
                  se postoLivre = 0 entao
                     se escalaSemana[(idxSemana - 1) * postosPorTurno + p] = 0 entao
                        postoLivre <- p
                     fimse
                  fimse
               fimpara

               se postoLivre = 0 entao
                  escreval("")
                  escreval("ERRO: Todos os postos de ", nomeDia[diaEscolhido], " - ", nomeTurno[turnoEscolhido], " já estão ocupados.")
               senao

                  escreval("")
                  escreval("Alocando em: ", nomeDia[diaEscolhido], " - ", nomeTurno[turnoEscolhido])
                  escreva("Informe o ID do médico: ")
                  leia(idEscolhido)

                  regraOk <- verdadeiro

                  posMedico <- identificarMedico(idEscolhido, nomeTurno[turnoEscolhido])
                  medicoEncontrado <- posMedico <> 0

                  se medicoEncontrado = falso entao
                     escreval("ERRO: ID de médico não encontrado.")
                     regraOk <- falso
                  fimse

                  se regraOk = verdadeiro entao
                     se medicoDisp[posMedico] <> nomeTurno[turnoEscolhido] entao
                        escreval("ERRO: A disponibilidade do médico não corresponde ao turno selecionado.")
                        regraOk <- falso
                     fimse
                  fimse

                  // Mesmo médico não pode repetir no mesmo turno
                  se regraOk = verdadeiro entao
                     para p de 1 ate postosPorTurno faca
                        s <- (idxSemana - 1) * postosPorTurno + p
                        se escalaSemana[s] > 0 entao
                           se medicoID[escalaSemana[s]] = idEscolhido entao
                              regraOk <- falso
                           fimse
                        fimse
                     fimpara
                     se regraOk = falso entao
                        escreval("ERRO: Este médico já foi alocado neste turno.")
                     fimse
                  fimse

                  // R8: limite semanal de plantões por médico
                  se regraOk = verdadeiro entao
                     qtdPlantoesMedico <- 0
                     para s de 1 ate 15 * postosPorTurno faca
                        se escalaSemana[s] > 0 entao
                           se medicoID[escalaSemana[s]] = idEscolhido entao
                              qtdPlantoesMedico <- qtdPlantoesMedico + 1
                           fimse
                        fimse
                     fimpara
                     se qtdPlantoesMedico >= limiteSemanal entao
                        escreval("ERRO: Este médico já atingiu o limite de ", limiteSemanal, " plantões na semana.")
                        regraOk <- falso
                     fimse
                  fimse

                  // R9: sem manhã logo após plantão noturno
                  se regraOk = verdadeiro entao
                     idxOutro <- 0
                     se (turnoEscolhido = 1) e (diaEscolhido > 1) entao
                        idxOutro <- (diaEscolhido - 2) * 3 + 3
                     fimse
                     se (turnoEscolhido = 3) e (diaEscolhido < 5) entao
                        idxOutro <- diaEscolhido * 3 + 1
                     fimse

                     se idxOutro > 0 entao
                        para p de 1 ate postosPorTurno faca
                           s <- (idxOutro - 1) * postosPorTurno + p
                           se escalaSemana[s] > 0 entao
                              se medicoID[escalaSemana[s]] = idEscolhido entao
                                 regraOk <- falso
                              fimse
                           fimse
                        fimpara
                        se regraOk = falso entao
                           escreval("ERRO: Não é permitido escalar o médico na manhã seguinte a um plantão noturno.")
                        fimse
                     fimse
                  fimse

                  // Grava a alocação após validar
                  se regraOk = verdadeiro entao
                     escalaSemana[(idxSemana - 1) * postosPorTurno + postoLivre] <- posMedico
                     escreval("")
                     escreval("SUCESSO: ", medicoNome[posMedico], " alocado(a) em ", nomeDia[diaEscolhido], " - ", nomeTurno[turnoEscolhido], ", posto ", postoLivre, ".")
                  fimse

               fimse

               escreval("")
               escreval("Pressione Enter para voltar.")
               leia(teclaEnter)
               limpatela

            fimse

            // ------------------------------------------------------------
            // TAREFA 19: VISUALIZAR COBERTURA SEMANAL
            // ------------------------------------------------------------
            se opcaoSemana = 4 entao

               limpatela
               escreval("=== COBERTURA SEMANAL ===")
               escreval("Mínimos: Clínicos: ", minClinicos, " | Pediatras: ", minPediatras, " | Cirurgiões: ", minCirurgioes)

               para diaEscolhido de 1 ate 5 faca

                  escreval("")
                  escreval("##### ", nomeDia[diaEscolhido], " #####")

                  para turnoEscolhido de 1 ate 3 faca

                     idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido

                     para iEsp de 1 ate 3 faca
                        qtdEscalaEsp[iEsp] <- 0
                     fimpara

                     escreval("")
                     escreval("--- ", nomeTurno[turnoEscolhido], " ---")

                     // Exibe médicos e conta cada especialidade
                     para p de 1 ate postosPorTurno faca

                        s <- (idxSemana - 1) * postosPorTurno + p

                        se escalaSemana[s] = 0 entao
                           escreval("Posto ", p, ": VAGO")
                        senao

                           escreval("Posto ", p, ": ", medicoNome[escalaSemana[s]], " - ", medicoEspec[escalaSemana[s]])

                           para iEsp de 1 ate 3 faca
                              se medicoEspec[escalaSemana[s]] = nomeEsp[iEsp] entao
                                 qtdEscalaEsp[iEsp] <- qtdEscalaEsp[iEsp] + 1
                              fimse
                           fimpara

                        fimse

                     fimpara

                     escreval("")
                     escreval("Cobertura por especialidade:")

                     para iEsp de 1 ate 3 faca

                        se qtdEscalaEsp[iEsp] >= minEsp[iEsp] entao

                           escreval(nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - OK")

                        senao

                           faltam <- minEsp[iEsp] - qtdEscalaEsp[iEsp]

                           escreval(nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - INSUFICIENTE (faltam ", faltam, ")")

                        fimse

                     fimpara

                     falhaTurno <- falso

                     para iEsp de 1 ate 3 faca
                        se qtdEscalaEsp[iEsp] < minEsp[iEsp] entao
                           falhaTurno <- verdadeiro
                        fimse
                     fimpara

                     se falhaTurno = verdadeiro entao
                        escreval("RESULTADO DO TURNO: COBERTURA INSUFICIENTE")
                     senao
                        escreval("RESULTADO DO TURNO: COBERTURA COMPLETA")
                        turnosCobertos <- turnosCobertos + 1
                     fimse

                  fimpara

               fimpara

               percentCobertura <- turnosCobertos / 15
               percentCobertura <- percentCobertura * 100

               escreval()
               escreval("Percentual de turnos cobertos na semana:")

               se percentCobertura >= 100 entao
                  escreva("[##########]")
               senao
                  se percentCobertura >= 90 entao
                     escreva("[#########.]")
                  senao
                     se percentCobertura >= 80 entao
                        escreva("[########..]")
                     senao
                        se percentCobertura >= 70 entao
                           escreva("[#######...]")
                        senao
                           se percentCobertura >= 60 entao
                              escreva("[######....]")
                           senao
                              se percentCobertura >= 50 entao
                                 escreva("[#####.....]")
                              senao
                                 se percentCobertura >= 40 entao
                                    escreva("[####......]")
                                 senao
                                    se percentCobertura >= 30 entao
                                       escreva("[###.......]")
                                    senao
                                       se percentCobertura >= 20 entao
                                          escreva("[##........]")
                                       senao
                                          se percentCobertura >= 10 entao
                                             escreva("[#.........]")
                                          senao
                                             escreva("[..........]")
                                          fimse
                                       fimse
                                    fimse
                                 fimse
                              fimse
                           fimse
                        fimse
                     fimse
                  fimse
               fimse

               escreval(" ", percentCobertura, "%")

               escreval("")
               escreval("Fim da análise da cobertura semanal.")
               escreval("Pressione Enter para voltar.")
               leia(teclaEnter)
               limpatela

            fimse

            // ------------------------------------------------------------
            // TAREFA 20: DIAGNÓSTICO DE FALHAS NA COBERTURA
            // ------------------------------------------------------------
            se opcaoSemana = 5 entao

               limpatela

               totalFalhas <- 0

               para iEsp de 1 ate 3 faca
                  falhasEsp[iEsp] <- 0
               fimpara

               escreval("=== DIAGNÓSTICO DE FALHAS SEMANAIS ===")
               escreval("Verificando os 15 turnos da semana...")
               escreval("")

               para diaEscolhido de 1 ate 5 faca

                  para turnoEscolhido de 1 ate 3 faca

                     idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido

                     para iEsp de 1 ate 3 faca
                        qtdEscalaEsp[iEsp] <- 0
                     fimpara

                     // Conta médicos escalados por especialidade
                     para p de 1 ate postosPorTurno faca

                        s <- (idxSemana - 1) * postosPorTurno + p

                        se escalaSemana[s] > 0 entao

                           para iEsp de 1 ate 3 faca

                              se medicoEspec[escalaSemana[s]] = nomeEsp[iEsp] entao
                                 qtdEscalaEsp[iEsp] <- qtdEscalaEsp[iEsp] + 1
                              fimse

                           fimpara

                        fimse

                     fimpara

                     falhaTurno <- falso

                     // Identifica especialidades abaixo do mínimo
                     para iEsp de 1 ate 3 faca

                        se qtdEscalaEsp[iEsp] < minEsp[iEsp] entao

                           falhaTurno <- verdadeiro
                           falhasEsp[iEsp] <- falhasEsp[iEsp] + 1
                           totalFalhas <- totalFalhas + 1

                        fimse

                     fimpara

                     // Registra dia, turno e especialidade da falha
                     se falhaTurno = verdadeiro entao

                        escreval("FALHA: ", nomeDia[diaEscolhido], " - ", nomeTurno[turnoEscolhido])

                        para iEsp de 1 ate 3 faca

                           se qtdEscalaEsp[iEsp] < minEsp[iEsp] entao

                              faltam <- minEsp[iEsp] - qtdEscalaEsp[iEsp]

                              escreval("   ", nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - Faltam ", faltam, " médico(s).")

                           fimse

                        fimpara

                        escreval("")

                     fimse

                  fimpara

               fimpara

               escreval("=== RESUMO DAS FALHAS ===")

               se totalFalhas = 0 entao

                  escreval("SEM FALHAS: todos os turnos atendem aos mínimos.")

               senao

                  escreval("Total de falhas de cobertura: ", totalFalhas)
                  escreval("")

                  para iEsp de 1 ate 3 faca

                     escreval(nomeEsp[iEsp], ": ", falhasEsp[iEsp], " turno(s) com falha.")

                  fimpara

                  escreval("")
                  escreval("DIAGNÓSTICO: a escala semanal apresenta")
                  escreval("insuficiência de médicos em um ou mais turnos.")

               fimse

               escreval("")
               escreval("Verificação dos 15 turnos concluída.")
               escreval("Pressione Enter para voltar.")
               leia(teclaEnter)
               limpatela

            fimse

            se opcaoSemana = 3 entao
               semanaAtiva <- falso
            fimse

            // Validação atualizada para aceitar opções de 1 a 5
            se (opcaoSemana < 1) ou (opcaoSemana > 5) entao
               escreval("ERRO: Opção inválida.")
               escreval("")
            fimse

         fimenquanto

         limpatela

      fimse

      // Opção inválida do menu
      se opcaoMenu < 1 entao
         limpatela
         escreval("ERRO: Opção inválida.")
         escreval("")
      fimse

      se opcaoMenu > 7 entao
         limpatela
         escreval("ERRO: Opção inválida.")
         escreval("")
      fimse

   fimenquanto

   // opção 7 do menu: encerrar programa
   escreval("")
   escreval("Sistema encerrado.")

fimalgoritmo