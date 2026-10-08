algoritmo "Hospital Aurora"

var

opcaoTurno : caractere

continuar : logico

qtdClinicos : inteiro
qtdPediatras : inteiro
qtdCirurgioes : inteiro

limiteMax : inteiro
minClinicos : inteiro
minPediatras : inteiro
minCirurgioes : inteiro

totalEspec : inteiro

inicio

    continuar <- falso

    enquanto continuar = falso faca
        escreval("=== HOSPITAL AURORA ===")
        escreval("=== ESCOLHER TURNO ===")

        // Menu de turno, usuário escolhe um número de acordo com o turno desejado.
        escreval("1 - Manhã")
        escreval("2 - Tarde")
        escreval("3 - Noite")
        escreva("Escolha uma opção: ")
        leia(opcaoTurno)

        // Validação da escolha. Se 1: Manhã. Se 2: Tarde. Se 3: Noite. OUTRO: Inválido.
        se (opcaoTurno = "1") entao
            opcaoTurno <- "Manhã"
            continuar <- verdadeiro
        senao
            se (opcaoTurno = "2") entao
                opcaoTurno <- "Tarde"
                continuar <- verdadeiro
            senao
                se (opcaoTurno = "3") entao
                    opcaoTurno <- "Noite"
                    continuar <- verdadeiro
                senao
                    limpatela
                    escreval("ERRO: Opção inválida.")
                    escreval("")
                    continuar <- falso
                fimse
            fimse
        fimse
    fimenquanto

    limpatela
    continuar <- falso

    // Análise do plantão
    enquanto continuar = falso faca
        escreval("=== PLANTAO ===")
        escreval("Turno selecionado: ", opcaoTurno)
        escreval("")

        // Quantidade de Clínicos Gerais
        escreva("Quantidade de Clínicos Gerais: ")
        leia(qtdClinicos)

        // Quantidade de Pediatras
        escreva("Quantidade de Pediatras: ")
        leia(qtdPediatras)

        // Quantidade de Cirurgiões
        escreva("Quantidade de Cirurgiões: ")
        leia(qtdCirurgioes)

        limiteMax <- 20
        minClinicos <- 4
        minPediatras <- 2
        minCirurgioes <- 3

        totalEspec <- qtdClinicos + qtdPediatras + qtdCirurgioes

        se (qtdClinicos > 0) e (qtdPediatras > 0) e (qtdCirurgioes > 0) entao

            // Verificação da cobertura
            se (qtdClinicos >= minClinicos) entao
                se (qtdPediatras >= minPediatras) entao
                    se (qtdCirurgioes >= minCirurgioes) entao
                        se (totalEspec <= limiteMax) entao
                            escreval("")
                            escreval("SUCESSO: Plantão pronto para ser publicado!")
                            continuar <- verdadeiro
                        senao
                            limpatela
                            escreval("ERRO: O Plantão excede o limite máximo de médicos (20).")
                            escreval("")
                            continuar <- falso
                        fimse
                    senao
                        limpatela
                        escreval("ERRO: O plantão não cobre o mínimo de CIRURGIÕES (3).")
                        escreval("")
                        continuar <- falso
                    fimse
                senao
                    limpatela
                    escreval("ERRO: O plantão não cobre o mínimo de PEDIATRAS (2).")
                    escreval("")
                    continuar <- falso
                fimse
            senao
                limpatela
                escreval("ERRO: O plantão não cobre o mínimo de CLÍNICOS (4).")
                escreval("")
                continuar <- falso
            fimse
        senao
            limpatela
            escreval("ERRO: a quantidade deve ser um número inteiro maior que zero.")
            escreval("")
            continuar <- falso
        fimse

    fimenquanto

fimalgoritmo