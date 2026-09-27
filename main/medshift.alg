algoritmo "Hospital Aurora"

var

opcaoMenu : caractere
opcaoTurno : caractere
opcaoQtd : real

qtdClinicos : inteiro
qtdPediatras : inteiro
qtdCirurgioes : inteiro

inicio
    // Menu inicial, usuário escolhe um número de acordo com a ação desejada.
    escreval("=== HOSPITAL AURORA ===")
    escreval("1 - Entrar")
    escreval("2 - Sair")
    escreva("Escolha uma opção: ")
    leia(opcaoMenu)
    limpatela

    // Validação da escolha. Se 1: Escolher turno. Se 2: Sair. OUTRO: Inválido.
    se (opcaoMenu = "1") entao
        escreval("=== ESCOLHER TURNO ===")
    senao
        se (opcaoMenu = "2") entao
            escreva("Você saiu.")
            interrompa
        senao
            escreva("ERRO: Opção inválida.")
            interrompa
        fimse
    fimse

    // Menu de turno, usuário escolhe um número de acordo com o turno desejado.
    escreval("1 - Manhã")
    escreval("2 - Tarde")
    escreval("3 - Noite")
    escreva("Escolha uma opção: ")
    leia(opcaoTurno)
    limpatela

    // Validação da escolha. Se 1: Manhã. Se 2: Tarde. Se 3: Noite. OUTRO: Inválido.
    se (opcaoTurno = "1") entao
        opcaoTurno <- "Manhã"
    senao
        se (opcaoTurno = "2") entao
            opcaoTurno <- "Tarde"
        senao
            se (opcaoTurno = "3") entao
                opcaoTurno <- "Noite"
            senao
                escreval("ERRO: Opção inválida.")
                interrompa
            fimse
        fimse
    fimse

    // Análise do plantão
    escreval("=== PLANTAO ===")
    escreval("Turno selecionado: ", opcaoTurno)
    escreval("")

    // Quantidade de Clínicos Gerais
    escreva("Quantidade de Clínicos Gerais: ")
    leia(opcaoQtd)

    se (opcaoQtd = int(opcaoQtd)) entao
        qtdClinicos <- int(opcaoQtd)
    senao
        escreval("ERRO: a quantidade deve ser um número inteiro.")
        interrompa
    fimse

    // Quantidade de Pediatras
    escreva("Quantidade de Pediatras: ")
    leia(opcaoQtd)

    se (opcaoQtd = int(opcaoQtd)) entao
        qtdPediatras <- int(opcaoQtd)
    senao
        escreval("ERRO: a quantidade deve ser um número inteiro.")
        interrompa
    fimse

    // Quantidade de Cirurgiões
    escreva("Quantidade de Cirurgiões: ")
    leia(opcaoQtd)

    se (opcaoQtd = int(opcaoQtd)) entao
        qtdCirurgioes <- int(opcaoQtd)
    senao
        escreval("ERRO: a quantidade deve ser um número inteiro.")
        interrompa
    fimse

fimalgoritmo
