package microcredito

import grails.gorm.services.Service
import microcredito.Distrito

@Service(Distrito)
interface DistritoService {

    Distrito get(Serializable id)

    List<Distrito> list(Map args)

    Long count()

    void delete(Serializable id)

    Distrito save(Distrito distrito)

}