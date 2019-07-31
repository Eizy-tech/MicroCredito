package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class MeioPagamentoController {

    MeioPagamentoService meioPagamentoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond meioPagamentoService.list(params), model:[meioPagamentoCount: meioPagamentoService.count()]
    }

    def show(Long id) {
        respond meioPagamentoService.get(id)
    }

    def create() {
        respond new MeioPagamento(params)
    }

    def save(MeioPagamento meioPagamento) {
        if (meioPagamento == null) {
            notFound()
            return
        }

        try {
            meioPagamentoService.save(meioPagamento)
        } catch (ValidationException e) {
            respond meioPagamento.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'meioPagamento.label', default: 'MeioPagamento'), meioPagamento.id])
                redirect meioPagamento
            }
            '*' { respond meioPagamento, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond meioPagamentoService.get(id)
    }

    def update(MeioPagamento meioPagamento) {
        if (meioPagamento == null) {
            notFound()
            return
        }

        try {
            meioPagamentoService.save(meioPagamento)
        } catch (ValidationException e) {
            respond meioPagamento.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'meioPagamento.label', default: 'MeioPagamento'), meioPagamento.id])
                redirect meioPagamento
            }
            '*'{ respond meioPagamento, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        meioPagamentoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'meioPagamento.label', default: 'MeioPagamento'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'meioPagamento.label', default: 'MeioPagamento'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
