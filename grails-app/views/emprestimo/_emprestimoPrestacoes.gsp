<%@ page import="microcredito.Emprestimo1Service" %>
<%
    def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
%>


<h4 class="modal-title"><i
        class="fa fa-money-bill-wave"></i>&nbsp;&nbsp;Prestacoes do emprestimo => ${emprestimo.nrProcesso} | ${emprestimo.cliente.nome}
</h4>
<hr>

<table class="table table-bordered table-striped" id="prestacoes_emprestimo">
    <thead class="thead-light" style="background-color: #00a65a0d">
    <tr>
        <th>Numero</th>
        <th>Valor</th>
        <th>Num. Parcelas</th>
        <th>Total Pago (Parcelas)</th>
        <th style="color: red; font-weight: bold">Divida</th>
        <th>Prazo</th>
        <th>Tipo</th>
        <th>Estado</th>
        <th>Ref. Prestacao</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${emprestimo.prestacoes.sort{it.id}}" var="prestacao">
        <tr>
            <td>${prestacao.numero}</td>
            <td><g:formatNumber number="${prestacao.valor}" format="#,##0.00"/></td>
            <td>${emprestimoServic.totalParcelaDaPrestacao(prestacao)}</td>
            <td><g:formatNumber number="${emprestimoServic.totalPagaNasPrestacoes(prestacao)}" format="#,##0.00"/></td>
            <g:if test="${prestacao.estado == 'Pendente' || prestacao.estado == 'Vencido'}">
                <td style="color: red; font-weight: bold"><g:formatNumber
                        number="${prestacao.valor - emprestimoServic.totalPagaNasPrestacoes(prestacao)}"
                        format="#,##0.00"/></td>
            </g:if>
            <g:else>
                <td>--</td>
            </g:else>
            <td><g:formatDate date="${prestacao.dataLimite}" format="dd MMM yyyy"/></td>
            <td>${prestacao.tipoPrestacao.descricao}</td>
            <g:if test="${prestacao.estado == 'Pago'}">
                <td style="color: green; font-weight: bold; font-size: 17px">${prestacao.estado}</td>
            </g:if>
            <g:if test="${prestacao.estado == 'Validado'}">
                <td style="color: green; font-weight: bold; font-size: 17px">${prestacao.estado}</td>
            </g:if>
            <g:if test="${prestacao.estado == 'Pendente'}">
                <td style="color: orange; font-weight: bold; font-size: 17px">${prestacao.estado}</td>
            </g:if>
            <g:if test="${prestacao.estado == 'Vencido'}">
                <td style="color: red; font-weight: bold; font-size: 17px">${prestacao.estado}</td>
            </g:if>
            <g:if test="${prestacao.estado == 'Anulado'}">
                <td style="color: #0A38F5; font-weight: bold; font-size: 17px">${prestacao.estado}</td>
            </g:if>
            <td>${emprestimoServic.numeroPrestacaoReferencia(prestacao)}</td>
        </tr>
    </g:each>
    </tbody>
</table>
