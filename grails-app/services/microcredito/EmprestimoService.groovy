package microcredito

import grails.gorm.services.Service
import microcredito.Emprestimo

@Service(Emprestimo)
interface EmprestimoService {

    Emprestimo get(Serializable id)

    List<Emprestimo> list(Map args)

    Long count()

    void delete(Serializable id)

    Emprestimo save(Emprestimo emprestimo)

}