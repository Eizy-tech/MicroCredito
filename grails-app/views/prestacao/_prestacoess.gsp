<style>
    input[type='checkbox'] {
        -webkit-appearance:none;
        width:20px;
        height:20px;
        background:white;
        border-radius:5px;
        border:2px solid #555;
    }
    input[type='checkbox']:checked {
        background: #00a65a;
    }
</style>

<%@ page import="microcredito.Prestacao1Service" %>
<%
    def prestacao1Service = grailsApplication.classLoader.loadClass('microcredito.Prestacao1Service').newInstance()
%>

<span id="span_aux" valor="${emprestimoFechadoOuNao}">${emprestimoFechadoOuNao}</span>
<ol class="breadcrumb" style="padding: 2px; align-content: center">
    <strong>Cliente: <span id="nom_cliente" style="color:#00a65a">${emprestimo.cliente.nome}</span> - Capital: <span id="valor_pedido" style="color:#00a65a"><g:formatNumber number="${emprestimo.valorPedido}" format="#,##0.00"/>
    </span> - Percent.: <span id="percentagem_juros" style="color:#00a65a">${emprestimo.taxaJuros}%</span> - Val_Pagar: <span id="val_pag" style="color:#00a65a"><g:formatNumber number="${emprestimo.valorPedido+(emprestimo.valorPedido*(emprestimo.taxaJuros/100))}" format="#,##0.00"/></span> -  Prazo: <span id="data_concessaoo" style="color:#00a65a"><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></span> - Modalid.: <span id="modo-pagamento" modoPagamento="${emprestimo.modoPagamento.descricao}" style="color:#00a65a"> ${emprestimo.modoPagamento.descricao} </span></strong>
</ol>
<table class="table table-bordered text-center table-striped" style="border: 2px">
    <thead class="thead-light" style="background-color: #00a65a0d">
        <tr>
            <th>Num.</th>
            <th>Valor</th>
            <th>Tipo</th>
            <th>Limite</th>
            <th>Estado</th>
            <th>Meio Pag.</th>
            <th>Parcela</th>
            <th>
                <g:if test="${prestacoes.size() > 0}">
                    <input type="checkbox" class="minimal select_all-checkbox" id='select_all'>
                    <span>Selec./Parc. </span>
                </g:if>
            </th>
        </tr>
    </thead>
    <tbody>
        <g:if test="${prestacoes.size() > 0}">
            <g:each in="${prestacoes}" var="prestacao">
                <tr>
                    <td>
                        ${prestacao.numero}
                    </td>
                    <td id="data-valor${prestacao.id}"  data-valor="${prestacao.valor}" class="valorAPagar">
                        <g:if test="${prestacao.prestacoes}">
                            <g:formatNumber number="${prestacao1Service.dividaPrestacao(prestacao)}" format="#,##0.00"/>
                        </g:if>
                        <g:else>
                             <g:formatNumber number="${prestacao.valor}" format="#,##0.00"/>
                        </g:else>
                    </td>
                    <td>
                        ${prestacao.tipoPrestacao.descricao}
                    </td>
                    <td>
                        <g:formatDate date="${prestacao.dataLimite}" format="dd MMM yyyy"/>
                    </td>
                    <td>
                        ${prestacao.estado}
                    </td>
                    <td>
                        <select class="form-control input-sm" id="${prestacao.id}">
                            <g:each in="${meiosPagamento}" var="meioPagamento">
                                <option value="${meioPagamento.descricao}">${meioPagamento.descricao}</option>
                             </g:each>
                        </select>
                    </td>
                    <td>
                        <span classe="span-parcela" valor-parcela="0.00" style='text-align: center;' id="valor-parcela${prestacao.id}">0.00</span>
                        <input type="hidden" id="observacao${prestacao.id}" value="">
                    </td>
                    <td style="text-align: center; vertical-align: middle; white-space:nowrap;" id="celula-accoes${prestacao.id}">
                        <button class="btn-xs btn-primary pull-right btn-parcela" id="btn-parcela${prestacao.id}" referencia="${prestacao.id}">Parcela</button>
                        <input type="checkbox" mensal="0" class='checkbox checkboxprestacoes' id="check-box${prestacao.id}" data-prest="${prestacao.id}" val="${prestacao.valor}">
                    </td>
                </tr>
            </g:each>
            <g:if test="${emprestimo.modoPagamento.id==3}">
                <tr>
                    <td style="color: orange">
                        ---
                    </td>
                    <td style="color: orange">
                        <g:formatNumber number="${emprestimo.valorPedido}" format="#,##0.00"/>
                    </td>
                    <td style="color: orange">
                        Capital
                    </td>
                    <td style="color: orange">
                        <g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/>
                    </td>
                    <td style="color: orange">
                        Pendente
                    </td>
                    <td>
                        <select class="form-control input-sm" id="meio-pagamento-capital">
                            <g:each in="${meiosPagamento}" var="meioPagamento">
                                <option value="${meioPagamento.descricao}">${meioPagamento.descricao}</option>
                             </g:each>
                        </select>
                    </td>
                    <td style="color: orange">
                        <span classe="span-parcela" observacao-capital="" valor-parcela="0.00" emprestimo-id="${emprestimo.id}" valor-capital="${emprestimo.valorPedido}" style='text-align: center;' id="valor-parcela-capital">0.00</span>
                        <input type="hidden" id="observacao-capital" value="">
                    </td>
                    <td style="text-align: center; vertical-align: middle; white-space:nowrap;" id="-">
                        <button class="btn-xs btn-primary pull-right" id="btn-parcela-capital" valor-capital="${emprestimo.valorPedido}" referencia="capital">Parcela</button>
                        <input type="checkbox" class='checkbox-capital' id="check-box-capital" emprestimo-id="${emprestimo.id}" data-prest="${emprestimo.id}" valor-capital="${emprestimo.valorPedido}">
                    </td>
                </tr>
            </g:if>
        </g:if>
        <g:else>
            <div style="text-align: center">
                <strong style="text-align: center; font-size: 25px; color: red">Não há Prestacoes pendentes desse emprestimo.</strong>
            </div>
        </g:else>
    </tbody>
