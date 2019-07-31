package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class TipoDocumentoController {

    TipoDocumentoService tipoDocumentoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond tipoDocumentoService.list(params), model:[tipoDocumentoCount: tipoDocumentoService.count()]
    }

    def show(Long id) {
        respond tipoDocumentoService.get(id)
    }

    def create() {
        respond new TipoDocumento(params)
    }

    def save(TipoDocumento tipoDocumento) {
        if (tipoDocumento == null) {
            notFound()
            return
        }

        try {
            tipoDocumentoService.save(tipoDocumento)
        } catch (ValidationException e) {
            respond tipoDocumento.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tipoDocumento.label', default: 'TipoDocumento'), tipoDocumento.id])
                redirect tipoDocumento
            }
            '*' { respond tipoDocumento, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond tipoDocumentoService.get(id)
    }

    def update(TipoDocumento tipoDocumento) {
        if (tipoDocumento == null) {
            notFound()
            return
        }

        try {
            tipoDocumentoService.save(tipoDocumento)
        } catch (ValidationException e) {
            respond tipoDocumento.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoDocumento.label', default: 'TipoDocumento'), tipoDocumento.id])
                redirect tipoDocumento
            }
            '*'{ respond tipoDocumento, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        tipoDocumentoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoDocumento.label', default: 'TipoDocumento'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoDocumento.label', default: 'TipoDocumento'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
