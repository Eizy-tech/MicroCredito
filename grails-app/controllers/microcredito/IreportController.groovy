package microcredito

import grails.plugin.springsecurity.annotation.Secured
import microcredito.porextenso.CurrencyWriter
import net.sf.jasperreports.engine.JRExporterParameter
import net.sf.jasperreports.engine.JRStyle
import net.sf.jasperreports.engine.JasperExportManager
import net.sf.jasperreports.engine.JasperFillManager
import net.sf.jasperreports.engine.JasperPrint
import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource
import net.sf.jasperreports.engine.export.ooxml.JRDocxExporter
import net.sf.jasperreports.export.ExporterInputItem
import net.sf.jasperreports.export.ReportExportConfiguration
import net.sf.jasperreports.export.SimpleDocxReportConfiguration
import net.sf.jasperreports.export.SimpleExporterInput
import net.sf.jasperreports.export.SimpleOutputStreamExporterOutput

class IreportController {
    def jasperLogo = 'D:/Dropbox/Microcredito/jasper/logo.jpg'
    def jasperDir = 'D:/Dropbox/Microcredito/jasper/'
    def pdfDestino = ''
    def methods = new MethodsController()

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
        String txtPrimeira, txtSegunda, txtTerceira, txtQuarta, txtQuinta, txtSexta, txtSetima, txtOitava, txtNona, txtCliente, logo, userAndDate,data
    }

    def pdfContratoExclusiveFrente(Emprestimo emprestimo) {
        def cliente = emprestimo.cliente
        CurrencyWriter cw = CurrencyWriter.getInstance()
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
                bens += '1(uma) ' + it.tipoGarantia.descricao + ', ' + it.descricao + '; '
            } else {
                bens += '1(um) ' + it.tipoGarantia.descricao + ', ' + it.descricao + '; '
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

        contratoExclusive.setTxtCliente("<b>"+srOrsra+cliente.nome+'</b>, de nacionalidade Moçambicana, natural de '+cliente.naturalidade+' de , ' +
                'portador do '+cliente.tipoDocumento.descricao+' \n'+cliente.nrDocumento+', emitido aos '+methods.formatData(cliente.dataEmissao)+
                ' validade ate dia '+methods.formatData(cliente.dataValidade)+' pelo Arquivo de ' +
                'Indetificacao Civil de '+cliente.localEmissao+'. Residente '+cliente.endereco+'.  ' +
                'Profissão: '+emprestimo.experienciaNegocio+'.  E trabalha na '+emprestimo.localNegocio+' SEGUNDO CONTRAENTE (mutuário) ,\n \n' +
                'É celebrado um contrato de mútuo nos termos do artigo 1142.º do Código Cívil e que se rege pelas cláusulas seguintes: '
        )

        contratoExclusive.setTxtPrimeira(
                'O PRIMEIRO CONTRAENTE (MUTUANTE) concede no presente acto ao SEGUNDO CONTRAENTE (MUTUÁRIO), que aceita,' +
                        ' um empréstimo no valor de ' + String.format("%,.2f", emprestimo.valorPedido) + ' Mt (' + valorPedidoExtenso.trim() + ') a título de empréstimo, ' +
                        'quantia que este aceita e da qual se confessa devedor. '
        )

        def dias = emprestimo.nrPrestacoes*30
        contratoExclusive.setTxtSegunda('O presente empréstimo será amortizado e reembolsado integralmente no ' +
                'prazo máximo de '+dias+' (dias), tendo seu término ' + methods.formatDataNascimento(emprestimo.prazoPagamento) +
                ', ressalvando-se o exposto na cláusula seguinte. '
        )

        contratoExclusive.setTxtTerceira('O empréstimo e os juros acordados pelas partes,  ' +
                'perfazem um valor global de <b>' + String.format("%,.2f", emprestimo.valorApagar) + ' Mt (' + valorAPagarExtenso + ')</>.\n' +
                'A Quantia mutuada podera  ser  reembolsada em 1 (Uma) prestaçoes .\n' +
                '1º Prestaçao no valor de ' + String.format("%,.2f", emprestimo.valorApagar) + ' Mt (' + valorAPagarExtenso + ') No dia ' + methods.formatDataNascimento(emprestimo.prazoPagamento) + '.\n' +
                '\n\n' +
                '- O reembolso será feito em numerário, em depósito bancário ou ainda por transferência bancária ' +
                'para conta BCI nº 16998522610001 ou NIB nº 0008.000069985226101.95 , cujo comprovativo será entregue ' +
                'imediatamente ao mutuário.                                                                                                                                 '
        )

        contratoExclusive.setTxtQuarta('Apesar do prazo de amortização previsto neste contrato para ambas as partes, ' +
                'pode no entanto o mutuário(a) antecipar a amortização do empréstimo, sem prejuízo nos juros aplicáveis' +
                ' ao capital. O nao cumprimento do pagamento do valor na data acordada tera juros de mora de 1.5% diario '
        )

        contratoExclusive.setTxtQuinta('Para garantia do pagamento e liquidação da quantia mutuaria, dos respectivos ' +
                'juros compensatórios e moratórios e ainda as despesas judiciais e extrajudiciais o mutuário contratante ' +
                'constitui a favor do mutuante, que a aceita o penhor sobre os seguintes bens moveis: <b>' + bens.trim()+'.</b>'
        )

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