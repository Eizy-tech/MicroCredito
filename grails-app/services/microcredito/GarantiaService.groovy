package microcredito

import grails.gorm.services.Service
import microcredito.Garantia

@Service(Garantia)
interface GarantiaService {

    Garantia get(Serializable id)

    List<Garantia> list(Map args)

    Long count()

    void delete(Serializable id)

    Garantia save(Garantia garantia)

}