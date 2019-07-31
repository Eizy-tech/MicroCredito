<div class="nav-tabs-custom box box-primary m-0">
    <ul class="nav nav-tabs pull-right" style="background-color: #ecf0f5">
        <li>
            <a class="btn btn-info btn-sm" title="Fechar" data-dismiss="modal" aria-label="Close"><i class="fa fa-times text-red"></i></a>
        </li>
        <li><a href="#contacto-endereco" data-toggle="tab"><i class="fa fa-phone"></i>&nbsp;Contacto & Endereço</a></li>
        <li class="active"><a href="#dados-pessoas" data-toggle="tab"><i class="fa fa-user"></i>&nbsp;Dados Pessoais</a></li>
        <li class="pull-left header wizzard-title"><i class="fa fa-pencil"></i> Adicionar Avalista</li>
    </ul>
    <div class="tab-content" style="background-color: transparent">
        <div class="tab-pane active p-3" id="dados-pessoas" >
            <div class="row margin-bottom">
                <div class="col-sm-6">
                    <label class="form-label" for="nome">Nome Completo</label>
                    <input type="text" name="nomeCompleto" id="nome" class="form-control" required>
                </div>

                <div class="col-sm-3">
                    <label class="form-label" for="estadoCivil-avalista">Estado Civil</label>
                    <g:select  class="form-control select estado-civil" id="estadoCivil-avalista" name="estadoCivil"
                       data-conjuge="nomeConjuge-avalista" from="${cliente.constrainedProperties.estadoCivil.inList}"
                    />
                </div>

                <div class="col-sm-3">
                    <label class="form-label" for="nomeConjuge-avalista">Nome do Cônjuge</label>
                    <input type="text" name="nomeConjuge" id="nomeConjuge-avalista" class="form-control"/>
                </div>
            </div>
            <div class="row  margin-bottom">
                <div class="col-sm-4">
                    <label class="form-label" for="tipoDocumento">Tipo de Documento</label>
                    <g:select id="tipoDocumento" name="tipoDocumento" optionKey="id" optionValue="descricao"
                              from="${tipoDocumentoList.list()}" class="form-control select"
                    />
                </div>
                <div class="col-sm-4">
                    <label class="form-label" for="nrDocumento">Número do Documento</label>
                    <input type="text" name="nrDocumento" id="nrDocumento" class="form-control" required/>
                </div>
                <div class="col-sm-4">
                    <label class="form-label" for="localEmissao">Local de Emissão</label>
                    <input type="text" name="localEmissao" id="localEmissao" class="form-control" required/>
                </div>
            </div>
            <div class="row margin-bottom">
                <div class="col-sm-4">
                    <label class="form-label" for="dataEmissao-avalista">Data de Emissão</label>
                    <input type="date" name="dataEmissao" id="dataEmissao-avalista" class="form-control select" required/>
                </div>
                <div class="col-sm-4">
                    <label class="form-label" for="dataValidade-avalista">Data de validade</label>
                    <input type="date" name="dataValidade" id="dataValidade-avalista" class="form-control select data-hoje" required />
                </div>
                <div class="col-sm-4">
                    <label class="form-label" for="tipoContrato">Tipo de Contrato de Trabaho</label>
                    <input type="text" name="tipoContrato" id="tipoContrato" class="form-control" value="Tiposs" />
                </div>
            </div>
            <div class="row">
                <div class="col-sm-4">
                    <label class="form-label" for="anoAdmissao">Ano de Admissão</label>
                    <input type="text" name="anoAdmissao" id="anoAdmissao" class="form-control anoAdmissao"/>
                </div>
                <div class="col-sm-4">
                    <label class="form-label" for="nrDependentes">Nº de Dependentes</label>
                    <input type="number" name="nrDependentes" id="nrDependentes" class="form-control"/>
                </div>
                <div class="col-sm-4">
                    <label class="form-label" for="nrFihos">Nº de Filhos</label>
                    <input type="number" name="nrFihos" id="nrFihos" class="form-control"/>
                </div>
            </div>
        </div>
        <div class="tab-pane p-3" id="contacto-endereco">
            <div class="row margin-bottom">
                <div class="col-sm-6">
                    <div class="row">
                        <div class="col-sm-6">
                            <label class="form-label" for="contacto1">Contacto</label>
                            <input type="text" name="contacto1" id="contacto1"  class="form-control contacto" required>
                        </div>
                        <div class="col-sm-6">
                            <label class="form-label" for="contacto2">Contacto Opcional</label>
                            <input type="text" name="contacto2" id="contacto2" class="form-control contacto"/>
                        </div>
                    </div>
                </div>

                <div class="col-sm-6">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" name="email" id="email"  class="form-control select"/>
                </div>
            </div>

            <div class="row margin-bottom">
                <div class="col-sm-3">
                    <label class="form-label" for="provinciaAvalista">Província</label>
                    <g:select id="provinciaAvalista" name="provinciaAvalista" optionKey="id"  optionValue="designacao"
                              from="${provinciaList}" class="form-control select provincia" data-div="div-Distrito-2"/>
                </div>
                <div class="col-sm-3" id="div-Distrito-2">
                    %{--<select id="distrito" name="distrito" class="form-control"></select>--}%
                </div>

                <div class="col-sm-3">
                    <label class="form-label" for="amplitude">Latitude</label>
                    <input type="text" id="amplitude" name="amplitude"   class="form-control" required>
                </div>

                <div class="col-sm-3">
                    <label class="form-label" for="longitude">Longitude</label>
                    <input type="text" name="longitude" id="longitude"  class="form-control" required>
                </div>
            </div>
            <div class="row margin-bottom">
                <div class="col-sm-9">
                    <label class="form-label" for="endereco">Morada</label>
                    <input type="text" name="endereco" id="endereco"  class="form-control" value="bairro polana case" required>
                </div>
                <div class="col-sm-3">
                    <label class="form-label" for="tipoCasa">Casa</label>
                    <g:select id="tipoCasa" name="tipoCasa" optionKey="descricao"  optionValue="descricao"
                              from="${tipoCasaList}" class="form-control select"
                    />
                </div>
            </div>
        </div>
    </div>
