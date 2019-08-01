<g:if test="${emprestimoList.size() > 0}">
    <%@ page import="microcredito.Emprestimo1Service" %>
    <%
        def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
    %>
    %{--<%@ page import="microcredito.UserDetailService" %>--}%
    %{--<%--}%
        %{--def userDetailService = grailsApplication.classLoader.loadClass('microcredito.UserDetailService').newInstance()--}%
    %{--%>--}%
    <table id="tabelaoriginal" class="table table-bordered text-center table-striped"
           style="border: 2px; margin-bottom: 0px">
        <thead class="thead-light" style="background-color: #00a65a0d">
            <tr>
            <th>Nr. Processo</th>
            <th>Nome do Cliente</th>
            <th>Tipo</th>
            <th>Val. Pedido</th>
            <th>Taxa_Juros (%)</th>
            <th>Val. a Pagar</th>
            <th>Estado</th>
            <th>Prazo</th>
            <th style="font-weight: bold; color: #9f191f">Divida Total</th>
            <th style="font-weight: bold; color: #9f191f">Divida Hoje</th>
            <th>Reistado Por</th>
            <th>Accoes</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${emprestimoList}" var="emprestimo">
            <tr>
                <td>${emprestimo.nrProcesso}</td>
                <td>
                    <a style="color: #007bb6; cursor: pointer" id="${emprestimo.cliente.id}" class="link-cliente">
                        ${emprestimo.cliente.nome}
                    </a>
                </td>
                <td>${emprestimo.modoPagamento.descricao}</td>
                <td><g:formatNumber number="${emprestimo.valorPedido}" format="#,##0.00"/></td>
                <td><g:formatNumber number="${emprestimo.taxaJuros}" format="#,##0.00"/></td>
                <td><g:formatNumber number="${emprestimo.valorApagar}" format="#,##0.00"/></td>
                <g:if test="${emprestimo.estado == 'Aberto'}">
                    <td style="color: green; font-weight: bold">${emprestimo.estado}</td>
                </g:if>
                <g:if test="${emprestimo.estado == 'Fechado'}">
                    <td style="color: red; font-weight: bold">${emprestimo.estado}</td>
                </g:if>
                <g:if test="${emprestimo.estado == 'Vencido'}">
                    <td style="color: #080df9; font-weight: bold">${emprestimo.estado}</td>
                </g:if>
                <g:if test="${emprestimo.estado == 'Suspenso'}">
                    <td style="color: orange; font-weight: bold">${emprestimo.estado}</td>
                </g:if>
                <td><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></td>
                <td><span style="color: goldenrod; font-weight: bold">
                    <g:formatNumber number="${emprestimoServic.somaPrestacoesDivida(emprestimo)}"
                                    format="#,##0.00"/></span></td>
                <td><span style="color: #a60000; font-weight: bold"><g:formatNumber
                        number="${emprestimoServic.dividaHoje(emprestimo)}" format="#,##0.00"/></span></td>
                <td>${emprestimo.userRegisto.nome}</td>
                <td style="float: right; border: none">
                    <g:if test="${emprestimo.estado == 'Aberto' || emprestimo.estado == 'Vencido'}">
                        <g:link controller="prestacao" action="pagamento" params="[cred: emprestimo.id]">
                            <button class="btn btn-sm btn-success"><i class="fa fa-money"></i>&nbsp;Pagamento</button>
                        </g:link>
                    </g:if>
                    <button class="btn btn-sm btn-primary btn-parcelasList" data-modal="modal-prestacoes"
                        id="btn-parcelasList" id-emprestimo="${emprestimo.id}"
                        title="Ver Prestacoes"><i class="fa fa-list-ul"></i>&nbsp;Prestacoes
                    </button>
                    <button class="btn btn-warning btn-sm emp-detalhes" data-emprestimo-id="${emprestimo.id}">
                        <i class="fa fa-info"></i>&nbsp;Detalhes
                    </button>
                </td>
            </tr>
        </g:each>
        <sec:ifLoggedIn>
        %{--Perfil com id==1 eh o director--}%
            <g:if test="${userPerfil == 1}">
                <tr>
                    <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5">TOTAL:</td>
                    <td></td>
                    <td></td>
                    <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                            number="${emprestimoServic.somaValorPedido(emprestimosCopia)}" format="#,##0.00"/></td>
                    <td></td>
                    <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                            number="${emprestimoServic.somaValorPagar(emprestimosCopia)}" format="#,##0.00"/></td>
                    <td></td>
                    <td></td>
                    <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                            number="${emprestimoServic.somaDividaTotal(emprestimosCopia)}" format="#,##0.00"/></td>
                    <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                            number="${emprestimoServic.somaDividaHoje(emprestimosCopia)}" format="#,##0.00"/></td>
                    <td></td>
                    <td></td>
                </tr>
            </g:if>
        </sec:ifLoggedIn>
        </tbody>
    </table>

    <div class="row" style="margin: 5px 0; padding: 0px">
        <div class="col-md-6" style="align-content: start">
            <g:if test="${filtro == true}">
                <div class="pagination dataTables_paginate paging_simple_numbers">
                    <util:remotePaginate action="filtro" total="${emprestimoCount ?: 0}" update="lista"
                                         params="${params}" next="Proximo" prev="Anterior"/>
                </div>
            </g:if>

            <g:if test="${filtro == false}">
                <div class="pagination dataTables_paginate paging_simple_numbers">
                    <g:paginate total="${emprestimoCount ?: 0}" next="Proximo" prev="Anterior"/>
                </div>
            </g:if>
        </div>

        <div class="col-md-6" style="align-content: end">
            <div class="pagination dataTables_paginate paging_simple_numbers pull-right">
                <button class="btn btn-success btn-flat pull-right" id="btnExportExcel" style="margin: 3px"><i
                        class="fa fa-file-excel-o"></i>&nbsp;&nbsp;Exportar</button>
                <a href="#" class="step pull-right"
                   style="background-color: #008d4c; color: #fff">Total de Registros = ${emprestimoCount}</a>
            </div>
        </div>
    </div>

    %{--===========================================================================================COPIA PARA EXPORT=========================================--}%

