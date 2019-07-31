<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'emprestimo.label', default: 'Emprestimo')}"/>
    <title><g:message code="default.list.label" args="[entityName]"/></title>
    <asset:stylesheet src="bootstrap-daterangepicker/daterangepicker.css"/>
    <asset:javascript src="jquery-3.3.1.slim.min.js"/>
    %{--<asset:stylesheet src="export/tableexport.min.css"/>--}%

</head>

<body>
<%@ page import="microcredito.Emprestimo1Service" %>
<%
    def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
%>

%{--A variavel user segura o user logado--}%
<g:set var="user" value="${sec.username()}"/>

<div class="box box-success direct-chat direct-chat-success">
    <div class="box-header with-border" style="background-color: #ecf0f5">
        <h3 class="box-title"><i class="fa fa-list"></i><strong>&nbsp;Validação de pagamentos</strong></h3>
    </div>
    <!-- /.box-header -->
    <div class="box-body" style="padding: 8px">
        <div name="criterio-list">

        </div>

        <div name="lista" id="lista" class="box lista" style="margin-top: 8px">
            <table class="table table-bordered text-center table-striped" id="tabelaRelatorio">
                <thead>
                <tr>
                    <th style="text-align: left">Cliente</th>
                    <th style="text-align: right">Valor Pago</th>
                    <th style="text-align: left">Tipo de Pagamento</th>
                    <th style="text-align: center">Data de Pagamento</th>
                    <th style="text-align: left">Usuario Responsavel</th>
                    <th style="text-align: left">Accao</th>
                </tr>
                </thead>
                <tbody>
                <g:each in="${prestacoes}" var="prestacao">
                    <tr>
                        <td style="text-align: left">${prestacao.emprestimo.cliente.nome}</td>
                        <td style="text-align: right">
                            <g:formatNumber number="${prestacao.valor}" format="#,##0.00"/>
                        </td>
                        <td style="text-align: left">${prestacao.tipoPrestacao.descricao}</td>
                        <td><g:formatDate date="${prestacao.dataPagamento}" format="dd MMM yyyy" /></td>
                        <g:if test="${prestacao.userRegisto==null}">
                            <td style="text-align: left">---</td>
                        </g:if>
                        <g:else>
                            <td style="text-align: left">${prestacao.userRegisto.nome}</td>
                        </g:else>
                        <td>
                            <button id="btn-prestacao${prestacao.id}" data-idprestacao="${prestacao.id}"
                                    data-valor="<g:formatNumber number="${prestacao.valor}" format="#,##0.00"/>" class="btn btn-success btn-sm btn-validar">Validar</button>
                        </td>
                    </tr>
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
        $('#li_validacao').addClass('active');
    });
</script>

<script>
    $('.btn-validar').on('click', function () {
        var idPagamento = +$(this).attr('data-idprestacao');
        var valor = $(this).attr('data-valor');
        var dados = [];
        dados.push(idPagamento);
       // swal("Info", +idPagamento, "warning");
        swal({
            title: "Confirmar validacao do pagamento de " +valor+ " MT?",
            imageUrl: "../assets/question.png",
            showCancelButton: true,
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function () {
            $.ajax({
                url: "${g.createLink( controller: 'prestacao', action:'validarPagamento')}",
                contentType: 'application/json',
                type: "POST",
                data: JSON.stringify(dados),
                success: function (data) {
                    setTimeout(function () {
                        swal({
                            title: "Certo!",
                            text: "Validacao efectuada com Sucesso!",
                            timer: 2500,
                            type: "success",
                            showConfirmButton: false
                        });
                        setInterval(
                            function () {
                                location.reload();
                            }, 1000
                        )
                    }, 2000);
                },
                error: function () {
                    swal("Erro", "Ocorreu algum erro ao validar o pagamento.", "error");
                }
            });
        });
    });
</script>
</body>
</html>