</table>
<div class="row">
    <div class="col-md-12">
        <g:if test="${emprestimo.modoPagamento.id==3}">
            <g:if test="${prestacoes[0] != null }" >
                <g:if test="${prestacoes[0].dataLimite < new Date()}">
                    <button type="button" disabled class="btn btn-danger pull-right" id="btnMulta">MULTA: ${prestacao1Service.multaJuros(prestacoes[0])}</button>
                </g:if>
            </g:if>
        </g:if>
        <hr>
    </div>
    <div class="col-md-12">
        <button type="submit" disabled class="btn btn-success pull-right btn-pagar" id="btnPagar">Pagar</button>
        <input class="form-control pull-right" disabled name="valorAPagar" id="totaPagar" value="0.00" style="text-align: left; margin-right: 5px; width: 50%">
    </div>
</div>

%{--Modal de Parcela Normal--}%
<div class="modal fade" id="modal-parcela">
    <div class="modal-dialog">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">  <i class="fa fa-money"></i>&nbsp;Parcela</h4>
            </div>
            <div class="modal-body">
                <table class="table table-bordered table-striped">
                    <thead class="thead-light" style="background-color: #00a65a0d">
                    <tr>
                        <th>Valor</th>
                        <th>Observacao</th>
                    </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <input data-validation-help="Somente numeros. (Inteiros ou Decimais)" type="text" data-validation="number" data-validation-allowing="range[0.00;9999999.00],float" class="form-control allow_decimal" id="valor-parcela" name="valor-parcela" placeholder="0.00">
                            </td>

                            <script>
                                $(".allow_decimal").on("input", function(evt) {
                                    var self = $(this);
                                    self.val(self.val().replace(/[^0-9\.]/g, ''));
                                    if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57))
                                    {
                                        evt.preventDefault();
                                    }
                                });
                            </script>
                            <td>
                                <textarea class="form-control" rows="5" id="observacao-parcela" placeholder="Observacao..."  value=""></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success" data-dismiss="modal" id="btn-salvar-parcela"><i class="fa fa-save"></i>&nbsp;Concluir</button>
            </div>
        </div>
    </div>
</div>

