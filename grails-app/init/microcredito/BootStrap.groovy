package microcredito

class BootStrap {

    def init = { servletContext ->
//        def adminRole = Role.findOrSaveWhere(authority: 'ROLE_ADMIN')
//        def userRole = Role.findOrSaveWhere(authority: 'ROLE_USER')
//
//        def perfil = Perfil.findOrSaveWhere(designacao: 'Agente')
//
//        def admin = User.findByUsername('admin')
//        if(!admin) {
//            admin = new User(username: 'admin', nome: 'Joao N. Mabjaia', dataModif: new Date(), dataRegisto: new Date(),
//            password: 'admin', perfil: perfil, version: new Long(1), contacto1: '846229811', contacto2: '825214114').save()
//        }
//        def user = User.findByUsername('user')
//        if(!user){
//            user = new User(username: 'user', nome: 'Fader Azevedo', dataModif: new Date(), dataRegisto: new Date(),
//            password: 'user', perfil: perfil, version: new Long(1), contacto1: '846229811', contacto2: '825214114').save()
//        }
//
////      Fader
//        if(!UserRole.findByUserAndRole(admin,adminRole)){
//            new UserRole(user: admin, role: adminRole).save()
//        }
//        if(!UserRole.findByUserAndRole(user,userRole)){
//            new UserRole(user: user, role: userRole).save()
//        }

//        //Registo de tipos de casa
//        def tiposCasa =["Propria","Arrendada","Outro"]
//        for(int i = TipoCasa.findAllByDescricaoInList(tiposCasa).size(); i < tiposCasa.size(); i++){
//            new TipoCasa("descricao":tiposCasa.get(i)).save()
//        }
//
//        //Registo de Tipos de Destino de credito
//        def listDestino =["Negocio","Consumo","Outro"]
//        for(int i = DestinoCredito.findAllByDescricaoInList(listDestino).size(); i < listDestino.size(); i++){
//            new DestinoCredito("descricao":listDestino.get(i)).save()
//        }
//
//        def listTipoDoc =["BI","Passaporte","DIRE"]
//        for(int i = TipoDocumento.findAllByDescricaoInList(listTipoDoc).size(); i < listTipoDoc.size(); i++){
//            new TipoDocumento("descricao":listTipoDoc.get(i)).save()
//        }
//
//        //Registo de tipos de Meio de pagameto
//        def listMeioPagamento =["M-PESA","Conta Movel","POS"]
//        for(int i = MeioPagamento.findAllByDescricaoInList(listMeioPagamento).size(); i < listMeioPagamento.size(); i++){
//            new MeioPagamento("descricao":listMeioPagamento.get(i)).save()
//        }
//
//        // Registo de tipos de Prestacao
//        def listTipoPestacao =["Renda Normal","Multa","Parcela","Taxa de Concessao"]
//        for(int i = TipoPrestacao.findAllByDescricaoInList(listTipoPestacao).size(); i < listTipoPestacao.size(); i++){
//            new TipoPrestacao("descricao":listTipoPestacao.get(i)).save()
//        }
//
//        //Registo de modalidades de pagamento
//        def listModalidades =["Diaria","Semanal","Mensal","Quinzenal"]
//        def listDias =[1,7,30,15]
//        for(int i = ModoPagamento.findAllByDescricaoInList(listModalidades).size(); i < listModalidades.size(); i++){
//            new ModoPagamento("descricao":listModalidades.get(i),"nrDias":listDias.get(i)).save()
//        }
//
//        def listPerfil =["Developer"]
//        for(int i = Perfil.findAllByDesignacaoInList(listPerfil).size(); i < listPerfil.size(); i++){
//            new Perfil("designacao":listPerfil.get(i)).save()
//        }
//
//        //Registo de Tipos de garantia
//        def listTipoGarantia =["Carro","Congelador","Geleira","Televisao","Computador"]
//        for(int i = TipoGarantia.findAllByDescricaoInList(listTipoGarantia).size(); i < listTipoGarantia.size(); i++){
//            new TipoGarantia("descricao":listTipoGarantia.get(i),"dataRegisto":new Date(),'dataModif':new Date(),
//                    "userRegisto":User.get(1),"userModif": User.get(1)
//            ).save()
//        }
//
//        def micro = MicroCredito.findByDesignacao('Exlusive')
//        if(!micro){
//            new MicroCredito('designacao': 'Exlusive','slogan': 'Micro','logo': 'D:/Dropbox/Microcredito/jasper/logo.jpg',
//                    'nuit': '106850739', 'mutuante': 'Cabral Toze', 'nrRegisto': '0001', 'telefone': '842159357',
//                    'celular': '842159357','fax': '21088843', 'email': 'starprestigio@gmail.com','webSite': 'www.exclusive',
//                    'endereco': 'Rua Timor leste  58 1⁰ andar', dataModif: new Date(), dataRegisto: new Date(),
//                    userModif: User.get(1), userRegisto: User.get(1)
//            ).save()
//        }
    }
    def destroy = {
    }
}
