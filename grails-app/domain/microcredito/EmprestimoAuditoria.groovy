package microcredito

class EmprestimoAuditoria {

    Emprestimo emprestimo
    Date dataRegisto, prazoAntigo, prazoNovo
    Double capitalAntigo, capitalNovo
    String observacao,tipo
    User userResponsavel //O user que esteve por detras da geracao deste registro
    Prestacao prestacao
    static constraints = {
        prestacao (nullable: true)
        observacao(nullable: true)
        capitalAntigo(nullable: true)
        capitalNovo(nullable: true)
        prazoAntigo(nullable: true)
        prazoNovo(nullable: true)
        tipo(inList: ['Recapitalizacao','Prolongamento','Reducao_Capital'])
        userResponsavel(nullable: true)
    }
    static mapping = {
        observacao type: "text"
    }
}

