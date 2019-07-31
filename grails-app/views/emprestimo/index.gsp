<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'emprestimo.label', default: 'Emprestimo')}"/>
    <title>Lista de Emprestimos</title>
    <asset:stylesheet src="bootstrap-daterangepicker/daterangepicker.css"/>
    <asset:javascript src="jquery-3.3.1.slim.min.js"/>

</head>

<body>
<g:set var="user" value="${sec.username()}"/>

<div class="box box-primary direct-chat direct-chat-success">
    <div class="box-header with-border" style="background-color: #ecf0f5">
        <h3 class="box-title"><i class="fa fa-list"></i><strong>&nbsp;Lista de Emprestimos</strong></h3>
    </div>
    <!-- /.box-header -->
    <div class="box-body" style="padding: 8px">
        <div name="criterio-list">
            <div class="row">
                <div class="col-md-2" style="padding: auto">
                    <input class="form-control" type="text" id="taxaJurosFiltro" placeholder="Todas Taxas de Juros (%)">
                </div>

                <div class="col-md-2" style="padding: auto">
                    <g:select class="form-control select_filtro" id="modalidadeSelect" name='modalidades'
                              optionValue="descricao" optionKey="id" style="margin-bottom: 10px; margin-top: -1px; margin-right: -1; margin-left: -1"
                              noSelection="${['null': 'Selecione a modalidade']}" data-size="10"
                              from='${microcredito.ModoPagamento.list()}'/>
                </div>

                <div class="col-md-2" style="padding: auto">
                    <g:select class="form-control mb-md-3 select_filtro" id="clienteSelect" name='clientes'
                              optionValue='nome' optionKey="id" style="margin-bottom: 5px; margin-top: 5px"
                              noSelection="${['null': 'Selecione o Cliente']}" data-size="10"
                              from='${microcredito.Cliente.createCriteria().list { order('nome') }}'/>
                </div>

                <div class="col-md-2" style="padding: auto">
                    <select class="form-control mb-md-3 select_filtro" id="estadoSlect">
                        <option>Todos [Estados]</option>
                        <option>Aberto</option>
                        <option>Fechado</option>
                        <option>Suspenso</option>
                        <option>Vencido</option>
                    </select>
                </div>

                <div class="col-md-2" style="padding: auto">
                    <div class="input-group">
                        <button type="button" class="btn btn-default" id="daterange-btn">
                            <span>
                                <i class="fa fa-calendar"></i> Selecione um Periodo [Prazo]
                            </span>
                            <i class="fa fa-caret-down"></i>
                        </button>
                    </div>
                </div>

                <div class="col-md-2" style="padding: auto">
                    <g:select class="form-control select_filtro" id="userSelect" name='users' optionValue="nome"
                              optionKey="id"
                              noSelection="${['null': 'Selecione o Utilizador']}"
                              from='${microcredito.User.list()}'/>
                </div>
            </div>
        </div>

        <div name="lista" id="lista" class="box lista" style="margin-top: 8px">
            <g:render template="filtro" model="[emprestimoList: emprestimoList]"></g:render>
        </div>
    </div>
    <!-- /.box-body -->
    <div class="box-footer">

    </div>
    <!-- /.box-footer-->
</div>

%{--modal de Prestacoes de um determinado emprestimo--}%
<div class="modal fade" id="modal-prestacoes">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content" style="width: 70%">
                <div class="modal-body">
                    <span name="listaPrestacoes" id="listaPrestacoes">

                    </span>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-danger pull-right" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>