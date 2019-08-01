package microcredito

import microcredito.porextenso.CurrencyWriter
import net.sf.jasperreports.engine.JasperExportManager
import net.sf.jasperreports.engine.JasperFillManager
import net.sf.jasperreports.engine.JasperPrint
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource
import net.sf.jasperreports.engine.export.ooxml.JRDocxExporter
import net.sf.jasperreports.export.ExporterInputItem
import net.sf.jasperreports.export.ReportExportConfiguration
import net.sf.jasperreports.export.SimpleExporterInput
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput

class IreportController {
    def jasperLogo = 'D:/Dropbox/Microcredito/jasper/logo.jpg'
    def jasperDir = 'D:/Dropbox/Microcredito/jasper/'
    def pdfDestino = ''
    def methods = new MethodsController()
    def cw = CurrencyWriter.getInstance()

    IreportController(pdfDestino) {
        this.pdfDestino = pdfDestino
    }

    def porExtenso(String extenso) {
        def quebra = extenso.split(' ')
        if (quebra[1].equalsIgnoreCase('mil') && quebra[0].equalsIgnoreCase('um')) {
            return extenso.split(' ', 2)[1].trim()
        } else {
            return extenso
        }
    }

    class IreportEmprestimo {
        String nome, tipoDocumento, email, tipoRenda
        String  nrProcesso, taxaTramitacao, prazoPretendido, inicioPagamento, modoPagamento, cliente, valorPedido, valorApagar, taxaJuros, renda, logo, notaBem, userAndDate
    }

    class IreportPrestacao {
        String num, valor, limite, logo, userAndDate /*, multa*/
    }

    class IreportContratoExclusive {
        String txtDados, txtObjecto, txtObrigacao, txtGarantia, txtQuarta, txtQuinta, txtSexta, txtSetima, txtOitava, txtNona, txtCliente, logo, userAndDate,data
    }

    def parcelas(Emprestimo emprestimo){
        def parcelas =''
        def exte = porExtenso(cw.write(new BigDecimal(Double.parseDouble(emprestimo.nrPrestacoes.toString()))))

        if(emprestimo.nrPrestacoes > 1){

            if(emprestimo.modoPagamento.descricao.equalsIgnoreCase('diaria')){
                parcelas = 'diárias, pagáveis diárias'
            }

            if(emprestimo.modoPagamento.descricao.equalsIgnoreCase('semanal')){
                parcelas = 'semanais, pagáveis semanais'
            }

            if(emprestimo.modoPagamento.descricao.equalsIgnoreCase('quinzenal')){
                parcelas = 'quinzenais, pagáveis quinzenais'
            }

            if(emprestimo.modoPagamento.descricao.equalsIgnoreCase('mensal')){
                parcelas = 'mensais, pagáveis mensais'
            }
        }
        return emprestimo.nrPrestacoes+' ('+exte+')'+ 'parcelas '+parcelas
    }

