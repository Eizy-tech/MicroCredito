$('#btn-cancelar-parcela-capital').click(// Accao de cancelamento de parcela
    function (){
        $('#valor-parcela-capital').html('0.00');//Actualizacao do valor da parcela na tabela para zero
        $('#observacao-parcela-capital-modal').attr('value',"");
        $('#check-box-capital')[0].checked = false;
        $('#check-box-capital').removeAttr('disabled');

        var flag = true;//O botao pagar deve ser desabilitado

        $('.checkbox').each(function(){
            if (this.checked){
                flag = false;//O botao pagar nao deve ser desabilitado
            }
        });

        if (flag) {
            $('#btnPagar').prop('disabled', true);
        }

        //Actualizar o valor a pagar
        var valorParcc = +$('#valor-parcela-capital').attr('valor-parcela');
        total = +(+total - valorParcc);//
        $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
        $('#totaPagar').attr('value', +total)//Actualizacao do total a pagar

        // if ($('.checkbox:checked').length != $('.checkbox').length ){
        $("#select_all")[0].checked = false; //change "select all" checked status to true
        // }
        actualizarArray();
    }
);

// $('.btn-parcela').click(function () {               //open Modal de parcelamento pop-up
//     referenciaPrestacao = $(this).attr('referencia');
//     var valorParcelaActual = $('#parcela'+referenciaPrestacao).text();
//
//     if (valorParcelaActual){
//         // alert($('#valor-parcela').val()+"-----"+valorParcelaActual);
//         $('#valor-parcela').attr('value',valorParcelaActual);
//         // alert($('#valor-parcela').val());
//     }else {
//         $('#valor-parcela').attr('value',"0.00");
//     }
// });