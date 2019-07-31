<%@ page import="microcredito.ContaBancaria" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'contaBancaria.label', default: 'ContaBancaria')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body>
%{--<a href="#create-contaBancaria" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>--}%
%{--<div class="nav" role="navigation">--}%
%{--<ul>--}%
%{--<li><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></li>--}%
%{--<li><g:link class="list" action="index"><g:message code="default.list.label" args="[entityName]" /></g:link></li>--}%
%{--</ul>--}%
%{--</div>--}%
%{--<div id="create-contaBancaria" class="content scaffold-create" role="main">--}%
%{--<h1><g:message code="default.create.label" args="[entityName]" /></h1>--}%
%{--<g:if test="${flash.message}">--}%
%{--<div class="message" role="status">${flash.message}</div>--}%
%{--</g:if>--}%
%{--<g:hasErrors bean="${this.contaBancaria}">--}%
%{--<ul class="errors" role="alert">--}%
%{--<g:eachError bean="${this.contaBancaria}" var="error">--}%
%{--<li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message error="${error}"/></li>--}%
%{--</g:eachError>--}%
%{--</ul>--}%
%{--</g:hasErrors>--}%
%{--<g:form resource="${this.contaBancaria}" method="POST">--}%
%{--<fieldset class="form">--}%
%{--<f:all bean="contaBancaria"/>--}%
%{--</fieldset>--}%
%{--<fieldset class="buttons">--}%
%{--<g:submitButton name="create" class="save btn btn-success" value="${message(code: 'default.button.create.label', default: 'Create')}" />--}%
%{--</fieldset>--}%
%{--</g:form>--}%
%{--</div>--}%

<div class="box box-primary direct-chat direct-chat-success">
    <div class="box-header with-border" style="background-color: #ecf0f5">
        <h3 class="box-title"><i class="fa fa-pen"></i>&nbsp;<strong>Conta Bancaria</strong></h3>
    </div>

    <div class="box-body" style="padding: 8px; background-color: #fff">

        <div class="row">
            <div class="col-lg-2"></div>

            <div class="col-lg-8">
                <div class="box box-info">
                    <div class="box-header">
                        <i class="fa fa-pen"></i>

                        <h3 class="box-title">Registar Conta Bancaria</h3>
                    </div>

                    <div class="box-body">
                        <g:form resource="${this.contaBancaria}" method="POST">
                        %{--<form class="form-horizontal pr-2" id="form_create">--}%
                            <br>
                            <br>

                            <div class="row mb-4">
                                <div class="col-lg-6">
                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="numero" class="form-label">Numero</label>
                                        <input type="text" class="form-control" id="numero" name="numero" required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="banco" class="form-label">Banco:</label>
                                        <input type="text" class="form-control" id="banco" name="banco" required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="observacao" class="form-label">observacao:</label>
                                        <input type="text" class="form-control" id="observacao" name="observacao"
                                               required>
                                    </div>

                                    <div class="input-group mb-3 hidden" style="width: 100%">
                                        <label for="estado" class="form-label">Estado</label>

                                        <g:select class="form-control select " id="estado" name="estado"
                                                  from="${microcredito.ContaBancaria.constrainedProperties.estado.inList}"/>
                                    </div>
                                </div>

                                <div class="col-lg-6">
                                    <div class="input-group mb-3" style=" width: 100%">
                                        <label for="nib" class="form-label">Nib:</label>
                                        <input type="text" class="form-control" id="nib" name="nib" required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="referencia" class="form-label">Referencia:</label>
                                        <input type="text" class="form-control" id="referencia" name="referencia"
                                               required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="titular" class="form-label">Titular:</label>
                                        <input type="text" class="form-control" id="titular"
                                               name="titular" required>
                                    </div>
                                </div>
                            </div>
                            <hr style="border: #ccc 1px solid">
                            <br>

                            <div class="row mb-4">
                                <div class="col-lg-6 pull-right rig">
                                    <button type="button" id="btn-cancelar"
                                            class="btn btn-warning col-lg-5 mr-5">Cancelar</button>
                                    %{--<button class="btn btn-success col-lg-5 pull-right" id="btn-salvar" type="submit" disabled><i class="fa fa-save"></i>&nbsp;Salvar</button>--}%
                                    <g:submitButton name="create" class="save btn btn-success col-lg-5 pull-right"
                                                    value="Salvar"/>
                                </div>
                            </div>
                        </g:form>
                    </div>
                </div>
            </div>

            <div class="col-lg-2"></div>
        </div>
    </div>
</div>

<asset:javascript src="jquery-3.3.1.slim.min.js"/>

<script>
    $(document).ready(function () {
        $('#caminho').append('<li><a><g:link action="create">Registar Conta bancaria</g:link>  </a></li>');
        $('#li_sistema').addClass('active');
        $('#li_list_contas').addClass('active');
    })
</script>
</body>
</html>
