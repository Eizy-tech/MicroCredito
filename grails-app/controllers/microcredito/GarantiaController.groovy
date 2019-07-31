package microcredito

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import org.grails.core.io.ResourceLocator

import javax.annotation.Resource

import static org.springframework.http.HttpStatus.*
//@Secured('ROLE_ADMIN')
@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class GarantiaController {

    GarantiaService garantiaService
    def methods = new MethodsController()

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond garantiaService.list(params), model:[garantiaCount: garantiaService.count()]
    }

    def show(Long id) {
        respond garantiaService.get(id)
    }

    def create() {
        respond new Garantia(params)
    }

    def save(Garantia garantia) {
        if (garantia == null) {
            notFound()
            return
        }

        try {
            garantiaService.save(garantia)
        } catch (ValidationException e) {
            respond garantia.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'garantia.label', default: 'Garantia'), garantia.id])
                redirect garantia
            }
            '*' { respond garantia, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond garantiaService.get(id)
    }

    def update(Garantia garantia) {
        if (garantia == null) {
            notFound()
            return
        }

        try {
            garantiaService.save(garantia)
        } catch (ValidationException e) {
            respond garantia.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'garantia.label', default: 'Garantia'), garantia.id])
                redirect garantia
            }
            '*'{ respond garantia, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        garantiaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'garantia.label', default: 'Garantia'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'garantia.label', default: 'Garantia'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    ResourceLocator r1l

    def upload(){
//        def file = request.getFile('file')
//        def file = params.file
        def rs = [:]
//        if(file.empty){
//            rs["msg"]="vazio"
//        }else{
//            File f = grailsApplication.mainContext.getResource(file.originalFilename).file  //indica o diretorio dentro do project
//            file.transferTo(f)                                                              //transfere o file para diretorio indicado acima
//            f.renameTo(new File('grails-app/assets/images/'+file.originalFilename))         //remove o file para um diretorio especifico
//            rs["msg"]= "Done"
//        }
//        rs["msg"]=file
//        render rs as JSON


//        def files = request.getFiles('file[]')
//        for (def fi: files){
//            File f = grailsApplication.mainContext.getResource(fi.originalFilename).file  //indica o diretorio dentro do project
//            fi.transferTo(f)                                                              //transfere o file para diretorio indicado acima
//            f.renameTo(new File('grails-app/assets/images/'+fi.originalFilename))
//        }

        request.getMultiFileMap().file.each{
//            println it.originalFilename                                                     //'it' e filme
            File f = grailsApplication.mainContext.getResource(it.originalFilename).file    //indica o diretorio dentro do project
            it.transferTo(f)
            f.renameTo(new File('grails-app/assets/images/upload/'+it.originalFilename))    //transfere o file para diretorio indicado acima
        }

        rs["msg"]="Done"
        render rs as JSON
    }

    def salvarGarantia(Emprestimo emprestimo) {
        def nrGarantia = params.nrGarantias.toInteger() + 1
        def index = 1
        List<Garantia> garantiaList = new ArrayList<>()
        while (nrGarantia > index) {
            def indexString = index.toString()
            def garantia = new Garantia()
            def tipoGarantia = TipoGarantia.findByDescricao(params.get('tipoGarantia' + indexString).toString())

            if (!tipoGarantia) {
                tipoGarantia = new TipoGarantia()
                tipoGarantia.descricao = params.get('tipoGarantia' + indexString).toString()
                tipoGarantia.userModif = emprestimo.userModif
                tipoGarantia.userRegisto = emprestimo.userRegisto
                tipoGarantia.dataRegisto = emprestimo.dataRegisto
                tipoGarantia.dataModif = emprestimo.dataModif
                tipoGarantia.save()
            }

            garantia.tipoGarantia = tipoGarantia
            garantia.descricao = params.get('descricao' + indexString)
            garantia.valor = Double.parseDouble(params.get('valor' + indexString).toString())
            garantia.localizacao = params.get('localizacao' + indexString)
            garantia.latitude = Double.parseDouble(params.get('latitude' + indexString).toString())
            garantia.longitude = Double.parseDouble(params.get('longitude' + indexString).toString())
            garantia.dataRegisto = new Date()
            garantia.dataModif = new Date()
            garantia.userRegisto = emprestimo.userRegisto
            garantia.userModif = emprestimo.userModif
            garantia.emprestimo = emprestimo
            def fileUpload = request.getFile('foto' + indexString)
            def credito = 'Credito'
            if (!fileUpload.empty) {
                def fullNameQuebra = fileUpload.originalFilename.toString().split("\\.")//quebra o nome original comm ..
                def extensao = fullNameQuebra[fullNameQuebra.length - 1]
                def nomeFoto = 'IMG_' + System.currentTimeMillis() + indexString + '.' + extensao
                File destino = grailsApplication.mainContext.getResource(fileUpload.originalFilename).file
                fileUpload.transferTo(destino)//transfere o file para diretorio statico
                if (emprestimo.cliente.id) {
                    def list = Emprestimo.createCriteria().list { eq('cliente', emprestimo.cliente) }
                    credito += list.size() + 1
                } else {
                    credito += 1
                }
                destino.renameTo(new File('D:/Dropbox/Microcredito/' + emprestimo.cliente.codigo + '_' + methods.semAcentos(emprestimo.cliente.nome) + '/' + credito + '/upload/' + nomeFoto))
                garantia.foto = nomeFoto
            }
            garantiaList.add(garantia)
            index += 1
        }
        return garantiaList
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def showImage(){
        def garantia = Garantia.get(params.id)
        def emprestimo = Emprestimo.get(garantia.emprestimo.id)
        def nrPrecesso = emprestimo.nrProcesso.substring(emprestimo.nrProcesso.length()-4)
        def credito = '/Credito'+Integer.parseInt(nrPrecesso)+'/upload/'
        def pasta = 'D:/Dropbox/Microcredito/'+emprestimo.cliente.codigo+'_'+methods.semAcentos(emprestimo.cliente.nome)+credito+garantia.foto
        if(garantia.foto){
            render file: new File(pasta).bytes, contentType: ''
            println('tem foto da garantia')
        }else{
            render file: new File('D:/Dropbox/Microcredito/jasper/logo.jpg').bytes, contentType: ''
            println('nao tem foto da garantia')
        }
    }
}