package microcredito

class Perfil {

    String designacao

    static hasMany = [users: User]

    static constraints = {
        designacao(blank: false, maxSize: 45)
    }
}
