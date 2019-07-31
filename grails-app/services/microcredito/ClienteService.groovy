package microcredito

import grails.gorm.services.Service
import microcredito.Cliente

@Service(Cliente)
interface ClienteService {

    Cliente get(Serializable id)

    List<Cliente> list(Map args)

    Long count()

    void delete(Serializable id)

    Cliente save(Cliente cliente)

}