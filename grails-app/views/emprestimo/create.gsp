<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'emprestimo.label', default: 'Emprestimo')}" />
    %{--<g:set var="cliente" value="${message(code: 'cliente.label', default: 'Cliente')}" />--}%
    <title>Registar Emprestimo</title>

    %{--<asset:stylesheet src="datepicker/bootstrap-datepicker.min.css"/>--}%
</head>
<body>

<div class="row">
    <div class="col-md-12">
        %{--<div class="main">--}%
        <div class="container">
            <form id="signup-form" class="signup-form" autocomplete="off" enctype="multipart/form-data">
                <input type="hidden" name="codigo" id="codigo"  class="form-control" value="12342">
                <g:hiddenField name="testemunhas" id="testemunhas"/>
                <g:hiddenField name="idCliente" id="idCliente" value="0"/>
                <g:hiddenField name="idDomingo" id="idDomingo" value="1"/>
                <div>
                    <h3>Dados Pessoais</h3>
                    <fieldset>
                        %{--<div id="idd">--}%
                        %{--<input type="text" id="picker" class="form-control">--}%
                        %{--</div>--}%
                        <input type="hidden">
                        <h4 class="wizzard-title"><i class="fa fa-user"></i>&nbsp;Dados Pessoais</h4>
                        <hr class="hr">
                        <div class="fieldset-content" id="fieldset-cliente">
                            <div class="row margin-bottom">
                                <div class="col-sm-6 pr-0">
                                    <label class="form-label" for="nomeCompleto">Nome Completo<span>&nbsp;*</span></label>
                                    <div class="input-group">
                                        <div class="has-feedback has-clear">
                                            <input type="text" class="form-control" id="nomeCompleto" name="nomeCompleto" required>
                                            <span id="clear-nomeCompleto" class="form-control-feedback fa fa-times"
                                                  title="Limpar campo">
                                            </span>
                                        </div>
                                        <div class="input-group-btn">
                                            <button type="button" class="btn btn-default btn-open-modal"
                                                    title="Selecionar Cliente ja Existente"
                                                    data-modal="modal-cliente">Add
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="row">
                                        <div class="col-sm-6 pr-0">
                                            <label class="form-label" for="nrDocumento">Nº do Documento</label>
                                            <input type="text" name="nrDocumento" id="nrDocumento" class="form-control" required/>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label" for="tipoDocumento">Tipo de Documento</label>
                                            <g:select id="tipoDocumento" name="tipoDocumento" optionKey="id" optionValue="descricao"
                                                      from="${tipoDocumentoList.list()}" class="form-control select"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-sm-6 pr-0">
                                    <label class="form-label" for="localEmissao">Local de Emissão</label>
                                    <input type="text" name="localEmissao" id="localEmissao" class="form-control datepicker-days" required/>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row">
                                        <div class="col-sm-6 pr-0">
                                            <label class="form-label" for="dataEmissao">Data de Emissão</label>
                                            <input type="text"  name="dataEmissao" id="dataEmissao" class="form-control data-hoje" required/>
                                        </div>
                                        %{--data-language='pt' data-date-format="dd-mm-yyyy"--}%
                                        <div class="col-sm-6">
                                            <label class="form-label" for="dataValidade">Data de validade</label>
                                            <input type="text" name="dataValidade" id="dataValidade" class="form-control data-hoje" required/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row  margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="estadoCivil">Estado Civil</label>
                                    <g:select  class="form-control select estado-civil" id="estadoCivil" name="estadoCivil" data-conjuge="nomeConjuge"
                                               from="${cliente.constrainedProperties.estadoCivil.inList}"
                                    />
                                </div>
                                <div class="col-sm-6 pr-0">
                                    <label class="form-label" for="nomeConjuge">Nome do Cônjuge</label>
                                    <input type="text" name="nomeConjuge" id="nomeConjuge" class="form-control"/>
                                </div>
                                <div class="col-sm-3">
                                    <label class="form-label" for="nrDependentes">Nº de Dependentes</label>
                                    <input type="number" name="nrDependentes" id="nrDependentes" class="form-control"/>
                                </div>
                            </div>
                            <div class="row margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="nrFihos">Nº de Filhos</label>
                                    <input type="number" name="nrFihos" id="nrFihos" class="form-control"/>
                                </div>
                                <div class="col-sm-6 pr-0" >
                                    <label class="form-label" for="tipoContrato">Tipo de Contrato de Trabaho</label>
                                    <input type="text" name="tipoContrato" id="tipoContrato" class="form-control"/>
                                </div>
                                <div class="col-sm-3 ">
                                    <label class="form-label" for="anoAdmissao">Ano de Admissão</label>
                                    <input type="text" name="anoAdmissao" id="anoAdmissao" class="form-control anoAdmissao" title="Ano de admissao no trabalho"/>
                                </div>
                            </div>
                        </div>
                    </fieldset>

                    <h3>Contacto e Endereço</h3>
                    <fieldset>
                        <h4 class="wizzard-title"><i class="fa fa-phone-square"></i>&nbsp;Contacto e Endereço</h4>
                        <hr class="hr">
                        <div class="fieldset-content" id="fieldset-cont-endereco-cliente">
                            <div class="row margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="contacto1">Contacto</label>
                                    <input type="text" name="contacto1" id="contacto1" class="form-control contacto" required>
                                </div>

                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="contacto2">Contacto Opcional</label>
                                    <input type="text" name="contacto2" id="contacto2" class="form-control contacto"/>
                                </div>

                                <div class="col-sm-6">
                                    <label class="form-label" for="email">Email</label>
                                    <input type="email" name="email" id="email" class="form-control select"/>
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-sm-6">
                                    <div class="row margin-bottom">
                                        <div class="col-sm-6 pr-0">
                                            <label class="form-label" for="provincia">Província</label>
                                            <g:select id="provincia" name="provincia" optionKey="id"  optionValue="designacao"
                                                      from="${provinciaList}" class="form-control select provincia" data-div="div-distrito-1"/>
                                        </div>
                                        <div class="col-sm-6 pr-0" id="div-distrito-1"></div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12 pr-0">
                                            <label class="form-label" for="endereco">Morada</label>
                                            <textarea rows="5" class="form-control select" name="endereco" id="endereco">

                                            </textarea>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row">
                                        <div class="col-sm-12 margin-bottom">
                                            <label class="form-label" for="tipoCasa">Casa</label>
                                            <g:select id="tipoCasa" name="tipoCasa" optionKey="descricao"  optionValue="descricao"
                                                      from="${tipoCasaList}" class="form-control select"
                                            />
                                        </div>

                                        <div class="col-sm-12 margin-bottom">
                                            <label class="form-label" for="amplitude">Latitude</label>
                                            <input type="text" id="amplitude" name="amplitude"   class="form-control">
                                        </div>

                                        <div class="col-sm-12 mb-5">
                                            <label class="form-label" for="longitude">Longitude</label>
                                            <input type="text" name="longitude" id="longitude"  class="form-control">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset>

                    <h3>Empréstimo</h3>
                    <fieldset>
                        <h4 class="wizzard-title"><i class="fa fa-file"></i>&nbsp;Empréstimo</h4>
                        <hr class="hr">
                        <div class="fieldset-content">
                            <div class="row margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="valorPedido">Valor Pretendido</label>
                                    <input type="text" name="valorPedido" id="valorPedido" class="form-control" required/>
                                </div>
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="taxaJuros">Taxa de Juros (%)</label>
                                    <input type="text" min="0" max="100" name="taxaJuros" id="taxaJuros" class="form-control" required/>
                                </div>
                                <div class="col-sm-3 pr-2">
                                    <label class="form-label" for="valorApagar">Valor a Pagar</label>
                                    <input type="text" readonly name="valorApagar" id="valorApagar" class="form-control"/>
                                </div>
                                <div class="col-sm-3 pl-3">
                                    <label class="form-label" for="modoPagamento">Modo de Pagamento</label>
                                    <g:select id="modoPagamento" name="modoPagamento" optionKey="descricao"
                                              optionValue="descricao" from="${modoPagamentoList}" class="form-control select"
                                    />
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="nrPrestacoes" id="label-nrPrestacoes">Numero de Prestações</label>
                                    <input type="text" name="nrPrestacoes" id="nrPrestacoes" class="form-control input-valor" value="1" required/>
                                </div>
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="valorPorPrestacao" id="label-valorPrestacao">Valor Por Prestação</label>
                                    <input readonly type="text" name="valorPorPrestacao" id="valorPorPrestacao" class="form-control" title="Valor a pagar por prestação" />
                                </div>
                                <div class="col-sm-3 pr-2">
                                    <label class="form-label" for="dataInicioPagamento">Inicio de Pagamento</label>
                                    <input  type="text" name="dataInicioPagamento" id="dataInicioPagamento" class="form-control select" required/>
                                </div>
                                <div class="col-md-3 pl-3">
                                    <label class="form-label" for="dataPrazo">Prazo de Pagamento</label>
                                    <input type="text" name="dataPrazo" id="dataPrazo" class="form-control" value="10" required/>
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-md-3 pr-0">
                                    <label class="form-label" for="taxaMulta">Taxa de Multa</label>
                                    <input type="text" name="taxaMulta" id="taxaMulta" class="form-control" value="10" required/>
                                </div>
                                <div class="col-md-3 pr-0">
                                    <label class="form-label" for="taxaConcessao">Taxa de Concessão</label>
                                    <input type="text" name="taxaConcessao" id="taxaConcessao" class="form-control" value="150" required/>
                                </div>
                                %{--<div class="col-sm-6">--}%
                                %{--<div class="row">--}%
                                <div class="col-sm-6">
                                    <label class="form-label" for="localNegocio">Local do Nogócio</label>
                                    <input type="text" name="localNegocio" id="localNegocio" class="form-control"/>
                                </div>

                                %{--</div>--}%
                                %{--</div>--}%
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-sm-4">
                                    <label class="form-label" for="experienciaNegocio">Experiencia no Negócio actual</label>
                                    <input type="text" name="experienciaNegocio" title="Experiencia no negocio actual" id="experienciaNegocio" class="form-control" />
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label" for="destinoCredito">Destino do Crédito</label>
                                    <g:select id="destinoCredito" name="destinoCredito" optionKey="descricao"  optionValue="descricao"
                                              from="${destinoCreditoList}" class="form-control select"/>
                                </div>
                                <div class="col-sm-4">
                                    <label class="form-label" for="tipoNegocio">Tipo de Nogócio</label>
                                    <input type="text" name="tipoNegocio" id="tipoNegocio" class="form-control"/>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-6">
                                    <label class="form-label" for="instituicoescredito">Crédito Em Outras Instituições</label>
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <input data-id="outroCredito" type="checkbox" class="flat-red form-check" data-input="instituicoescredito">
                                        </span>
                                        <input type="text" name="instituicoescredito" id="instituicoescredito" class="form-control"
                                               placeholder="Nomes das Instituições">
                                    </div>
                                    <input type="hidden" id="outroCredito" name="outroCredito">
                                </div>
                                <div class="col-sm-6">
                                    <label class="form-label" for="bancos">Conta Bancária</label>
                                    <div class="input-group">
                                        <span class="input-group-addon">
                                            <input data-id="contaBancaria" type="checkbox" class="flat-red form-check" data-input="bancos">
                                        </span>
                                        <input type="text" id="bancos" name="bancos" class="form-control" placeholder="Em que bancos">
                                    </div>
                                    <input type="hidden" id="contaBancaria" name="contaBancaria">
                                </div>
                            </div>
                        </div>
                        %{--<button type="submit" class="btn btn-success">Save</button>--}%
                    </fieldset>

                    <h3>Garantia</h3>
                    <fieldset>
                        <h4 class="wizzard-title"><i class="fa fa-phone-square"></i>&nbsp;Garantia</h4>
                        <hr class="hr">
                        <div class="fieldset-content">
                            <div class="row mb-1">
                                <div class="col-sm-6" id="div-avalista">
                                    <g:render template="/cliente/avalistaCombo"/>
                                </div>
                                <div class="col-sm-6">
                                    <label class="form-label" for="btn-testemunhas">&nbsp;</label>
                                    <a type="button" class="btn btn-app btn-warning ml-0 btn-open-modal pt-2 pb-0" data-modal="modal-testemunhas" style="width: 100%; height: 35px; background-color: wheat" id="btn-testemunhas" title="Adicionar Testemunhas">
                                        <span class="badge bg-blue"></span>
                                        <i class="fa fa-users"></i>&nbsp;Testemunhas
                                    </a>
                                </div>
                                <g:hiddenField name="relacaoBens" id="relacaoBens"/>
                            </div>

                            <div class="row mt-0" id="div-garantias">
                                %{--as divs de garantias estarao aqui--}%
                            </div>
                            <input type="hidden" id="nrGarantias" name="nrGarantias">
                        </div>
                    </fieldset>
                </div>
            </form>
        </div>
        %{--</div>--}%
    </div>
