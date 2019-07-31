package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

@Secured(['ROLE_ADMIN', 'ROLE_USER'])
class TipoPrestacaoController {

    TipoPrestacaoService tipoPrestacaoService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond tipoPrestacaoService.list(params), model:[tipoPrestacaoCount: tipoPrestacaoService.count()]
    }

    def show(Long id) {
        respond tipoPrestacaoService.get(id)
    }

    def create() {
        respond new TipoPrestacao(params)
    }

    def save(TipoPrestacao tipoPrestacao) {
        if (tipoPrestacao == null) {
            notFound()
            return
        }

        try {
            tipoPrestacaoService.save(tipoPrestacao)
        } catch (ValidationException e) {
            respond tipoPrestacao.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'tipoPrestacao.label', default: 'TipoPrestacao'), tipoPrestacao.id])
                redirect tipoPrestacao
            }
            '*' { respond tipoPrestacao, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond tipoPrestacaoService.get(id)
    }

    def update(TipoPrestacao tipoPrestacao) {
        if (tipoPrestacao == null) {
            notFound()
            return
        }

        try {
            tipoPrestacaoService.save(tipoPrestacao)
        } catch (ValidationException e) {
            respond tipoPrestacao.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'tipoPrestacao.label', default: 'TipoPrestacao'), tipoPrestacao.id])
                redirect tipoPrestacao
            }
            '*'{ respond tipoPrestacao, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        tipoPrestacaoService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'tipoPrestacao.label', default: 'TipoPrestacao'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'tipoPrestacao.label', default: 'TipoPrestacao'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
