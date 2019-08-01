<div class="row">

    <%@ page import="microcredito.Prestacao1Service" %>
    <%
        def prestacao1Service = grailsApplication.classLoader.loadClass('microcredito.Prestacao1Service').newInstance()
    %>
    <%@ page import="microcredito.Emprestimo1Service" %>
    <%
        def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
    %>

    <div class="col-md-12" id="div-a">

        %{--<g:link target="_blank" class="btn btn-sm btn-default mb-2 ml-2 btnRecibo "  style="color: black; width: 95%; font-size: 15px"--}%
        %{--controller="emprestimo" action="verRecibo" id="recibo">--}%
        %{--<i class="fa fa-file-pdf" style="color: red"></i>&nbsp;Recibo--}%
        %{--</g:link>--}%
        %{--<a target="_blank" href="/emprestimo/verRecibo/recibo" id="reciboBtn">Rec</a>--}%

        <div class="box box-success" style="background-color: white">
            <div class="box-header" style="background-color: #ecf0f5">
                <h3 class="box-title"><i class="fa fa-list"></i><strong>&nbsp;Prestações não pagas</strong></h3>
            </div>

            <div class="box-body">
                <div class="row">
                    <div class="col-md-3">
                        <div class="list-group mb-1">
                            <a class="list-group-item">
                                Cliente: <b class="pull-right">${emprestimo.cliente.nome}</b>
                            </a>
                            <a class="list-group-item">
                                Emprestimo(Nº do processo): <b class="pull-right">${emprestimo.nrProcesso}</b>
                            </a>
                            <a class="list-group-item">
                                Capital: <b class="pull-right"><g:formatNumber number="${emprestimo.valorPedido}"
                                                                               format="#,##0.00"/></b>
                            </a>
                            <a class="list-group-item">
                                Renda Normal: <b class="pull-right">
                                <g:formatNumber number="${emprestimo.valorPedido * (emprestimo.taxaJuros) / 100}"
                                                format="#,##0.00"/></b>
                            </a>
                            <a class="list-group-item">Valor a pagar: <b class="pull-right">
                                <g:formatNumber
                                        number="${emprestimo.valorPedido + (emprestimo.valorPedido * (emprestimo.taxaJuros / 100))}"
                                        format="#,##0.00"/></b>
                            </a>
                            <a class="list-group-item">
                                Prazo: <b class="pull-right"><g:formatDate
                                    date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></b>
                            </a>
                            <a class="list-group-item" style="font-weight: bold; color: #9f191f">
                                Dívida Total: <b class="pull-right"><g:formatNumber
                                    number="${emprestimoServic.somaPrestacoesDivida(emprestimo)}"
                                    format="#,##0.00"/></b>
                            </a>
                            <a class="list-group-item">
                                <button class="btn btn-sm btn-success btn-reduzir-capital col-md-offset-3"
                                        id="btn-reduzir-capital" data-capital="${emprestimo.valorPedido}"
                                        data-capital-parcela="0" data-idp-emprestimo="${emprestimo.id}"
                                        data-id-emp="${params.cred}" params="[cred: ${params.cred}]"><i
                                        class="fa fa-money-bill-wave"></i>&nbsp;&nbsp;&nbsp;&nbsp;Reduzir Capital&nbsp;&nbsp;&nbsp;&nbsp;
                                </button>
                                %{--joaoBtnParcCap--}%
                            </a>
                        </div>
                    </div>

                    <div class="col-md-9">
                        <div id="prestacoesEmprestimo" class="prestacoesEmprestimo">

                            <table class="table table-striped table-bordered"
                                   style="border: 2px solid gainsboro; border-radius: 5px">
                                <thead class="thead-light" style="background-color: #00a65a0d">
                                <tr>
                                    <th style="width: 11%">Numero</th>
                                    <th style="width: 11%">Valor</th>
                                    <th style="width: 11%">Tipo</th>
                                    <th style="width: 9%">Limite</th>
                                    <th style="width: 13%">Meio Pag.</th>
                                    <th style="width: 11%">Referencia/Conta</th>
                                    <th style="width: 9%">
                                        <input type="checkbox" class="minimal select_all-checkbox" id='select_all'>
                                        <span>Pagar</span>
                                    </th>
                                    <th style="width: 11%">Parcela</th>
                                    <th style="width: 11%">
                                        <span>Parcelas</span>
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <g:if test="${prestacoes.size() > 0}">
                                    <g:each in="${prestacoes.sort { it.id }}" var="prestacao">
                                    %{--a prestacao tem parcela--}%
                                        <g:if test="${prestacao.prestacoes}">
                                            <tr
                                                id="linhaprestacao${prestacao.id}" data-valprestacao="${prestacao1Service.dividaPrestacao(prestacao)}"
                                                data-valparcela="0" data-meiopagamento="" data-referenciapag="" data-contapag=""
                                                data-tipoprestacao="${prestacao.tipoPrestacao.id}" data-idprestacao="${prestacao.id}"
                                                class="linhaprestacao" data-observacao=""
                                            >
                                        </g:if>
                                    %{--a prestacao nao tem parcelas--}%
                                        <g:else>
                                            <tr
                                                id="linhaprestacao${prestacao.id}" data-valprestacao="${prestacao1Service.dividaPrestacao(prestacao)}"
                                                data-valparcela="0" data-meiopagamento="" data-referenciapag="" data-contapag=""
                                                data-tipoprestacao="${prestacao.tipoPrestacao.id}" data-idprestacao="${prestacao.id}"
                                                class="linhaprestacao"
                                            >
                                        </g:else>
                                        <td>
                                            ${prestacao.numero}
                                        </td>
                                        <td class="valorAPagar">
                                            <g:if test="${prestacao.prestacoes}">
                                                <g:formatNumber
                                                        number="${prestacao1Service.dividaPrestacao(prestacao)}"
                                                        format="#,##0.00"/>
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
                                    %{--<td>--}%
                                    %{--${prestacao.estado}--}%
                                    %{--</td>--}%
                                        <td style="padding: 1px">
                                            <select class="form-control select-meiopagamento m-0 p-0"
                                                    id="meio-pagamento${prestacao.id}"
                                                    data-referenciaprestacao="${prestacao.id}">
                                                <g:each in="${meiosPagamento}" var="meioPagamento">
                                                    <option value="${meioPagamento.id}">${meioPagamento.descricao}</option>
                                                </g:each>
                                            </select>
                                        </td>
                                        <td id="referenciaouconta" style="padding: 1px">
                                            <div class="form-group m-0 p-0" id="div-referencia${prestacao.id}">
                                                <input id="input-referencia${prestacao.id}" type="text"
                                                       class="form-control referencia-pagamento m-0"
                                                       data-idprestacao="${prestacao.id}"
                                                       placeholder="Referencia">
                                            </div>

                                            <div class="form-group" id="div-bancaria${prestacao.id}">
                                                <select class="form-control select-conta m-0 p-0"
                                                        id="conta-bancaria${prestacao.id}"
                                                        data-referenciaprestacao="${prestacao.id}">
                                                    <g:each in="${contas}" var="banco">
                                                        <option value="${banco.id}">${banco.banco}</option>
                                                    </g:each>
                                                </select>
                                            </div>
                                        </td>
                                        <td id="celula-accoes${prestacao.id}">
                                            <input type="checkbox" class='checkbox checkboxprestacoes'
                                                   id="check-box${prestacao.id}"
                                                   data-referenciaprestacao="${prestacao.id}">
                                        </td>
                                        <td>
                                            <span style='text-align: center;'
                                                  id="valor-parcela${prestacao.id}">0.00
                                            </span>
                                        </td>
                                        <td>
                                            <g:if test="${prestacao.prestacoes}">
                                                <button class="btn btn-sm btn-primary btn-parcela"
                                                        id="btn-parcela${prestacao.id}"
                                                        data-valorprestacao="${prestacao1Service.dividaPrestacao(prestacao)}"
                                                        data-idprestacao="${prestacao.id}"><i
                                                        class="fa fa-money-bill-wave"></i>&nbsp;Parcelar
                                                </button>
                                            </g:if>
                                            <g:else>
                                                <button class="btn btn-sm btn-primary btn-parcela"
                                                        id="btn-parcela${prestacao.id}"
                                                        data-valorprestacao="${prestacao.valor}"
                                                        data-idprestacao="${prestacao.id}"><i
                                                        class="fa fa-money-bill-wave"></i>&nbsp;Parcelar
                                                </button>
                                            </g:else>
                                        </td>
                                        </tr>
                                    </g:each>
                                </g:if>
                                <g:else>
                                    <div style="text-align: center">
                                        <strong style="text-align: center; font-size: 25px; color: red">Não há Prestacoes pendentes desse emprestimo.</strong>
                                    </div>
                                </g:else>
                                </tbody>
                            </table>

                            <div class="row">
                                <div class="col-sm-4"></div>

                                <div class="col-sm-3"></div>

                                <div class="col-sm-1" style="padding-right: 1px">
                                    <span class="pull-right" style="font-size: 1.8em; text-align: center">MT</span>
                                </div>

                                <div class="col-sm-3" style="padding-right: 3px; padding-left: 2px">
                                    <input id="valor-apagar" class="form-control" type="text" value="0.00" disabled
                                           style="font-size: 1.8em;">
                                </div>

                                <div class="col-sm-1" style="padding-left: 3px">
                                    <button id="btnpagar" class="btn btn-success"
                                            style="padding: 6px; height: 90%; width: 100%"><i
                                            class="fa fa-money-bill-wave"></i>&nbsp;Pagar
                                    </button>
                                </div>
                            </div>
                        </div>
                        %{--<u><small>Posperidade MicroCredito Lda</small></u>--}%
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

