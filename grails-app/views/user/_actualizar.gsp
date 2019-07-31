
<div class="box box-success">
    <div class="box-header with-border" style="background-color: #ecf0f5">
        <h3 class="box-title"><strong>Informar novos Dados:</strong></h3>
    </div>
    <!-- /.box-header -->
    <!-- form start -->
    <div class="box-body row">
        <div class="col-md-4" style="text-align: right; padding-top: 8px">
            <p><label for="nomeCompleto" class="control-label" style="margin-top: 8px">NOME COMPLETO:</label></p>
            <p><label for="username" class="control-label" style="margin-top: 8px">USERNAME:</label></p>
            <p><label for="contacto1" class="control-label" style="margin-top: 8px">COMTACTO PRINCIPAL:</label></p>
            <p><label for="contacto2" class="control-label" style="margin-top: 8px">COMTACTO OPCIONAL:</label></p>
            <p><label for="password" class="control-label" style="margin-top: 8px">NOVA PASSWORD:</label></p>
            <p><label for="password-confirm" class="control-label" style="margin-top: 8px">CONFIRMA PASSWORD:</label></p>
        </div>
        <div class="col-md-8">
            <p><input type="text" class="form-control" id="nomeCompleto" name="nomeCompleto" value="${user.nome}"></p>
            <p><input type="text" class="form-control" id="username" name="username" value="${user.username}"></p>
            <p><input type="text" class="form-control" id="contacto1" name="contacto1" value="${user.contacto1}"></p>
            <p><input type="text" class="form-control" id="contacto2" name="contacto2" value="${user.contacto1}"></p>
            <p><input type="password" class="form-control" id="password" name="password"></p>
            <p><input type="password" class="form-control" id="password-confirm" name="password-confirm"></p>
        </div>
    </div>
    <!-- /.box-body -->
    <div class="box-footer">
        <button id="btn-cancelar" class="btn btn-primary  btn-flat">Cancelar</button>
        <button class="btn btn-success btn-flat pull-right" id="btn-actualizar">Submeter</button>
    </div>
        <!-- /.box-footer -->
</div>

<script>
    var parametros = [];

    $('#btn-cancelar').click(
        function () {
            $('#formulario').html('');
        }
    );

    $('#btn-actualizar').click(function () {
        parametros.push($('#nomeCompleto').val());
        parametros.push($('#username').val());
        parametros.push($('#contacto1').val());
        parametros.push($('#contacto2').val());
        parametros.push($('#password').val());
        if ($('#password').val() === $('#password-confirm').val()) {
            swal(
                {
                    title: "Confirmar actualizacao de perfil?",
                    imageUrl: "../assets/question.png",
                    showCancelButton: true,
                    closeOnConfirm: false,
                    showLoaderOnConfirm: true
                }, function () {
                    $.ajax({
                        url: "${g.createLink( controller: 'user', action:'actualizarPerfil')}",
                        contentType: 'application/json',
                        type: "POST",
                        data: JSON.stringify(parametros),
                        success: function (data) {
                            setTimeout(function () {
                                swal({
                                    title: "Certo!",
                                    text: "Perfil actualizado com Sucesso!",
                                    timer: 2500,
                                    type: "success",
                                    showConfirmButton: false
                                });
                            }, 1000);
                        },
                        error: function () {
                            swal("Erro", "Ocorreu algum erro ao actualizar perfil", "error");
                        }
                    });
                });
        }else {
            alert("As Passwords nao batem, tente novamente");
        }
    });
</script>


