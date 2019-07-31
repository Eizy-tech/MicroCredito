package microcredito

import grails.gorm.services.Service
import microcredito.Provincia

@Service(Provincia)
interface ProvinciaService {

    Provincia get(Serializable id)

    List<Provincia> list(Map args)

    Long count()

    void delete(Serializable id)

    Provincia save(Provincia provincia)

}