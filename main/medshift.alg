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

   continuarPlan : logico

   // escolhaTurno guarda o que foi digitado (1, 2 ou 3)
   // opcaoTurno guarda o nome do turno (Manhã, Tarde ou Noite)
   escolhaTurno : caractere
   opcaoTurno : caractere
   teclaEnter : caractere

   qtdClinicos : inteiro
   qtdPediatras : inteiro
   qtdCirurgioes : inteiro

   limiteMax : inteiro

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
   medicoValido : logico
   duplicadoEscala : logico
   escalaPos : vetor[1..20] de inteiro

   // Controle do plantão em andamento (criar, pausar e retomar)
   dadosOk : logico
   abortarPlantao : logico
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
   // mínimo por especialidade: 1 = clínico, 2 = pediatra, 3 = cirurgião
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
   // 15 turnos x postosPorTurno = 135 postos (9 postos por turno)
   // índice do turno = (dia - 1) * 3 + turno
   // índice do posto = (índice do turno - 1) * postosPorTurno + posto
   escalaSemana : vetor[1..135] de inteiro
   postosPorTurno : inteiro
   limiteSemanal : inteiro
   opcaoSemana : inteiro
   semanaAtiva : logico
   diaEscolhido : inteiro
   turnoEscolhido : inteiro
   idxSemana : inteiro
   postoLivre : inteiro
   p : inteiro
   s : inteiro
   codigoErro : inteiro

   // Tarefas 19 e 20: cobertura da escala semanal
   qtdEscalaEsp : vetor[1..3] de inteiro
   falhasEsp : vetor[1..3] de inteiro
   totalFalhas : inteiro
   falhaTurno : logico

   // Tarefa 23: percentual de turnos cobertos na semana
   turnosCobertos : inteiro
   percentCobertura : real


   // ADICAO: variaveis exclusivas do relatorio completo
   relCarga : vetor[1..60] de inteiro
   relPrimeiraPos : vetor[1..60] de inteiro
   relQtdUnicos : inteiro
   relIndice : inteiro
   relIndiceMedico : inteiro
   relContador : inteiro
   relMaior : inteiro
   relMenor : inteiro
   relTotal : inteiro
   relCobertos : inteiro
   relFalhas : inteiro
   relFaltam : inteiro
   relMedia : real
   relPercentual : real
   relSobrecarga : inteiro
   relCoberturaCompleta : logico
   relEncontrado : logico

   // Largura (em caracteres) usada para centralizar títulos e menus
   larguraTela : inteiro

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

   // ------------------------------------------------------------
   // FUNÇÃO: VALIDAR ALOCAÇÃO NA ESCALA SEMANAL
   // Recebe a posição do médico no vetor, o ID digitado,
   // o dia (1 a 5) e o turno (1 a 3).
   // Retorna 0 se a alocação é permitida, ou o código do erro:
   //   1 = ID de médico não encontrado
   //   2 = disponibilidade diferente do turno
   //   3 = médico já alocado neste turno
   //   4 = limite semanal de plantões atingido
   //   5 = manhã logo após plantão noturno
   // ------------------------------------------------------------

funcao validarAlocacao(posVal: inteiro; idVal: inteiro; diaVal: inteiro; turnoVal: inteiro): inteiro
var
   codigo : inteiro
   idxTurnoVal : inteiro
   idxVizinho : inteiro
   pVal : inteiro
   sVal : inteiro
   qtdVal : inteiro
inicio
   codigo <- 0
   idxTurnoVal <- (diaVal - 1) * 3 + turnoVal

   // Erro 1: ID não encontrado
   se posVal = 0 entao
      codigo <- 1
   fimse

   // Erro 2: disponibilidade do médico diferente do turno
   se codigo = 0 entao
      se medicoDisp[posVal] <> nomeTurno[turnoVal] entao
         codigo <- 2
      fimse
   fimse

   // Erro 3: mesmo médico não pode repetir no mesmo turno
   se codigo = 0 entao
      para pVal de 1 ate postosPorTurno faca
         sVal <- (idxTurnoVal - 1) * postosPorTurno + pVal
         se escalaSemana[sVal] > 0 entao
            se medicoID[escalaSemana[sVal]] = idVal entao
               codigo <- 3
            fimse
         fimse
      fimpara
   fimse

   // Erro 4 (R8): limite semanal de plantões por médico
   se codigo = 0 entao
      qtdVal <- 0
      para sVal de 1 ate 15 * postosPorTurno faca
         se escalaSemana[sVal] > 0 entao
            se medicoID[escalaSemana[sVal]] = idVal entao
               qtdVal <- qtdVal + 1
            fimse
         fimse
      fimpara
      se qtdVal >= limiteSemanal entao
         codigo <- 4
      fimse
   fimse

   // Erro 5 (R9): sem manhã logo após plantão noturno
   se codigo = 0 entao
      idxVizinho <- 0
      se (turnoVal = 1) e (diaVal > 1) entao
         idxVizinho <- (diaVal - 2) * 3 + 3
      fimse
      se (turnoVal = 3) e (diaVal < 5) entao
         idxVizinho <- diaVal * 3 + 1
      fimse

      se idxVizinho > 0 entao
         para pVal de 1 ate postosPorTurno faca
            sVal <- (idxVizinho - 1) * postosPorTurno + pVal
            se escalaSemana[sVal] > 0 entao
               se medicoID[escalaSemana[sVal]] = idVal entao
                  codigo <- 5
               fimse
            fimse
         fimpara
      fimse
   fimse

   retorne codigo
