$(document).ready(function () {
    $('.select2').select2();
    // $('#nomeCompleto').editableSelect();
    $('#caminho').append('<li><a href="/emprestimo/create">Registar Emprestimo</a></li>');
    $('#li_emprestimos').addClass('active');
    $('#li_novo_emprestimo').addClass('active');

    $.fn.inputFilter = function(inputFilter) {
        return this.on("input keydown keyup mousedown mouseup select contextmenu drop", function() {
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

    $('.btn-open-modal').click(function () {               //open testemunhas pop-up
        $('#nomeCompleto-error').remove();
        $('#'+$(this).attr('data-modal')).modal({
            show:true, backdrop: "static"
        })
    });

    $('#btn-select-cliente').click(function () {
        clienteSelecionado = $('#clienteSelecionado option:selected').text();
        clienteSelecionadoID = $('#clienteSelecionado').val();
        $('#idCliente').val(clienteSelecionadoID);                          //guarda id do cliente selecionado no hidden input
        $('#nomeCompleto').val(clienteSelecionado);                         //poe o nome do cliente selecionado no input
        $('#nomeCompleto').prop('readOnly',true);                           //desabilita campo
        // for(i=0;i<2;i++){$('.actions ul li:nth-child(2) a').trigger('click');}
        $('#modal-cliente').modal('toggle');
        // $('#fieldset-cliente > .fieldset-content > input').prop('readOnly',true);
        $('#nomeCompleto').trigger('propertychange');                       //dispara para aparecer btn-clear
        getClienteDados(clienteSelecionadoID)
    });

    function getClienteDados(id){
        $.ajax({
            method: 'POST',
            url: '/cliente/getClienteDados', //metodo na controller
            data: {'id': id},
            success: function (cliente) {
                $('#nomeConjuge').val(cliente.nomeConjuge);
                $('#nrDocumento').val(cliente.nrDocumento);
                $('#localEmissao').val(cliente.localEmissao);
                $("#dataEmissao").val(formatDataHojeESeguinte(new Date(cliente.dataEmissao),0));
                $('#dataValidade').val(formatDataHojeESeguinte(new Date(cliente.dataValidade),0));
                $('#nrDependentes').val(cliente.nrDependentes);
                $('#nrFihos').val(cliente.nrFilhos);
                $('#tipoContrato').val(cliente.tipoContrato);
                $('#anoAdmissao').val(cliente.anoAdmissao);

                /*contacto e endereco*/
                $('#contacto1').val(cliente.contacto1);
                $('#contacto2').val(cliente.contacto2);
                $('#email').val(cliente.email);
                $('#endereco').val(cliente.endereco);
                $('#amplitude').val(cliente.amplitude);
                $('#longitude').val(cliente.longitude);
            }
        });
    }

    $('#nomeCompleto').on('input propertychange',function () {
        var visible = Boolean($(this).val());
        $(this).siblings('#clear-nomeCompleto').toggleClass('hidden', !visible);
    }).trigger('propertychange');

    $('#clear-nomeCompleto').click(function () {
        $(this).siblings('input[type="text"]').val('').trigger('propertychange').focus();   //limpa o testo

        if(parseInt($('#idCliente').val()) !== 0){                                      //quando ja foi selecionado um cliente antes
            $('#idCliente').val(0);                                                     //esvazia o input id do cliente, pondo (0)
            $('#fieldset-cliente :input').val("");                                      //limpa todos inputs na sessao de dados do cliente
            $('#fieldset-cliente .data-hoje').val(formatDataHojeESeguinte(new Date(),0));
            $('#fieldset-cont-endereco-cliente :input').val("");                        //limpa todos inputs na sessao de contacto e endereco
            $('#fieldset-cont-endereco-cliente :text').val("");                         //limpa textarea
            $('#nomeCompleto').removeAttr('readOnly');                                  //abilita o input
        }
    });

    $('#dataInicioPagamento').val(formatDataHojeESeguinte(new Date(),1));
    $('.data-hoje').val(formatDataHojeESeguinte(new Date(),0));

    function formatDataHojeESeguinte(date,i) {
        var day = date.getDate()+i;     //dia
        monthIndex = null;
        if(date.getMonth() < 9){
            monthIndex = '0'+parseInt(date.getMonth()+1);  // mes corrente 0=Janeiro, 1=Fereveiro
        }else{
            monthIndex = date.getMonth()+1;
        }
        if(date.getDate()+i < 9){
            day = '0'+day
        }
        var year = date.getFullYear();
        return year + '-' + monthIndex + '-' + day;
    }


    $('#tabelaTestemunha').SetEditable({ $addButton: $('#but_add')}); //habilita tabela de testemunhas para que seja editevel

    $('#but_add').click(function () {
        var rowCount = $('#tabelaTestemunha >tbody >tr').length;
        if(rowCount === 1){
            $('#bEdit').trigger('click');
        }
    });

    $('#btn-saveTestemunhas').click(function () {
        var myRows = [];
        var headersText = [];
        var $headers = $("th");

        $("#tabelaTestemunha tbody tr").each(function(index) {
            $cells = $(this).find("td:not(:last-child)");           //excluiu a ulmina coluna prk contem buttons
            myRows[index] = {};
            $cells.each(function(cellIndex) {
                if(headersText[cellIndex] === undefined) { // Set the header text
                    headersText[cellIndex] = $($headers[cellIndex]).text();
                }
                myRows[index][headersText[cellIndex]] = $(this).text();
            });
        });
        accaobtnTestemuna(myRows)
    });

    function accaobtnTestemuna(myRows){
        var rowCount = $('#tabelaTestemunha >tbody >tr').length;
        if(rowCount >=1) {
            $('#testemunhas').val(JSON.stringify(myRows)); //prenche o input de testemunhas com dados da tabela no formato JSON
            $('#btn-testemunhas').css({"background-color": "#00a65a","color":"white"});
            $('#btn-testemunhas span').html(rowCount);
        }else{
            $('#btn-testemunhas').css({"background-color": "wheat","color":"black"});
            $('#btn-testemunhas span').html(null);
        }
    }

    /*buscar distritos de uma determinada provincia*/
    $('.provincia').on('change',function () {
        var provinciaId = $(this).val();
        var div = $(this).attr('data-div');
        $.ajax({
            method: 'POST',
            url: 'getDistrito', //metodo na controller
            data: {'id': provinciaId},
            success: function (data) {
                $('#'+div).html(data); //renderiza combo de distritos
                $('select').selectpicker();
            }
        });
    });
    $('.provincia').val($('.provincia').first().val()).trigger('change'); //prenche combo de distritos ao abrir a pagina

    /*credito em outras instituicoes e conta bancaria*/
    $('.form-check').on('ifChanged',function () {
        var value = $(this).iCheck('update')[0].checked; //verica o check se esta selecioonado ou nao e retorna o valor[true|false]
        $("#"+$(this).attr('data-id')).val(value); //poe o valor no input boolean
        if(value){
            $("#"+$(this).attr('data-input')).removeAttr('readonly'); //habilita input
            $("#"+$(this).attr('data-input')).prop('required',true) //habilita input
        }else{
            $("#"+$(this).attr('data-input')).prop('readonly',true); //desabiita input
            $("#"+$(this).attr('data-input')).removeAttr('required'); //desabiita input
            $("#"+$(this).attr('data-input')).val('')               //limpa campo
        }
    });
    $('.form-check').trigger('ifChanged'); //inicializar os checks

    $('.input-valor').on('input',function () {
        calculoValorApagar()
    });

    $("#valorPedido").inputFilter(function(value) {
        calculoValorApagar();
        return /^\d*$/.test(value) && (value === "" || value.length <= 20);
    });
    $("#taxaJuros").inputFilter(function(value) {
        calculoValorApagar();
        return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
    });
    $('#taxaMulta').inputFilter(function(value) {
        return /^\d*$/.test(value) && (value === "" || parseInt(value) <= 100);
    });
    $('#taxaConcessao').inputFilter(function(value) {
        return /^\d*$/.test(value) && (value === "" || value.length <= 20);
    });

    function calculoValorApagar() {
        valorPedido = $('#valorPedido').val();
        percent = $('#taxaJuros').val()/100; // valor em percentagem
        if(valorPedido === ''){
            $('#valorApagar').val("");
            $('#valorPorPrestacao').val("");
            return
        }
        valorApagar = parseFloat(valorPedido)+ parseFloat(valorPedido*percent); // calculo de valor total a pagar
        $('#valorApagar').val(valorApagar.toFixed(2));

        nrPrestacoes = $('#nrPrestacoes').val();
        valorPorPrestacao = valorApagar/nrPrestacoes;                //caculo de valor a pagar por prestacao
        $('#valorPorPrestacao').val(valorPorPrestacao.toFixed(2))    //formatacao de valor
    }

    $('#modoPagamento').on('change',function () {
        modoPagamento = $(this).val();                         //get value of modaidadadepagamento input
        nrPrestacoesElement = $('#nrPrestacoes');
        if(modoPagamento === 'Diaria'){                    //prestacao diaria
            nrPrestacoesElement.attr({"min":1,"max":13});
            nrPrestacoesElement.val(1);
            nrPrestacoesElement.removeAttr('readOnly');
            minimo = 1; maximo =13
        }else if(modoPagamento === 'Semanal'){             //prestacao semanal
            nrPrestacoesElement.attr({"min":3, "max":4});
            nrPrestacoesElement.val(3);
            minimo = 3; maximo =4;
            nrPrestacoesElement.removeAttr('readOnly');
        }else {                                         //prestacao mensal
            nrPrestacoesElement.val(1);
            minimo = 1; maximo = 6;
        }
        nrPrestacoesElement.inputFilter(function(value) {
            return /^\d*$/.test(value) && (value === "" || (parseInt(value) <= maximo && parseInt(value) >=minimo ))
        });

        calculoValorApagar();
    });
    $('#modoPagamento').val($('#modoPagamento').val()).trigger('change'); //prenche combo de distritos ao abrir a pagina

    $('#signup-form').submit(function () {
        event.preventDefault();
        var form_data = new FormData(this);                         //pega todos valores[inputs] no form
        var nrGarantias = parseInt($('#nrGarantias').val());      //busca nr de garantia k pretende-se salvar
        for(var id=1; id < nrGarantias+1; id++){
            var inputFile = $("#file-"+id).prop("files")[0];
            form_data.append("foto"+id, inputFile);
        }
        swal({
            title: "Salvar?",
            imageUrl: "../../assets/question.png",
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
                success: function(data){
                    // $('#div-avalista').html(data);
                    setTimeout(function () {
                        swal({
                            title: "Certo!",
                            text: "Emprestimo Salvo com Sucesso!",
                            timer: 2500,
                            type:  "success",
                            showConfirmButton: false
                        });
                        $('#nomeCompleto').removeAttr('readOnly');
                        $('#dataInicioPagamento').val(formatDataHojeESeguinte(new Date(),1));
                        $('.data-hoje').val(formatDataHojeESeguinte(new Date(),0));
                        //
                        for (var r=1; r < 4; r++) {
                            $('.actions ul li:first-child a').trigger('click');     // clicks no btn previous
                        }

                        for(var d=1; d < parseInt($('#nrGarantias').val())+1; d++){
                            $('#box-garantia-'+d).remove();                     //remove o box de garantia usando id da div mae
                            // document.getElementById("file"-d).value = "";           //faz reset de inputs files
                        }

                        $('#signup-form').trigger('reset');
                        $('#fieldset-cliente .data-hoje').val(formatDataHojeESeguinte(new Date(),0));
                        $('#tabelaTestemunha >tbody >tr').remove();              //limpa tabela de testemuhas
                        accaobtnTestemuna();
                        appendGarantia();
                    }, 2000);
                },
                error: function () {
                    swal("Erro", "Ocorreu algum erro ao salvar Emprestimo", "error");
                }
            });
        });
    });

    /*Funcao que adiciona div de nova garantia*/
    function appendGarantia(){
        index = $('.box-garantia').length+1;        //conta divs de garantia que ja existem
        // if(index === 4) return;                         //apenas so aceita 3 divs de garantia
        $.ajax({
            method: 'POST',
            url: 'addGarantiaForm',
            data: {'index':index},
            success: function (data) {
                $('#div-garantias').append(data);
                // $('#btn-remove-1').remove()         //desabilita/apaga button de remover box-garantia
            }
        });
        $('#nrGarantias').val(index);
    }

    appendGarantia();                                            //adiciona primeira div de garantia na inicializacao
    $(".input-valor-garantia").inputFilter(function(value) {
        return /^\d*$/.test(value) && (value === "" || value.length <= 20);
    });

    $(document).on('click','.btn-add-garantia',function () {
        appendGarantia() //adicona outra div de garantia
    });

    $(document).on('change','.input-upload',function () {       //acao de input file depois de selecioonar o file
        labelUpload =  $('#label-'+$(this).attr('id'));
        if ($(this).get(0).files.length === 0) {
            labelUpload.html('Foto');     //caso nao selecionar um file
            labelUpload.prop('title','Carregar Foto');
            labelUpload.removeClass('btn-success');
            labelUpload.addClass('btn-primary');
        }else{
            fileName = $(this).val().split('\\');
            labelUpload.html('&nbsp;'+fileName[fileName.length-1].substr(0, 20)); //poe o nome do selected file na label e limita o string em 30 characters
            labelUpload.prop('title','Foto Carregada: '+fileName[fileName.length-1]);
            labelUpload.removeClass('btn-primary');
            labelUpload.addClass('btn-success');
            labelUpload.prepend('<i class="fa fa-check"></i>')
        }
    });

    $(".contacto").inputFilter(function(value) {
        return /^\d*$/.test(value) && (value === "" || value.length <= 9)
    });

    $('.anoAdmissao').inputFilter(function(value) {
        return /^\d*$/.test(value) && (value === "" || parseInt(value) <= new Date().getFullYear())
    });

    /*Remocao de label de erro*/
    $('input').on('focusin', function () {
        $('#'+$(this).attr('id')+'-error').remove();
    });

    //Avalista
    $(document).on('click','#btn-add-avalista',function () {
        $('#modal-avalista').modal({
            show:true, backdrop: "static"
        })
    });

    $(document).on('click',"#btn-clean-alavista",function () {
        $('#avalista').val($('#avalista option:first').val()).trigger('change');
    });

    $('#avalista').on('change',function () {                    //combo avalista
        var visible = Boolean($(this).val());
        $(this).siblings('#clear-avalista').toggleClass('hidden', !visible);
    }).trigger('propertychange');

    $('#clear-avalista').click(function () {
        // $(this).siblings('input[type="text"]').val('').trigger('propertychange').focus();   //limpa o testo
        $('#avalista').val($('#avalista option:first').val()).trigger('change');
    });

    $('#btn-cancel-avalista').click(function () {
        $('#form-avalista').trigger('reset')
    });
    $('#btn-save-avalista').click(function () {
        $('#form-avalista').trigger('submit')
    });

    $('.estado-civil').on('change',function () {
        // estadoCivil = $('#estadoCivil option:selected').text();
        estadoCivil = $(this).children('option').filter(':selected').text();
        conjogue =  $(this).attr('data-conjuge');
        if(estadoCivil === "Casado"){
            $('#'+conjogue).prop('required',true)
        }else{
            $('#'+conjogue+'-error').remove();
            $('#'+conjogue).removeAttr('required')
        }
    });

});