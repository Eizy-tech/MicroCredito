package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class TipoGarantiaController {

    TipoGarantiaService tipoGarantiaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond tipoGarantiaService.list(params), model:[tipoGarantiaCount: tipoGarantiaService.count()]
    }

    def show(Long id) {
        respond tipoGarantiaService.get(id)
    }

    def create() {
        respond new TipoGarantia(params)
    }

    def save(TipoGarantia tipoGarantia) {
        if (tipoGarantia == null) {
            notFound()
            return
        }

        try {
            tipoGarantiaService.save(tipoGarantia)
        } catch (ValidationException e) {
            respond tipoGarantia.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tipoGarantia.label', default: 'TipoGarantia'), tipoGarantia.id])
                redirect tipoGarantia
            }
            '*' { respond tipoGarantia, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond tipoGarantiaService.get(id)
    }

    def update(TipoGarantia tipoGarantia) {
        if (tipoGarantia == null) {
            notFound()
            return
        }

        try {
            tipoGarantiaService.save(tipoGarantia)
        } catch (ValidationException e) {
            respond tipoGarantia.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoGarantia.label', default: 'TipoGarantia'), tipoGarantia.id])
                redirect tipoGarantia
            }
            '*'{ respond tipoGarantia, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        tipoGarantiaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoGarantia.label', default: 'TipoGarantia'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoGarantia.label', default: 'TipoGarantia'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