%{--Modal de Parcela do Capital--}%
<div class="modal fade" id="modal-parcela-capital">
    <div class="modal-dialog">
        <div class="modal-content modal-lg">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">  <i class="fa fa-money"></i>&nbsp;Parcela</h4>
            </div>
            <div class="modal-body">
                <table class="table table-bordered table-striped">
                    <thead class="thead-light" style="background-color: #00a65a0d">
                    <tr>
                        <th>Valor</th>
                        <th>Observacao</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            <input data-validation-help="Somente numeros. (Inteiros ou Decimais)" type="text" data-validation="number" data-validation-allowing="range[0.00;9999999.00],float" class="form-control allow_decimal" id="valor-parcela-capital-modal" name="valor-parcela" placeholder="0.00">
                        </td>

                        <script>
                            $(".allow_decimal").on("input", function(evt) {
                                var self = $(this);
                                self.val(self.val().replace(/[^0-9\.]/g, ''));
                                if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57))
                                {
                                    evt.preventDefault();
                                }
                            });
                        </script>
                        <td>
                            <textarea class="form-control" rows="5" id="observacao-parcela-capital-modal" placeholder="Observacao..."  value=""></textarea>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success" data-dismiss="modal" id="btn-salvar-parcela-capital-modal"><i class="fa fa-save"></i>&nbsp;Concluir</button>
            </div>
        </div>
    </div>
</div>
<script type='text/javascript'>

    $('#btn-parcela-capital').click(function () {               //open Modal de parcelamento do capital
        $('#modal-parcela-capital').modal({
            show:true, backdrop: "static"
        })
    });

    $('#btn-salvar-parcela-capital-modal').click(// Accao de registo de parcela Normal
        function (){
            var valorParcelaCapital = +$('#valor-parcela-capital-modal').val(); //Valor introduzido
            var valorCapital = +$('#valor-parcela-capital').attr('valor-capital');

            if((valorCapital-valorParcelaCapital) > 0){ //A parcela deve ser de valor menor que o do capital
                $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
                observacaoCapital = $('#observacao-parcela-capital-modal').val();
                $('#valor-parcela-capital').attr('observacao-capital', observacaoCapital); // Receber a obervacao que o user deu
                //Colocar na coluna de parcela o valor e o butao de cancelar
                $('#valor-parcela-capital').html(
                    '<span id="parcela-capital-span" style="margin-right: 8px;">'
                    +valorParcelaCapital+
                    '</span><button id="btn-cancelar-parcela-capital" type="button" class="btn btn-xs btn-danger"><i class="fas fa-times" aria-hidden="true"></i></button>'
                );//Actualizacao do valor da parcela na tabela

                $.getScript('/assets/prestacoesauxcapital.js');

                // vamos verificar se antes este chech estava selecionado
                if( $('#check-box-capital')[0].checked){
                    //Temos que fazer uma substituicao (Qual?)
                    if(+$('#valor-parcela-capital').attr('valor-parcela') == 0){
                        //Significa que queriam pagar o capital e nao parcela
                        total = +(+total - valorCapital);//
                        total = +(+total + valorParcelaCapital);
                        $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
                        $('#totaPagar').attr('value', +total)//Actualizacao do total a pagar
                        $('#btnPagar').removeAttr('disabled');

                    }else if(+$('#valor-parcela-capital').attr('valor-parcela') > 0 ){
                        //Significa que anteriormente queriam pagar uma parcela
                        var parcelaC = +$('#valor-parcela-capital').attr('valor-parcela');
                        total = +(+total - parcelaC);//
                        total = +(+total + valorParcelaCapital);
                        $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
                        $('#totaPagar').attr('value', +total)//Actualizacao do total a pagar
                        $('#btnPagar').removeAttr('disabled');
                    }
                }else{
                    total = +(+total + valorParcelaCapital);
                    $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
                    $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
                    $('#btnPagar').removeAttr('disabled');
                }

                $('#check-box-capital')[0].checked = true;  //faz check-true
                $('#check-box-capital').prop('disabled', true); //Desabilita o check
                $('#btnPagar').removeAttr('disabled');

                if ($('.checkbox:checked').length == $('.checkbox').length ){
                    $("#select_all")[0].checked = true; //change "select all" checked status to true
                }
                $('#valor-parcela-capital').attr('valor-parcela', valorParcelaCapital);
                $('#valor-parcela-capital-modal').val('');
                $('#observacao-parcela-capital-modal').val('');
                actualizarArray();
            }else{
                alert("A parcela deve ser de valor menor que o do capital");
            }
        }
    );
