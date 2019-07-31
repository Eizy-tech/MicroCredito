<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'cliente.label', default: 'Cliente')}"/>
    %{--<title><g:message code="default.list.label" args="[entityName]"/></title>--}%
    <title>Listagem de Clientes</title>
    <asset:stylesheet src="bootstrap-daterangepicker/daterangepicker.css"/>
    <asset:javascript src="jquery-3.3.1.slim.min.js"/>
</head>

<body>
<%@ page import="microcredito.UserDetailService" %>
<%
    def userDetailService = grailsApplication.classLoader.loadClass('microcredito.UserDetailService').newInstance()
%>
%{--A variavel user segura o user logado--}%
<g:set var="user" value="${sec.username()}"/>

<div class="box box-success direct-chat direct-chat-success">
    <div class="box-header with-border" style="background-color: #ecf0f5">
        <h3 class="box-title"><i class="fa fa-list"></i>&nbsp;<strong>Lista de Clientes</strong></h3>
    </div>

    <div class="box-body" style="padding: 8px">
        <div name="criterio-list">
            <div class="row ">
                <div class="col-md-4">
                    <div class="input-group" style="width: 100%">
                        <input type="text" id="search_field" name="table_search" class="form-control pull-right"
                               placeholder="Busca por Nome do cliente">

                        %{--<g:select class="form-control select_filtro" id="search_field" style="margin-bottom: 5px;  margin-top: 5px; width: 100%"--}%
                                  %{--name='clientes' optionValue="nome" optionKey="nome"--}%
                                  %{--noSelection="${['null':'Pesquisar Cliente']}" data-size="10"--}%
                                  %{--from='${microcredito.Cliente.createCriteria().list {order('nome')}}'--}%
                        %{--/>--}%

                        <div class="input-group-btn">
                            <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3">
                    <button type="button" class="btn btn-default pull-right" id="daterange-btn">
                        <span>
                            <i class="fa fa-calendar"></i> Selecione um Periodo [Registo]
                        </span>
                        <i class="fa fa-caret-down"></i>
                    </button>
                </div>

                <div class="col-md-3">
                    <select class="form-control mb-md-3 select_filtro" id="estadoSlect">
                        <option>Todos Estados</option>
                        <option>Activo</option>
                        <option>Inactivo</option>
                    </select>
                </div>
            </div>

            <div name="lista" id="lista" class="box lista" style="margin-top: 8px">
                <g:render template="filtro_cliente" model="[clienteList: clienteList]"></g:render>
            </div>
        </div>
        <div class="box-footer">
        </div>
    </div>
</div>
</body>
</html>