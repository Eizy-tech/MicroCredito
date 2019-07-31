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
                %{--<input type="text" id="format" placeholder="Format">--}%
                <input type="hidden" name="codigo" id="codigo"  class="form-control" value="12342">
                <g:hiddenField name="testemunhas" id="testemunhas"/>
                <g:hiddenField name="idCliente" id="idCliente" value="0"/>
                <g:hiddenField name="idDomingo" id="idDomingo" value="1"/>
                <div>
                    <h3>Dados Pessoais</h3>
                    <fieldset>
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
                                            <label class="form-label" for="nrDocumento">Nº do Documento<span>&nbsp;*</span></label>
                                            <input type="text" name="nrDocumento" id="nrDocumento" class="form-control" required/>
                                        </div>
                                        <div class="col-sm-6">
                                            <label class="form-label" for="tipoDocumento">Tipo de Documento<span>&nbsp;*</span></label>
                                            <g:select id="tipoDocumento" name="tipoDocumento" optionKey="id" optionValue="descricao"
                                                      from="${tipoDocumentoList.list()}" class="form-control select"
                                            />
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-sm-6 pr-0">
                                    <label class="form-label" for="localEmissao">Local de Emissão<span>&nbsp;*</span></label>
                                    <input type="text" name="localEmissao" id="localEmissao" class="form-control datepicker-days" required/>
                                </div>
                                <div class="col-sm-6">
                                    <div class="row">
                                        <div class="col-sm-6 pr-0">
                                            <label class="form-label" for="dataEmissao">Data de Emissão<span>&nbsp;*</span></label>
                                            <input type="text"  name="dataEmissao" id="dataEmissao" class="form-control data-hoje" required/>
                                        </div>
                                        %{--data-language='pt' data-date-format="dd-mm-yyyy"--}%
                                        <div class="col-sm-6">
                                            <label class="form-label" for="dataValidade">Data de validade<span>&nbsp;*</span></label>
                                            <input type="text" name="dataValidade" id="dataValidade" class="form-control data-hoje" required/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row margin-bottom">
                                <div class="col-sm-6 pr-0">
                                    <label class="form-label" for="nacionalidade">Nacionalidade<span>&nbsp;*</span></label>
                                    <input type="text" name="nacionalidade" id="nacionalidade" class="form-control" required/>
                                </div>

                                <div class="col-sm-6">
                                    <label class="form-label" for="naturalidade">Naturalidade<span>&nbsp;*</span></label>
                                    <input type="text" name="naturalidade" id="naturalidade" class="form-control datepicker-days" required/>
                                </div>
                            </div>
                            <div class="row  margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="estadoCivil">Estado Civil<span>&nbsp;*</span></label>
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
                                    <label class="form-label" for="contacto1">Contacto<span>&nbsp;*</span></label>
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
                                            <label class="form-label" for="endereco">Morada<span>&nbsp;*</span></label>
                                            <textarea rows="5" class="form-control select" name="endereco" id="endereco" required>

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
                                <div class="col-sm-4 pr-0">
                                    <label class="form-label" for="valorPedido">Valor Pretendido<span>&nbsp;*</span></label>
                                    <input type="text" name="valorPedido" id="valorPedido" class="form-control" required/>
                                </div>
                                <div class="col-sm-4 pr-0">
                                    <label class="form-label" for="nrPrestacoes" id="label-nrPrestacoes">Numero de Prestações<span>&nbsp;*</span></label>
                                    <input type="text" name="nrPrestacoes" id="nrPrestacoes" class="form-control input-valor" value="1" required min="1"/>
                                </div>
                                <div class="col-sm-4">
                                    <label class="form-label" for="taxaJuros">Taxa de Juros (%)<span>&nbsp;*</span></label>
                                    <input type="text" min="0" max="100" name="taxaJuros" id="taxaJuros" class="form-control" value="30" required/>
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-sm-3 pr-0">
                                    <label class="form-label" for="valorApagar">Valor a Pagar</label>
                                    <input type="text" readonly name="valorApagar" id="valorApagar" class="form-control"/>
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
                                    <input type="text" name="dataPrazo" id="dataPrazo" class="form-control" required/>
                                </div>
                            </div>

                            <div class="row margin-bottom">
                                <div class="col-md-4 pr-0">
                                    <label class="form-label" for="taxaMulta">Taxa de Multa<span>&nbsp;*</span></label>
                                    <input type="text" name="taxaMulta" id="taxaMulta" class="form-control" value="1.5" required/>
                                </div>
                                <div class="col-md-4 pr-0">
                                    <label class="form-label" for="taxaConcessao">Taxa de Tramitação</label>
                                    <input type="text" name="taxaConcessao" id="taxaConcessao" class="form-control" value="0" required/>
                                </div>
                                <div class="col-sm-4">
                                    <label class="form-label" for="experienciaNegocio">Profissão<span>&nbsp;*</span></label>
                                    <input type="text" name="experienciaNegocio" title="Experiencia no negocio actual" id="experienciaNegocio" class="form-control" required/>
                                </div>
                            </div>

                            <div class="row margin-bottom">

                                <div class="col-md-4 pr-0">
                                    <label class="form-label" for="destinoCredito">Destino do Crédito</label>
                                    <g:select id="destinoCredito" name="destinoCredito" optionKey="descricao"  optionValue="descricao"
                                              from="${destinoCreditoList}" class="form-control select"/>
                                </div>
                                <div class="col-sm-4 pr-0">
                                    <label class="form-label" for="tipoNegocio">Tipo de Nogócio</label>
                                    <input type="text" name="tipoNegocio" id="tipoNegocio" class="form-control"/>
                                </div>
                                <div class="col-sm-4">
                                    <label class="form-label" for="localNegocio">Local do Nogócio</label>
                                    <input type="text" name="localNegocio" id="localNegocio" class="form-control"/>
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
                    </fieldset>

                    <h3>Garantia</h3>
                    <fieldset>
                        <h4 class="wizzard-title"><i class="fa fa-phone-square"></i>&nbsp;Garantia</h4>
                        <hr class="hr">
                        <div class="fieldset-content">
                            <div class="row mb-1">
                                <div class="col-sm-6" id="div-avalista">
                                    <label class="form-label" for="avalista">Avalista</label>
                                    <input  type="text" name="avalista" id="avalista" class="form-control"/>
                                </div>
                                <div class="col-sm-6">
                                    <label class="form-label" for="btn-testemunhas">&nbsp;</label>
                                    <a type="button" class="btn btn-app btn-warning ml-0 btn-open-modal pt-2 pb-0" data-modal="modal-testemunhas" style="width: 100%; height: 35px; background-color: wheat" id="btn-testemunhas" title="Adicionar Testemunhas">
                                        <span class="badge bg-blue"></span>
                                        <i class="fa fa-users"></i>&nbsp;Testemunhas
                                    </a>
                                </div>
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

    // function formatMoney(n, c, d, t) {
    //     var c = isNaN(c = Math.abs(c)) ? 2 : c,
    //         d = d == undefined ? "." : d,
    //         t = t == undefined ? "," : t,
    //         s = n < 0 ? "-" : "",
    //         i = String(parseInt(n = Math.abs(Number(n) || 0).toFixed(c))),
    //         j = (j = i.length) > 3 ? j % 3 : 0;
    //
    //     return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
    // };

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
            $('#fieldset-cont-endereco-cliente .distrito').val(data.distrito).trigger('change');
        },1000);
    }
