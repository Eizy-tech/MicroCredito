<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main" />
    <g:set var="entityName" value="${message(code: 'prestacaoGeral.label', default: 'Prestacao')}" />
    <title><g:message code="default.create.label" args="[entityName]" /></title>
</head>
    <body>
        <div class="box box-primary" style="padding: 10px; font-size: 14px">
            <div class="row">
                <div class="col-md-4" style="padding-right: 5px">
                    <div class="box box-success" style="background-color: white">
                        <div class="box-header" style="background-color: #ecf0f5">
                            <h3 class="box-title">Clientes e seus Emprestimos</h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <div class="input-group input-group-sm">
                                            <input type="text" id="search_field" name="table_search" class="form-control pull-right" placeholder="Busca por Nome ou Codigo do cliente">

                                            <div class="input-group-btn">
                                                <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                    <table class="table myTable table-bordered table-striped" style="border: 2px; margin-bottom: 0px">
                                        <thead class="thead-light" style="background-color: #00a65a0d">
                                            <tr class="myHead">
                                                <th scope="col">Cod. - Nome</th>
                                                <th scope="col">V. Pagar</th>
                                                <th scope="col">Limite</th>
                                                <th scope="col">Prestacoes</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <g:each in="${emprestimos}" var="emprestimo">
                                                    <tr>
                                                        <td class="nomeCli">${emprestimo.cliente.codigo}-${emprestimo.cliente.nome}</td>
                                                        <td class="valPag"><g:formatNumber number="${emprestimo.valorPedido+(emprestimo.valorPedido*(emprestimo.taxaJuros/(100)))}" format="#,##0.00"/></td>
                                                        <g:if test="${emprestimo.estado == 'Vencido'}">
                                                            <td class="limitePag" style="color: #ea0000;"><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></td>
                                                        </g:if>
                                                        <g:else>
                                                            <td class="limitePag"><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></td>
                                                        </g:else>
                                                        <td class="botaoPrestacoes">
                                                            <button type="button" id="list-${emprestimo.id}" data-id="${emprestimo.id}" class="btn-xs btn-block btn-success btn-listar">Listar</button>
                                                        </td>
                                                    </tr>
                                            </g:each>
                                        </tbody>
                                    </table>
                                    <div class="pagination" >
                                        <g:paginate total="${emprestimoCount ?: 0}" next="Proximo" prev="Anterior" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-8" style="padding-left: 5px">
                    <div class="box box-success"  style="background-color: white">
                        <div class="box-header"  style="background-color: #ecf0f5">
                            <h3 class="box-title">Prestacoes por pagar</h3>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-md-12">
                                    <div id="prestacoesEmprestimo" class="prestacoesEmprestimo">

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <asset:javascript src="jquery-3.3.1.slim.min.js"/>
            <script>
                lastBtnlist='';
                $(document).ready( function() {
                    $('#li_list_prestacoes').addClass('active');
                    $('#li_prestacoes').addClass('active');
                    $('.btn-listar').click(function () {
                        var param = $(this).attr('data-id');
                        lastBtnlist = $(this).attr('id');
                        <g:remoteFunction action="prestacoesEmprestimo" params="\'emprestimoId=\'+param" update="prestacoesEmprestimo"/>
                        // console.log('disparou');
                    });
                });

                $('#search_field').on('keyup', function() {
                    var value = $(this).val();
                    var patt = new RegExp(value, "i");

                    $('#myTable').find('tr').each(function() {
                        if (!($(this).find('td').text().search(patt) >= 0)) {
                            $(this).not('.myHead').hide();
                        }
                        if (($(this).find('td').text().search(patt) >= 0)) {
                            $(this).show();
                        }
                    });
                });
            </script>
        </div>
    </body>
</html>