fimfuncao

   // ------------------------------------------------------------
   // PROCEDIMENTOS DE APRESENTAÇÃO (só formatam a tela)
   // ------------------------------------------------------------

   // Desenha uma linha com o símbolo repetido por toda a largura
procedimento desenharLinha(simbolo: caractere)
var
   n : inteiro
inicio
   para n de 1 ate larguraTela faca
      escreva(simbolo)
   fimpara
   escreval("")
fimprocedimento

   // Escreve o texto centralizado na largura da tela
procedimento centralizar(texto: caractere)
var
   n : inteiro
   espacos : inteiro
inicio
   espacos <- (larguraTela - compr(texto)) \ 2
   se espacos < 0 entao
      espacos <- 0
   fimse
   para n de 1 ate espacos faca
      escreva(" ")
   fimpara
   escreval(texto)
fimprocedimento

   // Título principal: moldura visual com o texto centralizado
procedimento tituloPrincipal(texto: caractere)
inicio
   escreval("")
   desenharLinha("=")
   escreval("")
   centralizar(texto)
   escreval("")
   desenharLinha("=")
   escreval("")
fimprocedimento

   // Título de seção: separadores simétricos e centralização
procedimento tituloSecao(simbolo: caractere; texto: caractere)
var
   n : inteiro
   lado : inteiro
   restante : inteiro
inicio
   escreval("")
   lado <- (larguraTela - compr(texto) - 2) \ 2
   se lado < 0 entao
      lado <- 0
   fimse
   restante <- larguraTela - (lado * 2) - compr(texto) - 2
   para n de 1 ate lado faca
      escreva(simbolo)
   fimpara
   escreva(" ", texto, " ")
   para n de 1 ate lado + restante faca
      escreva(simbolo)
   fimpara
   escreval("")
   escreval("")
fimprocedimento

   // Item de menu com margem à esquerda e espaçamento consistente
procedimento itemMenu(margem: inteiro; texto: caractere)
var
   n : inteiro
inicio
   para n de 1 ate margem faca
      escreva(" ")
   fimpara
   escreval(texto)
   escreval("")
fimprocedimento

   // Pergunta do menu com a mesma margem dos itens
procedimento perguntaMenu(margem: inteiro; texto: caractere)
var
   n : inteiro
inicio
   escreval("")
   para n de 1 ate margem faca
      escreva(" ")
   fimpara
   escreva(texto)
fimprocedimento

