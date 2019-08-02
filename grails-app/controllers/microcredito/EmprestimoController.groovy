package microcredito

import com.lowagie.text.pdf.PdfRendition
import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import grails.plugins.jasper.JasperReportDef
import grails.plugins.jasper.JasperService
import net.sf.jasperreports.engine.JRReport
import net.sf.jasperreports.engine.JasperReport
import net.sf.jasperreports.engine.export.PdfTextRenderer
import org.apache.commons.io.FileUtils
import groovy.json.JsonSlurper
import org.springframework.ui.jasperreports.JasperReportsUtils

import java.text.Normalizer
import java.text.NumberFormat

import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN' , 'ROLE_USER'])
class EmprestimoController {

    EmprestimoService emprestimoService
    TipoDocumentoService tipoDocumentoService
    ClienteService clienteService
    ModoPagamentoService modoPagamentoService
    def springSecurityService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def usuarioLogado(){
        def user = (User)springSecurityService.currentUser
        return user
    }

    def index(Integer max) {

//        IreportController ireportController = new IreportController('D:/')
//        ireportController.pdfContrato(Emprestimo.get(13)) //gera contrato
//        ireportController.pdfPrestacoes(Emprestimo.get(13)) //gera contrato

        def userPerfil = usuarioLogado().perfil.id
        def filtro = false
        def emprestimosCopia =  Emprestimo.createCriteria().list (){
            order("prazoPagamento")
        }
        params.max = Math.min(max ?: 10, 100)
        def emprestimos =  Emprestimo.createCriteria().list (params){
            order("prazoPagamento")
        }


        def prazo = MicroCredito.get(1).prazo

        if(new Date().after(prazo)){
//            println('ja erra')
            render(view: "/microCredito/info")
        }else{
            render(view: "index", model:[
                    userPerfil: userPerfil,filtro: filtro, emprestimoList: emprestimos , emprestimosCopia: emprestimosCopia, emprestimoCount: emprestimos.totalCount
            ])
        }
    }

    def filtro(Integer max){
        def userPerfil = usuarioLogado().perfil.id
        boolean filtro = true
        def cliente
        def modalidadePagamento
        def estado
        def userRegist
        def data1
        def data2
        def taxaJuros
        if (params.idCliente){ cliente =  Cliente.get(params.idCliente)}
        if (params.idModalidade){
            modalidadePagamento = ModoPagamento.get(params.idModalidade)
//            println('Mabjaia   :'+modalidadePagamento.descricao)
        }
        if (params.idUser){ userRegist = User.get(params.idUser)}
        if (params.estadoEmprestimo){
            estado = (String) params.estadoEmprestimo
            if(estado.equalsIgnoreCase('Todos [Estados]')){
                estado = null
            }
        }
        if (params.dataRange1){
            data1 = new Date().parse("dd.MM.yyy", params.dataRange1).format("dd.MM.YYYY")
            data1 = new Date().parse("dd.MM.yyy", data1)
        }
        if (params.dataRange2){
            data2 = new Date().parse("dd.MM.yyy", params.dataRange2).format("dd.MM.YYYY")
            data2 = new Date().parse("dd.MM.yyy", data2)
        }
        if (params.taxaJuros){ taxaJuros = Double.parseDouble(params.taxaJuros)}


        def criterio = Emprestimo.createCriteria()
        def emprestimosCopia = criterio.list () {

            and {
                if (modalidadePagamento) {
                    eq("modoPagamento", modalidadePagamento)
                }
                if (estado) {
                    eq("estado", estado)
                }
                if (cliente) {
                    eq("cliente", cliente)
                }
                if (userRegist) {
                    eq("userRegisto", userRegist)
                }
                if (data1 && data2) {
                    between("prazoPagamento", data1, data2)
                }
                if (taxaJuros) {
                    eq("taxaJuros", taxaJuros)
                }
            }
            order("prazoPagamento", "asc")
        }

        params.max = Math.min(max ?: 10, 100)
        def criterio1 = Emprestimo.createCriteria()
//        def emprestimoList = criterio1.list (max: params.max, offset: params.offset) {
        def emprestimoList = criterio1.list (params) {
            and {
                if (modalidadePagamento){
                    eq("modoPagamento", modalidadePagamento)
                }
                if (estado){
                    eq("estado", estado)
                }
                if(cliente){
                    eq("cliente", cliente)
                }
                if (userRegist){
                    eq("userRegisto", userRegist)
                }
                if(data1 && data2){
                    between("prazoPagamento", data1, data2)
                }
                if (taxaJuros){
                    eq("taxaJuros", taxaJuros)
                }
            }
            order("prazoPagamento", "asc")
        }
        render(template:"/emprestimo/filtro.gsp",model:[
                userPerfil: userPerfil,filtro: filtro, emprestimoList: emprestimoList , emprestimosCopia: emprestimosCopia, emprestimoCount: emprestimoList.totalCount
        ])
    }