</div>

<div class="modal fade" id="modal-cliente">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content" style="border-radius: 5px; width: 35%">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-sm-12">
                            <h4 class="text-center text-dark"><strong>Selecione o Cliente</strong></h4>
                            <div id="div-cliente-selecionar">
                                %{--<g:select id="clienteSelecionado" name="clienteSelecionado" optionKey="id"  optionValue="nome"--}%
                                %{--from="${cliente.createCriteria().list{order('nome')}}" class="form-control select2" data-size="13" style="width: 100%"--}%
                                %{--/>--}%
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger pull-left" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-success" id="btn-select-cliente"><i class="fa fa-check"></i>&nbsp;Concluir</button>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modal-avalista">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content" style="border-radius: 5px">
                <div class="modal-body m-0 p-0" id="avalista-corpo">
                    <form id="form-avalista">
                        <g:render template="/cliente/avalista"/>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger pull-left" data-dismiss="modal" id="btn-cancel-avalista">Cancelar</button>
                    <button type="button" class="btn btn-success" id="btn-save-avalista"><i class="fa fa-check"></i>&nbsp;Concluir</button>
                </div>
            </div>
        </div>
    </div>
</div>
%{--modal de testemunha--}%
<div class="modal fade" id="modal-testemunhas">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content modal-lg centered">
                <div class="modal-body">
                    <h4 class="modal-title">  <i class="fa fa-users"></i>&nbsp;Testemunhas
                        <span style="float:right">
                            <button id="but_add" class="btn btn-primary margin-bottom">
                                <i class="fa fa-plus"></i>&nbsp;Adicionar
                            </button>
                        </span>
                    </h4>
                    <table class="table table-bordered" id="tabelaTestemunha">
                        <thead>
                        <tr>
                            <th>Nome</th>
                            <th>Endereco</th>
                            <th>Contacto</th>
                            <th>Grau_de_Parentesco</th>
                        </tr>
                        </thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger pull-left" data-dismiss="modal">Cancelar</button>
                    <button type="button" class="btn btn-success" data-dismiss="modal" id="btn-saveTestemunhas"><i class="fa fa-check"></i>&nbsp;Concluir</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- JS -->
