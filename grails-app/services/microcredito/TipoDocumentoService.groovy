package microcredito

import grails.gorm.services.Service
import microcredito.TipoDocumento

@Service(TipoDocumento)
interface TipoDocumentoService {

    TipoDocumento get(Serializable id)

    List<TipoDocumento> list(Map args)

    Long count()

    void delete(Serializable id)

    TipoDocumento save(TipoDocumento tipoDocumento)

}