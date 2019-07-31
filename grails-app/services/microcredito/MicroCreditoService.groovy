package microcredito

import grails.gorm.services.Service
import microcredito.MicroCredito

@Service(MicroCredito)
interface MicroCreditoService {

    MicroCredito get(Serializable id)

    List<MicroCredito> list(Map args)

    Long count()

    void delete(Serializable id)

    MicroCredito save(MicroCredito microCredito)

}