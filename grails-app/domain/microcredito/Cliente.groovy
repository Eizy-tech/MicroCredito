package microcredito

class Cliente {
    String codigo, nome, estadoCivil, nomeConjuge, tipoContrato, anoAdmissao, estado, nrDocumento, localEmissao,
            contacto1, contacto2,email, endereco, tipoCasa, observacao, nacionalidade, naturalidade
    int  nrDependentes, nrFilhos
    TipoDocumento tipoDocumento
    Date dataEmissao, dataValidade, dataRegisto, dataModif
    User userModif, userRegisto
    Distrito distrito
    Double amplitude, longitude

    static  hasMany = [emprestimos: Emprestimo]
    static belongsTo = [distrito: Distrito, tipoDocumento: TipoDocumento]

    static constraints = {
        codigo(blank: false, maxSize: 45)
        nome(blank: false, nullable: false, maxSize: 100)
        nomeConjuge(nullable: true, maxSize: 100)
        tipoContrato(nullable: true, maxSize: 100)
        anoAdmissao(nullable: true)
        estado(inList: ["Activo", "Inactivo"], maxSize: 45)
        estadoCivil(inList: ["Solteiro", "Casado", "Viuvo","Divorciado"], maxSize: 45)
        nrDocumento(blank: true, maxSize: 45)
        localEmissao(blank: true, maxSize: 45)
        contacto1(blank: true, maxSize: 45)
        contacto2(nullable: true, maxSize: 45)
        email(nullable: true)
        endereco (blank: true, maxSize: 500)
        nrDependentes(nullable: true, min:0, blank:true)
        nrFilhos(nullable: true, min:0)
        tipoDocumento(blank:false, nullable: false)
        amplitude(blank:true, nullable: true)
        longitude(blank:true,nullable: true)
        observacao(nullable: true)
        nacionalidade(nullable: true)
        naturalidade(nullable: true)
    }

    static mapping = {
        observacao type: "text"
    }

}