</div>
<asset:javascript src="jquery-3.3.1.slim.min.js"/>

<script type="text/javascript">
    $(function () {
        // $('#distrito').selectpicker()
        // var dataEmissaoAvalista = $('#dataEmissao-avalista').datepicker({language: 'pt'}).data('datepicker');
        // var dataValidadeAvalista = $('#dataValidade-avalista').datepicker({language: 'pt'}).data('datepicker');
        // dataEmissaoAvalista.selectDate(new Date());
        // dataValidadeAvalista.selectDate(new Date());

        $("#form-avalista").validate({
            errorPlacement: function errorPlacement(error, element) {
                // element.before(error);
                element.css({"border": "red dotted 1px"});
            },
            rules: {
                email: {
                    email: true
                },
            },
            onfocusout: function(element,value) {
                $(element).valid();
                $(element).css({"border": "1px solid #ccc"});
            },
            onfocusin: function(element,value) {
                $(element).css({"border": "1px solid #40b6e0"});
            }
        });

        $('#form-avalista').submit(function (x) {
            x.preventDefault();
            if(!$(this).valid()) return;
            var form_data = new FormData(this);                         //pega todos valores[inputs] no form
            swal({
                title: "Salvar?",
                imageUrl: "../../assets/question.png",
                showCancelButton: true,
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function () {
                $.ajax({
                    url: 'salvarAvalista',
                    data: form_data,
                    type: 'POST',
                    dataType: 'text',
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function (data) {
                        $('#div-avalista').html(data);                                              //actualiza o select de avalista
                        $('#avalista').val($('#avalista option:last').val()).trigger('change');         //poe o ultiomo o avalista criado no select ja selecionado
                        $('#modal-avalista').modal('toggle');       //fecha o modal principal
                        swal({
                            title: "Certo!",
                            text: "Avalista Salvo com Sucesso!",
                            timer: 1500,
                            type: "success",
                            showConfirmButton: false
                        });
                    },
                    error: function () {
                        swal("Erro", "Ocorreu algum erro ao salvar Avalista", "error");
                    }
                })
            });
        });
    });
</script>