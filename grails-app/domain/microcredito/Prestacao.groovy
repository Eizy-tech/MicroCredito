package microcredito

class Prestacao {
    String numero, observacao, referencia
    Double valor
    Date dataLimite
    Date dataPagamento, dataParcela
    String estado
    Prestacao prestacao
    TipoPrestacao tipoPrestacao
    MeioPagamento meioPagamento
    Emprestimo emprestimo
    Date dataRegisto
    Date dataModif
    User userRegisto
    User userModif
    ContaBancaria conta

    static hasMany = [prestacoes: Prestacao]
    static belongsTo = [emprestimo: Emprestimo, tipoPrestacao: TipoPrestacao, meioPagamento: MeioPagamento]

    static constraints = {
        numero(blank: false, maxSize: 45)
        valor(blank: false)
        estado(inList: ["Pendente", "Vencido", "Pago","Anulado", "Capitalizado", "Validado"], maxSize: 45)
        prestacao(nullable: true)
        meioPagamento(nullable: true, blank: true)
        emprestimo(nullable: false, blank: false)
        dataPagamento(nullable: true, blank: true)
        dataParcela(nullable: true, blank: true)
        dataLimite(nullable: true, blank: true)
        observacao(nullable: true, blank: true)
        referencia(nullable: true, blank: true)
        userModif(nullable: true, blank: true)
        userRegisto(nullable: true, blank: true)
        conta(nullable: true)
    }

    static mapping = {
        observacao type: "text"
    }
}