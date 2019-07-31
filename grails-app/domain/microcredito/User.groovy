package microcredito

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString
import grails.compiler.GrailsCompileStatic

@GrailsCompileStatic
@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class User implements Serializable {

    private static final long serialVersionUID = 1

    String  nome, username, contacto1, contacto2, password
    boolean enabled = true
    boolean accountExpired
    boolean accountLocked
    boolean passwordExpired
    Date dataRegisto
    Date dataModif
    User userRegisto
    User userModif
    Perfil perfil

    Set<Role> getAuthorities() {
        (UserRole.findAllByUser(this) as List<UserRole>)*.role as Set<Role>
    }

    static constraints = {
        password nullable: false, blank: false, password: true
        username nullable: false, blank: false, unique: true
        perfil(nullable: false)
        userModif(nullable: true, blank: true)
        userRegisto(nullable: true, blank: true)
        dataRegisto(nullable: true, blank: true)
        dataModif(nullable: true, blank: true)
        nome(nullable: false, blank: false)
        contacto1(nullable: true, blank: true)
        contacto2(nullable: true, blank: true)
    }

    static mapping = {
	    password column: '`password`'
    }

}
