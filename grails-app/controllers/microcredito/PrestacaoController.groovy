package microcredito

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import groovy.json.JsonSlurper

import java.text.DateFormat
import java.text.SimpleDateFormat

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class PrestacaoController {

    PrestacaoService prestacaoService
    ClienteService clienteService
    MeioPagamentoService meioPagamentoService
    Prestacao1Service prestacao1Service
    EmprestimoAuditoriaService emprestimoAuditoriaService
    EmprestimoService emprestimoService

    MethodsController methods = new MethodsController()

    def springSecurityService
    def emprestimoFechadoOuNao = true

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def haCapital = false
    def pagaCapital = false
    def haMulta = false
    def haJuros = false
    def valorMulta = 0
    def capitalTotal = 0
    def capitalParcela = 0
    def meioPagamentoCapital = ''
    def obsCapital = ''
    def obsJuros = ''
    Emprestimo emprestimoCapital = null
    def prazo = new Date()
    def dataPrazo = null
    def capitalAntes = 0
//    def capitalDepois = 0
    def idEmprestimoo = 0
    def excepcao = false
    def mesesExcepcao = 0
    def meioPagJuros = ''
    def userModif = null
    def idPrestacao = 0
    Prestacao prestacaoGeral = null
    def valParcelaAux = 0
//    def dataHoje = new Date()
    DateFormat formatter = new SimpleDateFormat("MMM yyyy")

    def dataHojeString = new Date().format("MMM yyyy")
    def dataHoje = new Date().parse("MMM yyyy", dataHojeString)

    def tipoPrestacaoRendaNormal = TipoPrestacao.get(1)//Renda Normal
    def tipoPrestacaoParcela = TipoPrestacao.get(3)//Parcela
    def tipoPrestacaoParcelaCapital = TipoPrestacao.get(5)
    def tipoPrestacaoCapital = TipoPrestacao.get(6)
    def nrSequenciaPrestacao = ''


    def usuarioLogado() {
        def user = (User) springSecurityService.currentUser
        return user
    }

    def validacao() {

        def criteria = Prestacao.createCriteria()

        def prestacoes = criteria.list {
            eq('estado', 'Pago')
        }

        render(view: "validacao", model: [prestacoes: prestacoes])
    }

    def validarPagamento() {
        String jsonObject = request.JSON
        def parametros = new JsonSlurper().parseText(jsonObject)
        userModif = usuarioLogado()

        def id = parametros[0]

        def prestacao = Prestacao.get(id)
        prestacao.setEstado('Validado')
        prestacaoService.save(prestacao)
    }

    def pagamento() {//NOVA VERSAO (EXCLUSIVE)
        def emprestimo = Emprestimo.get(params.cred)// 'cred eh o id do emprestimo/credito que vem da listagem'
        def criterio = Prestacao.createCriteria()
        def prestacoes = criterio.list {
            eq("emprestimo", emprestimo)
            or {
                eq("estado", "Pendente")
                eq("estado", "Vencido")
            }
            order("dataLimite")
        }

        def criterioContas = ContaBancaria.createCriteria()
        def contas = criterioContas.list {
            eq('estado', 'Activo')
        }

        respond emprestimo, model: [prestacoes: prestacoes, meiosPagamento: meioPagamentoService.list(), contas: contas]
        //redirect(action: 'pagamento', model: [prestacoes: prestacoes, meiosPagamento:meioPagamentoService.list()])

    }

    def pagamentos() { //Aqui e realizado o registo de pagamentos


        String jsonObject = request.JSON
        def pagamentoPrestacoes = new JsonSlurper().parseText(jsonObject)
        userModif = usuarioLogado()

        def linhaCapital = pagamentoPrestacoes[0]
        println(linhaCapital.size())
        if (linhaCapital.size() > 4) {
            haCapital = linhaCapital[0]//Pega do array vinda view
            println(haCapital)
            pagaCapital = linhaCapital[1]//Pega do array vinda view
            capitalTotal = linhaCapital[2]
            capitalParcela = linhaCapital[3]
            meioPagamentoCapital = linhaCapital[4]
            obsCapital = linhaCapital[5]
            idEmprestimoo = linhaCapital[6]
            emprestimoCapital = Emprestimo.get(idEmprestimoo)// o emprestimo em questao

            prazo = emprestimoCapital.prazoPagamento
            def dataPrazoString = prazo.format("MM.YYYY")
            dataPrazo = new Date().parse("MM.yyyy", dataPrazoString)
            def linhaJuros = pagamentoPrestacoes[1]
            idPrestacao = linhaJuros[0]
            meioPagJuros = linhaJuros[1]//Meio de Pagamento da Prestacao (Juros)
            valParcelaAux = linhaJuros[2] // Parcela que vem da view
            obsJuros = linhaJuros[3]
            prestacaoGeral = Prestacao.get(idPrestacao)

            if (linhaJuros != null) {
                haJuros = true
            }
        }

        println(haCapital)
        if (haCapital) {//Trata-se de modo mensal
            println('Ha capital')
            if (pagaCapital) {//Vai pagar o capital Tambem
                if (capitalParcela == 0) {//Vai pagar todoo capital
                    pagarCapitalTotaL(prestacaoGeral)
//                    println('Vai pagar todoo capital')
                } else if (capitalParcela > 0) {// Vai pagar parte do Capital
                    pagarCapitalParcela(prestacaoGeral)
//                    println('Vai pagar parcela do capital')
                }
            } else {//So vai pagar a taxa de juros e/ou multa
                if (haJuros) {
                    if (valParcelaAux == 0) {//Vai Pagar a prestacao (Juros) na totalidade
                        pagarPrestacaoJuros(prestacaoGeral)
                    } else{//Vai pagar uma parcela da prestacaoGeral
                        pagarParcelaDaPrestacaoJuros(prestacaoGeral)
                    }
                }
            }
        } else {//Trata-se de pagamentos normais, modalidades diferentes de mensais
            println('Nao Ha capital')
            for (linhaSubArray in pagamentoPrestacoes) {
                valParcelaAux = linhaSubArray[2]
                if (valParcelaAux > 0) {//Valor da Parcela existe
                    prestacaoGeral = prestacaoService.get(Integer.parseInt(linhaSubArray[0]))
                    def meioPag = MeioPagamento.findByDescricao(linhaSubArray[1].toString())
                    def user = usuarioLogado()
                    def valorOrigem = prestacaoGeral.valor
                    def valorParcela = valParcelaAux
                    def observacao = linhaSubArray[3].toString()
                    def tipoPrestacaoParcela = TipoPrestacao.get(3)//Tipo 'Parcela'

                    if (valorOrigem > valorParcela) {
                        prestacao1Service.pagarParcela(prestacaoGeral, meioPag, user, "Pago", valorParcela, tipoPrestacaoParcela, observacao)
                    }
                } else {//Paga Prestacao na totalidade
                    prestacaoGeral = prestacaoService.get(Integer.parseInt(linhaSubArray[0]))
                    def meioPag = MeioPagamento.findByDescricao(linhaSubArray[1].toString())
                    userModif = usuarioLogado()

                    emprestimoFechadoOuNao = prestacao1Service.pagarNormal(prestacaoGeral, meioPag, userModif, "Pago")
                }
            }
        } //Diferentes de mensais

        render(view: "create", model: [clienteList: clienteService.list(params), clienteCount: clienteService.count(), emprestimoFechadoOuNao: emprestimoFechadoOuNao])
//                respond clienteService.list(params), model:[clienteCount: clienteService.count(), emprestimoFechadoOuNao: emprestimoFechadoOuNao]
    }

    //Prestacao do proximo mes
    def proximaPrestacao(Prestacao prestacao) {
        def novaPrestacao = new Prestacao()
        novaPrestacao.setEstado('Pendente')
        novaPrestacao.setDataModif(new Date())
        novaPrestacao.setUserModif(usuarioLogado())
        novaPrestacao.setDataRegisto(new Date())
        novaPrestacao.setValor((emprestimoCapital.valorPedido * (emprestimoCapital.taxaJuros / 100)))
        Calendar limite = Calendar.getInstance()
        limite.setTime(prestacao.dataLimite)
        limite.add(Calendar.MONTH, 1)
        Date dataNovoPrazo = limite.getTime()
        novaPrestacao.setDataLimite(dataNovoPrazo)//Prazo da Prestacao do proximo mes
        novaPrestacao.setEmprestimo(emprestimoCapital)

        def ultimoNum = prestacao.numero
        def nrSeq3Digts = ultimoNum.substring(ultimoNum.size() - 3, ultimoNum.size())
        nrSeq3Digts = novoNumero(nrSeq3Digts)
        ultimoNum = prestacao.emprestimo.nrProcesso + nrSeq3Digts
        novaPrestacao.setNumero(ultimoNum)
        novaPrestacao.setTipoPrestacao(tipoPrestacaoRendaNormal)
        prestacaoService.save(novaPrestacao)//Salvando a prestacao
    }

    //Este metodo regista a prestacao (Juros) e a multa caso exista
    def pagarPrestacaoJuros(Prestacao prestacao) {
        if (haMulta) {
            //Fazer o pagamento da multa
            pagarMulta()
        }
        if (dataPrazo >= dataHoje) {//Se nao for ultimo mes, paga esta, cria a proxima e continua
            //Pagamento da prestacaoGeral (Multa)
            prestacao1Service.pagarNormal(prestacao, MeioPagamento.findByDescricao(meioPagJuros.toString()), userModif, "Pago")

            //Geracao da proxima prestacaoGeral
            proximaPrestacao(prestacao)

        } else if (dataPrazo < dataHoje) {
//Se for ultimo mes, verifica se ha excepcao, se houver, deve aumentar o prazo[Ainda nao tenho os controladores na view]
            if (excepcao) {//Ha excepcao
                //Paga este juros (Renda Normal)
                prestacao1Service.pagarNormal(prestacao, MeioPagamento.findByDescricao(meioPagJuros.toString()), userModif, "Pago")

                //Geracao da proxima prestacaoGeral
                proximaPrestacao(prestacao)

                //Cria o registro de auditoria
                def empAudit = new EmprestimoAuditoria()
                empAudit.setEmprestimo(emprestimoCapital)
                empAudit.setObservacao('A empresa da mais ' + mesesExcepcao + ' mes(es) ao cliente.')
                empAudit.setDataRegisto(new Date())
                empAudit.setCapitalAntigo(emprestimoCapital.capital)
                empAudit.setCapitalNovo(emprestimoCapital.capital)
                empAudit.setPrazoAntigo(emprestimoCapital.prazoPagamento)
                //Mais meses
                Calendar novoPrazo = Calendar.getInstance()
                novoPrazo.setTime(emprestimoCapital.prazoPagamento)
                novoPrazo.add(Calendar.MONTH, mesesExcepcao)
                Date dataNovoPrazo = novoPrazo.getTime()

                empAudit.setPrazoNovo(dataNovoPrazo)
                empAudit.setTipo('Prolongamento')
                empAudit.setUserResponsavel(usuarioLogado())
                emprestimoAuditoriaService.save(empAudit)

                //Aumenta prazo (muda o prazo do emprestimo)
                emprestimoCapital.setPrazoPagamento(dataNovoPrazo)
                emprestimoCapital.setDataModif(new Date())
                emprestimoCapital.setUserModif(usuarioLogado())
                emprestimoService.save(emprestimoCapital)

            } else {//Nao Ha excepcao [Ainda falta tratar, e como fica o emprestimo]
                //Paga a prestacaoGeral
                prestacao1Service.pagarNormal(prestacao, MeioPagamento.findByDescricao(meioPagJuros.toString()), userModif, "Pago")

                //Muda o estado do emprestimo para "Vencido"
                emprestimoCapital.setEstado('Vencido')
                emprestimoCapital.setDataModif(new Date())
                emprestimoCapital.setUserModif(usuarioLogado())
                emprestimoService.save(emprestimoCapital)
            }
        }
    }

    //Este metodo vai pagar uma parcecela da prestacaoGeral
    def pagarParcelaDaPrestacaoJuros(Prestacao prestacao) {
        if (haMulta) {//Se tiver multa, PAGA!
            //Fazer o pagamento da multa
            pagarMulta()
        }

        def parcelaJuros = new Prestacao()
        parcelaJuros.setEstado('Pago')
        parcelaJuros.setUserModif(usuarioLogado())
        parcelaJuros.setDataRegisto(new Date())
        parcelaJuros.setDataModif(new Date())
        parcelaJuros.setObservacao(obsJuros)
        parcelaJuros.setEmprestimo(emprestimoCapital)
        parcelaJuros.setTipoPrestacao(tipoPrestacaoParcela)
        //Geracao do Numero da parcela
        def numParcela = ''
        def parcelasAnteriores = 0
        prestacao.prestacoes.each {
            if (it.tipoPrestacao == tipoPrestacaoParcela) {
                parcelasAnteriores += 1
            }
        }
        numParcela = '' + parcelasAnteriores
        if (numParcela.size() == 1) {
            numParcela = '00' + numParcela
        }
        if (numParcela.size() == 2) {
            numParcela = '0' + numParcela
        }
        if (numParcela.size() == 3) {
            numParcela = '' + numParcela
        }
        parcelaJuros.setNumero(prestacao.numero + numParcela)
        parcelaJuros.setDataLimite(new Date())
        parcelaJuros.setValor(valParcelaAux)
        def meioPag = MeioPagamento.findByDescricao(meioPagJuros.toString())
        parcelaJuros.setMeioPagamento(meioPag)
        parcelaJuros.setDataPagamento(new Date())
        parcelaJuros.setDataParcela(new Date())
        parcelaJuros.setPrestacao(prestacao)
        //Ja pode ser salva a prestacaoGeral
        prestacaoService.save(parcelaJuros)
    }

    //Este metodo permite ao cliente devolver parte do valor (Juros+Capital)
//    def pagarCapitalParcela(Prestacao prestacao){
    def pagarCapitalParcela() {
        def nrSequenciaPrestac
        def ultimoNumero
        def prestacoesTodasPagas = true
        def msg = [:]
        def valorParcela = Double.parseDouble(params.valorParcela)
        def observacao = params.obs

        Emprestimo emprestimoDefaut = Emprestimo.get(Integer.parseInt(params.idEmp))
        EmprestimoAuditoria emprestimoAuditoria
        Prestacao prestacaoCapital = new Prestacao()

        if (emprestimoDefaut.valorPedido < valorParcela || valorParcela < 0) {
            msg['msg'] = 'O valor informado não deve ser maior que o capital actual ou menor que zero.'
        } else {
            //Para numero de prestacao
            ultimoNumero = emprestimoDefaut.prestacoes.last().numero
            nrSequenciaPrestac = ultimoNumero.substring(ultimoNumero.size() - 3, ultimoNumero.size())
            nrSequenciaPrestac = Integer.parseInt(nrSequenciaPrestac)
            nrSequenciaPrestac = novoNumero(nrSequenciaPrestac.toString())

            //A prestacao a ser salva
            prestacaoCapital.setEstado('Pago')
            prestacaoCapital.setUserRegisto(usuarioLogado())
            prestacaoCapital.setUserModif(usuarioLogado())
            prestacaoCapital.setDataRegisto(new Date())
            prestacaoCapital.setDataModif(new Date())
            prestacaoCapital.setObservacao(observacao)
            prestacaoCapital.setEmprestimo(emprestimoDefaut)
            prestacaoCapital.setTipoPrestacao(TipoPrestacao.get(5))
            prestacaoCapital.setNumero(emprestimoDefaut.nrProcesso + nrSequenciaPrestac)
            prestacaoCapital.setDataLimite(new Date())
            prestacaoCapital.setValor(valorParcela)

            //Verificacao se todas prestacoes foram pagas
            emprestimoDefaut.prestacoes.each {
                if (it.estado.equalsIgnoreCase('Pago') || it.estado.equalsIgnoreCase('Validado')) {
                    // A prestacao esta baga
                } else {
                    prestacoesTodasPagas = false
                }
            }

            //Muda estado do emprestimo
            if (prestacoesTodasPagas) {//Todas prestacoes pagas

                if (valorParcela >= emprestimoDefaut.valorPedido) {
                    //Capital a ser paga na totalidade (O estado muda para 'Fechado' e nao cria auditoria)
                    emprestimoDefaut.setEstado('Fechado')
                    //Sera actualizado no momento do registo da parcela
                } else {//Capital a ser paga na parcela
                    // Se nao For reducao na totalidade
                    //Auditoria
                    emprestimoAuditoria = emprestimoDefaut
                    emprestimoAuditoria.setEmprestimo(emprestimoDefaut)
                    emprestimoAuditoria.setObservacao('Reducao do capital')
                    emprestimoAuditoria.setDataRegisto(new Date())
                    emprestimoAuditoria.setTipo('Reducao_Capital')
                    emprestimoAuditoria.setPrestacao(prestacaoCapital)
                    emprestimoAuditoria.setCapitalNovo(emprestimoDefaut.valorPedido - valorParcela)
                    emprestimoAuditoria.setUserResponsavel(usuarioLogado())
                    emprestimoAuditoria.setVersion(0)
                    emprestimoDefaut.setValorPedido(emprestimoDefaut.valorPedido - valorParcela)
                    emprestimoDefaut.setObservacao(emprestimoDefaut.observacao + '\nCapital Reduzido.')
                    //Sera salvo no momento do registo da parcela
                }
            }else{
                emprestimoAuditoria = new EmprestimoAuditoria()
                emprestimoAuditoria.setPrazoNovo(emprestimoDefaut.prazoPagamento)
                emprestimoAuditoria.setPrazoAntigo(emprestimoDefaut.prazoPagamento)
                emprestimoAuditoria.setCapitalAntigo(emprestimoDefaut.capital)
                emprestimoAuditoria.setEmprestimo(emprestimoDefaut)
                emprestimoAuditoria.setObservacao('Reducao do capital')
                emprestimoAuditoria.setDataRegisto(new Date())
                emprestimoAuditoria.setTipo('Reducao_Capital')
                emprestimoAuditoria.setPrestacao(prestacaoCapital)
                emprestimoAuditoria.setCapitalNovo(emprestimoDefaut.valorPedido - valorParcela)
                emprestimoAuditoria.setUserResponsavel(usuarioLogado())
                emprestimoAuditoria.setVersion(0)
                emprestimoDefaut.setValorPedido(emprestimoDefaut.valorPedido - valorParcela)
                emprestimoDefaut.setObservacao(emprestimoDefaut.observacao + '\nCapital Reduzido.')
            }
        }

        try {
//            println('Prestacao: ' + prestacaoCapital.save(flush: true))
            println('Prestacao: ' + prestacaoService.save(prestacaoCapital))

            println('Default: ' + emprestimoDefaut.save(flush: true))
            emprestimoAuditoria.id = null
            println('Audit: ' + emprestimoAuditoria.save(flush: true))
            msg['msg'] = 'Salvo com sucesso'
        } catch (Exception e) {
            msg['msg'] = 'Erro: \n' + e.getMessage() + '\nContacte um técnico.'
        }


        render msg as JSON


////        prestacaoGeral = this.prestacaoGeral
//        //Se tiver multa vai pagar
//        if(haMulta){//Se tiver multa, PAGA!
//            //Fazer o pagamento da multa
//            pagarMulta()
//        }
//        //Se tiver Juros vai pagar
//        if(haJuros){
//            //Pagamento da prestacaoGeral (Multa)
//            prestacao.valor
//            prestacao1Service.pagarNormal(prestacao, MeioPagamento.findByDescricao(meioPagJuros.toString()), userModif, "Pago")
//        }
//
//        //Nova Prestacao Parcela Capital
//        def prestacaoCapitalParcela = new Prestacao()
//        prestacaoCapitalParcela.setDataPagamento(new Date())
//        prestacaoCapitalParcela.setMeioPagamento(MeioPagamento.findByDescricao(meioPagamentoCapital.toString()))
//        prestacaoCapitalParcela.setValor(capitalParcela)
//        prestacaoCapitalParcela.setDataLimite(emprestimoCapital.prazoPagamento)
//
//        def ultimoNumero = emprestimoCapital.prestacoes.last().numero
//        nrSequenciaPrestacao = ultimoNumero.substring(ultimoNumero.size()-3, ultimoNumero.size())
//        nrSequenciaPrestacao = novoNumero(nrSequenciaPrestacao)
//        ultimoNumero = emprestimoCapital.nrProcesso+nrSequenciaPrestacao
//        prestacaoCapitalParcela.setNumero(ultimoNumero)
//        prestacaoCapitalParcela.setTipoPrestacao(tipoPrestacaoParcelaCapital)
//        prestacaoCapitalParcela.setEmprestimo(emprestimoCapital)
//        prestacaoCapitalParcela.setObservacao(obsCapital)
//        prestacaoCapitalParcela.setDataModif(new Date())
//        prestacaoCapitalParcela.setDataRegisto(new Date())
//        prestacao.setUserModif(usuarioLogado())
//        prestacaoCapitalParcela.setEstado('Pago')
//        //Salvar prestacao capitalTotal
//        prestacaoService.save(prestacaoCapitalParcela)
//
//        def novoCapital = emprestimoCapital.valorPedido - capitalParcela
//
//        //Cria o registro de auditoria
//        def empAudit = new EmprestimoAuditoria()
//        empAudit.setEmprestimo(emprestimoCapital)
//        empAudit.setDataRegisto(new Date())
//        empAudit.setCapitalAntigo(emprestimoCapital.capital)
//        empAudit.setCapitalNovo(novoCapital)
//        empAudit.setPrazoAntigo(emprestimoCapital.prazoPagamento)
//        Calendar novoPrazo = Calendar.getInstance()
//        novoPrazo.setTime(emprestimoCapital.prazoPagamento)
//        novoPrazo.add(Calendar.MONTH, mesesExcepcao)
//        Date dataNovoPrazo = novoPrazo.getTime()
//        empAudit.setPrazoNovo(dataNovoPrazo)
//        empAudit.setTipo('Recapitalizacao')
//        empAudit.setUserResponsavel(usuarioLogado())
//        emprestimoAuditoriaService.save(empAudit)
//
//        //Recapitalizacao
//        emprestimoCapital.setValorPedido(novoCapital)
//        emprestimoCapital.setValorApagar((novoCapital * (emprestimoCapital.taxaJuros/100))+novoCapital)
//        emprestimoCapital.setDataModif(new Date())
//        emprestimoCapital.setUserModif(usuarioLogado())
//        emprestimoCapital.setPrazoPagamento(dataNovoPrazo)
//
//        //Ainda esta dentro do prazo
//        if(dataPrazo > dataHoje){//Se nao for ultimo mes, cria a proxima prestacaoGeral
//            def novaPrestacao = new Prestacao()
//            novaPrestacao.setEstado('Pendente')
//            novaPrestacao.setDataModif(new Date())
//            novaPrestacao.setUserModif(usuarioLogado())
//            novaPrestacao.setDataRegisto(new Date())
//            novaPrestacao.setValor(novoCapital * (emprestimoCapital.taxaJuros/100))
//
//            Calendar limite = Calendar.getInstance()
//            limite.setTime(prazo)
//            limite.add(Calendar.MONTH, 1)
//            dataNovoPrazo = limite.getTime()
//
//
//            novaPrestacao.setDataLimite(dataNovoPrazo)//Prazo da Prestacao do proximo mes
//            novaPrestacao.setEmprestimo(emprestimoCapital)
//            ultimoNumero = emprestimoCapital.prestacoes.last().numero
//            nrSequenciaPrestacao = ultimoNumero.substring(ultimoNumero.size()-3, ultimoNumero.size())
//            nrSequenciaPrestacao = Integer.parseInt(nrSequenciaPrestacao) + 1
//            nrSequenciaPrestacao = novoNumero(nrSequenciaPrestacao.toString())
//            ultimoNumero = emprestimoCapital.nrProcesso+nrSequenciaPrestacao
//            novaPrestacao.setNumero(ultimoNumero)
//            novaPrestacao.setTipoPrestacao(tipoPrestacaoRendaNormal)
//            prestacaoService.save(novaPrestacao)//Salvando a prestacaoGeral
//        }else if(dataPrazo <= dataHoje){//Se for ultimo mes, verifica se ha excepcao, se houver, deve aumentar o prazo[Ainda nao tenho os controladores na view]
//            if(!excepcao){//Nao ha excepcao
//                //Muda o estado do emprestimo para "Vencido"
//                emprestimoCapital.setEstado('Vencido')
//                emprestimoCapital.setDataModif(new Date())
//                emprestimoCapital.setUserModif(usuarioLogado())
//                emprestimoService.save(emprestimoCapital)
//            }
//        }
//        emprestimoService.save(emprestimoCapital)
    }

    //Este metodo permite ao cliente devolver todoo valor (Juros+Capital)
    def pagarCapitalTotaL(Prestacao prestacao) {
        //Se tiver multa vai pagar
        if (haMulta) {//Se tiver multa, PAGA!
            //Fazer o pagamento da multa
            pagarMulta()
        }
        //Se tiver Juros vai pagar
        if (haJuros) {
            //Pagamento da prestacaoGeral (Multa)
            prestacao1Service.pagarNormal(prestacao, MeioPagamento.findByDescricao(meioPagJuros.toString()), userModif, "Pago")
        }

        //Nova Prestacao Capital
        def prestacaoCapital = new Prestacao()
        prestacaoCapital.setDataPagamento(new Date())
        prestacaoCapital.setMeioPagamento(MeioPagamento.findByDescricao(meioPagamentoCapital.toString()))
        prestacaoCapital.setValor(capitalTotal)
        prestacaoCapital.setDataLimite(emprestimoCapital.prazoPagamento)

        def ultimoNumero = emprestimoCapital.prestacoes.last().numero

        def nrSequenciaPrestac = ultimoNumero.substring(ultimoNumero.size() - 3, ultimoNumero.size())
        nrSequenciaPrestac = Integer.parseInt(nrSequenciaPrestac)
        nrSequenciaPrestac = novoNumero(nrSequenciaPrestac.toString())


        prestacaoCapital.setNumero(emprestimoCapital.nrProcesso + nrSequenciaPrestac)
        prestacaoCapital.setTipoPrestacao(tipoPrestacaoCapital)
        prestacaoCapital.setEmprestimo(emprestimoCapital)
        prestacaoCapital.setObservacao(obsCapital)
        prestacaoCapital.setDataModif(new Date())
        prestacaoCapital.setDataRegisto(new Date())
        prestacao.setUserModif(usuarioLogado())
        prestacaoCapital.setEstado('Pago')
        //Salvar prestacao capitalTotal
        prestacaoService.save(prestacaoCapital)

        //Mudanca de estado do emprestimo para Fechado
        emprestimoCapital.setEstado('Fechado')
        emprestimoCapital.setDataModif(new Date())
        emprestimoCapital.setUserModif(usuarioLogado())
        emprestimoService.save(emprestimoCapital)

    }

    //Devolve o proximo numero
    def novoNumero(String nrPrestacao3Digitos) {
        def resultado = ''
        def stringCovertidaInt = Integer.parseInt(nrPrestacao3Digitos)

        stringCovertidaInt = stringCovertidaInt + 1
        def stringDeVolta = stringCovertidaInt.toString()
        if (stringDeVolta.size() == 3) {
            resultado = stringDeVolta
        }
        if (stringDeVolta.size() == 2) {
            resultado = '0' + stringDeVolta
        }
        if (stringDeVolta.size() == 1) {
            resultado = '00' + stringDeVolta
        }

        return resultado
    }

    //Pagamento da Multa
    def pagarMulta() {

    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond prestacaoService.list(params), model: [prestacaoCount: prestacaoService.count()]
    }

    def index1(Integer max) {
        params.max = Math.min(max ?: 8, 100)
        respond prestacaoService.list(params), model: [prestacaoCount: prestacaoService.count()]
    }

    def show(Long id) {
        respond prestacaoService.get(id)
//        Prestacao.
    }

    def prestacoesEmprestimo(Long emprestimoId) {//Listagem de prestacoes de um emprestimo
        Emprestimo emprestimo = Emprestimo.get(emprestimoId)
        def criterio = Prestacao.createCriteria()
        def prestacoes = criterio.list {
            eq("emprestimo", emprestimo)
            and {
                not {
                    eq("estado", "Pago")
                }
            }
            order("dataLimite", "asc")
        }
        render(template: "/prestacao/prestacoess.gsp", model: [meiosPagamento: meioPagamentoService.list(), prestacoes: prestacoes, emprestimo: emprestimo])
// ByEmprestimo(emprestimo)])
    }

    def create(Integer max) {

        def ok = methods.saltarDomingos(Date.parse("yyyy-MM-dd", (Emprestimo.get(1).dataInicioPagamento + 1).format("yyyy-MM-dd")))
        println('Data:'+ ok)
        params.max = Math.min(max ?: 7, 100)
        def emprestimoFechadoOuNao = false
        def emprestimos = Emprestimo.createCriteria().list(max: params.max, offset: params.offset) {
            or {
                eq('estado', 'Aberto')
                eq('estado', 'Vencido')
            }
            order("prazoPagamento")
        }
        respond emprestimos, model: [emprestimos: emprestimos, emprestimoCount: emprestimos.totalCount, emprestimoFechadoOuNao: emprestimoFechadoOuNao]
    }

    def save(Prestacao prestacao) {
        if (prestacao == null) {
            notFound()
            return
        }
        try {
            prestacaoService.save(prestacao)
        } catch (ValidationException e) {
            respond prestacao.errors, view: 'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'prestacaoGeral.label', default: 'Prestacao'), prestacao.id])
                redirect prestacao
            }
            '*' { respond prestacao, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond prestacaoService.get(id)
    }

    def update(Prestacao prestacao) {
        if (prestacao == null) {
            notFound()
            return
        }

        try {
            prestacaoService.save(prestacao)
        } catch (ValidationException e) {
            respond prestacao.errors, view: 'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'prestacaoGeral.label', default: 'Prestacao'), prestacao.id])
                redirect prestacao
            }
            '*' { respond prestacao, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        prestacaoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'prestacaoGeral.label', default: 'Prestacao'), id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'prestacaoGeral.label', default: 'Prestacao'), params.id])
                redirect action: "index", method: "GET"
            }
            '*' { render status: NOT_FOUND }
        }
    }


    /*Fader */