</script>

<script type='text/javascript'>
    var total = 0;
    var val = 0;
    var pagamentoPrestacoes = [];
    var registro = [];
    var idPrestacao;
    var referenciaPrestacao;
    var meioPagamento;
    var valorParcela;
    var observacaoParcela;
</script>
<script>
    var haCapital = false;
    var PagaCapital = false;
    var capitalTotal = 0;
    var capitalParcela = 0;
    var meioPagamentoCapital = '';
    var observacaoCapital = '';

    $(document).ready( function() {
        var modoPagamento = $('#modo-pagamento').attr('modoPagamento');
        // if(modoPagamento == 'Mensal' && $('.checkbox').length > 0){
        if(modoPagamento == 'Mensal'){
            haCapital = true;
        }
    });
</script>

<script type='text/javascript'>
    $('#btn-salvar-parcela').click(// Accao de registo de parcela Normal
        function (){
            var valorParcela = $('#valor-parcela').val(); //Valor introduzido
            var valorPrestacao = $('#data-valor'+referenciaPrestacao).attr('data-valor');

            if((valorPrestacao-valorParcela) > 0){ //A parcela deve ser de valor menor que o da prestacaoGeral
                // $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
                var observacaoDaParcela = $('#observacao-parcela').val();
                $('#observacao'+referenciaPrestacao).val(observacaoDaParcela); // Receber a obervacao que o user deu
                //Colocar na coluna de parcela o valor e o butao de cancelar
                $('#valor-parcela'+referenciaPrestacao).html(
                    '<span id="parcela'+referenciaPrestacao+'" style="margin-right: 8px;">'
                    +valorParcela+
                    '</span><button id="btn-cancelar-parcela'+referenciaPrestacao+'" type="button" referencia="'+referenciaPrestacao+'" class="btn btn-xs btn-danger btn-cancela_parcela"><i class="fas fa-times" aria-hidden="true"></i></button>'
                );//Actualizacao do valor da parcela na tabela

                $.getScript('/assets/prestacoesaux.js');

                // vamos verificar se antes este chech estava selecionado
                if( $('#check-box'+referenciaPrestacao)[0].checked){
                    //Temos que fazer uma substituicao (Qual?)
                    if(+$('#valor-parcela'+referenciaPrestacao).attr('valor-parcela') == 0){
                        //Significa que queriam pagar a prestacaoGeral e nao parcela
                        //total = +(+total - valorPrestacao);//
                        valorPrestacao = +valorPrestacao+0;
                        valorParcela = +valorParcela+0;
                        total = (total - valorPrestacao);//
                        total = +(total + valorParcela);
                        $('#totaPagar').attr('value','')//Actualizacao do total a pagar
                        $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
                        $('#btnPagar').removeAttr('disabled');

                    }else if(+$('#valor-parcela'+referenciaPrestacao).attr('valor-parcela') > 0){
                        //Significa que anteriormente queriam pagar uma parcela
                        var parcela = +$('#valor-parcela'+referenciaPrestacao).attr('valor-parcela');
                        var totalAnt = +$('#totaPagar').val();
                        valorParcela = +valorParcela+0;
                        total = +(+totalAnt - parcela);
                        total = +(+total + valorParcela);
                        $('#totaPagar').attr('value','')//Actualizacao do total a pagar
                        $('#totaPagar').attr('value', +total)//Actualizacao do total a pagar
                        $('#btnPagar').removeAttr('disabled');
                    }
                }else{
                    valorParcela = +valorParcela+0;
                    total = +(+total + valorParcela);
                    $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
                    $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
                    $('#btnPagar').removeAttr('disabled');
                }

                $('#check-box'+referenciaPrestacao)[0].checked = true;  //faz check-true
                $('#check-box'+referenciaPrestacao).prop('disabled', true); //Desabilita o check
                $('#btnPagar').removeAttr('disabled');

                if ($('.checkbox:checked').length == $('.checkbox').length ){
                    $("#select_all")[0].checked = true; //change "select all" checked status to true
                }
                $('#valor-parcela'+referenciaPrestacao).attr('valor-parcela', valorParcela);
                $('#valor-parcela').val('');
                $('#observacao-parcela').val('');
                actualizarArray();
            }else{
                alert("A parcela deve ser de valor menor que o da prestacaoGeral");
            }
        }
    );

     $('.btn-parcela').click(function () {               //open Modal de parcelamento pop-up
        referenciaPrestacao = $(this).attr('referencia');
        $('#modal-parcela').modal({
            show:true, backdrop: "static"
        })
     });

    //Assunto Checks
    //seleccao de todos checkboxes
    $("#select_all").change(function(){  //"select all" change (Todos checks)
        total = 0; //Inicializa o total
        var status = this.checked; // Pega o estado do"select all"

        $('.checkbox').each(function(){//Em cada Check
            //Mudar estado de cada check
            this.checked = status; //Pega o mesmo estado do "select all"

            //Somatorio de total a pagar se o 'select all' for true
            if (status){
                val = +$(this).closest('tr').find('td[data-valor]').data('valor');
                total = +(+total+val);
            }
        });//A variavel 'total sai com o total <> 0 se o chek for true

        if(status){//Se o select all for true
            $('#btnPagar').removeAttr('disabled');//Habilita o butao de pagar
            if(haCapital){
                $("#check-box-capital")[0].checked = true;// o check do capital tambem fica true
                capitalTotal = +$('#check-box-capital').attr('valor-capital');
                total = +(total + capitalTotal);// Adiciona o valor do capital
            }
        }else{//O select all foi unchecked
            total = 0.00;
            if(haCapital) {
                capitalTotal = 0;
                $("#check-box-capital")[0].checked = false;// o check do capital tambem fica true
                $('#valor-parcela-capital').html('0.00');// O valor da parcela na view fica zero
                $('#check-box-capital').removeAttr('disabled');//O check do capital fica habilitado
                $('#valor-parcela-capital').attr('valor-parcela', '0.00');
            }
            $('#btnPagar').prop('disabled', true);
            $('.checkbox').each(function(){
                var referenciaPrestacao = $(this).attr('data-prest');
                $('#valor-parcela'+referenciaPrestacao).html('0.00');
                $('#valor-parcela'+referenciaPrestacao).attr('valor-parcela', '0.00');
                $('#check-box'+referenciaPrestacao).prop('disabled', false); //Desabilita o check
                $('#check-box'+referenciaPrestacao).removeAttr('disabled');
            });
        };
        $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
        $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
        actualizarArray();
    });
    //Seleccao de um check
    $('.checkbox').change(function(){ //".checkbox" change (Um check)
        //uncheck "select all", if one of the listed checkbox item is unchecked
        if(this.checked == false){ //if this item is unchecked
            $("#select_all")[0].checked = false; //change "select all" checked status to false

            val = +$(this).closest('tr').find('td[data-valor]').data('valor');
            total = +$('#totaPagar').val();
            total = +(+total-val);
            $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
            $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
            if (($('.checkbox:checked').length) == 0){
                $('#btnPagar').prop('disabled', true);
            }
            actualizarArray();
        }

        if(this.checked == true){ //if this item is checked
            //Actualizar total a pagar
            val = +$(this).closest('tr').find('td[data-valor]').data('valor');
            total = $('#totaPagar').val();
            total = +(+total+val);

            $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
            $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
            $('#btnPagar').removeAttr('disabled');

            //Este e selecinado enquanto os outros ja estavam tambem, logo seleciona todos
            if(haCapital){
                if (($('.checkbox:checked').length) == ($('.checkbox').length) && $('#check-box-capital')[0].checked ){
                    $("#select_all")[0].checked = true; //change "select all" checked status to true
                }
            }else{
                if (($('.checkbox:checked').length) == ($('.checkbox').length)){
                    $("#select_all")[0].checked = true; //change "select all" checked status to true
                }
            }
            actualizarArray();
        }
    });

    //seleccao do check de capital
    $('#check-box-capital').change(function(){
        var estadoCheckCapital = $('#check-box-capital')[0].checked;
        var valorCapital = 0;
        if(estadoCheckCapital){
            valorCapital = +$('#check-box-capital').attr('valor-capital');
            total = +$('#totaPagar').val();
            total = +(+total+valorCapital);
            $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
            $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
            $('#btnPagar').removeAttr('disabled');
            if (($('.checkbox:checked').length) == ($('.checkbox').length)){
                $("#select_all")[0].checked = true; //change "select all" checked status to true
            }
            actualizarArray();
        }else{
            $("#select_all")[0].checked = false; //change "select all" checked status to false
            valorCapital = +$('#check-box-capital').attr('valor-capital');
            total = +$('#totaPagar').val();
            total = +(+total-valorCapital);
            $('#totaPagar').attr('value', total)//Actualizacao do total a pagar
            if (($('.checkbox:checked').length) == 0){
                $('#btnPagar').prop('disabled', true);
            }
            actualizarArray();
        }
    });


    function actualizarArray(){
        pagamentoPrestacoes = [];
        val = 0;
        if(haCapital){
            PagaCapital = $("#check-box-capital")[0].checked;
            registro = [];
            registro.push(haCapital);
            registro.push(PagaCapital);
            capitalTotal = +$('#valor-parcela-capital').attr('valor-capital');
            registro.push(capitalTotal);
            registro.push(capitalParcela);
            meioPagamentoCapital = $('#meio-pagamento-capital').val();
            registro.push(meioPagamentoCapital);
            capitalParcela = +$('#valor-parcela-capital').attr('valor-parcela');
            registro.push(observacaoCapital);
            registro.push(+$('#valor-parcela-capital').attr('emprestimo-id'));
            pagamentoPrestacoes.push(registro);
            registro = [];
        }
        $('.checkbox').each(function(){
            if(this.checked == true){
                idPrestacao = $(this).attr('data-prest');
                if(+($('#valor-parcela'+idPrestacao).text()) > 0){

                    $('#check-box'+idPrestacao)[0].checked = true;  //faz check-true
                    $('#check-box'+idPrestacao).prop('disabled', true); //Desabilita o check

                    meioPagamento = $('select[id='+idPrestacao+']').val();
                    valorParcela = +($('#valor-parcela'+idPrestacao).text());
                    observacaoParcela = $('#observacao'+idPrestacao).val();
                    registro.push(idPrestacao);
                    registro.push(meioPagamento);
                    registro.push(valorParcela);
                    registro.push(observacaoParcela);
                    pagamentoPrestacoes.push(registro);
                    // console.log(pagamentoPrestacoes);
                    registro = [];


                }else{
                    meioPagamento = $('select[id='+idPrestacao+']').val();
                    valorParcela = +($('#valor-parcela'+idPrestacao).text());
                    observacaoParcela = $('#observacao'+idPrestacao).val();
                    registro.push(idPrestacao);
                    registro.push(meioPagamento);
                    registro.push(valorParcela);
                    registro.push(observacaoParcela);
                    pagamentoPrestacoes.push(registro);
                    console.log(pagamentoPrestacoes);
                    registro = [];
                }
            }
        });
        //Actualizar total a pagar
        // $('#totaPagar').attr('value', total);
    };

    $('#btnPagar').click(function () {
        actualizarArray();
       swal({
            title: "Confirmar o pagamento de "+$('#totaPagar').val()+" MT?",
            imageUrl: "../assets/question.png",
            showCancelButton: true,
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function () {
            $.ajax({
                url: "${g.createLink( controller: 'prestacao', action:'pagamentos')}",
                contentType:'application/json',
                type: "POST",
                data: JSON.stringify(pagamentoPrestacoes),
                success: function(data) {
                    //location.reload();
                    if($('#span_aux').attr('valor')){
                        setTimeout(function () {
                            swal({
                                title: "Certo!",
                                text: "Pagamento efectuado com Sucesso... Parabens, liquidou todas dividas!",
                                timer: 2500,
                                type:  "success",
                                showConfirmButton: false
                            });
                        }, 2000);
                        alert("Parabens, liquidou todas dividas!")
                    }else{
                        setTimeout(function () {
                            swal({
                                title: "Certo!",
                                text: "Pagamento efectuado com Sucesso!",
                                timer: 2500,
                                type:  "success",
                                showConfirmButton: false
                            });
                        }, 1000);
                        $('#'+lastBtnlist).trigger('click');
                    }
                },
                error: function () {
                    swal("Erro", "Ocorreu algum erro ao Efectuar pagamento", "error");
                }
            });
        });
    });
</script>




