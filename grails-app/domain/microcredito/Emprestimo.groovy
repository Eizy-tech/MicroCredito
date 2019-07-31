package microcredito

class Emprestimo {
    Double valorPedido, taxaJuros, taxaMulta, valorApagar, capital
    Integer nrPrestacoes, nrRecibo
    Date prazoPagamento, dataInicioPagamento
    String destinoCredito, tipoNegocio, localNegocio, experienciaNegocio, instituicoescredito, bancos, estado, nrProcesso,
            testemunhas,observacao,avalista
    Cliente cliente
    ModoPagamento modoPagamento
    Date dataRegisto
    Date dataModif
    User userRegisto
    User userModif

    static  hasMany = [prestacoes: Prestacao, garantias: Garantia]
    static belongsTo = [cliente:Cliente, modoPagamento:ModoPagamento]

    static constraints = {
        destinoCredito(blank: true, maxSize: 45, inList: ['Negocio','Consumo'])
        tipoNegocio(blank: true, nullable: true, maxSize: 45)
        localNegocio(blank: true,nullable: true, maxSize: 45)
        experienciaNegocio(blank: true,nullable: true, maxSize: 100)
        instituicoescredito(blank: true,nullable: true)
        bancos(blank: true, nullable: true)
        estado(inList: ["Aberto", "Suspenso", "Fechado", "Vencido"])
        dataInicioPagamento(nullable: true, blank: true)
        observacao(nullable: true)
        avalista(blank:true,nullable: true)
        testemunhas(nullable: true)
        nrRecibo(nullable: true)
    }

    static mapping = {
        instituicoescredito type: "text"
        bancos type: "text"
        testemunhas type: "text"
    }
}