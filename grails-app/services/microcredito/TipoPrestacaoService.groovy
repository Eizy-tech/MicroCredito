package microcredito

import grails.gorm.transactions.Transactional
import microcredito.Prestacao
import microcredito.TipoPrestacao

@Transactional(readOnly = true)
class TipoPrestacaoService {

    def create() {

        [tipoPrestacao: TipoPrestacao.list(), prestacoes: Prestacao.list()]
    }

    @Transactional
    def save() {
        [tipoPrestacao:tipoPrestacaoService.list()]
    }


}