    def emprestimoPrestacoes(){
        def emprestimo = null
        if (params.referenciaEmprestimo){
            emprestimo = Emprestimo.get(params.referenciaEmprestimo)
        }
        render(template:"/emprestimo/emprestimoPrestacoes.gsp",model:[emprestimo: emprestimo])//
    }

    def relatorio(){

        def criteria = Emprestimo.createCriteria()

        def emprestimos = criteria.list {
            order('cliente')
        }

        render(view: "relatorio", model: [emprestimos: emprestimos])
    }

    def devedoresHoje(){
        def emprestimos = Emprestimo.createCriteria().list(params){
            or {
                eq('estado', 'Aberto')
                eq('estado', 'Vencido')
            }
        }
        render(template:"/emprestimo/devedoresHoje.gsp",model:[emprestimos: emprestimos])//
    }

    def show(Long id) {
        respond emprestimoService.get(id)
    }

    def create() {
        println('fader')
        respond new Emprestimo(params),
                model: ['tipoDocumentoList': TipoDocumento,
                        'provinciaList':Provincia.list(), 'distritoList':Distrito.list(),
                        'modoPagamentoList':ModoPagamento.createCriteria().list {order('nrDias')},
                        'tipoCasaList':TipoCasa.list(),
                        'destinoCreditoList':DestinoCredito.list(),
                        'cliente': Cliente,
                        'avalistas':Cliente.createCriteria().list {eq('estado','Activo')}
                ]
    }

