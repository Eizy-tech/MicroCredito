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
        String txtContrato, txtDados
        String  nrProcesso, taxaTramitacao, prazoPretendido, inicioPagamento, modoPagamento, cliente, valorPedido, valorApagar, taxaJuros, renda, logo, notaBem, userAndDate
    }

    class IreportPrestacao {
        String num, valor, limite, logo,tipo, txtDados, userAndDate /*, multa*/
    }

    class IreportContrato {
        String txtDados, txtContrato, logo, userAndDate
    }

    def parcelas(Emprestimo emprestimo){
        def parcelas
        def exte = porExtenso(cw.write(new BigDecimal(Double.parseDouble(emprestimo.nrPrestacoes.toString()))))
        def quebra = exte.split(' ')

        switch (emprestimo.modoPagamento.descricao.toLowerCase()){
            case 'diaria':
                parcelas = 'diárias, pagáveis diárias'
                break
            case 'semanal':
                parcelas = 'semanais, pagáveis semanais'
                break
            case 'quinzenal':
                parcelas = 'quinzenais, pagáveis quinzenais'
                break
            case 'mensal':
                parcelas = 'mensais, pagáveis mensais'
                break
            default:
                parcelas = 'diárias, pagáveis diárias'
        }
        return emprestimo.nrPrestacoes+' ('+quebra[0].trim()+')'+ ' parcelas '+parcelas
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

        IreportContrato contrato = new IreportContrato()
        contrato.setLogo(new File(jasperLogo).toString())

        contrato.setTxtDados(
                "<b>" +
                        "Rua: " +microcredito.endereco+"<br>" +
                        "Cell: " +microcredito.celular+"<br>" +
                        "Email: " +microcredito.email+"<br>"+
                        "NUIT: "+microcredito.nuit+
                "</b>"
        )
        contrato.setTxtContrato("<p>&#9;&#9;&#9;&#9;&#9;<b>CONTRATO DE MÚTUO</b></p> <br>" +
                "<b>Entre<br>Prosperidade Microcrédito E.I</b>, com sede no Bairro Central, "+microcredito.endereco+
                ", <b>Cidade de Maputo</b>, registado na Conservátoria de Registos Legais de Maputo, sob número " +
                "101097439, representada pelo seu representante, <b>"+microcredito.mutuante+"</b>, adiante designado por <b>MUTUANTE,</b>" +
                "<br>"+
                "<p><b>E,</b></p>" +
                "<b>"+cliente.nome+"</b>, de nacionalidade Moçambicana, natural de "+cliente.naturalidade + "portador do" +
                " <b>"+cliente.tipoDocumento.descricao+"</b> nº "+cliente.nrDocumento+", emitido em "+cliente.localEmissao+" " +
                "aos "+methods.formatData(cliente.dataEmissao)+" adiante designada por <b>MUTUÁRIA</b> têm entre si," +
                " justo e contratado, o seguinte:"+
                "<br>"+
                "<p>&#9;&#9;&#9;&#9;&#9;<b>(Objecto)</b></p>" +
                "I - O MUTUANTE concede ao MUTUÁRIO neste acto, um crédito de <b>" +
                String.format("%,.2f", emprestimo.valorPedido) + " Mt (" + valorPedidoExtenso.trim() + ").</b>" +
                "<br>" +
                "<p>&#9;&#9;&#9;&#9;  <b>(Obrigação do Mutuário)</b></p>"+
                "II - O MUTUÁRIO se compromete a restituir ao MUTUANTE a quantia mutuada, mediante" +
                "ao pagamento de "+parcelas(emprestimo)+" a contar da data da assinatura" +
                "do presente contrato de Mútuo Oneroso, até a liquidação TOTAL da dívida no valor <b>"
                +String.format("%,.2f", emprestimo.valorApagar) + " Mt (" + valorAPagarExtenso +").</b>" +
                "<br>" +
                "<p>&#9;&#9;&#9;&#9;&#9;<b>(Garantia)</b></p>"+
                " O MUTUÁRIO entregará como garantia do presente acordo, os seguintes bens:"+bens.trim()
        )

        List<IreportContrato> ireportContratoList = new ArrayList<>()
        ireportContratoList.add(contrato)
        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(ireportContratoList)
        JasperPrint jasperPrint = JasperFillManager.fillReport(new File(jasperDir + 'contrato.jasper').toString(), null, dataSource)
        OutputStream outputStream = new FileOutputStream(new File(jasperDir + 'contrato_frente.pdf'))
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream)
//        System.out.println("contrato frente pdf Generated now:")

        return  jasperPrint
   }

    def pdfContratoVerso(Emprestimo emprestimo) {
        def microcredito = MicroCredito.get(1)
        def cliente = emprestimo.cliente
        IreportContrato contrato = new IreportContrato()
        def exte = porExtenso(cw.write(new BigDecimal(emprestimo.taxaJuros)))
        def quebra = exte.split(' ')
        contrato.setUserAndDate('Data: ' + methods.formatData(new Date()) + '&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;utilizador: ' +emprestimo.userRegisto.nome)

        contrato.setTxtContrato("Que serão penhorados para a liquidação da divida contraída caso o MUTUÁRIO não consiga " +
                "honrar com o compromisso de pagamento da dívida contraída nas datas programadas."+
                "<br>" +
                "<p>&#9;&#9;&#9;&#9;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>(Taxa de Juro)</b></p>" +
                "IV - o montante mutuado vence juros à taxa de "+emprestimo.taxaJuros+"% ("+quebra[0].trim()+" por centos) ao mês." +
                "<br>" +
                "<p>&#9;&#9;&#9;&#9;&#9;<b>(Sanções)</b></p>" +
                "V - Na falta de pagamento do empréstimo na data aprazada o MUTUÁRIO pagará uma multa no percentual de " +
                "1.5%(um virgula cinco por cento) do valor total da dívida por cada dia de atraso;"+
                "<br>" +
                "<p>&#9;&#9;&#9;&#9;&#9;<b>(Encargos)</b></p>" +
                "VI - Todos encargos que venham a recair durante o periódo da posse dos bens supracitados pelo MUTUANTE," +
                " continuarão na responsabilidade do MUTUÁRIO, devendo ser acrescidos na dívida se houver inadimplemento " +
                "por parte do MUTUÁRIO;" +
                "<br>" +
                "VII - Se o MUTUANTE recorrer à via judicial para receber o seu crédito, terá direito à multa compensatória " +
                "de 1.5% (um virgula cinco por cento) do valor do crédito e a correção monetária, sem prejuizo dos custos" +
                " e das despesas processuais." +
                "<br>" +
                "E, por estarem de acordo com todas as disposições nele consignadas, as partes assinam esse instrumento" +
                "particular, juntamente com uma testemunha, em duas vias de igual teor, ficando cada parte com uma via." +
                "<br>" +
                "<p>Maputo "+methods.formatDataNascimento(new  Date())+"</p>" +
                "<br>" +
                "<p>_____________________________________&#9;&#9;&#9;_____________________________________</p>" +
                "<p>&#9;"+microcredito.mutuante+"&#9;&#9;&#9;&#9;&#9;"+cliente.nome+"</p>\n" +
                "<p>&#9;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Mutuante)&#9;&#9;&#9;&#9;&#9;&#9;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Mutuário)</p>"
        )

        List<IreportContrato> ireportContratoList = new ArrayList<>()
        ireportContratoList.add(contrato)

        JRBeanCollectionDataSource dataSource = new JRBeanCollectionDataSource(ireportContratoList)
        JasperPrint jasperPrint = JasperFillManager.fillReport(new File(jasperDir + 'contrato_verso.jasper').toString(), null, dataSource)
        OutputStream outputStream = new FileOutputStream(new File(jasperDir + 'contrato_verso.pdf'))
        JasperExportManager.exportReportToPdfStream(jasperPrint, outputStream)
//        System.out.println("contrato frente pdf Generated:")

        return jasperPrint
    }

    def pdfContrato(Emprestimo emprestimo){
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
                return pdfContratoVerso(emprestimo)
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

    def pdfPrestacoes(Emprestimo emprestimo) {
        List<IreportPrestacao> ireportPrestacaoList = new ArrayList<>()
        def prestacoes = Prestacao.createCriteria().list { eq('emprestimo', emprestimo) order('id') }
        prestacoes.each {
            if (it.tipoPrestacao.id == 1 || it.tipoPrestacao.id == 6) {                 //exclui taxa de concessao
                IreportPrestacao prestacao = new IreportPrestacao()
                prestacao.setNum(it.numero)
                prestacao.setValor(String.format("%,.2f",it.valor))
                prestacao.setLimite(methods.formatData(it.dataLimite).toString())
                prestacao.setTipo(it.tipoPrestacao.descricao)
                ireportPrestacaoList.add(prestacao)
            }
        }

        JRBeanCollectionDataSource beansPrestacoes = new JRBeanCollectionDataSource(ireportPrestacaoList)
        Map<String, Object> parameters = new HashMap<String, Object>()
        parameters.put('prestacoesSource', beansPrestacoes)

        def microcredito = MicroCredito.get(1)
        IreportEmprestimo ireportEmprestimo = new IreportEmprestimo()

        ireportEmprestimo.setTxtDados(
            "<b>" +
                "Rua: " +microcredito.endereco+"<br>" +
                "Cell: " +microcredito.celular+"<br>" +
                "Email: " +microcredito.email+"<br>"+
                "NUIT: "+microcredito.nuit+
            "</b>"
        )

        def rt
        if(emprestimo.modoPagamento.descricao.equalsIgnoreCase('mensal')){
            rt = 'Juros'
        }else{
            rt = 'Renda Normal'
        }

        ireportEmprestimo.setTxtContrato(
                "<p>Nº do processo: "+emprestimo.nrProcesso+"&#9;&#9;Modalidade:"+emprestimo.modoPagamento.descricao +
                        " &#9;Cliente: <b>"+emprestimo.cliente.nome.toUpperCase()+"</b></p>" +

                "<p>Capital: "+String.format("%,.2f",emprestimo.valorPedido) + "MT&#9;&#9;Taxa de juros: "+
                        emprestimo.taxaJuros.toString()+"&#9;&#9;"+rt+": "+
                        String.format("%,.2f", emprestimo.valorPedido*emprestimo.taxaJuros/100)+"</p>"+

                "<p>Reembolso: "+String.format("%,.2f", emprestimo.valorApagar)+"&#9;&#9;&#9;&#9;" +
                        "Data do Reembolso: "+methods.formatData(emprestimo.prazoPagamento).toString()+"</p>"

        )
//
//        ireportEmprestimo.setValorPedido(String.format("%,.2f",emprestimo.valorPedido) + ' MT')
//        ireportEmprestimo.setTaxaJuros(emprestimo.taxaJuros.toString())
//        ireportEmprestimo.setValorApagar(String.format("%,.2f", emprestimo.valorApagar) + ' MT')
//        ireportEmprestimo.setRenda(String.format("%,.2f", emprestimo.valorPedido*emprestimo.taxaJuros/100) + ' MT')
//        ireportEmprestimo.setPrazoPretendido(methods.formatData(emprestimo.prazoPagamento).toString())
//        ireportEmprestimo.setInicioPagamento(methods.formatData(emprestimo.dataInicioPagamento).toString())
//        ireportEmprestimo.setModoPagamento(emprestimo.modoPagamento.descricao)
//        ireportEmprestimo.setNrProcesso(emprestimo.nrProcesso)
//        ireportEmprestimo.setCliente(emprestimo.cliente.nome.toUpperCase())
        ireportEmprestimo.setLogo(new File(jasperLogo).toString())
        ireportEmprestimo.setUserAndDate('Data: ' + methods.formatData(new Date()) + '&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;utilizador: ' +emprestimo.userRegisto.nome)

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
        String txtEndereco, txtContacto, txtEmail, txtNuit
    }

    static reciboDir =''
    def pdfRecibo(Emprestimo emprestimo, def prestacoesArrayList) {

        def nrPrecesso = emprestimo.nrProcesso.substring(emprestimo.nrProcesso.length()-4)
        def credito = '/Credito'+Integer.parseInt(nrPrecesso)+'/recibos'
        def destinoRecibo = ('D:/Dropbox/Microcredito/'+emprestimo.cliente.codigo.trim()+'_'+methods.semAcentos(emprestimo.cliente.nome)).trim()+credito
        if(!new File(destinoRecibo).isDirectory()) {
            new File(destinoRecibo).mkdir()
        }
        def microcredito = MicroCredito.get(1)

        Recibo recibo = new Recibo()
//        recibo.setTxtDados(
//            "<b>" +
//                    "Rua: " +microcredito.endereco+"<br>" +
//                    "Cell: " +microcredito.celular+"<br>" +
//                    "Email: " +microcredito.email+"<br>"+
//                    "NUIT: "+microcredito.nuit+
//                    "</b>"
//        )

        recibo.setTxtEndereco(microcredito.endereco)
        recibo.setTxtContacto(microcredito.celular)
        recibo.setTxtEmail(microcredito.email)
        recibo.setTxtNuit(microcredito.nuit)
        recibo.setLogo(new File(jasperLogo).toString())
        recibo.setUserAndDate('Data: ' + methods.formatData(new Date()) + '&#9;&#9;&#9;&#9;&#9;&#9;&#9;&#9;utilizador: ' +emprestimo.userRegisto.nome)
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