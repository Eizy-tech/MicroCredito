package microcredito

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class EmprestimoAuditoriaController {

    EmprestimoAuditoriaService emprestimoAuditoriaService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond emprestimoAuditoriaService.list(params), model:[emprestimoAuditoriaCount: emprestimoAuditoriaService.count()]
    }

    def show(Long id) {
        respond emprestimoAuditoriaService.get(id)
    }

    def create() {
        respond new EmprestimoAuditoria(params)
    }

    def save(EmprestimoAuditoria emprestimoAuditoria) {
        if (emprestimoAuditoria == null) {
            notFound()
            return
        }

        try {
            emprestimoAuditoriaService.save(emprestimoAuditoria)
        } catch (ValidationException e) {
            respond emprestimoAuditoria.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'emprestimoAuditoria.label', default: 'EmprestimoAuditoria'), emprestimoAuditoria.id])
                redirect emprestimoAuditoria
            }
            '*' { respond emprestimoAuditoria, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond emprestimoAuditoriaService.get(id)
    }

    def update(EmprestimoAuditoria emprestimoAuditoria) {
        if (emprestimoAuditoria == null) {
            notFound()
            return
        }

        try {
            emprestimoAuditoriaService.save(emprestimoAuditoria)
        } catch (ValidationException e) {
            respond emprestimoAuditoria.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'emprestimoAuditoria.label', default: 'EmprestimoAuditoria'), emprestimoAuditoria.id])
                redirect emprestimoAuditoria
            }
            '*'{ respond emprestimoAuditoria, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        emprestimoAuditoriaService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'emprestimoAuditoria.label', default: 'EmprestimoAuditoria'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'emprestimoAuditoria.label', default: 'EmprestimoAuditoria'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
