package microcredito

class TipoDocumento {
    String descricao
    static  hasMany = [clientes: Cliente]

    static constraints = {
        descricao(blank:false, maxSize: 45)
    }
}