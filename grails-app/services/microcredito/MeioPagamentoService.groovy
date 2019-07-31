package microcredito

import grails.gorm.services.Service

@Service(MeioPagamento)
interface MeioPagamentoService {

    MeioPagamento get(Serializable id)

    List<MeioPagamento> list(Map args)

    Long count()

    void delete(Serializable id)

    MeioPagamento save(MeioPagamento meioPagamento)

}