    def pdfContratoExclusiveFrente(Emprestimo emprestimo) {
        def microcredito = MicroCredito.get(1)
        def cliente = emprestimo.cliente
        def valorPedidoExtenso = porExtenso(cw.write(new BigDecimal(emprestimo.valorPedido.toString())))
        def valorAPagarExtenso = porExtenso(cw.write(new BigDecimal(emprestimo.valorApagar.toString())))

        def arrayExtensao = valorPedidoExtenso.split(' ')
        valorPedidoExtenso = ''
        for (def i = 0; i < arrayExtensao.length; i++) {
            valorPedidoExtenso += methods.capitalize(arrayExtensao[i].toString()) + ' '
        }

        def arrayAPagarExtensao = valorAPagarExtenso.split(' ')
        valorAPagarExtenso = ''
        for (def i = 0; i < arrayAPagarExtensao.length; i++) {
            valorAPagarExtenso += methods.capitalize(arrayAPagarExtensao[i].toString()) + ' '
        }

        def bens = ''
        def garantias = emprestimo.garantias
        garantias.each {
            if ((it.tipoGarantia.descricao.trim().charAt(it.tipoGarantia.descricao.length() - 1)).toString().equalsIgnoreCase('a')) {
                bens += '<p>✓ 1(uma) ' + it.tipoGarantia.descricao + it.descricao + '\n</p>'
            } else {
                bens += '<p>✓ 1(um) ' + it.tipoGarantia.descricao + it.descricao + '\n</p>'
            }
        }

        IreportContratoExclusive contratoExclusive = new IreportContratoExclusive()
        def nomeArray = cliente.nome.split(' ')
        def srOrsra
        if(nomeArray[0].charAt(nomeArray[0].length()-1).toString().equalsIgnoreCase('a')){
            srOrsra = 'Sra, '
        }else{
            srOrsra = 'Sr, '
        }

        contratoExclusive.setTxtDados("<p><b>Entre</b></p>\n" +
                "<b>Prosperidade Microcrédito E.I</b>, com sede no, "+microcredito.endereco+
                ", <b>\nCidade de Maputo</b>, registado na Conservátoria de Registos Legais de Maputo, sob número " +
                "\n 101097439, representada pelo seu representante, <b>"+microcredito.mutuante+"</b>, adiante designado por <b>MUTUANTE," +
                "\n\n"
        )

        contratoExclusive.setTxtCliente("<p><b>E,</b></p><b>"+cliente.nome+'</b>, de nacionalidade Moçambicana, natural de '+cliente.naturalidade +
                '\nportador do <b>'+cliente.tipoDocumento.descricao+'</b> nº \n'+cliente.nrDocumento+', emitido em '+cliente.localEmissao+'\naos '
                +methods.formatData(cliente.dataEmissao)+
                ' adiante designada por <b>MUTUÁRIA</b> têm entre si, justo e contratado, o seguinte:'
        )

        contratoExclusive.setTxtObjecto(
                'I - O MUTUANTE concede ao MUTUÁRIO, neste acto, um crédito de <b>' + String.format("%,.2f", emprestimo.valorPedido) + ' Mt (' + valorPedidoExtenso.trim() + ').</b>'
        )

        contratoExclusive.setTxtObrigacao(
                'II - O MUTUÁRIO se compromete a restituir ao MUTUANTE a quantia mutuada, mediante\n' +
                'ao pagamento de '+parcelas(emprestimo)+' a contar da data da assinatura\n ' +
                'do presente contrato de Mútuo Oneroso, até a liquidação TOTAL da dívida no valor <b>'
                        +String.format("%,.2f", emprestimo.valorApagar) + ' Mt (' + valorAPagarExtenso + ').</b>'
        )

        contratoExclusive.setTxtGarantia('III - O MUTUÁRIO entregará como garantia do presente acordo, os seguintes bens:\n'+bens.trim())

        contratoExclusive.setUserAndDate('Utilizador: ' + emprestimo.userRegisto.nome + '                                                       Data: ' + methods.formatData(new Date()))
        contratoExclusive.setLogo(new File(jasperLogo).toString())

        List<IreportContratoExclusive> ireportContratoList = new ArrayList<>()
        ireportContratoList.add(contratoExclusive)
        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(ireportContratoList)
        JasperPrint jasperPrint = JasperFillManager.fillReport(new File(jasperDir + 'contrato.jasper').toString(), null, dataSource)
        OutputStream outputStream = new FileOutputStream(new File(jasperDir + 'contrato_frente.pdf'))
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream)
        System.out.println("contrato frente pdf Generated:")

