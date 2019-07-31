<%@ page import="microcredito.Emprestimo1Service" %>
<%
    def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
%>

<h4 class="modal-title"><i
        class="fa fa-money-bill-wave"></i> Devedores de Hoje
</h4>
<hr>

<table class="table table-bordered table-striped" id="prestacoes_emprestimo">
    <thead class="thead-light" style="background-color: #00a65a0d">
    <tr>
        <th>Nr. Processo</th>
        <th>Nome</th>
        <th>Valor a pagar</th>
    </tr>
    </thead>
    <tbody>
    <g:each in="${emprestimos}" var="emprestimo">
        <g:if test="${emprestimoServic.dividaHoje(emprestimo) > 0}">
            <tr>
                <td>${emprestimo.nrProcesso}</td>
                <td>${emprestimo.cliente.nome}</td>
                <td style="color: red; font-weight: bold">
                    <g:formatNumber number="${emprestimoServic.dividaHoje(emprestimo)}" format="#,##0.00"/>
                </td>
            </tr>
        </g:if>
    </g:each>
    </tbody>
</table>