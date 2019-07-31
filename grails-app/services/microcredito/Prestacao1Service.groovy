package microcredito

import grails.gorm.transactions.Transactional

import java.text.DecimalFormat

@Transactional
class Prestacao1Service {
    EmprestimoService emprestimoService

    def multaJuros(Prestacao prestacao){
        return  prestacao.valor * (prestacao.emprestimo.taxaMulta/100)
    }

    @Transactional
    def pagarNormal(Prestacao prestacao, MeioPagamento meioPagamento, User user, String estado, String observacao, Integer conta, String referencia) {
        def emprestimo = prestacao.emprestimo
        def modoPagamento = emprestimo.modoPagamento.id// Se =3 eh mensal

        def emprestimoFechado = true
        def estadoEmprestimo = "Fechado" //Caso o pagamento de prestacaoGeral feche o emprestimo

        prestacao.dataModif = new Date()
        prestacao.estado = estado
        prestacao.dataPagamento = new Date()
        prestacao.userModif = user
        prestacao.meioPagamento = meioPagamento
        prestacao.observacao = observacao
        prestacao.referencia = referencia

        if (conta > 0){//Id da conta existe
            def contaBancaria = ContaBancaria.get(conta)
            prestacao.conta = contaBancaria
        }


        def prest = prestacao.save()
        def prestacoesDoEmprestimo = prest.emprestimo.prestacoes //Todas prestacoes do emprestimo

        //Fader Recibo

        prestacoesDoEmprestimo.each {
            if (it.estado.equalsIgnoreCase("Pendente") || it.estado.equalsIgnoreCase("Vencido")){
                emprestimoFechado = false
            }

        }

        if (emprestimoFechado){
//            if(modoPagamento != 3){ // So vai fechar para emprestimos que nao sejam mensais, Os mensais serao fechados no PrestacaoController
                emprestimo.setEstado(estadoEmprestimo)
                emprestimoService.save(emprestimo)
//            }
        }

        return prest
    }

    @Transactional
    def pagarParcela(Prestacao prestacaoOrigem, MeioPagamento meioPagamento, User user, String estado, Double valor, TipoPrestacao tipoPrestacao, String observacao, Integer conta, String referencia){
        Prestacao parcela = new Prestacao()
        parcela.estado = estado
        parcela.meioPagamento = meioPagamento
        parcela.userModif = user
        parcela.dataPagamento = new Date()
        parcela.valor = valor
        parcela.emprestimo = prestacaoOrigem.emprestimo
        parcela.dataLimite = new Date()
        parcela.dataParcela = new Date()
        parcela.dataRegisto = new Date()
        if (conta > 0){
            def contaBancaria = ContaBancaria.get(conta)
            parcela.conta = contaBancaria
        }
        parcela.referencia = referencia
//        conta o numero de parcelas desta prestacaoGeral
        def parcelasAnteriores = 0
        def numParcela = ''
        prestacaoOrigem.prestacoes.each {
            if (it.tipoPrestacao.descricao.equalsIgnoreCase('Parcela')){
                parcelasAnteriores = parcelasAnteriores+1
            }
        }
        parcelasAnteriores = parcelasAnteriores+1
        numParcela = ''+parcelasAnteriores
        if (numParcela.size()==1){
            numParcela = '00'+numParcela
        }
        if (numParcela.size()==2){
            numParcela = '0'+numParcela
        }
        if (numParcela.size()==3){
            numParcela = ''+numParcela
        }

        parcela.numero = prestacaoOrigem.numero+numParcela
        parcela.observacao = observacao
        parcela.tipoPrestacao = tipoPrestacao
        parcela.userRegisto = user
        parcela.dataModif = new Date()
        parcela.prestacao = prestacaoOrigem
        def prest = parcela.save()

        return prest
    }

    def dividaPrestacao(Prestacao prestacao){
        def divida = 0

        //Verificar se a prestacaoGeral tem prestacoes
        if (prestacao.prestacoes.size() > 0){
            def parcelas = prestacao.prestacoes
            def somaParcela = 0

            parcelas.each {
                if (it.tipoPrestacao.descricao.equalsIgnoreCase('Parcela')){
                    somaParcela += it.valor
                }
            }
            divida = prestacao.valor - somaParcela
        }else {
            divida = prestacao.valor
        }

        return divida
    }
}
