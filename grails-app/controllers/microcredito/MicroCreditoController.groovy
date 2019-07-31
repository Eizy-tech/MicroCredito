package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class MicroCreditoController {

    MicroCreditoService microCreditoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond microCreditoService.list(params), model:[microCreditoCount: microCreditoService.count()]
    }

    def show(Long id) {
        respond microCreditoService.get(id)
    }

    def create() {
        respond new MicroCredito(params)
    }

    def save(MicroCredito microCredito) {
        if (microCredito == null) {
            notFound()
            return
        }

        try {
            microCreditoService.save(microCredito)
        } catch (ValidationException e) {
            respond microCredito.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'microCredito.label', default: 'MicroCredito'), microCredito.id])
                redirect microCredito
            }
            '*' { respond microCredito, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond microCreditoService.get(id)
    }

    def update(MicroCredito microCredito) {
        if (microCredito == null) {
            notFound()
            return
        }

        try {
            microCreditoService.save(microCredito)
        } catch (ValidationException e) {
            respond microCredito.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'microCredito.label', default: 'MicroCredito'), microCredito.id])
                redirect microCredito
            }
            '*'{ respond microCredito, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        microCreditoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'microCredito.label', default: 'MicroCredito'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'microCredito.label', default: 'MicroCredito'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
