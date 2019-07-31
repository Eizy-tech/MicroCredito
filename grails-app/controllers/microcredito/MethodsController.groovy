package microcredito

import com.lowagie.text.Document
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfImportedPage
import com.lowagie.text.pdf.PdfReader
import com.lowagie.text.pdf.PdfWriter

import java.text.Normalizer

class MethodsController {

    def index() { }


    def saltarDomingos(def date){
        Calendar calendar = Calendar.getInstance()
        calendar.setTime(date)
        if(calendar.get(Calendar.DAY_OF_WEEK) == 1){
            date = Date.parse("yyyy-MM-dd", (date + 1).format("yyyy-MM-dd"))
        }
        return date
    }
    def saltarDomingosVerificao(def date){
        Calendar calendar = Calendar.getInstance()
        calendar.setTime(date)
        (calendar.get(Calendar.DAY_OF_WEEK) == 1)?true:false
    }

    def retornaInt(def input) {
        if (input == null || input == "") {
            return 0
        } else {
            return input.toInteger()
        }
    }

    def retornaDouble(def input) {
        if (input == null || input == "") {
            return 0
        } else {
            return input.toDouble()
        }
    }

    // retorna zeros a acrescentar antes de numero da prestacao
    def retornaZeros(quant){
        def zeros=''
        for (def i =0; i < quant;i++){
            zeros+='0'
        }
        return zeros
    }

    /*Remove acentuacoes numa string*/
    def semAcentos(String s) {
        s = Normalizer.normalize(s, Normalizer.Form.NFD)
        s = s.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        return s
    }

    def dataPicker(string) {
        def quebra = string.toString().split('-')
        def ano = quebra[2]
        def mes = quebra[1]
        def dia = quebra[0]

        return ano + "-" + mes + "-" + dia
    }

    def formatData(def data){
        Calendar calendar = Calendar.getInstance()
        calendar.setTime(data)
        def mes = (calendar.get(Calendar.MONTH)+1)
        if(mes.toString().length() == 1){
            mes =0+''+mes
        }
        return calendar.get(Calendar.DAY_OF_MONTH)+'/'+mes+'/'+calendar.get(Calendar.YEAR)
    }

    def formatDataeHora(def data){
        Calendar calendar = Calendar.getInstance()
        calendar.setTime(data)
        def mes = (calendar.get(Calendar.MONTH)+1)
        if(mes.toString().length() == 1){
            mes =0+''+mes
        }
        return calendar.get(Calendar.DAY_OF_MONTH)+'/'+mes+'/'+calendar.get(Calendar.YEAR)+'     '+
                calendar.get(Calendar.HOUR_OF_DAY)+'h:'+calendar.get(Calendar.MINUTE)
    }

    def formatDataNascimento(def data){
        Calendar calendar = Calendar.getInstance()
        calendar.setTime(data)
        def array = ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro']
        return calendar.get(Calendar.DAY_OF_MONTH)+' de '+array.get(calendar.get(Calendar.MONTH))+' de '+calendar.get(Calendar.YEAR)
    }

    def capitalize(String input){
        if(input.length() <= 1){
            return input
        }else{
            return input.substring(0, 1).toUpperCase() + input.substring(1)
        }
    }

    def mergePdf(def list, def outputStream){
        Document document = new Document()
        PdfWriter pdfWriter = PdfWriter.getInstance(document, outputStream)
        document.open()
        PdfContentByte pdfContentByte = pdfWriter.getDirectContent()

        for (InputStream inStr : list) {
            PdfReader pdfReader = new PdfReader(inStr)
            for (int i = 1; i <= pdfReader.getNumberOfPages(); i++) {
                document.newPage()
                PdfImportedPage page = pdfWriter.getImportedPage(pdfReader, i)
                pdfContentByte.addTemplate(page, 0, 0)
            }
        }
        outputStream.flush()
        document.close()
        outputStream.close()
    }

    def backupDB(){
        try {
            String name = "backup_"+System.currentTimeMillis().toString()
            String dump = "mysqldump -uroot -r"+name+"1.sql micro_credito"
            File destino = new File("D:/Dropbox/Microcredito/_DBbackups/")
            if(!destino.isDirectory()){
                destino.mkdir()
            }
            Process prcs = Runtime.getRuntime().exec(dump,null,destino)
            prcs.waitFor()

            //other method to backup
            String savePath = "D:/Dropbox/Microcredito/_DBbackups/"+name+"2.sql"
            String executeCmd = "mysqldump -uroot  --database micro_credito -r " + savePath

            Process runtimeProcess = Runtime.getRuntime().exec(executeCmd)
            int processComplete = runtimeProcess.waitFor()
            if (processComplete == 0) {
                System.out.println("Backup Complete")
            } else {
                System.out.println("Backup Failure")
            }
        } catch (IOException ex1) {

        } catch (InterruptedException ex) {

        }
    }
}
