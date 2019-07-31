$('.btn-cancela_parcela').click(// Accao de cancelamento de parcela
    function (){
        var referenciaPrestacao = $(this).attr('referencia');
        $('#valor-parcela'+referenciaPrestacao).html('0.00');//Actualizacao do valor da parcela na tabela para zero
        $('#observacao'+referenciaPrestacao).attr('value',"");
        $('#check-box'+referenciaPrestacao)[0].checked = false;
        $('#check-box'+referenciaPrestacao).removeAttr('disabled');

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
            var valorParc = +$('#valor-parcela'+referenciaPrestacao).attr('valor-parcela');
            total = +(+total - valorParc);//
            $('#totaPagar').attr('value', '')//Actualizacao do total a pagar
            $('#totaPagar').attr('value', +total)//Actualizacao do total a pagar

        // if ($('.checkbox:checked').length != $('.checkbox').length ){
            $("#select_all")[0].checked = false; //change "select all" checked status to true
        // }
        actualizarArray();
    }
);

// $('.btn-parcela').click(function () {               //open Modal de parcelamento pop-up
//         referenciaPrestacao = $(this).attr('referencia');
//         var valorParcelaActual = $('#parcela'+referenciaPrestacao).text();
//
//         if (valorParcelaActual){
//                 // alert($('#valor-parcela').val()+"-----"+valorParcelaActual);
//                 $('#valor-parcela').attr('value',valorParcelaActual);
//                 // alert($('#valor-parcela').val());
//         }else {
//                 $('#valor-parcela').attr('value',"0.00");
//         }
// });