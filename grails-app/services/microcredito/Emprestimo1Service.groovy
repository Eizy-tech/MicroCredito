package microcredito

import grails.gorm.transactions.Transactional

import java.text.SimpleDateFormat

@Transactional
class Emprestimo1Service {

    def somaPrestacoesDivida(Emprestimo emprestimo) { //Soma das prestacoes da divida total
        def divida = 0
        emprestimo.prestacoes.each {//Pego cada prestacaoGeral do emprestimo
            def idPrest = it.id
            def prest = Prestacao.get(idPrest)
            def somaParcelas = 0
            //Pegar tipo=renda_Normal ou tipo_Multa
            if(prest.tipoPrestacao.id == 1){//Renda Normal
                if (prest.estado.equalsIgnoreCase('Vencido') || prest.estado.equalsIgnoreCase('Pendente')) {
                    //Esta prestacaoGeral tem parcelas???
                    if (prest.prestacoes.size() > 0) {//Esta prestacaoGeral tem parcelas?
                        //Pegamos todas parcelas e multas dela
                        def criterio = Prestacao.createCriteria()
                        def parcelas = criterio.list {
                            eq('prestacao', prest)
                        }
//
                        divida += prest.valor //Pega o valor desta prestacaoGeral

                        parcelas.each {
                            if (it.tipoPrestacao.id == 2){//Trata-se de multa
                                def multa = Prestacao.get(it.id)
                                if (multa.prestacoes.size() > 0) {//Esta multa tem parcelas?
                                    if (multa.estado.equalsIgnoreCase('Pendente') || multa.estado.equalsIgnoreCase('Vencido')) {
                                        //Devemos fazer a diferenca
                                        def criterio1 = Prestacao.createCriteria()
                                        def parcelasMulta = criterio1.list {
                                            eq('prestacao', multa)
                                        }
                                        divida = divida + multa.valor//Adicionar o total da multa
                                        parcelasMulta.each {//Diminuir o que ja foi paga
                                            divida = divida - it.valor
                                        }
                                    }
                                }else {//Trata-se da multa nao parcelada
                                    if (multa.estado.equalsIgnoreCase('Pendente') || multa.estado.equalsIgnoreCase('Vencido')){
                                        divida = divida + multa.valor
                                    }
                                }
                            }
                            if (it.tipoPrestacao.descricao.equalsIgnoreCase('Parcela')){
                                divida -= it.valor
                            }
                        }


                    }else {
                        //O total desta prestacaoGeral eh divida
                        divida += prest.valor
                    }
                }
            }
        }
        return divida
    }

    def dividaHoje(Emprestimo emprestimo) {//Divida a ser paga hoje
        def divida = 0
        def dataBD
        def dataHoje = new Date().format("yyyy-MM-dd")

        emprestimo.prestacoes.each {

            if( it.dataLimite) {
                dataBD = it.dataLimite.format("yyyy-MM-dd")

                if (dataBD.equalsIgnoreCase(dataHoje) && (it.estado.equalsIgnoreCase('Pendente') || it.estado.equalsIgnoreCase('Vencido'))) {
                    divida += it.valor
                }
            }
        }
        return divida
    }

    def quantosPagamHoje(){//Quantos clientes devem pagar hoje
        def total = 0
        def emprestimos = Emprestimo.list()

        emprestimos.each {
            if( dividaHoje(it) > 0){
                total = total + 1
            }
        }

        return total
    }

    def somaValorPedido(List<Emprestimo> emprestimos){
        def total = 0

        emprestimos.each {
            total += it.valorPedido
        }
        return total
    }

    def somaValorPagar(List<Emprestimo> emprestimos){
        def total = 0

        emprestimos.each {
            total += it.valorApagar
        }
        return total
    }

    def somaDividaTotal(List<Emprestimo> emprestimos){ //Soma todas dividas de emprestimos
        def total = 0

        emprestimos.each {
            total += somaPrestacoesDivida(it)
        }

        return total
    }

    def somaDividaHoje(List<Emprestimo> emprestimos){
        def total = 0
//        def dataBD
//        def dataHoje = new Date().format("yyyy-MM-dd")
//        dataHoje = new Date().parse("yyyy-MM-dd", dataHoje)
//
//        emprestimos.each {
//            it.prestacoes.each {
//                if(it.dataLimite) {
//                    dataBD = it.dataLimite.toString().substring(0, 10)
//                    dataBD = new Date().parse("yyyy-MM-dd", dataBD)
//
//                    if (dataBD == dataHoje) {
//                        total += it.valor
//                    }
//                }
//            }
//        }

        emprestimos.each {
            total = total + dividaHoje(it)
        }


        return total
    }

    def totalParcelaDaPrestacao(Prestacao prestacao){

        def total = 0

        def todasPrestacoes = prestacao.prestacoes //Considerando que a multa tambem eh prestacaoGeral/

        def tipoPrestacao = TipoPrestacao.findByDescricao('Parcela')

        todasPrestacoes.each {
            if (it.tipoPrestacao == tipoPrestacao){
                total += 1
            }
        }

        return total
    }

    def totalPagaNasPrestacoes(Prestacao prestacao){
        def total = 0

        def todasPrestacoes = prestacao.prestacoes //Considerando que a multa tambem eh prestacaoGeral/

        def tipoPrestacao = TipoPrestacao.findByDescricao('Parcela')

        todasPrestacoes.each {
            if (it.tipoPrestacao == tipoPrestacao){
                total += it.valor
            }
        }
        return total
    }

    def numeroPrestacaoReferencia(Prestacao prestacao){
        def numero = '####'

        if (prestacao.prestacao){
            numero = prestacao.prestacao.numero
        }
        return numero
    }

//    def totalRelatorio (Emprestimo emprestimo, Integer estado){
//        def total = 0
//
//        if (estado == 1){//Situacao PAGO:
//            def prestacoes = emprestimo.prestacoes
//
//            prestacoes.each {
//                if (it.tipoPrestacao.descricao.equalsIgnoreCase('Pago')){
//                    total += it.valor
//                }
//            }
//        }else{//Situacao NAO PAGO:
//            if (!(it.tipoPrestacao.descricao.equalsIgnoreCase('Pago')) && !(it.tipoPrestacao.descricao.equalsIgnoreCase('Anulado'))){
//                total += it.valor
//            }
//        }
//        return total
//    }

    def dividaParcela(Prestacao prestacao){
        def divida = 0
        def valorOriginal = prestacao.valor
        def soma = 0

        if (prestacao.prestacoes.size() > 0){
            def listaParcelas = prestacao.prestacoes

            listaParcelas.each {
                if(!it.tipoPrestacao.descricao.equalsIgnoreCase('Multa') && !it.tipoPrestacao.descricao.equalsIgnoreCase('Taxa de Concessao')){
                    soma += it.valor
                }
            }

            divida = valorOriginal - soma
        } else if (!(prestacao.estado.equalsIgnoreCase('Pago')) && !(prestacao.estado.equalsIgnoreCase('Anulado'))){
            divida = valorOriginal
        }
        return  divida
    }

    def dividaTotalRelatorio(Emprestimo emprestimo){
        def total = 0
        def prestacoes = emprestimo.prestacoes

        prestacoes.each {
            total += dividaParcela(it)
        }

        return  total
    }
}