    def save(Emprestimo emprestimo) {
        if (emprestimo == null) {
            notFound()
            return
        }

        try {
            emprestimoService.save(emprestimo)
        } catch (ValidationException e) {
            respond emprestimo.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'emprestimo.label', default: 'Emprestimo'), emprestimo.id])
                redirect emprestimo
            }
            '*' { respond emprestimo, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond emprestimoService.get(id)
    }

    def update(Emprestimo emprestimo) {
        if (emprestimo == null) {
            notFound()
            return
        }

        try {
            emprestimoService.save(emprestimo)
        } catch (ValidationException e) {
            respond emprestimo.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'emprestimo.label', default: 'Emprestimo'), emprestimo.id])
                redirect emprestimo
            }
            '*'{ respond emprestimo, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        emprestimoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'emprestimo.label', default: 'Emprestimo'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'emprestimo.label', default: 'Emprestimo'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
            '*'{ render status: NOT_FOUND }
        }
    }

    def getDistrito(){
        def provincia = Provincia.get(params.id)
        def distritos = Distrito.findAllByProvincia(provincia)
        render(template: "/distrito/comboDistritos", model: ['distritos': distritos])
    }



    def clientController = new ClienteController()
    def garantiaController = new GarantiaController()
    def prestacaoController = new PrestacaoController()
    def methods = new MethodsController()
    def pdfDestino =''

    def salvar() {
        def cliente
        def idCliente = params.idCliente.toInteger()
        if (idCliente == 0) {
            cliente = clientController.salvarCliente(new Cliente())
            cliente.codigo = clientController.codigoCliente()

            cliente.dataEmissao = Date.parse("yyyy-MM-dd", methods.dataPicker(params.dataEmissao))
            cliente.dataValidade = Date.parse("yyyy-MM-dd", methods.dataPicker(params.dataValidade))
        } else {
            cliente = clientController.salvarCliente(Cliente.get(idCliente))
        }

        cliente.userRegisto = usuarioLogado()
        cliente.userModif = usuarioLogado()

        def emprestimo = new Emprestimo()
        emprestimo.valorPedido = params.valorPedido.toDouble()
        emprestimo.taxaJuros = params.taxaJuros.toDouble()
        emprestimo.taxaMulta = params.taxaMulta.toDouble()
        emprestimo.valorApagar = params.valorApagar.toDouble()
        emprestimo.capital = params.valorApagar.toDouble()
        emprestimo.nrPrestacoes = params.nrPrestacoes.toInteger()
        emprestimo.userRegisto = cliente.userRegisto
        emprestimo.userModif = cliente.userModif
        emprestimo.dataInicioPagamento = Date.parse('yyyy-MM-dd', methods.dataPicker(params.dataInicioPagamento))
        emprestimo.prazoPagamento = Date.parse('yyyy-MM-dd', methods.dataPicker(params.dataPrazo))

        emprestimo.dataModif = new Date()
        emprestimo.dataRegisto = new Date()
        emprestimo.instituicoescredito = params.instituicoescredito
        emprestimo.bancos = params.bancos
        emprestimo.experienciaNegocio = params.experienciaNegocio
        emprestimo.destinoCredito = params.destinoCredito
        emprestimo.localNegocio = params.localNegocio
        emprestimo.tipoNegocio = params.tipoNegocio
        emprestimo.estado = "Aberto"
        emprestimo.cliente = cliente
        emprestimo.testemunhas = params.testemunhas

        def modoPagamento = ModoPagamento.findByDescricao(params.modoPagamento)
        emprestimo.setModoPagamento(modoPagamento)
        emprestimo.nrProcesso = numeroProcesso(emprestimo)
        emprestimo.garantias = garantiaController.salvarGarantia(emprestimo)
        emprestimo.prestacoes = prestacaoController.salvarPrestacoes(emprestimo)
        emprestimo.nrRecibo = 0
        emprestimo.avalista = params.avalista

        List<Emprestimo> emprestimoList = new ArrayList<>()
        emprestimoList.add(emprestimo)
        cliente.emprestimos = emprestimoList
        def msg = [:]
        try {
            cliente.save(flush: true)
            msg['msg'] = "Salvo Com Sucesso"
            IreportController ireportController = new IreportController(pdfDestino)
            ireportController.pdfContrato(emprestimo) //gera contrato
            ireportController.pdfPrestacoes(emprestimo)
            methods.backupDB()
        } catch (Exception e) {
            msg['msg'] = e.getMessage()
        }
        render msg as JSON
    }

    /*funcao de gera numero de processo de emprestimo*/
    def numeroProcesso(Emprestimo emp) {
        def count = Emprestimo.getCount()
        def codigo = ""
        if (count < 9999) {
            def dirFile = 'D:/Dropbox/Microcredito'
            if(!new File(dirFile).isDirectory()){
                new File(dirFile).mkdir()
            }
            def dir = (dirFile+'/' + emp.cliente.codigo.trim() + '_' + methods.semAcentos(emp.cliente.nome)).trim()
            def vezes=1             //numero de emprestimos efectuados por um cliente
            if (emp.cliente.id) {   //caso o cliente ja tenha sido registado
                def list = Emprestimo.createCriteria().list { eq('cliente', emp.cliente) }
                def length = (list.size() + 1).toString().length()                  //leva o length numero de numero de emprestimos efecuador por cliente
                for (def i = length; i < 4; i++) {
                    codigo += '0'
                }
                vezes = list.size()+1
                codigo += + vezes
                if(!new File(dir).isDirectory()){
                    new File(dir).mkdir()
                }
            } else {
                codigo += '000'+vezes
                new File(dir).mkdir()
            }
            if(!new File(dir + '/Credito' + vezes).isDirectory()){
                new File(dir + '/Credito' + vezes).mkdir()
                new File(dir + '/Credito' + vezes + '/upload').mkdir()
                new File(dir + '/Credito' + vezes + '/recibos').mkdir()
            }
            pdfDestino = dir + '/Credito' + vezes+'/'
        }
        def nrCliente = emp.cliente.codigo
        def nrEmprestimo = codigo.toString()
        return nrCliente + nrEmprestimo //codigo: cccceeee
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def salvarAvalista() {
        def cliente = clientController.salvarCliente(new Cliente())
        cliente.codigo = clientController.codigoCliente()
        cliente.dataEmissao = Date.parse("yyyy-MM-dd", params.dataEmissao)
        cliente.dataValidade = Date.parse("yyyy-MM-dd", params.dataValidade)
        cliente.userModif = usuarioLogado()
        cliente.userRegisto = usuarioLogado()
        cliente.save()
        render(template: "/cliente/avalistaCombo", model: ['cliente': Cliente])
    }

    def addGarantiaForm() {
        render(template: "/garantia/form", model: ['tipoGarantiaList': TipoGarantia.createCriteria().list {
            order('descricao')
        }])
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def getDetalhes(){
        def emprestimo = Emprestimo.get(params.id)
        List<Testemunha> listTestemunha = new ArrayList<>()
        if (emprestimo.testemunhas){
            def jsonTestemunhas = new JsonSlurper().parseText(emprestimo.testemunhas)
            for (def i = 0; i < jsonTestemunhas.size(); i++) {
                Testemunha test = new Testemunha()
                test.nome = jsonTestemunhas[i].Nome
                test.endereco = jsonTestemunhas[i].Endereco
                test.contacto = jsonTestemunhas[i].Contacto
                test.grau = jsonTestemunhas[i].Grau_de_Parentesco
                listTestemunha.add(test)
            }
        }
        render(template: '/emprestimo/detalhes',model: [garantias: emprestimo.garantias,testenunbas:listTestemunha,emprestimo: emprestimo])
    }

    class Testemunha {
        String nome, contacto, endereco, grau
    }
}