//    def salvarPrestacoes(Emprestimo emprestimo) {
//        List<Prestacao> prestacaoList = new ArrayList<>()
//        def contador = 1
//        Calendar calendar = Calendar.getInstance()
//        calendar.setTime(emprestimo.dataInicioPagamento)
//        def limite
//        while (contador < emprestimo.nrPrestacoes+1) {
//            limite = calendar.getTime()
//            Prestacao prestacao = new Prestacao()
//            prestacao.valor = params.valorPorPrestacao.toDouble()
//            prestacao.estado = "Pendente"
//            def zeros = (3 - (contador.toString().length()))
//            prestacao.numero = emprestimo.nrProcesso+methods.retornaZeros(zeros)+contador
//            prestacao.emprestimo = emprestimo
//            prestacao.setDataRegisto(emprestimo.dataRegisto)
//            prestacao.setDataModif(emprestimo.dataModif)
//            prestacao.setUserRegisto(emprestimo.userRegisto)
//            prestacao.setUserModif(emprestimo.userRegisto)
//            prestacao.dataLimite =  methods.saltarDomingos(Date.parse("yyyy-MM-dd", (limite).format("yyyy-MM-dd")))
//            prestacao.tipoPrestacao = TipoPrestacao.get(1)
//            prestacaoList.add(prestacao)
//            contador+=1
//            calendar.add(Calendar.MONTH, 1)
//        }
//        return prestacaoList
//    }


    IreportController ireportController = new IreportController()

    def pagamentos3() { //Aqui e realizado o registo de pagamentos

        def idPrestacao = 0;
        def tipoPrestacao = 0;
        def valorPrestacao = 0;
        def valorParcela = 0;
        def meioPagamento = 0;
        def contaPagamento = 0;
        def referenciaPagamento = '';
        def observacao = '';
        def prestacaoRecibo = null //FADER VARIAVEL
        List<Prestacao> prestacaoListRecibo = new ArrayList<>()

        String jsonObject = request.JSON
        def pagamentoPrestacoes = new JsonSlurper().parseText(jsonObject)
        userModif = usuarioLogado()
        def l1 = pagamentoPrestacoes[0]
        def idP1 = l1[0]
        def emprestimo = Prestacao.get(idP1).emprestimo

        for (linhaSubArray in pagamentoPrestacoes) {

            idPrestacao = linhaSubArray[0]
            tipoPrestacao = linhaSubArray[1]
            valorPrestacao = linhaSubArray[2]
            valorParcela = linhaSubArray[3]
            meioPagamento = linhaSubArray[4]
            contaPagamento = linhaSubArray[5]
            referenciaPagamento = linhaSubArray[6]
            observacao = linhaSubArray[7]

            def haParcela = false
            if (valorParcela > 0) {
                haParcela = true
            }

            if (haParcela) {
                def prestacaoGeral = prestacaoService.get(idPrestacao)
                def meioPag = MeioPagamento.get(meioPagamento)
                def user = usuarioLogado()
                def tipoPrestacaoParcela = TipoPrestacao.get(3)//Tipo 'Parcela'
                prestacaoRecibo = prestacao1Service.pagarParcela(prestacaoGeral, meioPag, user, "Pago", valorParcela, tipoPrestacaoParcela, observacao, contaPagamento, referenciaPagamento)
                //Adiciona aqui
                prestacaoListRecibo.add(prestacaoRecibo)
            } else {
                prestacaoGeral = prestacaoService.get(linhaSubArray[0])
                def meioPag = MeioPagamento.get(meioPagamento)
                userModif = usuarioLogado()

                prestacaoRecibo = prestacao1Service.pagarNormal(prestacaoGeral, meioPag, userModif, "Pago", observacao, contaPagamento, referenciaPagamento)
                //Adiciona aqui
                prestacaoListRecibo.add(prestacaoRecibo)
            }
        }

        ireportController.pdfRecibo(emprestimo, prestacaoListRecibo)
        methods.backupDB()
    }

    @Secured(['ROLE_ADMIN', 'ROLE_USER'])
    def verRecibo() {
        def ficha = new File(IreportController.reciboDir)
        render(file: ficha, contentType: 'application/pdf')
    }
}

}