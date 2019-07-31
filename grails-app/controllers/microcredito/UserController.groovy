package microcredito

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import grails.validation.ValidationException
import groovy.json.JsonSlurper
import sun.misc.Perf

import static org.springframework.http.HttpStatus.*

@Secured('ROLE_ADMIN')
class UserController {

    UserService userService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def springSecurityService
    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def usuarioLogado(){
        def user = (User)springSecurityService.currentUser
        return user
    }

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond userService.list(params), model:[userCount: userService.count()]
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def perfil() {
        respond  usuarioLogado()
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def update1(){
        def user = (User)springSecurityService.currentUser
        render(template:'/user/actualizar.gsp', model:[user: user])
    }

    @Secured(['ROLE_ADMIN' , 'ROLE_USER'])
    def actualizarPerfil(){
        String jsonObject = request.JSON
        def parametros = new JsonSlurper().parseText(jsonObject)

        def nomeCompleto = parametros[0].toString()
        def username = parametros[1].toString()
        def contacto1 = parametros[2].toString()
        def contacto2 = parametros[3].toString()
        def password = parametros[4].toString()

//        println(nomeCompleto+" "+username+" "+contacto1+" "+contacto2+" "+password)

        def user = (User)springSecurityService.currentUser

        if (!nomeCompleto.isEmpty() && nomeCompleto != null){user.setNome(nomeCompleto)}
        if (!username.isEmpty() && username != null){user.setUsername(username)}
        if (!contacto1.isEmpty() && contacto1 != null){user.setContacto1(contacto1)}
        if (!contacto2.isEmpty() && contacto2 != null){user.setContacto2(contacto2)}
        if (!password.isEmpty() && password != null){user.setPassword(password)}

        try {

            userService.save(user)
            def url = createLink(controller: 'user', action: 'perfil')
            render(contentType: 'text/html', text: "<script>window.location.href='$url'</script>")
//            redirect(action: "perfil")
        }catch (ValidationException e) {
            respond user.errors, view:'create'
            println(user.errors)
            return
        }

    }

    def show(Long id) {
        respond userService.get(id)
    }

    def create() {
        respond new User(params), model: [perfilList: Perfil.createCriteria().list {eq('id',new Long(1))}]
        respond new User(params), model: [perfilList: Perfil.findAllByIdInList([2,3])]
    }

    def save(User user) {
        if (user == null) {
            notFound()
            return
        }

        try {
            userService.save(user)
        } catch (ValidationException e) {
            respond user.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*' { respond user, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond userService.get(id)
    }

    def update(User user) {
        if (user == null) {
            notFound()
            return
        }

        try {
            userService.save(user)
        } catch (ValidationException e) {
            respond user.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'user.label', default: 'User'), user.id])
                redirect user
            }
            '*'{ respond user, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        userService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'user.label', default: 'User'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'user.label', default: 'User'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }


    def salvarUser(){
        def msg = [:]
        def username = params.username;
        def verifica = User.findByUsername(username)
        if(verifica){
            msg['msg']="existe"
        }else {
            def user = new User()
            user.setUserModif(usuarioLogado())
            user.setUserRegisto(usuarioLogado())
            user.setDataRegisto(new Date())
            user.setDataModif(new Date())
            user.setContacto1(params.contacto1)
            user.setContacto2(params.contacto2)
            user.setNome(params.nomeCompleto)
            user.setUsername(params.username)
            user.setPassword(params.password)
            user.setAccountExpired(false)
            user.setAccountLocked(false)
            user.setPasswordExpired(false)
            user.setVersion(new Long(0))
            user.setPerfil(Perfil.get(2))

            if(user.save()){
                UserRole.create(user,Role.get(2),true)
                msg['msg']='Salvo com sucesso'
                println('salvo done')
            }else{
                msg['msg']='Erro ao salvar'
                println('nao salvo')
            }
        }
        render msg as JSON
    }


    def bloquear(){
        def user = User.get(params.id)
        user.setAccountLocked(true)
        user.setAccountExpired(true)
        user.setEnabled(false)
        user.save(flush:true)
        render('done')
    }

    def desbloquear(){
        def user = User.get(params.id)
        user.setAccountLocked(false)
        user.setAccountExpired(false)
        user.setEnabled(true)
        user.save(flush:true)
        render('done')
    }
}
