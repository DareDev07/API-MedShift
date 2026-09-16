algoritmo "Hospital Aurora"

var

opcaoMenu : caractere
opcaoTurno : caractere

inicio
    // Menu inicial, usuário escolhe um número de acordo com a ação desejada.
    escreval("--> Hospital Aurora <--")
    escreval("1 - Entrar")
    escreval("2 - Sair")
    escreva("Escolha uma opção: ")
    leia(opcaoMenu)
    limpatela

    // Validação da escolha. Se 1: Escolher turno. Se 2: Sair. OUTRO: Inválido.
    se (opcaoMenu = "1") entao
        escreval("--> Escolher turno")
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

    // Validação da escolha. Se 1: Manhã. Se 2: Tarde. Se 3: Noite. OUTRO: A FAZER.
    se (opcaoTurno = "1") entao
        opcaoTurno <- "Manhã"
    senao
        se (opcaoTurno = "2") entao
            opcaoTurno <- "Tarde"
        senao
            se (opcaoTurno = "3") entao
                opcaoTurno <- "Noite"

            senao 
                escreva("ERRO: Opção inválida.")
            fimse
        fimse
    fimse

fimalgoritmo
