package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class DistritoController {

    DistritoService distritoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond distritoService.list(params), model:[distritoCount: distritoService.count()]
    }

    def show(Long id) {
        respond distritoService.get(id)
    }

    def create() {
        respond new Distrito(params)
    }

    def save(Distrito distrito) {
        if (distrito == null) {
            notFound()
            return
        }

        try {
            distritoService.save(distrito)
        } catch (ValidationException e) {
            respond distrito.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'distrito.label', default: 'Distrito'), distrito.id])
                redirect distrito
            }
            '*' { respond distrito, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond distritoService.get(id)
    }

    def update(Distrito distrito) {
        if (distrito == null) {
            notFound()
            return
        }

        try {
            distritoService.save(distrito)
        } catch (ValidationException e) {
            respond distrito.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'distrito.label', default: 'Distrito'), distrito.id])
                redirect distrito
            }
            '*'{ respond distrito, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        distritoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'distrito.label', default: 'Distrito'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'distrito.label', default: 'Distrito'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