%{--Modal de Parcela Normal--}%
<div class="modal fade" id="modal-parcela">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content" style="width: 30%">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"><i class="fa fa-money"></i>&nbsp;Parcela</h4>
                </div>

                <div class="modal-body">
                    <label>Valor:</label>
                    <input data-validation-help="Somente numeros. (Inteiros ou Decimais)" type="text"
                           data-validation="number"
                           data-validation-allowing="range[0.00;9999999.00],float" class="form-control allow_decimal"
                           id="valor_parcela_modal" name="valor-parcela" placeholder="0.00" data-idprestacao=""
                           autocomplete="off">

                    <textarea class="form-control mt-4" rows="5" id="observacao_parcela_modal"
                              placeholder="Observacao..." value=""></textarea>


                    <script>
                        $(".allow_decimal").on("input", function (evt) {
                            var self = $(this);
                            self.val(self.val().replace(/[^0-9\.]/g, ''));
                            if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57)) {
                                evt.preventDefault();
                            }
                        });
                    </script>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-success" data-dismiss="modal"
                            id="btnSalvarParcela" data-idprestacao="" data-valorprestacao="">
                        <i class="fa fa-check"></i>&nbsp;Concluir
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

%{--Modal de Parcela Capital--}%
<div class="modal fade" id="modal-reduzir-capital">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content" style="width: 30%">
                <div class="modal-header">
                    <button type="button" class="close" id="btn-parcela-capital" data-dismiss="modal"
                            aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title"><i class="fa fa-money"></i>&nbsp;Reduzir Capital</h4>
                </div>

                <form id="formulario-parcela-capital">
                    <div class="modal-body">
                        <g:hiddenField name="idEmp" value="${params.cred}" id="id-emp"/>
                        <label>Valor:</label>
                        <input data-validation-help="Somente numeros. (Inteiros ou Decimais)" type="text"
                               data-validation="number"
                               data-validation-allowing="range[0.00;9999999.00],float"
                               class="form-control allow_decimal"
                               id="valor_parcela_capital" name="valorParcela" placeholder="0.00" data-idprestacao=""
                               autocomplete="off">

                        <textarea class="form-control mt-4" rows="5" id="observacao_parcela_capital"
                                  placeholder="Observacao..." name="obs" value=""></textarea>
                        %{--<button type="submit" class="btn btn-success" data-dismiss="modal"--}%
                        %{--id="btnSalvarParcelaCapital" data-idprestacao="" data-valorprestacao="" disabled>--}%
                        %{--<i class="fa fa-check"></i>&nbsp;Pagar--}%
                        %{--</button>--}%
                        %{--joaoPagar--}%

                    </div>

                    <div class="modal-footer">
                        <button type="submit" class="btn btn-success"
                                id="btnSalvarParcelaCapital" data-idprestacao="" data-valorprestacao="" disabled>
                            <i class="fa fa-check"></i>&nbsp;Pagar
                        </button>
                    </div>
                </form>
                <script>
                    $(".allow_decimal").on("input", function (evt) {
                        var self = $(this);
                        self.val(self.val().replace(/[^0-9\.]/g, ''));
                        if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57)) {
                            evt.preventDefault();
                        }
                    });

                    $(document).ready(function () {
                        $("#formulario-parcela-capital").submit(function (event) {
                            event.preventDefault();

                            $.ajax({
                                url: "${g.createLink( controller: 'prestacao', action:'pagarCapitalParcela')}",
                                type: "post",
                                data: $(this).serialize(),
                                success: function (data) {
                                    // window.location ='/categoriaEntidade/show/'+data.categoria.id;
                                    alert('Sucesso: '+data.msg);
                                    $('#valor_parcela_capital').val('');
                                    $('#observacao_parcela_capital').val('');
                                    $('#btnSalvarParcelaCapital').modal('hide');
                                },
                                error: function (data) {
                                    alert('Erro: '+data.msg);
                                    $('#valor_parcela_capital').val('');
                                    $('#observacao_parcela_capital').val('');
                                }
                            });
                        });
                    });

                    $(document).ready(
                        $('#valor_parcela_capital').on('input', function (e) {
                                var capital = +$('#btn-reduzir-capital').attr('data-capital');
                                var parcelaCapital = +$(this).val();

                                if (capital < parcelaCapital || parcelaCapital < 0) {
                                    $('#btnSalvarParcelaCapital').prop('disabled', true);
                                    alert('O valor informado não deve ser maior que o capital actual ou menor que zero.');
                                } else {
                                    //Vai acontecer aqui
                                    $('#btnSalvarParcelaCapital').removeAttr('disabled');
                                }
                                // joaoScr
                            }
                        )
                    );
                </script>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(
        function () {
            $('#caminho').append('<li><a><g:link controller="emprestimo" action="index">Emprestimo</g:link>  </a></li>');
            $('#caminho').append('<li><a>Prestações</a></li>');

            hideAllSelectConta();//Fecha todos selects de contas
            $('#btnpagar').prop('disabled', true);//Desabilitar botao
        }
    );

    //METODOS
    // Assunto ComboBox Conta Bancaria
    function hideAllSelectConta() {
        $('.select-conta').each(function () {
            this.style.display = 'none';
        })
    }

    function showAllSelectConta() {
        $('.select-conta').each(function () {
            this.style.display = 'block';
        })
    }

    function hideSelectConta(id) {
        var earrings = document.getElementById('conta-bancaria' + id);
        earrings.style.display = 'none';
        document.getElementById('div-bancaria' + id).style.display = 'none';
    }

    function showSelectConta(id) {
        var earrings = document.getElementById('conta-bancaria' + id);
        earrings.style.display = 'block';
        document.getElementById('div-bancaria' + id).style.display = 'block';
    }

    //Fim do Assunto ComboBox Conta Bancaria

    // Assunto Referencia Pagamento Mpesa
    function hideAllInputReferencia() {
        $('.referencia-pagamento').each(function () {
            this.style.display = 'none';
        })
    }

    function showAllInputReferencia() {
        $('.referencia-pagamento').each(function () {
            this.style.display = 'block';
        })
    }

    function hideInputReferencia(id) {
        // alert(id);
        var earrings = document.getElementById('input-referencia' + id);
        earrings.style.display = 'none';
        document.getElementById('div-referencia' + id).style.display = 'none';
    }

    function showInputReferencia(id) {
        var earrings = document.getElementById('input-referencia' + id);
        earrings.style.display = 'block';
        document.getElementById('div-referencia' + id).style.display = 'block';
    }

    //Fim do Assunto Referencia Pagamento Mpesa

    // Assunto CheckBoxes
    function check(idCheck) {
        $('#check-box' + idCheck)[0].checked = true;
    }

    function unCheck(idCheck) {
        $('#check-box' + idCheck)[0].checked = false;
        removeParcela(idCheck);
    }

    //Metodo chamado quando muda o estado do check All
    function ckeckOrUncheckAllCkeckBoxPagar(status) {
        $('.checkbox').each(function () {//Em cada Check
            //Mudar estado de cada check
            this.checked = status; //Pega o mesmo estado do "select all"
        });
        if (!status) {//status=falso
            //fecha o botao de pagar
            $('#btnpagar').prop('disabled', true);//Desabilitar botao

            //zera todas parcela
            $('.checkbox').each(function () {//Em cada Check
                var idPrestacao = +$(this).attr('data-referenciaprestacao');
                //Zera cada prestacao
                zeraParcela(idPrestacao);

                //Limpa cada Observacao
                limpaObservacao(idPrestacao);
            });
        }
    }

    //Ao mudar o status dum check simples, decida se seleciona check-All ou diseleciona o check-All
    function checkUncheckSelectall(idPrestacao, status) {
        if (status) {//Se single check for 'true'
            var totalChecked = +$('.checkbox:checked').length;
            var totalCheckBox = +$('.checkbox').length;
            //Ver se eh o ultimo check true
            if (totalChecked === totalCheckBox) {
                $("#select_all")[0].checked = true;
            }
        } else {//Se single check for 'false'
            if ($("#select_all")[0].checked) {
                $("#select_all")[0].checked = false;
            }
            zeraParcela(idPrestacao);
            zeraParcelaSpan(idPrestacao);
            limpaObservacao(idPrestacao);
            $('#btnpagar').prop('disabled', true);//Desabilitar botao
        }
    }

    // Fim do Assunto CheckBoxes

    //Assunto Parcelas

    // No span de parcela coloca '0.00'
    function zeraParcelaSpan(idPrestacao) {//No span
        $('#valor-parcela' + idPrestacao).html('0.00');
    }

    //Zera a parcela na linha
    function zeraParcela(idPrestacao) {//Na linha
        $('#linhaprestacao' + idPrestacao).attr('data-valparcela', '0.00');
    }

    // Na linha
    function actualizaValorParcela(idPrestacao, valorParcela) {
        $('#linhaprestacao' + idPrestacao).attr('data-valparcela', valorParcela);
    }

    //Na linha
    function actualizaObservacao(idPrestacao, observacao) {
        $('#linhaprestacao' + idPrestacao).attr('data-observacao', observacao);
    }

    //Limpa a Observacao na linha
    function limpaObservacao(idPrestacao) {//Na linha
        $('#linhaprestacao' + idPrestacao).attr('data-observacao', '');
    }

    //Na linha
    function actualizaReferenciaPag(idPrestacao, referencia) {
        $('#linhaprestacao' + idPrestacao).attr('data-referenciapag', referencia);
    }

    //Limpa a referenciaPagamento na linha
    function limpaReferenciaPag(idPrestacao) {//Na linha
        $('#linhaprestacao' + idPrestacao).attr('data-referenciapag', '');
    }

    //Na linha
    function actualizaContaPag(idPrestacao, contapag) {
        $('#linhaprestacao' + idPrestacao).attr('data-contapag', contapag);
    }

    //Limpa a ContaPag na linha
    function limpaContaPag(idPrestacao) {//Na linha
        $('#linhaprestacao' + idPrestacao).attr('data-contapag', '');
    }

    //Na linha
    function actualizaMeioPagamento(idPrestacao, meioPagamento) {
        $('#linhaprestacao' + idPrestacao).attr('data-meiopagamento', meioPagamento);
    }

    //Limpa o MeioPagamento na linha
    function limpaMeioPagamento(idPrestacao) {//Na linha
        $('#linhaprestacao' + idPrestacao).attr('data-meiopagamento', '');
    }

    //Coloca a parcela e o botao cancelar no span da parcela
    function mostraParcela(idPrestacao, valorParcela) {
        $('#valor-parcela' + idPrestacao).html(
            '<span id="parcela-capital-span" style="margin-right: 8px;">'
            + valorParcela +
            '</span>' +
            '<button type="button" onclick="removeParcela(' + idPrestacao + ')" data-idprestacao="' + idPrestacao + '" id="btn-cancelar-parcela' + idPrestacao + '" class="btn btn-xs btn-danger btn_cancelar_parcela"><span style="display: none">' + idPrestacao + '</span><i class="fas fa-times" aria-hidden="true"></i>' +
            '</button>'
        );
    }

    function removeParcela(idPrestacao) {
        zeraParcelaSpan(idPrestacao); // No span de parcela coloca '0.00'
        $('#check-box' + idPrestacao)[0].checked = false;//faz check false
        limpaObservacao(idPrestacao);
        actualizaValorParcela(idPrestacao, 0.00);// Na linha
        upDateTotalAPagar();//Actualiza total
    }

    //Fim do Assunto Parcelas

    //Actualizacao do total
    function upDateTotalAPagar() {
        var parcela = 0;
        var valorPrestacao = 0;
        var total = 0.00;
        $('.linhaprestacao').each(
            function () {
                // alert(+$(this).attr('data-idprestacao'));
                var idPrestacao = +$(this).attr('data-idprestacao');
                var meioPagamento = $('#meio-pagamento' + idPrestacao).val();
                actualizaMeioPagamento(idPrestacao, meioPagamento);
                var status = $('#check-box' + idPrestacao)[0].checked;
                if (status) {
                    parcela = +$(this).attr('data-valparcela');
                    valorPrestacao = +$(this).attr('data-valprestacao');

                    if (parcela !== 0) {//Ha Parcela
                        total = +total;
                        total = total + parcela;
                    } else {//Nao ha parcela
                        total = +total;
                        total = total + valorPrestacao;
                    }
                }
            }
        );
        if (total === 0) {
            $('#valor-apagar').attr('value', '0.00');//Actualizacao do total a pagar
        } else {
            $('#btnpagar').removeAttr('disabled');
            $('#valor-apagar').attr('value', decimals(total, 2));//Actualizacao do total a pagar
        }
    }

    //Fim da Actualizacao do total

    //Decimals
    function decimals(n, d) {
        if ((typeof n !== 'number') || (typeof d !== 'number'))
            return false;
        n = parseFloat(n) || 0;
        return n.toFixed(d);
    }

    //Fim Decimals

    //Limpar preenchimento de Model da Parcela
    function limpaCamposModel() {
        $('#valor_parcela_modal').val('');
        $('#observacao_parcela_modal').val('');
    }

    //Fim do Limpar preenchimento de Model da Parcela

    //Combox Conta Pagamento, retorna a conta selecionada
    function selecionarContaPaga(idPrestacao) {
        return $('#conta-bancaria' + idPrestacao).val();
    }

    //Fim Combox

    //Referencia Pagamento MPESA
    function referenciaPagamento(idPrestacao) {
        return $('#input-referencia' + idPrestacao).val();
    }

    //Fim do Referencia Pagamento MPESA

    //FIM METODOS

    // Ao Mudar o check All
    $('#select_all').change(
        function () {
            var status = $('#select_all')[0].checked; // Pega o estado do"select all"
            // Muda estado dos outros checkes
            ckeckOrUncheckAllCkeckBoxPagar(status);

            //Actualizar total a pagar
            upDateTotalAPagar();
        }
    );
    // Fim do Ao Mudar o check All

    //Ao mudar um checkBox
    $('.checkbox').change(
        function () {
            var status = $(this)[0].checked;
            var idPrestacao = +($(this).attr('data-referenciaprestacao'));
            checkUncheckSelectall(idPrestacao, status);

            //Actualizar total a pagar
            upDateTotalAPagar();
        }
    );
    //Fim Ao mudar um checkBox


    // Ao mudar o meio de Pagamento
    $('.select-meiopagamento').change(
        function () {
            var idPrestacao = +($(this).attr('data-referenciaprestacao'));
            var meioPagamento = +$(this).val();
            var contaSelecionada = selecionarContaPaga(idPrestacao);//Retorna a conta selecionada
            // var referenciaPag = referenciaPagamento(idPrestacao);

            actualizaMeioPagamento(idPrestacao, meioPagamento);

            if (meioPagamento === 1) {//MPESA
                limpaContaPag(idPrestacao);
            } else if (meioPagamento === 4) {//Numerario
                limpaContaPag(idPrestacao);
                limpaReferenciaPag(idPrestacao);
            } else {
                actualizaContaPag(idPrestacao, contaSelecionada);
                limpaReferenciaPag(idPrestacao);
            }

            switch (meioPagamento) {

                case 1: {
                    // M-PESA
                    showInputReferencia(idPrestacao);
                    hideSelectConta(idPrestacao);
                    break;
                }
                case 2: {
                    // CONTA MOVEL
                    showSelectConta(idPrestacao);
                    hideInputReferencia(idPrestacao);
                    break;
                }
                case 3: {
                    // POS
                    showSelectConta(idPrestacao);
                    hideInputReferencia(idPrestacao);
                    break;
                }
                case 4: {
                    // NUMERARIO
                    hideInputReferencia(idPrestacao);
                    hideSelectConta(idPrestacao);
                    break;
                }
                case 5: {
                    // TRANSFERENCIA BANCARIA
                    showSelectConta(idPrestacao);
                    hideInputReferencia(idPrestacao);
                    break;
                }
                case 6: {
                    // TRANSFERENCIA DEPOSITO
                    showSelectConta(idPrestacao);
                    hideInputReferencia(idPrestacao);
                    break;
                }
                default:
                // code block
            }
        }
    );

    //Ao mudar a combo da conta bancaria
    $('.select-conta').change(
        function () {
            var idPrestacao = +($(this).attr('data-referenciaprestacao'));
            var contaSelecionada = selecionarContaPaga(idPrestacao);//Retorna a conta selecionada

            actualizaContaPag(idPrestacao, contaSelecionada);
            limpaReferenciaPag(idPrestacao);
        }
    );


    //Ao clicar para parcelar
    $('.btn-parcela').click(
        function () {
            var idPrestacao = +$(this).attr('data-idprestacao');
            var valorPrestacao = +$(this).attr('data-valorprestacao');

            //Setar os atributos 'idprestacao' e 'valorprestacao' no model
            $('#btnSalvarParcela').attr('data-idprestacao', idPrestacao).attr('data-valorprestacao', valorPrestacao);

            //Abrir Modal de Parcelamento
            $('#modal-parcela').modal({
                show: true, backdrop: "static"
            })
        }
    );
    //Fim do Ao clicar para parcelar

    // Ao clicar para parcelar Capital
    $('#btn-reduzir-capital').click(
        function () {
            // var idPrestacao = +$(this).attr('data-idprestacao');
            // var valorPrestacao = +$(this).attr('data-valorprestacao');

            //Abrir Modal de Parcelamento
            $('#modal-reduzir-capital').modal({
                show: true, backdrop: "static"
            })
        }
    );
    //Fim do Ao clicar para parcelar

    //Ao clicar para salvar parcela
    $('#btnSalvarParcela').click(
        function () {
            var valorParcelaModal = +$('#valor_parcela_modal').val();
            var observacaoModal = $('#observacao_parcela_modal').val();
            var valorPrestacao = +$(this).attr('data-valorprestacao');
            var idPrestacao = 0;

            // 'toFixed(2), converte o numero para um decimal com duas casas decimais'
            valorParcelaModal = +valorParcelaModal.toFixed(2);
            valorPrestacao = +valorPrestacao.toFixed(2);
            //Verifica se a parcela eh a baixo do valor da prestacao
            if (valorParcelaModal < valorPrestacao) {
                //Pega o id da prestacao
                idPrestacao = $(this).attr('data-idprestacao');

                // actualiza o valor da parcela na linha em questao
                actualizaValorParcela(idPrestacao, valorParcelaModal);

                //Actualiza o observacao na linha em questao
                actualizaObservacao(idPrestacao, observacaoModal);

                //Mostra o valor da parcela
                mostraParcela(idPrestacao, valorParcelaModal);

                //Faz check
                check(idPrestacao);

                //Actualiza total
                upDateTotalAPagar();

                //Limpar campos
                limpaCamposModel();

            } else {
                swal("Erro", "O valor da parcela deve ser menor que o valor da prestação. Tente novamente", "error");
            }
        }
    );
    //Fim Ao clicar para salvar parcela

    //Ao introduzir a referencia do pagamento MPESA
    $('.referencia-pagamento').on("input", function (evt) {
        var idPrestacao = +$(this).attr('data-idprestacao');
        var referencia = referenciaPagamento(idPrestacao);
        actualizaReferenciaPag(idPrestacao, referencia);
    });
    //Fim Ao introduzir a referencia do pagamento MPSA

    //Variaveis a serem usadas no envio de dados para o controller
    var idPrestacao = 0;
    var tipoPrestacao = 0;
    var valorPrestacao = 0;
    var valorParcela = 0;
    var meioPagamento = 0;
    var contaPagamento = 0;
    var referenciaPagamento = '';
    var observacao = '';
    var prestacao = [];
    var prestacoes = [];

    function preencherArrays() {
        $('.linhaprestacao').each(
            function () {
                idPrestacao = +$(this).attr('data-idprestacao');
                var status = $('#check-box' + idPrestacao)[0].checked;
                var count = 0;
                if (status) {
                    count = count + 1;

                    tipoPrestacao = +$('#linhaprestacao' + idPrestacao).attr('data-tipoprestacao');
                    valorPrestacao = +$('#linhaprestacao' + idPrestacao).attr('data-valprestacao');
                    valorParcela = +$('#linhaprestacao' + idPrestacao).attr('data-valparcela');
                    meioPagamento = +$('#linhaprestacao' + idPrestacao).attr('data-meiopagamento');
                    contaPagamento = +$('#linhaprestacao' + idPrestacao).attr('data-contapag');
                    referenciaPagamento = $('#linhaprestacao' + idPrestacao).attr('data-referenciapag');
                    observacao = $('#linhaprestacao' + idPrestacao).attr('data-observacao');

                    prestacao.push(idPrestacao);
                    prestacao.push(tipoPrestacao);
                    prestacao.push(valorPrestacao);
                    prestacao.push(valorParcela);
                    prestacao.push(meioPagamento);
                    prestacao.push(contaPagamento);
                    prestacao.push(referenciaPagamento);
                    prestacao.push(observacao);

                    prestacoes.push(prestacao);
                    prestacao = [];
                }
            }
        )
    }

    //Ao clicar para pagar
    $('#btnpagar').click(
        function () {
            preencherArrays();
            var totalPagar = +$('#valor-apagar').val();

            console.log(prestacoes);

            swal({
                title: "Confirmar o pagamento de " + totalPagar + " MT?",
                imageUrl: "../assets/question.png",
                showCancelButton: true,
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function () {
                $.ajax({
                    url: "${g.createLink( controller: 'prestacao', action:'pagamentos3')}",
                    contentType: 'application/json',
                    type: "POST",
                    data: JSON.stringify(prestacoes),
                    success: function (data) {
                        setTimeout(function () {
                            swal({
                                title: "Certo!",
                                text: "Pagamento efectuado com Sucesso!",
                                timer: 2500,
                                type: "success",
                                showConfirmButton: false
                            });
                            setInterval(
                                function () {
                                    location.reload();
                                    window.open('<g:createLink controller="prestacao" action="verRecibo"/>', '_blank');
                                }, 1000
                            )
                        }, 2000);
                    },
                    error: function () {
                        swal("Erro", "Ocorreu algum erro ao Efectuar pagamento", "error");
                    }
                });
            });

        }
    );
    //Fim Ao clicar para pagar

</script>