%{--Tabela Copia--}%
    <table id="tabelaCopia" class="table table-bordered text-center table-striped" style="border: 2px; display: none">
        <thead class="thead-light" style="background-color: #00a65a0d">
        <tr>
            <th>Nr. Processo</th>
            <th>Nome do Cliente</th>
            <th>Val. Pedido</th>
            <th>Taxa_Juros (%)</th>
            <th>Val. a Pagar</th>
            <th>Prazo</th>
            <th style="font-weight: bold; color: #9f191f">Divida Total</th>
            <th style="font-weight: bold; color: #9f191f">Divida Hoje</th>
            <th>Reistado Por</th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${emprestimoList}" var="emprestimo">
            <tr>
                <td>${emprestimo.nrProcesso}</td>
                <td>
                    <a href="#" id="l-Detalhes">${emprestimo.cliente.nome}</a>
                </td>
                <td><g:formatNumber number="${emprestimo.valorPedido}" format="#,##0.0"/></td>
                <td><g:formatNumber number="${emprestimo.taxaJuros}" format="#0.0"/></td>
                <td><g:formatNumber number="${emprestimo.valorApagar}" format="#,##0.0"/></td>
                %{--<td>${emprestimo.modoPagamento.descricao}</td>--}%
                <td><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></td>
                <td>
                    <span style="color: goldenrod; font-weight: bold">
                        <g:formatNumber number="${emprestimoServic.somaPrestacoesDivida(emprestimo)}" format="#,##0.0"/>
                    </span>
                </td>
                <td>
                    <span style="color: #a60000; font-weight: bold"><g:formatNumber
                            number="${emprestimoServic.dividaHoje(emprestimo)}" format="#,##0.0"/>
                    </span>
                </td>
                <td>${emprestimo.userRegisto.nome}</td>
            </tr>
        </g:each>
        <tr>
            <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5">TOTAL:</td>
            <td></td>
            <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                    number="${emprestimoServic.somaValorPedido(emprestimoList)}" format="#,##0.0"/></td>
            <td></td>
            <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                    number="${emprestimoServic.somaValorPagar(emprestimoList)}" format="#,##0.0"/></td>
            <td></td>
            <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                    number="${emprestimoServic.somaDividaTotal(emprestimoList)}" format="#,##0.0"/></td>
            <td style="font-weight: bold; color: #000; font-size: medium; background-color: #ecf0f5"><g:formatNumber
                    number="${emprestimoServic.somaDividaHoje(emprestimoList)}" format="#,##0.0"/></td>
            <td></td>
        </tr>
        </tbody>
    </table>
