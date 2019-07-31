package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured('ROLE_ADMIN')
class ContaBancariaController {

    ContaBancariaService contaBancariaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond contaBancariaService.list(params), model:[contaBancariaCount: contaBancariaService.count()]
    }

    def show(Long id) {
        respond contaBancariaService.get(id)
    }

    def create() {
        respond new ContaBancaria(params)
    }

    def save(ContaBancaria contaBancaria) {
        if (contaBancaria == null) {
            notFound()
            return
        }

        try {
            contaBancariaService.save(contaBancaria)
        } catch (ValidationException e) {
            respond contaBancaria.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'contaBancaria.label', default: 'ContaBancaria'), contaBancaria.id])
                redirect contaBancaria
            }
            '*' { respond contaBancaria, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond contaBancariaService.get(id)
    }

    def update(ContaBancaria contaBancaria) {
        if (contaBancaria == null) {
            notFound()
            return
        }

        try {
            contaBancariaService.save(contaBancaria)
        } catch (ValidationException e) {
            respond contaBancaria.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'contaBancaria.label', default: 'ContaBancaria'), contaBancaria.id])
                redirect contaBancaria
            }
            '*'{ respond contaBancaria, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        contaBancariaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'contaBancaria.label', default: 'ContaBancaria'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'contaBancaria.label', default: 'ContaBancaria'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
