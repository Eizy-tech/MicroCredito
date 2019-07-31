package microcredito

import grails.gorm.transactions.Transactional

@Transactional
class UserDetailService {

    def user(Object username) {
        return User.findAllByUsername(username.toString())
    }
}