</script>

<script>
    $(document).ready(function () {

        $('#format').on('input',function () {
            console.log('Format: '+formatMoney($(this).val()))
        });

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
        $('#caminho').append('<li><a><g:link action="index">Emprestimos</g:link>  </a></li>');
        $('#caminho').append('<li><a><g:link action="create">Novo</g:link>  </a></li>');
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
                    $('#nacionalidade').val(cliente.nacionalidade);
                    $('#naturalidade').val(cliente.naturalidade);
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
        $('#but_add').click(function (e) {
            var rowCount = $('#tabelaTestemunha >tbody >tr').length;
            if (rowCount === 0) {
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

        $("#valorPedido").inputFilter(function (value) {
            // console.log('Format: '+formatMoney($(this).val()))
            // $('#valorPedido').val(formatMoney(value));
            calculoValorApagar();
        });
        $("#nrPrestacoes").inputFilter(function (value) {
            result = /^\d*$/.test(value) && (value === "" || value.length <= 20);
            if (result) {
                calculoValorApagar();

                dates = $('#dataInicioPagamento').val().split('-');
                var prazoo = new Date(dates[1]+'-'+dates[0]+'-'+dates[2]);
                if(value == ''){
                    prazoo.setMonth(prazoo.getMonth());
                }else{
                    prazoo.setMonth(prazoo.getMonth()+parseInt(value-1));
                }
                dataPrazo.selectDate(prazoo);
            }
            return result;
        });
        // $("#taxaJuros").inputFilter(function (value) {
        //     calculoValorApagar();
        // });

        $('#taxaJuros').on('input',function () {
            calculoValorApagar();
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
            nrPrestacoes = $('#nrPrestacoes').val();
            valorPorPrestacao = valorApagar/nrPrestacoes;

            $('#valorApagar').val(valorApagar.toFixed(2));
            if($('#nrPrestacoes').val() == ''){
                $('#valorPorPrestacao').val(valorApagar.toFixed(2));
            }else{
                $('#valorPorPrestacao').val(valorPorPrestacao.toFixed(2));
            }
            // value = $('#nrPrestacoes').val();
            // if(parseInt(value) === 1){
            //     $('#taxaJuros').val(30)
            // }else if(parseInt(value) === 2){
            //     $('#taxaJuros').val(47)
            // }else if(parseInt(value) === 3){
            //     $('#taxaJuros').val(67)
            // }else if(parseInt(value) === 0){
            //     $('#taxaJuros').val(67)
            // }
        }

        $('#tabelaTestemunha').SetEditable({$addButton: $('#but_add')}); //habilita tabela de testemunhas para que seja editevel
        var dataInicioPagamento = $('#dataInicioPagamento').datepicker({language: 'pt'}).data('datepicker');

        dataProximo = new Date();
        dataProximo.setMonth(dataProximo.getMonth()+1);
        dataInicioPagamento.selectDate(dataProximo);

        var dataPrazo = $('#dataPrazo').datepicker({language: 'pt'}).data('datepicker');
        dataPrazo.selectDate(dataProximo);

        $("#dataInicioPagamento").datepicker({
            onSelect: function(dateText) {
                nrPrestacoesElement = $('#nrPrestacoes');

                dates = dateText.split('-');
                var prazoo = new Date(dates[1]+'-'+dates[0]+'-'+dates[2]);

                prazoo.setMonth(prazoo.getMonth()+parseInt(nrPrestacoesElement.val()-1));
                dataPrazo.selectDate(prazoo);
            }
        });

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