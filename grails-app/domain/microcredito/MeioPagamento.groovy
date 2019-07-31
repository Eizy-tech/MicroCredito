package microcredito

class MeioPagamento {
    String descricao
    static hasMany = [prestacoes: Prestacao]

    static constraints = {
        descricao(blank: false, maxSize: 45)
    }
}