<asset:javascript src="jquery-3.3.1.slim.min.js"/>
%{--<asset:javascript src="bootstrap.min.js"/>--}%
<script type="text/javascript">

    function appendGarantia() {
        index = $('.box-garantia').length + 1;        //conta divs de garantia que ja existem
        // if(index === 4) return;                         //apenas so aceita 3 divs de garantia
        $.ajax({
            method: 'POST',
            url: 'addGarantiaForm',
            data: {'index': index},
            success: function (data) {
                $('#div-garantias').append(data);
                // $('#btn-remove-1').remove()         //desabilita/apaga button de remover box-garantia
            }
        });
        $('#nrGarantias').val(index);
    }

    function setSelect2(){
        $('#clienteSelecionado').select2();
    }
    function provinciaEDistrito(data){
        $('#fieldset-cont-endereco-cliente .provincia').val(data.provincia).trigger('change');
        setTimeout(function () {
            $('#fieldset-cont-endereco-cliente .distrito').val(data.distrito).trigger('change')
        },1000);
    }
</script>

<script>
    $(document).ready(function () {

        function desabitilitaDomingo(domingo){
            var calendar = domingo.getDay();
            return [(calendar>0)]
        }


        // $('#picker').datepicker({language: 'pt'}).data('datepicker');
        $('#picker').datepicker({language: 'pt'});
        $('#picker').focus(function () {
            // $('.-weekend-').css({'background-color':'red'});
            // $('.datepicker').first().css({'background-color':'red'});
            $('.datepicker').first().css({'background-color':'blue'});
            $('.datepicker > .datepicker--content').first().css({'background-color':'red'});
            $('.datepicker > .datepicker--content > .datepicker--days').first().css({'background-color':'white'});
            $('.datepicker > .datepicker--content > .-weekend-').first().css({'background-color':'blue','color':'pink'});
            // $('.datepicker > .datepicker--content > .datepicker--cells > .datepicker--cell').first().css({'background-color':'yellow'});

            // datepicker--cell datepicker--cell-day -weekend-

            // datepicker--cell datepicker--cell-day -weekend- -selected-
            // datepicker--content
            // datepicker--days datepicker--body active
            // datepicker--cell datepicker--cell-day -weekend-
        });

        $("#picker").datepicker({
            onSelect: function (dateText) {
                dates = dateText.split('-');
                var prazoo = new Date(dates[1] + '-' + dates[0] + '-' + dates[2]);
                if(prazoo.getDay() === 0){
                    // alert('domingo')
                    prazoo.setDate(prazoo.getDate()+1);
                    // $('#picker').selectDate(prazoo)
                    $('#picker').datepicker({language: 'pt'}).data('datepicker').selectDate(prazoo)
                }
            }
        });

        $('.select2').select2();

        $.fn.inputFilter = function (inputFilter) {
            return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function () {
                if (inputFilter(this.value)) {
                    this.oldValue = this.value;
                    this.oldSelectionStart = this.selectionStart;
                    this.oldSelectionEnd = this.selectionEnd;
                } else if (this.hasOwnProperty("oldValue")) {
                    this.value = this.oldValue;
                    this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
                }
            });
        };

        $('.select2').select2();
        $('#caminho').append('<li><a><g:link action="create">Registar Emprestimo</g:link>  </a></li>');
        $('#li_emprestimos').addClass('active');
        $('#li_novo_emprestimo').addClass('active');

        $('.actions ul li:first-child a').prepend('<i class="fa fa-arrow-alt-circle-left fa-2x"></i>&nbsp;&nbsp;');
        $('.actions ul li:nth-child(2) a').append('&nbsp;&nbsp;<i class="fa fa-arrow-alt-circle-right fa-2x"></i>');
        $('.actions ul li:last-child a').append('&nbsp;&nbsp;<i class="fa fa-save fa-2x"></i>');
    });
