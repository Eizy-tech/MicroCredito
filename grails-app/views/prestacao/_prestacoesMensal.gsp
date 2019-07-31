<%@ page import="microcredito.Prestacao1Service" %>
<%
    def prestacao1Service = grailsApplication.classLoader.loadClass('microcredito.Prestacao1Service').newInstance()
%>
<div class="row">
    <div class="col-md-12">
        <div class="box box-success"  style="background-color: white">
            <div class="box-header"  style="background-color: #ecf0f5">
                <h3 class="box-title">Prestacoes Nao Pagas:</h3>
            </div>
            <div class="box-body">
                <div class="row">
                    <div class="col-md-12">
                        <div id="prestacoesEmprestimo" class="prestacoesEmprestimo">

                            <ol class="breadcrumb" style="padding: 2px; align-content: center; text-align: center">
                                <strong>
                                    Cliente: <span id="nom_cliente" style="color:#00a65a">${emprestimo.cliente.nome}</span>
                                    - Capital: <span id="valor_pedido" style="color:#00a65a"><g:formatNumber number="${emprestimo.valorPedido}" format="#,##0.00"/></span>
                                    - Taxa_Juros.: <span id="percentagem_juros" style="color:#00a65a">${emprestimo.taxaJuros}%</span>
                                    - Renda Normal: <span id="renda-normal" style="color:#00a65a">${emprestimo.valorPedido * (emprestimo.taxaJuros)/100}</span>
                                    - Val_Pagar: <span id="val_pag" style="color:#00a65a"><g:formatNumber number="${emprestimo.valorPedido+(emprestimo.valorPedido*(emprestimo.taxaJuros/100))}" format="#,##0.00"/></span>
                                    - Prazo: <span id="data_concessaoo" style="color:#00a65a"><g:formatDate date="${emprestimo.prazoPagamento}" format="dd MMM yyyy"/></span>
                                    - Modo_Pag.: <span id="modo-pagamento" modoPagamento="${emprestimo.modoPagamento.descricao}" style="color:#00a65a"> ${emprestimo.modoPagamento.descricao} </span>
                                </strong>
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
                                    <th>Referencia/Conta</th>
                                    <th>Parcela</th>
                                    <th>
                                        <input type="checkbox" class="minimal select_all-checkbox" id='select_all'>
                                        <span>Selec./Parc. </span>
                                    </th>
                                </tr>
                                </thead>
                                <tbody>
                                <g:if test="${prestacoes.size() > 0}">
                                    <g:each in="${prestacoes}" var="prestacao">
                                    %{--a prestacao tem parcela--}%
                                        <g:if test="${prestacao.prestacoes}">
                                            <tr
                                                id="linhaprestacao-${prestacao.id}" data-valprestacao="${prestacao1Service.dividaPrestacao(prestacao)}"
                                                data-valparcela="0" data-meiopagamento="" data-referenciapag="" data-contapag=""
                                                data-tipoprestacao="${prestacao.tipoPrestacao.id}"
                                            >
                                        </g:if>
                                    %{--a prestacao nao tem parcelas--}%
                                        <g:else>
                                            <tr
                                                id="linhaprestacao-${prestacao.id}" data-valprestacao="${prestacao.valor}"
                                                data-valparcela="0" data-meiopagamento="" data-referenciapag=""
                                                data-contapag="" data-tipoprestacao="${prestacao.tipoPrestacao.id}"
                                                data-observacaoparcela=""
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
                                        <td>
                                            ${prestacao.estado}
                                        </td>
                                        <td>
                                            <select class="form-control input-sm" id="meio-pagamento${prestacao.id}" data-referenciaprestacao="${prestacao.id}">
                                                <g:each in="${meiosPagamento}" var="meioPagamento">
                                                    <option value="${meioPagamento.descricao}">${meioPagamento.descricao}</option>
                                                </g:each>
                                            </select>
                                        </td>
                                        <td id="referenciaouconta">
                                            <div class="form-group">
                                                <input id="input-referencia${prestacao.id}" type="text"
                                                       class="form-control referencia-pagamento"
                                                       placeholder="Referencia do Pag.">
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
                                            <button class="btn-xs btn-primary btn-parcela"
                                                    id="btn-parcela${prestacao.id}"
                                                    data-referenciaprestacao="${prestacao.id}">Parcelar</button>
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
                                            <td></td>
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
                                <div class="col-sm-4"></div>
                                <div class="col-sm-3"></div>
                                <div class="col-sm-1" style="padding-right: 1px">
                                    <span class="pull-right" style="font-size: 1.8em; text-align: center">MZN </span>
                                </div>
                                <div class="col-sm-3" style="padding-right: 3px; padding-left: 2px">
                                    <input id="valor-apagar" class="form-control" type="text" value="0.00" disabled style="font-size: 1.8em;">
                                </div>
                                <div class="col-sm-1" style="padding-left: 3px">
                                    <button class="btn-flat btn-success" style="padding: 6px; height: 90%; width: 100%" >Pagar</button>
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
</div>