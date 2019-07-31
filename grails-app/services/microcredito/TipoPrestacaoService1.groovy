package microcredito

import grails.gorm.services.Service
import microcredito.TipoPrestacao

@Service(TipoPrestacao)
interface TipoPrestacaoService1 {

    TipoPrestacao get(Serializable id)

    List<TipoPrestacao> list(Map args)

    Long count()

    void delete(Serializable id)

    TipoPrestacao save(TipoPrestacao tipoPrestacao)

}