</script>

%{--Dados pessoias(Cliente)--}%
<script>
    $(document).ready(function () {
        var dataEmissao = $('#dataEmissao').datepicker({language: 'pt'}).data('datepicker');
        var dataValidade = $('#dataValidade').datepicker({language: 'pt'}).data('datepicker');
        // dataEmissao.selectDate(new Date());
        // dataValidade.selectDate(new Date());

        $('.estado-civil').on('change',function () {
            estadoCivil = $(this).children('option').filter(':selected').text();
            conjogue =  $(this).attr('data-conjuge');
            if(estadoCivil === "Casado"){
                $('#'+conjogue).prop('required',true)
            }else{
                $('#'+conjogue).removeAttr('required');
                $('#'+conjogue).css({"border": "1px solid #ccc"})
            }
        });

        $('.btn-open-modal').click(function () {               //open testemunhas pop-up
            if($(this).attr('data-modal') === "modal-cliente"){
                <g:remoteFunction controller="cliente" action="getClientes" update="div-cliente-selecionar" onSuccess="setSelect2()"/>
            }

            $('#' + $(this).attr('data-modal')).modal({
                show: true, backdrop: "static"
            });
        });

        $('#btn-select-cliente').click(function () {
            clienteSelecionado = $('#clienteSelecionado option:selected').text();
            clienteSelecionadoID = $('#clienteSelecionado').val();

            if(!clienteSelecionado){
                return
            }
            $('#idCliente').val(clienteSelecionadoID);                          //guarda id do cliente selecionado no hidden input
            $('#nomeCompleto').val(clienteSelecionado);                         //poe o nome do cliente selecionado no input
            $('#nomeCompleto').prop('readOnly', true);                           //desabilita campo
            $('#modal-cliente').modal('toggle');
            // $('#fieldset-cliente > .fieldset-content > input').prop('readOnly',true);
            $('#nomeCompleto').trigger('propertychange');                       //dispara para aparecer btn-clear
            getClienteDados(clienteSelecionadoID)
        });

        function getClienteDados(id) {
            $.ajax({
                method: 'POST',
                url: "${g.createLink( controller: 'cliente', action:'getClienteData')}",
                data: {'id': id},
                success: function (cliente) {
                    $('#nomeConjuge').val(cliente.nomeConjuge);
                    $('#nrDocumento').val(cliente.nrDocumento);
                    $('#localEmissao').val(cliente.localEmissao);
                    dataEmissao.selectDate(new Date(cliente.dataEmissao), 0);
                    dataValidade.selectDate(new Date(cliente.dataValidade), 0);
                    $('#nrDependentes').val(cliente.nrDependentes);
                    $('#nrFihos').val(cliente.nrFilhos);
                    $('#tipoContrato').val(cliente.tipoContrato);
                    $('#anoAdmissao').val(cliente.anoAdmissao);
                    // $('#estadoSlect')
                    /*contacto e endereco*/
                    $('#contacto1').val(cliente.contacto1);
                    $('#contacto2').val(cliente.contacto2);
                    $('#email').val(cliente.email);
                    $('#endereco').val(cliente.endereco);
                    $('#amplitude').val(cliente.amplitude);
                    $('#longitude').val(cliente.longitude);

                    $('#fieldset-cliente .estado-civil').val(cliente.estadoCivil).trigger('change');
                    $('#fieldset-cliente :input').css({"border": "1px solid #ccc"});
                    $('#fieldset-cliente #tipoDocumento').val(cliente.tipoDocumento.id).trigger('change');

                    <g:remoteFunction controller="provincia" action="getProvincia" onSuccess="provinciaEDistrito(data)" id="'+cliente.distrito.id+'"/>
                }
            });
        }

        $('#nomeCompleto').on('input propertychange', function () {
            var visible = Boolean($(this).val());
            $(this).siblings('#clear-nomeCompleto').toggleClass('hidden', !visible);
        }).trigger('propertychange');

        $('#clear-nomeCompleto').click(function () {
            $(this).siblings('input[type="text"]').val('').trigger('propertychange').focus();   //limpa o testo

            if (parseInt($('#idCliente').val()) !== 0) {                                      //quando ja foi selecionado um cliente antes
                $('#idCliente').val(0);                                                     //esvazia o input id do cliente, pondo (0)
                $('#fieldset-cliente :input').val("");                                      //limpa todos inputs na sessao de dados do cliente
                $('#fieldset-cont-endereco-cliente :input').val("");                        //limpa todos inputs na sessao de contacto e endereco
                $('#fieldset-cont-endereco-cliente :text').val("");                         //limpa textarea
                $('#nomeCompleto').removeAttr('readOnly');                                  //abilita o input
                $('#fieldset-cliente .estado-civil').val('Solteiro').trigger('change');
                // dataEmissao.selectDate(new Date());
                // dataValidade.selectDate(new Date())
            }
        });

        $('.anoAdmissao').inputFilter(function(value) {
            return /^\d*$/.test(value) && (value === "" || parseInt(value) <= new Date().getFullYear())
        });
    });
