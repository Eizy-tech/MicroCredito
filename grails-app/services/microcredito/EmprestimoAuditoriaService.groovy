package microcredito

import grails.gorm.services.Service

@Service(EmprestimoAuditoria)
interface EmprestimoAuditoriaService {

    EmprestimoAuditoria get(Serializable id)

    List<EmprestimoAuditoria> list(Map args)

    Long count()

    void delete(Serializable id)

    EmprestimoAuditoria save(EmprestimoAuditoria emprestimoAuditoria)

}