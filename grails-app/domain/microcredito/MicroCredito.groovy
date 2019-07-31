package microcredito

class MicroCredito {
    String designacao, slogan, logo, nuit, mutuante, nrRegisto, telefone, celular, email, fax, webSite, endereco
    Distrito distrito
    Date dataRegisto
    Date dataModif
    User userRegisto
    User userModif
    Date prazo //prazo de sistema

    static belongsTo = [distrito: Distrito]

    static constraints = {
        designacao(blank: false, maxSize: 200)
        slogan(blank: true, maxSize: 500)
        nuit(blank: true, maxSize: 45)
        mutuante(blank: false, maxSize: 200)
        nrRegisto(blank: false, maxSize: 45)
        telefone(blank: true, maxSize: 45)
        celular(blank: true, maxSize: 45)
        email(blank: true, maxSize: 45)
        webSite(blank: true, maxSize: 500)
        endereco(blank: true, maxSize: 500)
        distrito(nullable: true)
        prazo(nullable: true)
    }
}
