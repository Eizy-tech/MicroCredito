package microcredito

class TipoGarantia {
    String descricao
    Date dataRegisto
    Date dataModif
    User userRegisto
    User userModif

    static constraints = {
        descricao (nullable: false, blank: false, maxSize: 45)
    }
}
