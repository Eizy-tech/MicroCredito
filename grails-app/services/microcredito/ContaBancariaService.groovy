package microcredito

import grails.gorm.services.Service

@Service(ContaBancaria)
interface ContaBancariaService {

    ContaBancaria get(Serializable id)

    List<ContaBancaria> list(Map args)

    Long count()

    void delete(Serializable id)

    ContaBancaria save(ContaBancaria contaBancaria)

}