inicio
   // Inicialização de variáveis com valores definidos
   larguraTela <- 76
   cadMedicos <- falso
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
   minEsp[1] <- 4
   minEsp[2] <- 2
   minEsp[3] <- 3

   // Tarefas 17 e 18
   nomeDia[1] <- "Segunda"
   nomeDia[2] <- "Terça"
   nomeDia[3] <- "Quarta"
   nomeDia[4] <- "Quinta"
   nomeDia[5] <- "Sexta"
   postosPorTurno <- 9
   limiteSemanal <- 5

   para s de 1 ate 15 * postosPorTurno faca
      escalaSemana[s] <- 0
   fimpara

   // menu inicial, onde o usuário escolhe o que fazer
   enquanto opcaoMenu <> 7 faca

      tituloPrincipal("MEDSHIFT - HOSPITAL AURORA")
      itemMenu(21, "1 - Cadastrar médicos")
      itemMenu(21, "2 - Criar plantão")
      itemMenu(21, "3 - Consultar médicos cadastrados")
      itemMenu(21, "4 - Verificar cobertura mínima")
      itemMenu(21, "5 - Resumo diário dos plantões")
      itemMenu(21, "6 - Escala semanal")
      itemMenu(21, "7 - Encerrar")
      escreval("")
      desenharLinha("-")
      perguntaMenu(21, "Escolha uma opção: ")
      leia(opcaoMenu)

      // ------------------------------------------------------------
      // OPÇÃO 1: CADASTRAR MÉDICOS
      // ------------------------------------------------------------
      se opcaoMenu = 1 entao

         limpatela
         cadMedicos <- verdadeiro

         enquanto cadMedicos = verdadeiro faca

            se posicao < 60 entao

               tituloPrincipal("CADASTRAR MÉDICO")
               escreval("0 - para voltar ao menu principal")

               // O nome não pode ficar vazio
               nomeInserido <- ""
               enquanto nomeInserido = "" faca
                  escreva("Nome: ")
                  leia(nomeInserido)
                  se nomeInserido = "" entao
                     escreval("ERRO: O nome não pode ficar vazio.")
                  fimse
               fimenquanto

               se nomeInserido = "0" entao
                  cadMedicos <- falso
               senao

               escreval("")
               tituloSecao("-", "DISPONIBILIDADE")
               itemMenu(29, "1 - Manhã")
               itemMenu(29, "2 - Tarde")
               itemMenu(29, "3 - Noite")
               escreval("")
               perguntaMenu(29, "Escolha uma opção: ")
               leia(escolhaTurno)

               se escolhaTurno = "1" entao
                  turnoInserido <- "Manhã"
               senao
                  se escolhaTurno = "2" entao
                     turnoInserido <- "Tarde"
                  senao
                     se escolhaTurno = "3" entao
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

                  // A comparação do nome não diferencia maiúsculas de minúsculas
                  para i de 1 ate posicao faca
                     se maiusc(medicoNome[i]) = maiusc(nomeInserido) entao
                        qtdTurnosMedico <- qtdTurnosMedico + 1

                        se posPrimeiro = 0 entao
                           posPrimeiro <- i
                        fimse

                        se medicoDisp[i] = turnoInserido entao
                           duplicado <- verdadeiro
                        fimse
                     fimse
                  fimpara

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
                              tituloSecao("-", "ESPECIALIDADE")
                              itemMenu(29, "1 - Clínico geral")
                              itemMenu(29, "2 - Pediatra")
                              itemMenu(29, "3 - Cirurgião")
                              escreval("")
                              perguntaMenu(29, "Escolha uma opção: ")
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
                           // Mantém o nome e o ID do primeiro cadastro
                           medicoNome[posicao] <- medicoNome[posPrimeiro]
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
               tituloSecao("-", "CONTINUAR CADASTRANDO?")
               itemMenu(29, "1 - Continuar")
               itemMenu(29, "2 - Sair")
               escreval("")
               perguntaMenu(29, "Escolha uma opção: ")
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
         pausarPlantao <- falso
         abortarPlantao <- falso
         opcaoRetomar <- 2

         // Atualiza a contagem de médicos por turno e especialidade
         para iTurno de 1 ate 3 faca
            para iEsp de 1 ate 3 faca
               cobertura[(iTurno - 1) * 3 + iEsp] <- 0
            fimpara
         fimpara

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

         // Verifica se existe um plantão pausado anteriormente
         se plantaoPendente = verdadeiro entao
            opcaoRetomar <- 0
            enquanto (opcaoRetomar <> 1) e (opcaoRetomar <> 2) faca
               tituloPrincipal("PLANTÃO EM ANDAMENTO")
               escreval("Turno: ", turnoSalvo, " | Médicos já selecionados: ", qtdSalva)
               escreval("")
               itemMenu(24, "1 - Continuar de onde parou")
               itemMenu(24, "2 - Descartar e iniciar novo")
               escreval("")
               perguntaMenu(24, "Escolha uma opção: ")
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

         // ETAPA 1: define turno e quantidades (novo) ou restaura o rascunho (retomar)
         se opcaoRetomar = 1 entao

            opcaoTurno <- turnoSalvo
            qtdClinicos <- clinicosSalvo
            qtdPediatras <- pediatrasSalvo
            qtdCirurgioes <- cirurgioesSalvo
            totalEspec <- qtdClinicos + qtdPediatras + qtdCirurgioes
            inicioSelecao <- qtdSalva + 1

         senao

            continuarPlan <- falso

            enquanto continuarPlan = falso faca

               tituloPrincipal("ESCOLHER TURNO")
               itemMenu(29, "1 - Manhã")
               itemMenu(29, "2 - Tarde")
               itemMenu(29, "3 - Noite")
               escreval("0 - para voltar ao menu principal")
               escreval("")
               perguntaMenu(29, "Escolha uma opção: ")
               leia(escolhaTurno)

               se escolhaTurno = "0" entao
                  abortarPlantao <- verdadeiro
                  continuarPlan <- verdadeiro
               senao
               se escolhaTurno = "1" entao
                  opcaoTurno <- "Manhã"
                  continuarPlan <- verdadeiro
               senao
                  se escolhaTurno = "2" entao
                     opcaoTurno <- "Tarde"
                     continuarPlan <- verdadeiro
                  senao
                     se escolhaTurno = "3" entao
                        opcaoTurno <- "Noite"
                        continuarPlan <- verdadeiro
                     senao
                        limpatela
                        escreval("ERRO: Opção inválida.")
                        escreval("")
                     fimse
                  fimse
               fimse
               fimse

            fimenquanto

            se abortarPlantao = falso entao
            para iTurno de 1 ate 3 faca
               se nomeTurno[iTurno] = opcaoTurno entao
                  idxTurno <- iTurno
               fimse
            fimpara

            limpatela
            dadosOk <- falso

            enquanto (dadosOk = falso) e (abortarPlantao = falso) faca

               tituloPrincipal("PLANTÃO")
               escreval("Turno selecionado: ", opcaoTurno)
               escreval("")

               escreva("Quantidade de Clínicos Gerais: ")
               leia(qtdClinicos)

               escreva("Quantidade de Pediatras: ")
               leia(qtdPediatras)

               escreva("Quantidade de Cirurgiões: ")
               leia(qtdCirurgioes)

               totalEspec <- qtdClinicos + qtdPediatras + qtdCirurgioes

               se qtdClinicos < minEsp[1] entao
                  limpatela
                  escreval("ERRO: O plantão exige no mínimo ", minEsp[1], " clínicos.")
               senao
                  se qtdPediatras < minEsp[2] entao
                     limpatela
                     escreval("ERRO: O plantão exige no mínimo ", minEsp[2], " pediatras.")
                  senao
                     se qtdCirurgioes < minEsp[3] entao
                        limpatela
                        escreval("ERRO: O plantão exige no mínimo ", minEsp[3], " cirurgiões.")
                     senao
                        se totalEspec > limiteMax entao
                           limpatela
                           escreval("ERRO: O plantão excede o limite máximo de ", limiteMax, " médicos.")
                        senao

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
                              abortarPlantao <- verdadeiro
                           senao
                              dadosOk <- verdadeiro
                           fimse

                        fimse
                     fimse
                  fimse
               fimse

               se (dadosOk = falso) e (abortarPlantao = falso) entao
                  escreval("Pressione Enter para tentar novamente.")
                  leia(teclaEnter)
               fimse

            fimenquanto

            inicioSelecao <- 1
            fimse

         fimse

         // ETAPA 2: seleção dos médicos (vale para novo plantão e para retomada)
         se abortarPlantao = falso entao

            se opcaoRetomar = 1 entao
               tituloPrincipal("RETOMANDO PLANTÃO")
               escreval("Turno: ", opcaoTurno, " | Já selecionados: ", qtdSalva, " de ", totalEspec)
            fimse

            i <- inicioSelecao

            // O laço termina ao completar o plantão ou quando o usuário pausa (digita 0)
            enquanto (i <= totalEspec) e (pausarPlantao = falso) faca

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
                  desenharLinha("-")
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

                     se posMedico = 0 entao
                        escreval("ERRO: ID de médico não encontrado.")
                     senao
                        se medicoEspec[posMedico] <> especialidadeNecessaria entao
                           escreval("ERRO: A especialidade do médico não corresponde ao plantão.")
                        senao
                           se medicoDisp[posMedico] <> opcaoTurno entao
                              escreval("ERRO: A disponibilidade do médico não corresponde ao turno selecionado.")
                           senao

                              duplicadoEscala <- falso

                              para k de 1 ate i - 1 faca
                                 se escalaPos[k] = posMedico entao
                                    duplicadoEscala <- verdadeiro
                                 fimse
                              fimpara

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

               se pausarPlantao = falso entao
                  i <- i + 1
               fimse

            fimenquanto

            se pausarPlantao = verdadeiro entao
               escreval("")
               escreval("Plantão pausado! ", qtdSalva, " médico(s) mantido(s) em rascunho.")
               escreval("Pressione Enter para voltar ao menu.")
               leia(teclaEnter)
            senao
               plantaoPendente <- falso
               qtdSalva <- 0

               escreval("")
               escreval("SUCESSO: Plantão pronto para ser publicado!")
               escreval("")
               tituloSecao("=", "MÉDICOS SELECIONADOS")

               para i de 1 ate totalEspec faca
                  escreval("ID: ", medicoID[escalaPos[i]])
                  escreval("Nome: ", medicoNome[escalaPos[i]])
                  escreval("Especialidade: ", medicoEspec[escalaPos[i]])
                  escreval("Disponibilidade: ", medicoDisp[escalaPos[i]])
                  desenharLinha("-")
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
            fimse

         fimse

         limpatela

      fimse

      // ------------------------------------------------------------
      // OPÇÃO 3: CONSULTAR MÉDICOS CADASTRADOS
      // ------------------------------------------------------------
      se opcaoMenu = 3 entao

         limpatela
         tituloPrincipal("MÉDICOS CADASTRADOS")

         se posicao = 0 entao
            escreval("ERRO: Não há médicos cadastrados para serem apresentados.")
         senao
            para i de 1 ate posicao faca
               escreval("Identificador: ", medicoID[i])
               escreval("Nome: ", medicoNome[i])
               escreval("Especialidade: ", medicoEspec[i])
               escreval("Disponibilidade: ", medicoDisp[i])
               desenharLinha("-")
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

         // Atualiza a contagem de médicos por turno e especialidade
         para iTurno de 1 ate 3 faca
            para iEsp de 1 ate 3 faca
               cobertura[(iTurno - 1) * 3 + iEsp] <- 0
            fimpara
         fimpara

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

         para iTurno de 1 ate 3 faca
            turnoInsuf[iTurno] <- falso
            espInsuf[iTurno] <- falso
         fimpara

         tituloPrincipal("COBERTURA MÍNIMA POR TURNO")
         escreval("Mínimo por turno -> ", nomeEsp[1], ": ", minEsp[1], " | ", nomeEsp[2], ": ", minEsp[2], " | ", nomeEsp[3], ": ", minEsp[3])
         escreval("")

         para iTurno de 1 ate 3 faca
            tituloSecao("-", "Turno: " + nomeTurno[iTurno])

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

         tituloSecao("=", "RESULTADO DA ANÁLISE")

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
         tituloPrincipal("RESUMO DIÁRIO DOS PLANTÕES")

         se totalPlantoesResumo = 0 entao
            escreval("Nenhum plantao concluido para apresentar no resumo.")
         senao
            para resumoTurno de 1 ate 3 faca
               resumoPlantoesTurno <- 0
               resumoMedicosTurno <- 0
               escreval("")
               tituloSecao("=", "TURNO: " + nomeTurno[resumoTurno])

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
                     desenharLinha("-")
                  fimse
               fimpara

               escreval("Plantoes concluidos: ", resumoPlantoesTurno)
               escreval("Alocacoes de medicos: ", resumoMedicosTurno)
            fimpara

            escreval("")
            desenharLinha("=")
            escreval("TOTAL DE PLANTOES: ", totalPlantoesResumo)
            escreval("TOTAL DE ALOCACOES: ", totalAlocacoesResumo)
            desenharLinha("=")
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

            tituloPrincipal("ESCALA SEMANAL")
            itemMenu(19, "1 - Visualizar escala semanal")
            itemMenu(19, "2 - Alocar médico em um turno")
            itemMenu(19, "3 - Diagnóstico de falhas na cobertura")
            itemMenu(19, "4 - Visualizar cobertura semanal")
            itemMenu(19, "5 - Relatorio completo da semana")
             itemMenu(19, "6 - Voltar ao menu")
            escreval("")
            desenharLinha("-")
            perguntaMenu(19, "Escolha uma opção: ")
            leia(opcaoSemana)
            limpatela

            // TAREFA 17: VISUALIZAR A SEMANA COMPLETA
            se opcaoSemana = 1 entao

               tituloPrincipal("ESCALA DA SEMANA (SEG A SEX)")

               para diaEscolhido de 1 ate 5 faca
                  escreval("")
                  tituloSecao("=", nomeDia[diaEscolhido])

                  para turnoEscolhido de 1 ate 3 faca
                     idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido
                     tituloSecao("-", "Turno: " + nomeTurno[turnoEscolhido])

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

               tituloPrincipal("ALOCAR MÉDICO NA ESCALA")

               diaEscolhido <- -1
               enquanto ((diaEscolhido < 1) ou (diaEscolhido > 5)) e (diaEscolhido <> 0) faca
                  escreval("Dia: 1-Segunda | 2-Terça | 3-Quarta | 4-Quinta | 5-Sexta")
                  escreval("0 - para voltar ao menu principal")
                  escreva("Escolha o dia: ")
                  leia(diaEscolhido)
                  se ((diaEscolhido < 1) ou (diaEscolhido > 5)) e (diaEscolhido <> 0) entao
                     escreval("ERRO: Opção inválida.")
                  fimse
               fimenquanto

               se diaEscolhido = 0 entao
                  semanaAtiva <- falso
               senao

               turnoEscolhido <- -1
               enquanto ((turnoEscolhido < 1) ou (turnoEscolhido > 3)) e (turnoEscolhido <> 0) faca
                  escreval("Turno: 1-Manhã | 2-Tarde | 3-Noite")
                  escreval("0 - para voltar ao menu principal")
                  escreva("Escolha o turno: ")
                  leia(turnoEscolhido)
                  se ((turnoEscolhido < 1) ou (turnoEscolhido > 3)) e (turnoEscolhido <> 0) entao
                     escreval("ERRO: Opção inválida.")
                  fimse
               fimenquanto

               se turnoEscolhido = 0 entao
                  semanaAtiva <- falso
               senao

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
                  desenharLinha("-")
                  escreval("Alocando em: ", nomeDia[diaEscolhido], " - ", nomeTurno[turnoEscolhido])
                  escreva("Informe o ID do médico: ")
                  leia(idEscolhido)

                  posMedico <- identificarMedico(idEscolhido, nomeTurno[turnoEscolhido])
                  codigoErro <- validarAlocacao(posMedico, idEscolhido, diaEscolhido, turnoEscolhido)

                  se codigoErro = 1 entao
                     escreval("ERRO: ID de médico não encontrado.")
                  fimse
                  se codigoErro = 2 entao
                     escreval("ERRO: A disponibilidade do médico não corresponde ao turno selecionado.")
                  fimse
                  se codigoErro = 3 entao
                     escreval("ERRO: Este médico já foi alocado neste turno.")
                  fimse
                  se codigoErro = 4 entao
                     escreval("ERRO: Este médico já atingiu o limite de ", limiteSemanal, " plantões na semana.")
                  fimse
                  se codigoErro = 5 entao
                     escreval("ERRO: Não é permitido escalar o médico na manhã seguinte a um plantão noturno.")
                  fimse

                  // Grava a alocação após validar
                  se codigoErro = 0 entao
                     escalaSemana[(idxSemana - 1) * postosPorTurno + postoLivre] <- posMedico
                     escreval("")
                     escreval("SUCESSO: ", medicoNome[posMedico], " alocado(a) em ", nomeDia[diaEscolhido], " - ", nomeTurno[turnoEscolhido], ", posto ", postoLivre, ".")
                  fimse

               fimse

               fimse
               fimse

               se semanaAtiva = verdadeiro entao
               escreval("")
               escreval("Pressione Enter para voltar.")
               leia(teclaEnter)
               fimse
               limpatela

            fimse
            
            // ------------------------------------------------------------
            // TAREFA 20: DIAGNÓSTICO DE FALHAS NA COBERTURA
            // ------------------------------------------------------------
            se opcaoSemana = 3 entao

               limpatela

               totalFalhas <- 0

               para iEsp de 1 ate 3 faca
                  falhasEsp[iEsp] <- 0
               fimpara

               tituloPrincipal("DIAGNÓSTICO DE FALHAS SEMANAIS")
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

                        desenharLinha("-")

                     fimse

                  fimpara

               fimpara

               tituloSecao("=", "RESUMO DAS FALHAS")

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

            // ------------------------------------------------------------
            // TAREFA 19: VISUALIZAR COBERTURA SEMANAL
            // ------------------------------------------------------------
            se opcaoSemana = 4 entao

               limpatela
               turnosCobertos <- 0

               tituloPrincipal("COBERTURA SEMANAL")
               escreval("Mínimos: Clínicos: ", minEsp[1], " | Pediatras: ", minEsp[2], " | Cirurgiões: ", minEsp[3])

               para diaEscolhido de 1 ate 5 faca

                  escreval("")
                  tituloSecao("=", nomeDia[diaEscolhido])

                  para turnoEscolhido de 1 ate 3 faca

                     idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido

                     para iEsp de 1 ate 3 faca
                        qtdEscalaEsp[iEsp] <- 0
                     fimpara

                     escreval("")
                     tituloSecao("-", "Turno: " + nomeTurno[turnoEscolhido])

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

                     falhaTurno <- falso

                     para iEsp de 1 ate 3 faca
                        se qtdEscalaEsp[iEsp] >= minEsp[iEsp] entao
                           escreval(nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - OK")
                        senao
                           faltam <- minEsp[iEsp] - qtdEscalaEsp[iEsp]
                           escreval(nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - INSUFICIENTE (faltam ", faltam, ")")
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

               percentCobertura <- (turnosCobertos * 100) / 15

               escreval("")
               tituloSecao("=", "PERCENTUAL DE TURNOS COBERTOS NA SEMANA")

               // Barra de progresso: 1 '#' a cada 10%
               escreva("[")
               para p de 1 ate 20 faca
                  se percentCobertura >= p * 20 entao
                     escreva("#")
                  senao
                     escreva(".")
                  fimse
               fimpara
               escreval("] ", percentCobertura:6:1, "%")
               escreval("Turnos cobertos: ", turnosCobertos, " de 15")

               escreval("")
               escreval("Fim da análise da cobertura semanal.")
               escreval("Pressione Enter para voltar.")
               leia(teclaEnter)
               limpatela

            fimse

             // ------------------------------------------------------------
             // ADICAO: RELATORIO COMPLETO DA ESCALA SEMANAL
             // Usa apenas a escala semanal existente, sem alterar alocacoes.
             // ------------------------------------------------------------
             se opcaoSemana = 5 entao
                limpatela
                tituloPrincipal("RELATORIO COMPLETO DA ESCALA SEMANAL")

                se qtdMedicos = 0 entao
                   escreval("Nenhum medico cadastrado.")
                   escreval("Nao ha profissionais para calcular cargas e media.")
                   escreval("Turnos plenamente cobertos: 0 de 15 (0.0%).")
                senao
                   // Identifica cada profissional pelo ID, sem contar
                   // duas vezes quem possui cadastro em dois turnos.
                   relQtdUnicos <- 0
                   para relIndice de 1 ate posicao faca
                      relEncontrado <- falso
                      para relContador de 1 ate relQtdUnicos faca
                         se medicoID[relPrimeiraPos[relContador]] = medicoID[relIndice] entao
                            relEncontrado <- verdadeiro
                         fimse
                      fimpara
                      se relEncontrado = falso entao
                         relQtdUnicos <- relQtdUnicos + 1
                         relPrimeiraPos[relQtdUnicos] <- relIndice
                         relCarga[relQtdUnicos] <- 0
                      fimse
                   fimpara

                   relCobertos <- 0
                   relFalhas <- 0
                   relTotal <- 0
                   tituloSecao("=", "COBERTURA POR DIA E TURNO")
                   para diaEscolhido de 1 ate 5 faca
                      tituloSecao("=", nomeDia[diaEscolhido])
                      para turnoEscolhido de 1 ate 3 faca
                         idxSemana <- (diaEscolhido - 1) * 3 + turnoEscolhido
                         para iEsp de 1 ate 3 faca
                            qtdEscalaEsp[iEsp] <- 0
                         fimpara

                         // Conta alocacoes e carga por profissional.
                         para p de 1 ate postosPorTurno faca
                            s <- (idxSemana - 1) * postosPorTurno + p
                            se escalaSemana[s] > 0 entao
                               relTotal <- relTotal + 1
                               para iEsp de 1 ate 3 faca
                                  se medicoEspec[escalaSemana[s]] = nomeEsp[iEsp] entao
                                     qtdEscalaEsp[iEsp] <- qtdEscalaEsp[iEsp] + 1
                                  fimse
                               fimpara
                               para relContador de 1 ate relQtdUnicos faca
                                  se medicoID[relPrimeiraPos[relContador]] = medicoID[escalaSemana[s]] entao
                                     relCarga[relContador] <- relCarga[relContador] + 1
                                  fimse
                               fimpara
                            fimse
                         fimpara

                         relCoberturaCompleta <- verdadeiro
                         escreval("Turno: ", nomeTurno[turnoEscolhido])
                         para iEsp de 1 ate 3 faca
                            se qtdEscalaEsp[iEsp] < minEsp[iEsp] entao
                               relFaltam <- minEsp[iEsp] - qtdEscalaEsp[iEsp]
                               relFalhas <- relFalhas + 1
                               relCoberturaCompleta <- falso
                               escreval("  ", nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - FALHA (faltam ", relFaltam, ")")
                            senao
                               escreval("  ", nomeEsp[iEsp], ": ", qtdEscalaEsp[iEsp], "/", minEsp[iEsp], " - OK")
                            fimse
                         fimpara
                         se relCoberturaCompleta = verdadeiro entao
                            relCobertos <- relCobertos + 1
                            escreval("  RESULTADO: COBERTURA COMPLETA")
                         senao
                            escreval("  RESULTADO: COBERTURA INSUFICIENTE")
                         fimse
                         desenharLinha("-")
                      fimpara
                   fimpara

                   tituloSecao("=", "CARGA POR PROFISSIONAL")
                   relMaior <- relCarga[1]
                   relMenor <- relCarga[1]
                   para relContador de 1 ate relQtdUnicos faca
                      relIndiceMedico <- relPrimeiraPos[relContador]
                      escreval("ID ", medicoID[relIndiceMedico], " - ", medicoNome[relIndiceMedico], ": ", relCarga[relContador], " plantao(oes)")
                      se relCarga[relContador] > relMaior entao
                         relMaior <- relCarga[relContador]
                      fimse
                      se relCarga[relContador] < relMenor entao
                         relMenor <- relCarga[relContador]
                      fimse
                   fimpara

                   tituloSecao("=", "MAIOR E MENOR CARGA")
                   escreval("Maior carga: ", relMaior, " plantao(oes)")
                   para relContador de 1 ate relQtdUnicos faca
                      se relCarga[relContador] = relMaior entao
                         relIndiceMedico <- relPrimeiraPos[relContador]
                         escreval("  ID ", medicoID[relIndiceMedico], " - ", medicoNome[relIndiceMedico])
                      fimse
                   fimpara
                   escreval("Menor carga: ", relMenor, " plantao(oes)")
                   para relContador de 1 ate relQtdUnicos faca
                      se relCarga[relContador] = relMenor entao
                         relIndiceMedico <- relPrimeiraPos[relContador]
                         escreval("  ID ", medicoID[relIndiceMedico], " - ", medicoNome[relIndiceMedico])
                      fimse
                   fimpara

                   relMedia <- relTotal / relQtdUnicos
                   relSobrecarga <- 0
                   tituloSecao("=", "MEDIA E SOBRECARGA")
                   escreval("Total de alocacoes: ", relTotal)
                   escreval("Profissionais unicos: ", relQtdUnicos)
                   escreval("Media de plantoes por profissional: ", relMedia:6:1)
                   escreval("Acima da media (indicador estatistico):")
                   para relContador de 1 ate relQtdUnicos faca
                      se relCarga[relContador] > relMedia entao
                         relIndiceMedico <- relPrimeiraPos[relContador]
                         escreval("  ID ", medicoID[relIndiceMedico], " - ", medicoNome[relIndiceMedico], ": ", relCarga[relContador], " plantoes")
                         relSobrecarga <- relSobrecarga + 1
                      fimse
                   fimpara
                   se relSobrecarga = 0 entao
                      escreval("  Nenhum profissional acima da media.")
                   fimse

                   relPercentual <- (relCobertos * 100.0) / 15
                   tituloSecao("=", "RESUMO GERAL")
                   escreval("Falhas por especialidade/turno: ", relFalhas)
                   escreval("Turnos plenamente cobertos: ", relCobertos, " de 15")
                   escreval("Percentual de cobertura: ", relPercentual:6:1, "%")
                fimse

                escreval("")
                escreval("Pressione Enter para voltar.")
                leia(teclaEnter)
                limpatela
             fimse

            se opcaoSemana = 6 entao
               semanaAtiva <- falso
            fimse

            // ADICAO: validacao aceita a nova opcao 6
            se (opcaoSemana < 1) ou (opcaoSemana > 6) entao
               escreval("ERRO: Opção inválida.")
               escreval("")
            fimse

         fimenquanto

         limpatela

      fimse

      // Opção inválida do menu
      se (opcaoMenu < 1) ou (opcaoMenu > 7) entao
         limpatela
         escreval("ERRO: Opção inválida.")
         escreval("")
      fimse

   fimenquanto

   // opção 7 do menu: encerrar programa
   limpatela
   tituloPrincipal("SISTEMA ENCERRADO")
   centralizar("Obrigado por utilizar o MedShift - Hospital Aurora!")
   escreval("")

fimalgoritmo
