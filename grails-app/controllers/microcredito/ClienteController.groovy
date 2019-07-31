package microcredito

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import groovy.json.JsonSlurper

import static org.springframework.http.HttpStatus.*

class ClienteController {
    ClienteService clienteService
    User1Service user1Service

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def index(Integer max) {
        def userPerfil = usuarioLogado().perfil.id
        def filtro = false
        params.max = Math.min(max ?: 10, 100)
        def clienteList = Cliente.createCriteria().list(params){
            order('nome')
        }
        render(view: "index", model:[userPerfil: userPerfil, clienteList: clienteList, filtro: filtro, clienteCount: clienteList.totalCount])
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def filtro(Integer max){
        def userPerfil = usuarioLogado().perfil.id
        def filtro = true
        def nome
        def estado
        def data1
        def data2
//        if (params.codigo){ codigo =  Cliente.get(params.codigo)}
        params.max = Math.min(max ?: 10, 100)
        if (params.nome != 'null'){
            nome = (String) params.nome
            if(nome.equalsIgnoreCase('Pesquisar Cliente')){
                nome = null
            }
        }
        if (params.estado){
            estado = (String) params.estado
            if(estado.equalsIgnoreCase('Todos Estados')){
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

        def criterio = Cliente.createCriteria()
        def clienteList = criterio.list(params) {
            and {
                if (estado){
                    eq("estado", estado)
                }
                if (data1 && data2){
                    between("dataRegisto", data1, data2)
                }
                if (nome) {
                    like("nome", "%"+nome+"%")
                }
            }
            order("nome")
        }
        render(template:"/cliente/filtro_cliente.gsp",model:[userPerfil: userPerfil, clienteList: clienteList, filtro: filtro, clienteCount: clienteList.totalCount])
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def mudaEstadoCliente(){
        String jsonObject = request.JSON
        def dados = new JsonSlurper().parseText(jsonObject) // Recebendo os dados enviados na view

        def idCliente = Integer.parseInt(dados[0])
        def cliente = Cliente.get(idCliente)
        def estadoActual = cliente.estado
        def estadoNovo = ''

        if(estadoActual.equalsIgnoreCase('Activo')){
            estadoNovo = 'Inactivo'

        }else{
            estadoNovo = 'Activo'
        }

        cliente.setEstado(estadoNovo)
        cliente.setUserModif(usuarioLogado())
        cliente.setDataModif(new Date())

        clienteService.save(cliente)
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def numeroPrestacao(def numero){
        def codigo = ""
        def length = (numero).toString().length()
        if(numero < 999) {
            for (def i = length; i < 3; i++) {
                codigo += '0'
            }
        }
        return  codigo
    }

    def show(Long id) {
        respond clienteService.get(id)
    }
    def springSecurityService

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def usuarioLogado(){
        def user = (User)springSecurityService.currentUser
        return user
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def create() {

//        usuarioLogado()
//        println userDetailService.user(springSecurityService.principal.username)
//        def d = (User)springSecurityService.currentUser
//        println d.class
        respond new Cliente(params)
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def save(Cliente cliente) {
        if (cliente == null) {
            notFound()
            return
        }

        try {
            clienteService.save(cliente)
        } catch (ValidationException e) {
            respond cliente.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'cliente.label', default: 'Cliente'), cliente.id])
                redirect cliente
            }
            '*' { respond cliente, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond clienteService.get(id)
    }

    def update(Cliente cliente) {
        if (cliente == null) {
            notFound()
            return
        }

        try {
            clienteService.save(cliente)
        } catch (ValidationException e) {
            respond cliente.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'cliente.label', default: 'Cliente'), cliente.id])
                redirect cliente
            }
            '*'{ respond cliente, [status: OK] }
        }
    }


    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'cliente.label', default: 'Cliente'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
    MethodsController methods = new MethodsController()

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def salvarCliente(Cliente cliente) {
        cliente.nome = params.nomeCompleto.toString().trim()
        cliente.estadoCivil = params.estadoCivil
        cliente.nomeConjuge = params.nomeConjuge
        cliente.tipoContrato = params.tipoContrato
        cliente.anoAdmissao = params.anoAdmissao
        cliente.nrDependentes = methods.retornaInt(params.nrDependentes)
        cliente.nrFilhos = methods.retornaInt(params.nrFihos)
        cliente.estado = "Activo"
        cliente.nrDocumento = params.nrDocumento
        cliente.localEmissao = params.localEmissao
        cliente.dataEmissao = Date.parse("yyyy-MM-dd", methods.dataPicker(params.dataEmissao))
        cliente.dataValidade = Date.parse("yyyy-MM-dd", methods.dataPicker(params.dataValidade))
        cliente.contacto1 = params.contacto1
        cliente.contacto2 = params.contacto2
        cliente.email = params.email
        cliente.endereco = params.endereco.toString().trim()
        cliente.tipoCasa = params.tipoCasa
        cliente.amplitude = methods.retornaDouble(params.amplitude)
        cliente.longitude = methods.retornaDouble(params.longitude)
        cliente.nacionalidade = params.nacionalidade
        cliente.naturalidade = params.naturalidade
        def tipoDocumento = TipoDocumento.get(params.tipoDocumento)
        cliente.tipoDocumento = tipoDocumento

        def distrito = Distrito.get(params.distrito)
        cliente.distrito = distrito
        cliente.dataRegisto = new Date()
        cliente.dataModif = new Date()

        return cliente
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def codigoCliente() {
        def count = Cliente.getCount()
//        def count = Cliente.find(id: max)
        def length = (count + 1).toString().length()
        def codigo = ""
        if (count < 9999) {
            for (def i = length; i < 4; i++) {
                codigo += '0'
            }
            codigo += (count + 1)
        }
        return codigo
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def getClienteData() {
        render Cliente.get(params.id) as JSON
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def getClientes() {
        render(template: 'clienteCombo', model: [clientes: Cliente.createCriteria().list { order('nome') eq('estado','Activo') }])
    }


    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def getClienteDetalhes(){
        render(template: '/cliente/dados',model: [cliente: Cliente.get(params.id)])
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def showImage(){
        render file: new File('D:/Dropbox/Microcredito/jasper/logo.jpg').bytes, contentType: ''
    }
}