%{--// fim Tabela Copia--}%
    <script type="text/javascript">
        $('.btn-parcelasList').click(function () {               //open Modal de Parcelas pop-up
            var referenciaEmprestimo = $(this).attr('id-emprestimo');
            <g:remoteFunction action="emprestimoPrestacoes" params="{'referenciaEmprestimo': referenciaEmprestimo}" update="listaPrestacoes"/>
            $('#modal-prestacoes').modal({
                show: true, backdrop: "static"
            });
        });
    </script>
</g:if>
<g:else>
    <div style="text-align: center">
        <strong style="text-align: center; font-size: 25px; color: red">Não há Emprestimos por listar.</strong>
    </div>
</g:else>

<div class="modal fade" id="modal-detalhes-cliente">
</div>
<div class="modal fade" id="modal-detalhes">
</div>

<script>
    $('#btnExportExcel').on('click', function () {
        $('#tabelaCopia').show();
        var rowCount = $('#tabelaCopia >tbody >tr').length;
        if (rowCount > 1) {
            $('#tabelaCopia').tableExport({type: 'excel', escape: 'false'});
        } else {
            swal("Info", "Sem dados para exportar", "warning");
        }
        $('#tabelaCopia').hide();
    });
</script>

<script>
    var idUser = null;
    var idCliente = null;
    var idModalidade = null;
    var estadoEmprestimo = null;
    var taxaJuros = null;
    var dataRange1 = null;
    var dataRange2 = null;
</script>

<script>
    function filtrar() {
        idCliente = $('#clienteSelect').val();
        idUser = $('#userSelect').val();
        idModalidade = $('#modalidadeSelect').val();
        estadoEmprestimo = $('#estadoSlect').val();
        taxaJuros = $('#taxaJurosFiltro').val();

        <g:remoteFunction action="filtro" params="{'idCliente': idCliente, 'idUser': idUser, 'idModalidade': idModalidade,
        'estadoEmprestimo': estadoEmprestimo, 'taxaJuros': taxaJuros, 'dataRange1': dataRange1, 'dataRange2': dataRange2}" update="lista"/>

    }

    $(document).ready(function () {

        $(document).on('click', '.emp-detalhes', function () {
            emprestimoID = $(this).attr('data-emprestimo-id');
            <g:remoteFunction action="getDetalhes" params="{'id': emprestimoID}" update="modal-detalhes"/>
            $('#modal-detalhes').modal({
                show: true, backdrop: "static"
            })
        });

        // Ver detalhes do cliente
        $(document).on('click', '.link-cliente', function () {
            clienteID = $(this).attr('id');
            <g:remoteFunction controller="cliente" action="getClienteDetalhes" params="{'id': clienteID}" update="modal-detalhes-cliente"/>
            $('#modal-detalhes-cliente').modal({
                show: true, backdrop: "static"
            })
        });

        $('#li_emprestimos').addClass('active');
        $('#li_list_emprestimo').addClass('active');
        $('.select_filtro').change(function () {
            filtrar()
        });
        $("#taxaJurosFiltro").on("input", function (evt) {
            var self = $(this);
            self.val(self.val().replace(/[^0-9\.]/g, ''));
            if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which > 57)) {
                evt.preventDefault();
                filtrar()
            }
        });
    });
</script>
<script>
    $(function () {
        $('#clienteSelect').select2();
        $('#userSelect').select2();
        // //Date range as a button
        $('#daterange-btn').daterangepicker(
            {
                ranges: {
                    'Todos': [moment().subtract(73000, 'days'), moment().add(36500, 'days')],
                    'Hoje': [moment(), moment()],
                    'Ontem': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Ultimos 7 dias': [moment().subtract(6, 'days'), moment()],
                    'Ultimos 30 dias': [moment().subtract(29, 'days'), moment()],
                    'Mes Passado': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Este Mes': [moment().startOf('month'), moment().endOf('month')],
                    'Proximos 7 dias': [moment(), moment().add(6, 'days')],
                    'Proximos 30 dias': [moment(), moment().add(29, 'days')],
                    'Proximo Mes': [moment().add(1, 'month').startOf('month'), moment().add(1, 'month').endOf('month')],

                },
                startDate: moment().subtract(29, 'days'),
                endDate: moment()
            },
            function (start, end) {
                $('#daterange-btn span').html(start.format('D.MMM.YYYY') + ' - ' + end.format('D.MMM.YYYY'))
                //Caso seja selecionado para ver todos
                if (end.format('D.MMM.YYYY') == moment().add(36500, 'days').format('D.MMM.YYYY')) {
                    $('#daterange-btn span').html('<i class="fa fa-calendar"></i> Selecione um Periodo (Prazo de Pagamentos)')
                }
                dataRange1 = start.format('DD.MM.YYYY');
                dataRange2 = end.format('DD.MM.YYYY');
                filtrar();
            }
        )
    });

    %{--$('.btn-parcelasList').click(function () {               //open Modal de Parcelas pop-up--}%
        %{--var referenciaEmprestimo = $(this).attr('id-emprestimo');--}%
        %{--<g:remoteFunction action="emprestimoPrestacoes" params="{'referenciaEmprestimo': referenciaEmprestimo}" update="listaPrestacoes"/>--}%
        %{--$('#modal-prestacoes').modal({--}%
            %{--show: true, backdrop: "static"--}%
        %{--});--}%
    %{--});--}%
</script>