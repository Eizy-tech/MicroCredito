package microcredito

class Provincia {
    String designacao

    static constraints = {
        designacao(blank: false, maxSize: 45)
    }

    static  hasMany = [distritos: Distrito]
}
