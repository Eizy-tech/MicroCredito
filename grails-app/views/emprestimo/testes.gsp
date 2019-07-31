$('#btnPagar').click(function () {
        swal({
            title: ""Confirmar o pagamento de "+$('#totaPagar').val()+" MT?"",
            imageUrl: "../../assets/question.png",
            showCancelButton: true,
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function () {
            $.ajax({
                url: "${g.createLink( controller: 'prestacao', action:'pagamentos')}",
                contentType:'application/json',
                type: "POST",
                data: JSON.stringify(pagamentoPrestacoes),
                success: function(data) {
                    setTimeout(function () {
                        swal({
                            title: "Certo!",
                            text: "Pagamento Efectuado com Sucesso!",
                            timer: 2500,
                            type:  "success",
                            showConfirmButton: false
                        });
                    }, 2000);
                    if($('#span_aux').attr('valor')){
                        alert("Parabens, liquidou todas dividas!")
                    }else{
                        $('#'+lastBtnlist).trigger('click');
                    };
               },
               error: function () {
                   swal("Erro", "Ocorreu algum erro ao efectuar pagamento", "error");
               }
            });
        });
 });


alert("Salvo!");
                    if($('#span_aux').attr('valor')){
                        alert("Parabens, liquidou todas dividas!")
                    }else{
                        $('#'+lastBtnlist).trigger('click');
                    }