</script>

%{--Contacto e Endereco--}%
<script>
    $(document).ready(function () {
        $('.provincia').on('change', function () {
            var provinciaId = $(this).val();
            var div = $(this).attr('data-div');
            $.ajax({
                method: 'POST',
                // url: 'getDistrito', //metodo na controller
                url: "${g.createLink( controller: 'provincia', action:'getDistritos')}",
                data: {'id': provinciaId},
                success: function (data) {
                    $('#' + div).html(data); //renderiza combo de distritos
                    $('select').selectpicker();
                }
            });
        });
        $('.provincia').val($('.provincia').first().val()).trigger('change'); //prenche combo de distritos ao abrir a pagina

        $(".contacto").inputFilter(function(value) {
            return /^\d*$/.test(value) && (value === "" || value.length <= 9)
        });
    });
</script>

%{--Emprestimo--}%
<script>

    $(document).ready(function () {
        $('#tabelaTestemunha').SetEditable({$addButton: $('#but_add')}); //habilita tabela de testemunhas para que seja editevel
        var dataInicioPagamento = $('#dataInicioPagamento').datepicker({language: 'pt'}).data('datepicker');
        dataInicioPagamento.selectDate(new Date());

        var dataPrazo = $('#dataPrazo').datepicker({language: 'pt'}).data('datepicker');

        $('#but_add').click(function (e) {
            var rowCount = $('#tabelaTestemunha >tbody >tr').length;
            if (rowCount === 1) {
                $('#bEdit').trigger('click');
            }
            if(rowCount === 2){
                $('#but_add').attr("disabled", true); //desabilita btn de adicionar testemunhas
            }
        });

        $('#btn-saveTestemunhas').click(function () {
            var myRows = [];
            var headersText = [];
            var $headers = $("th");

            $("#tabelaTestemunha tbody tr").each(function (index) {
                $cells = $(this).find("td:not(:last-child)");           //excluiu a ulmina coluna prk contem buttons
                myRows[index] = {};
                $cells.each(function (cellIndex) {
                    if (headersText[cellIndex] === undefined) { // Set the header text
                        headersText[cellIndex] = $($headers[cellIndex]).text();
                    }
                    myRows[index][headersText[cellIndex]] = $(this).text();
                });
            });
            accaobtnTestemuna(myRows)
        });

        function accaobtnTestemuna(myRows) {
            var rowCount = $('#tabelaTestemunha >tbody >tr').length;
            if (rowCount >= 1) {
                $('#testemunhas').val(JSON.stringify(myRows)); //prenche o input de testemunhas com dados da tabela no formato JSON
                $('#btn-testemunhas').css({"background-color": "#00a65a", "color": "white"});
                $('#btn-testemunhas span').html(rowCount);
            } else {
                $('#btn-testemunhas').css({"background-color": "wheat", "color": "black"});
                $('#btn-testemunhas span').html(null);
            }
        }

        /*credito em outras instituicoes e conta bancaria*/
        $('.form-check').on('ifChanged', function () {
            var value = $(this).iCheck('update')[0].checked; //verica o check se esta selecioonado ou nao e retorna o valor[true|false]
            $("#" + $(this).attr('data-id')).val(value); //poe o valor no input boolean
            if (value) {
                $("#" + $(this).attr('data-input')).removeAttr('readonly'); //habilita input
                $("#" + $(this).attr('data-input')).prop('required', true) //habilita input
            } else {
                $("#" + $(this).attr('data-input')).prop('readonly', true); //desabiita input
                $("#" + $(this).attr('data-input')).removeAttr('required'); //desabiita input
                $("#" + $(this).attr('data-input')).val('');               //limpa campo
                $("#" + $(this).attr('data-input')).css({"border": "1px solid #ccc"})
            }
        });
        $('.form-check').trigger('ifChanged'); //inicializar os checks

        // $('.input-valor').on('input', function () {
        //     calculoValorApagar()
        // });

        $("#valorPedido").inputFilter(function (value) {
            result = /^\d*$/.test(value) && (value === "" || value.length <= 20);
            if (result) {
                calculoValorApagar();
            }
            return result;
        });
        $("#nrPrestacoes").inputFilter(function (value) {
            result = /^\d*$/.test(value) && (value === "" || value.length <= 20);
            if (result) {
                calculoValorApagar();
                $('#modoPagamento').val($('#modoPagamento').val()).trigger('change');
            }
            return result;
        });
        $("#taxaJuros").inputFilter(function (value) {
            result = /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
            if (result) {
                calculoValorApagar();
            }
            return result
        });
        $('#taxaMulta').inputFilter(function (value) {
            return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
        });
        $('#taxaConcessao').inputFilter(function (value) {
            return /^\d*$/.test(value) && (value === "" || value.length <= 20);
        });

        function calculoValorApagar() {
            valorPedido = $('#valorPedido').val();
            percent = $('#taxaJuros').val() / 100; // valor em percentagem
            if (valorPedido === '') {
                $('#valorApagar').val("");
                $('#valorPorPrestacao').val("");
                return
            }
            valorApagar = parseFloat(valorPedido) + parseFloat(valorPedido * percent); // calculo de valor total a pagar
            $('#valorApagar').val(valorApagar.toFixed(2));

            nrPrestacoes = $('#nrPrestacoes').val();

            valorPorPrestacao = valorApagar / nrPrestacoes;                //caculo de valor a pagar por prestacao
            if(modoPagamento === 'Mensal'){
                $('#valorPorPrestacao').val(parseFloat(valorPedido * percent));

                valorTotalMensal = parseFloat(valorPedido) + parseFloat(valorPedido * percent *nrPrestacoes);
                $('#valorApagar').val(valorTotalMensal.toFixed(2));
            }else{
                if (nrPrestacoes === '') {
                    $('#valorPorPrestacao').val(valorApagar.toFixed(2))
                }else{
                    $('#valorPorPrestacao').val(valorPorPrestacao.toFixed(2))
                }
            }

            //taxas de concessao
            if (parseFloat(valorPedido) >= 1000 && parseFloat(valorPedido) <= 5000) {
                $('#taxaConcessao').val(150)
            } else if (parseFloat(valorPedido) > 5000 && parseFloat(valorPedido) <= 100000) {
                $('#taxaConcessao').val(300)
            } else if (parseFloat(valorPedido) > 100000 && parseFloat(valorPedido) <= 500000) {
                $('#taxaConcessao').val(500)
            } else {
                $('#taxaConcessao').val(150)
            }
        }

        $('#modoPagamento').on('change', function () {
            var dataInicio = new Date();
            modoPagamento = $(this).val();                         //get value of modaidadadepagamento input
            nrPrestacoesElement = $('#nrPrestacoes');
            $('#label-nrPrestacoes').html('Numero de Prestações');
            $('#label-valorPrestacao').html('Valor Por Prestação');
            if (modoPagamento === 'Diaria') {                    //prestacao diaria
                dataInicio.setDate(dataInicio.getDate() + 1);
            } else if (modoPagamento === 'Semanal') {             //prestacao semanal
                dataInicio.setDate(dataInicio.getDate() + 7);
            } else if (modoPagamento === 'Quinzenal') {             //prestacao semanal
                dataInicio.setDate(dataInicio.getDate() + 15);
            } else {                                         //prestacao mensal
                dataInicio.setMonth(dataInicio.getMonth()+1);
                $('#label-nrPrestacoes').html('Numero de Mêses');
                $('#label-valorPrestacao').html('Juros');
            }

            dataInicioPagamento.selectDate(dataInicio);
            nrPrestacoesElement.attr({"min": 1});
            calculoValorApagar();
        });

        $("#dataInicioPagamento").datepicker({
            onSelect: function(dateText) {
                dates = dateText.split('-');
                var dataInico = new Date(dates[1]+'-'+dates[0]+'-'+dates[2]);
                var prazoo = new Date(dates[1]+'-'+dates[0]+'-'+dates[2]);

                var int = parseInt($('#nrPrestacoes').val()-1);
                console.clear();

                if (modoPagamento === 'Diaria') {//prestacao diaria
                    // prazoo.setDate(prazoo.getDate() + parseInt(nrPrestacoesElement.val()-1));
                    for (var i = 1; i <= int ; i++){
                        prazoo.setDate(prazoo.getDate()+1);
                        if(prazoo.getDay() === 0){ //se for domingo
                            console.log('domingo: '+ prazoo.getDate()+'-'+parseInt(prazoo.getMonth()+1)+'-'+prazoo.getFullYear());
                            prazoo.setDate(prazoo.getDate()+1);
                            console.log('Salta para: '+ prazoo.getDate()+'-'+parseInt(prazoo.getMonth()+1)+'-'+prazoo.getFullYear())
                        }
                        console.log('Prazo: '+i+'  :'+ prazoo.getDate()+'-'+parseInt(prazoo.getMonth()+1)+'-'+prazoo.getFullYear());
                    }
                } else if(modoPagamento === 'Semanal') {                                         //prestacao mensal
                    prazoo.setDate(prazoo.getDate() + parseInt((nrPrestacoesElement.val()-1)*7));
                }else if(modoPagamento === 'Quinzenal'){
                    prazoo.setDate(prazoo.getDate() + parseInt((nrPrestacoesElement.val()-1)*15));
                }else{
                    prazoo.setMonth(prazoo.getMonth()+parseInt(nrPrestacoesElement.val()-1));
                }

                if(dataInico.getDay() === 0 && modoPagamento === 'Diaria'){
                    swal({
                        title: "Deseja Continuar?",
                        text: "Selecionou domingo como data inicial de pagamento",
                        imageUrl: "../assets/question.png",
                        showCancelButton: true,
                        closeOnConfirm: true,
                        showLoaderOnConfirm: false,
                        confirmButtonText:'Sim',
                        cancelButtonText:'Não'
                    }, function (confirm) {
                        if(!confirm){
                            console.log('nao usar domingos')
                            dataInico.setDate(dataInico.getDate()+1);                                   //caso nao avancar com domingo
                            $('#dataInicioPagamento').datepicker({language: 'pt'}).data('datepicker').selectDate(dataInico);
                            if(prazoo.getDay() === 0) {
                                prazoo.setDate(prazoo.getDate() + 1)
                            }
                        }else{
                            console.log('usar domingos');
                            $('#dataInicioPagamento').datepicker({language: 'pt'}).data('datepicker').selectDate(dataInico);
                            prazoo.setDate(prazoo.getDate())
                        }
                    });
                }
                dataPrazo.selectDate(prazoo);
            }
        });

        $('#modoPagamento').val($('#modoPagamento').val()).trigger('change');

        $('#signup-form').submit(function () {
            event.preventDefault();
            var form_data = new FormData(this);                         //pega todos valores[inputs] no form
            var nrGarantias = parseInt($('#nrGarantias').val());      //busca nr de garantia k pretende-se salvar
            for (var id = 1; id < nrGarantias + 1; id++) {
                var inputFile = $("#file-" + id).prop("files")[0];
                form_data.append("foto" + id, inputFile);
            }

            swal({
                title: "Salvar?",
                imageUrl: "../assets/question.png",
                showCancelButton: true,
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function () {
                $.ajax({
                    url: 'salvar',
                    dataType: 'text',
                    cache: false,
                    contentType: false,
                    processData: false,
                    data: form_data,
                    type: 'POST',
                    success: function (data) {
                        setTimeout(function () {
                            swal({
                                title: "Certo!",
                                text: "Emprestimo Salvo com Sucesso!",
                                timer: 2500,
                                type: "success",
                                showConfirmButton: false
                            });

                            setInterval(
                                function() {
                                    window.location.reload();
                                }, 1000
                            );
                        }, 2000);
                    },
                    error: function (data) {
                        swal("Erro", "Ocorreu algum erro ao salvar Emprestimo \n"+data.msg, "error");
                    }
                });
            });
        });
    });
</script>

%{--Avalista--}%
<script>
    $(document).ready(function () {
        $(document).on('click','#btn-add-avalista',function () {
            $('#modal-avalista').modal({
                show:true, backdrop: "static"
            })
        });

        $(document).on('click', "#btn-clean-alavista", function () {
            $('#avalista').val($('#avalista option:first').val()).trigger('change');
        });

        $('#avalista').on('change', function () {                    //combo avalista
            var visible = Boolean($(this).val());
            $(this).siblings('#clear-avalista').toggleClass('hidden', !visible);
        }).trigger('propertychange');

        $('#clear-avalista').click(function () {$('#avalista').val($('#avalista option:first').val()).trigger('change');});
        $('#btn-cancel-avalista').click(function () {$('#form-avalista').trigger('reset')});
        $('#btn-save-avalista').click(function () {$('#form-avalista').trigger('submit')});
    });
</script>
%{--Garantia--}%
<script>
    $(document).ready(function () {
        appendGarantia();                                            //adiciona primeira div de garantia na inicializacao
        $(document).on('click', '.btn-add-garantia', function () {
            appendGarantia() //adicona outra div de garantia
        });

        $(document).on('change', '.input-upload', function () {       //acao de input file depois de selecioonar o file
            labelUpload = $('#label-' + $(this).attr('id'));
            if ($(this).get(0).files.length === 0) {
                labelUpload.html('Foto');     //caso nao selecionar um file
                labelUpload.prop('title', 'Carregar Foto');
                labelUpload.removeClass('btn-success');
                labelUpload.addClass('btn-primary');
            } else {
                fileName = $(this).val().split('\\');
                labelUpload.html('&nbsp;' + fileName[fileName.length - 1].substr(0, 20)); //poe o nome do selected file na label e limita o string em 20 characters
                labelUpload.prop('title', 'Foto Carregada: ' + fileName[fileName.length - 1]);
                labelUpload.removeClass('btn-primary');
                labelUpload.addClass('btn-success');
                labelUpload.prepend('<i class="fa fa-check-circle"></i>&nbsp;')
            }
        });
    });
</script>
</body>
</html>