package microcredito

class Garantia {
    Double valor, latitude,longitude
    String descricao
    String localizacao
    String foto
    TipoGarantia tipoGarantia
    Date dataRegisto
    Date dataModif
    User userRegisto
    User userModif

    static belongsTo = [emprestimo: Emprestimo, tipoGarantia: TipoGarantia]

    static constraints = {
        foto(nullable: true, blank: false, maxSize: 300)
    }

    static mapping = {
        descricao type: "text"
    }
}
