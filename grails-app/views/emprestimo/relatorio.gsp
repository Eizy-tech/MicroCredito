<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'emprestimo.label', default: 'Emprestimo')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
        <asset:stylesheet src="bootstrap-daterangepicker/daterangepicker.css"/>
        <asset:javascript src="jquery-3.3.1.slim.min.js"/>
    </head>
    <body>
    <%@ page import="microcredito.Emprestimo1Service" %>
    <%
        def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
    %>

    %{--A variavel user segura o user logado--}%
    <g:set var="user" value="${sec.username()}" />

    <div class="box box-success direct-chat direct-chat-success">
        <div class="box-header with-border" style="background-color: #ecf0f5">
            <h3 class="box-title"><i class="fa fa-list"></i><strong>&nbsp;Filtro</strong></h3>
        </div>
        <!-- /.box-header -->
        <div class="box-body" style="padding: 8px">
            <div name="criterio-list">

            </div>
            <div name="lista" id="lista" class="box lista" style="margin-top: 8px">
                <button class="btn btn-success btn-flat pull-right" id="btnExportExcel" style="margin: 3px"><i class="fa fa-file-excel-o"></i>&nbsp;&nbsp;Exportar</button>
                <table class="table table-bordered text-center table-striped"  id="tabelaRelatorio">
                        <thead>
                            <tr>
                                <th style="text-align: left">Num. Processo</th>
                                <th style="text-align: left">Nome</th>
                                <th style="text-align: left">Modalidade</th>
                                <th style="text-align: left">Valor_Ped.</th>
                                <th style="text-align: left">Taxa_Juros</th>
                                <th style="text-align: left">Total a Pagar</th>
                                <th style="text-align: left">Data Reg.</th>
                                <th style="text-align: left">Prazo</th>
                                <th style="text-align: left">Estado_Empr.</th>

                                <th style="text-align: left">Num. Prest</th>
                                <th style="text-align: left">Tipo</th>
                                <th style="text-align: left">Valor Orig.</th>
                                <th style="text-align: left">Estado_Prest.</th>
                                <th style="text-align: left">Prazo</th>
                                <th style="text-align: left">Valor Divida</th>
                            </tr>
                        </thead>
                        <tbody>
                            <g:each in="${emprestimos}" var="emprestimo">
                                <g:each in="${emprestimo.prestacoes}" var="prestacao">
                                    <tr>
                                        <td style="text-align: left">${emprestimo.nrProcesso+''}</td>
                                        <td style="text-align: left">${emprestimo.cliente.nome}</td>
                                        <td style="text-align: left">${emprestimo.modoPagamento.descricao}</td>
                                        <td style="text-align: right; mso-number-format:'#,##0.00'">${emprestimo.valorPedido}</td>
                                        <td style="text-align: right; mso-number-format:'#,##0.00'">${emprestimo.taxaJuros}</td>
                                        <td style="text-align: right; mso-number-format:'#,##0.00'">${emprestimo.valorApagar}</td>
                                        <td><g:formatDate date="${emprestimo.dataRegisto}" format="dd MMM yyyy"/></td>
                                        <td><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></td>
                                        <td style="text-align: left">${emprestimo.estado+''}</td>

                                        <td style="text-align: left">${prestacao.numero+''}</td>
                                        <td style="text-align: left">${prestacao.tipoPrestacao.descricao}</td>
                                        <td style="text-align: right; mso-number-format:'#,##0.00'">${prestacao.valor}</td>
                                        <td style="text-align: left">${prestacao.estado}</td>
                                        <td><g:formatDate date="${prestacao.dataLimite}" format="dd MMM yyyy"/></td>
                                        <td style="text-align: right;mso-number-format:'#,##0.00'">${emprestimoServic.dividaParcela(prestacao)}</td>
                                    </tr>
                                </g:each>
                            </g:each>
                        </tbody>
                </table>
            </div>

        </div>
        <!-- /.box-body -->
        <div class="box-footer">

        </div>
        <!-- /.box-footer-->
    </div>

    <script>
        $(document).ready(function () {
            $('#li_prestacoes').addClass('active');
            $('#li_relatorio_prestacoes').addClass('active');
        });
    </script>

    <script>
        $('#btnExportExcel').on('click', function () {
            // $('#tabelaCopia').show();
            var rowCount = $('#tabelaRelatorio >tbody >tr').length;
            if (rowCount >= 1) {
                $('#tabelaRelatorio').tableExport({type: 'excel', escape: 'false'});
            } else {
                swal("Info", "Sem dados para exportar", "warning");
            }
            // $('#tabelaCopia').hide();
        });
        // $('table').tableExport();
        // $('#btnExportExcel').tableExport({type:'csv'});
    </script>
    </body>
</html>