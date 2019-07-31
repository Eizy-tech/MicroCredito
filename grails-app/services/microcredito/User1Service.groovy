package microcredito

import grails.plugin.springsecurity.annotation.Secured
import grails.gorm.transactions.Transactional

@Transactional
class User1Service {


    def serviceMethod() {

    }

    def springSecurityService
    def usuarioLogado(){
        return springSecurityService.principal
    }
}