        return  jasperPrint
   }

    def pdfContratoExclusiveVerso(Emprestimo emprestimo) {
        IreportContratoExclusive contratoExclusive = new IreportContratoExclusive()
        contratoExclusive.setUserAndDate('Utilizador: ' + emprestimo.userRegisto.nome + '          Data: ' + methods.formatData(new Date()))
        contratoExclusive.setTxtSexta('O presente penhor torna-se imediaente exigível logo que esteja vencida qualquer obrigação ' +
                'e se verifique mora no seu cumprimento, ou ainda, quando qualquer dos bens penhorados, arrestado, ' +
                'ou objecto de qualquer forma de apreensão judicial. '
        )

        contratoExclusive.setTxtSetima('1 - Tornando-se exigível o penhor, fica o PRIMEIRO CONTRAENTE, desde já, ' +
                'expressamente autorizado pelo SEGUNDO CONTRAENTE, que lhe confere os necessários poderes, a em nome do ' +
                'SEGUNDO CONTRAENTE, vender extrajudicialmente os bens penhorados, como melhor entender, sem dependência ' +
                'de qualquer formalidade, recebendo os respectivos produtos da venda e deles dando quitação. O SEGUNDO ' +
                'CONTRAENTE autoriza, ainda, o PRIMEIRO CONTRAENTE a substabelecer tais poderes. \n' +
                '\n' +
                '2 - Fica desde já expressamente autorizado o PRIMEIRO CONTRAENTE, ou quem este indicar, a levantar, pelos ' +
                'meios adequados, os bens objecto do presente penhor mesmo que para tal seja necessário aceder ao local onde ' +
                'se encontrem os mesmos. \n' +
                '\n' +
                '3 - Para efeitos dos números anteriores, o SEGUNDO CONTRAENTE obriga-se a praticar todos os actos em que, ' +
                'por qualquer motivo, deva intervir para se efectuarem as transmissões. '
        )

        contratoExclusive.setTxtOitava('Em caso de incumprimento de qualquer uma das responsabilidades/obrigações em questão,' +
                ' fica o primeiro contratante autorizado a acabar de preencher a livrança acima referida pelo montante que se ' +
                'encontra em dívida e fixando-lhe o vencimento, em qualquer das modalidades permitidas por este contrato. '
        )

        contratoExclusive.setTxtNona('Para dirimir qualquer questão emergente do presente contrato é competente o Tribunal ' +
                'Judicial, com expressa renúncia a qualquer outro por mais privilegiado que seja. \n' +
                'E, por estarem de acordo com todas as disposições nele consignadas, as partes assinam esse instrumento ' +
                'particular, juntamente com duas testemunhas, em duas vias de igual teor, ficando cada parte com uma via. '
        )

        contratoExclusive.setUserAndDate('Utilizador: ' + emprestimo.userRegisto.nome + '                                                       Data: ' + methods.formatData(new Date()))
        contratoExclusive.setData(methods.formatDataNascimento(new Date()))

        List<IreportContratoExclusive> ireportContratoList = new ArrayList<>()
        ireportContratoList.add(contratoExclusive)

        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(ireportContratoList)
        JasperPrint jasperPrint = JasperFillManager.fillReport(new File(jasperDir + 'contrato_verso.jasper').toString(), null, dataSource)
        OutputStream outputStream = new FileOutputStream(new File(jasperDir + 'contrato_verso.pdf'))
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream)
        System.out.println("contrato frente pdf Generated:")

        return jasperPrint
    }

    def pdfContratoExclusive(Emprestimo emprestimo){
        List<ExporterInputItem> exporterInputItems = new ArrayList<>()
        ExporterInputItem exporterInputItemFrente = new ExporterInputItem() {
            @Override
            JasperPrint getJasperPrint() {
                return pdfContratoExclusiveFrente(emprestimo)
            }

            @Override
            ReportExportConfiguration getConfiguration() {
                return null
            }
        }
        ExporterInputItem exporterInputItemVerso = new ExporterInputItem() {
            @Override
            JasperPrint getJasperPrint() {
                return pdfContratoExclusiveVerso(emprestimo)
            }

            @Override
            ReportExportConfiguration getConfiguration() {
                return null
            }
        }

        exporterInputItems.add(exporterInputItemFrente)
        exporterInputItems.add(exporterInputItemVerso)
        JRDocxExporter docxExporter = new JRDocxExporter()
        docxExporter.setExporterInput(new SimpleExporterInput(exporterInputItems))
        docxExporter.setExporterOutput(new SimpleOutputStreamExporterOutput(new File(pdfDestino+emprestimo.nrProcesso+'_contrato.docx')))
        docxExporter.exportReport() //exporta contratos docc

        List<InputStream> listFile = new ArrayList<InputStream>()
        listFile.add(new FileInputStream(new File(jasperDir + 'contrato_frente.pdf')))
        listFile.add(new FileInputStream(new File(jasperDir + 'contrato_verso.pdf')))
        OutputStream contratoOutput = new FileOutputStream(new File(pdfDestino +  emprestimo.nrProcesso + '_contrato.pdf'))
        methods.mergePdf(listFile, contratoOutput)
        System.out.println("contrato pdf Generated")
    }

    def pdfPrestacoesExclusive(Emprestimo emprestimo) {
        List<IreportPrestacao> ireportPrestacaoList = new ArrayList<>()
        def prestacoes = Prestacao.createCriteria().list { eq('emprestimo', emprestimo) order('id') }
        prestacoes.each {
            if (it.tipoPrestacao.id == 1) {                 //exclui taxa de concessao
                IreportPrestacao prestacao = new IreportPrestacao()
                prestacao.setNum(it.numero)
                prestacao.setValor(String.format("%,.2f",it.valor))
                prestacao.setLimite(methods.formatData(it.dataLimite).toString())
                ireportPrestacaoList.add(prestacao)
            }
        }

        JRBeanCollectionDataSource beansPrestacoes = new JRBeanCollectionDataSource(ireportPrestacaoList)
        Map<String, Object> parameters = new HashMap<String, Object>()
        parameters.put('prestacoesSource', beansPrestacoes)

        IreportEmprestimo ireportEmprestimo = new IreportEmprestimo()
        ireportEmprestimo.setValorPedido(String.format("%,.2f",emprestimo.valorPedido) + ' MT')
        ireportEmprestimo.setTaxaJuros(emprestimo.taxaJuros.toString())
        ireportEmprestimo.setValorApagar(String.format("%,.2f", emprestimo.valorApagar) + ' MT')
        ireportEmprestimo.setRenda(String.format("%,.2f", emprestimo.valorPedido*emprestimo.taxaJuros/100) + ' MT')
        ireportEmprestimo.setPrazoPretendido(methods.formatData(emprestimo.prazoPagamento).toString())
        ireportEmprestimo.setInicioPagamento(methods.formatData(emprestimo.dataInicioPagamento).toString())
        ireportEmprestimo.setModoPagamento(emprestimo.modoPagamento.descricao)
        ireportEmprestimo.setNrProcesso(emprestimo.nrProcesso)
        ireportEmprestimo.setCliente(emprestimo.cliente.nome.toUpperCase())
        ireportEmprestimo.setLogo(new File(jasperLogo).toString())
        ireportEmprestimo.setUserAndDate('Utilizador: ' + emprestimo.userRegisto.nome + '                                                         Data: ' + methods.formatData(new Date()))

        List<IreportEmprestimo> arraylistOfEmprestimos = new ArrayList<>()
        arraylistOfEmprestimos.add(ireportEmprestimo)
        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(arraylistOfEmprestimos)

        JasperPrint jasperPrint = JasperFillManager.fillReport(new File(jasperDir + 'prestacoes.jasper').toString(), parameters, dataSource)
        OutputStream outputStream = new FileOutputStream(new File(pdfDestino + emprestimo.nrProcesso + '_prestacoes.pdf'))
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream)
        System.out.println("Prestacoes pdf Generated")
    }

    class Recibo{
        String num, tipo, valor, meio,referencia, nrProcesso,cliente, contacto,userAndDate,logo,nrRecibo
    }


    static reciboDir =''
    def pdfRecibo(Emprestimo emprestimo, def prestacoesArrayList) {

        def nrPrecesso = emprestimo.nrProcesso.substring(emprestimo.nrProcesso.length()-4)
        def credito = '/Credito'+Integer.parseInt(nrPrecesso)+'/recibos'
        def destinoRecibo = ('D:/Dropbox/Microcredito/'+emprestimo.cliente.codigo.trim()+'_'+methods.semAcentos(emprestimo.cliente.nome)).trim()+credito
        if(!new File(destinoRecibo).isDirectory()) {
            new File(destinoRecibo).mkdir()
        }
        Recibo recibo = new Recibo()
        recibo.setLogo(new File(jasperLogo).toString())
        recibo.setUserAndDate('Utilizador: ' + emprestimo.userRegisto.nome + '\t\t\t\t\t\t\tData: ' + methods.formatDataeHora(new Date()))
        recibo.setNrProcesso(emprestimo.nrProcesso)
        recibo.setCliente(emprestimo.cliente.nome)
        recibo.setContacto(emprestimo.cliente.contacto1)
        def nrrecibo
        if(emprestimo.nrRecibo == null){
            recibo.setNrRecibo(emprestimo.nrProcesso+'-'+gerradorNrRecibo('1'))
            nrrecibo = '1'
            emprestimo.setNrRecibo(1)
        }else{
            recibo.setNrRecibo(emprestimo.nrProcesso+'-'+gerradorNrRecibo(String.valueOf(emprestimo.nrRecibo+1)))
            nrrecibo = String.valueOf(emprestimo.nrRecibo+1)
            emprestimo.setNrRecibo(emprestimo.getNrRecibo()+1)
        }

        List<Prestacao> prestacoes = prestacoesArrayList
        List<Recibo> reciboArrayList = new ArrayList<>()
        prestacoes.each {
            Recibo prestacaoRecibo = new Recibo()
            prestacaoRecibo.setNum(it.numero)
            prestacaoRecibo.setTipo(it.tipoPrestacao.descricao)
            prestacaoRecibo.setValor(String.format("%,.2f",it.valor))
            prestacaoRecibo.setMeio(it.meioPagamento.descricao)
            if(it.referencia != null){
                prestacaoRecibo.setReferencia(it.referencia)
            }
            if(it.conta != null){
                prestacaoRecibo.setReferencia(it.conta.banco)
            }
            reciboArrayList.add(prestacaoRecibo)
        }

        JRBeanCollectionDataSource beansPrestacoesRecibo = new JRBeanCollectionDataSource(reciboArrayList)
        JRBeanCollectionDataSource beansPrestacoesRecibo2 = new JRBeanCollectionDataSource(reciboArrayList)
        Map<String, Object> parameters = new HashMap<String, Object>()
        parameters.put('reciboDatasetSource', beansPrestacoesRecibo)
        parameters.put('reciboData2Source', beansPrestacoesRecibo2)

        List<Recibo> reciboList = new ArrayList<>()
        reciboList.add(recibo)
        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(reciboList)
        JasperPrint jasperPrint = JasperFillManager.fillReport(new File(jasperDir + 'recibo.jasper').toString(), parameters, dataSource)
        OutputStream outputStream = new FileOutputStream(new File(destinoRecibo +'/'+ emprestimo.nrProcesso+'-'+gerradorNrRecibo(nrrecibo)+'_recibo.pdf'))
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream)
        emprestimo.save(flush:true)
        System.out.println("recibo pdf Generated destino: "+destinoRecibo)
        reciboDir = destinoRecibo +'/'+ emprestimo.nrProcesso+'-'+gerradorNrRecibo(nrrecibo)+'_recibo.pdf'
    }

    def gerradorNrRecibo(def numero){
        if (numero.size()==1){
            numero = '00'+numero
        }
        if (numero.size()==2){
            numero = '0'+numero
        }
        if (numero.size()==3){
            numero = ''+numero
        }
        return numero
    }
}