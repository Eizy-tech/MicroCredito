package microcredito

class Distrito {
    String designacao
    Provincia provincia

    static  hasMany = [microCreditos: MicroCredito, clientes: Cliente]
    static belongsTo = [provincia: Provincia]

    static constraints = {
        designacao(blank: false, maxSize: 45)
        provincia(nullable: false)
    }
}
