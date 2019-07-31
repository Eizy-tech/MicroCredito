<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}"/>
    <title><g:message code="default.create.label" args="[entityName]"/></title>
</head>

<body>
<div class="box box-primary direct-chat direct-chat-success">
    <div class="box-header with-border" style="background-color: #ecf0f5">
        <h3 class="box-title"><i class="fa fa-pen"></i>&nbsp;<strong>Utilizador</strong></h3>
    </div>

    <div class="box-body" style="padding: 8px; background-color: #fff">

        <div class="row">
            <div class="col-lg-2"></div>

            <div class="col-lg-8">
                <div class="box box-info">
                    <div class="box-header">
                        <i class="fa fa-pen"></i>

                        <h3 class="box-title">Registar Utilizador</h3>
                    </div>

                    <div class="box-body">
                        <form class="form-horizontal pr-2" id="form_create" autocomplete="off">
                            <br>
                            <br>

                            <div class="row mb-4">
                                <div class="col-lg-6">
                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="nomeCompleto" class="form-label">Nome Completo:</label>
                                        <input type="text" class="form-control" id="nomeCompleto" name="nomeCompleto"
                                               value="${user.nome}" required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="contacto1" class="form-label">Contacto Principal:</label>
                                        <input type="text" class="form-control" id="contacto1" name="contacto1"
                                               required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="contacto2" class="form-label">Contacto Opcional:</label>
                                        <input type="text" class="form-control" id="contacto2" name="contacto2">
                                    </div>

                                    %{--<div class="input-group mb-3" style="width: 100%">--}%
                                    %{--<label for="perfil" class="form-label">Perfil</label>--}%

                                    %{--<g:select id="perfil" name="perfil" optionKey="id"  optionValue="designacao"--}%
                                    %{--from="${perfilList}" class="form-control select"--}%
                                    %{--/>--}%
                                    %{--</div>--}%
                                </div>

                                <div class="col-lg-6">
                                    <div class="input-group mb-3" style=" width: 100%">
                                        <label for="username" class="form-label">Username:</label>
                                        <input type="text" class="form-control" id="username" name="username" required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="password" class="form-label">Password:</label>
                                        <input type="password" class="form-control password" id="password"
                                               name="password" required>
                                    </div>

                                    <div class="input-group mb-3" style="width: 100%">
                                        <label for="password-confirm" class="form-label">Confirma Password:</label>
                                        <input type="password" class="form-control password" id="password-confirm"
                                               name="password-confirm" required>
                                    </div>
                                </div>
                            </div>
                            <hr style="border: #ccc 1px solid">
                            <br>
                            <div class="row mb-4">
                                <div class="col-lg-6 pull-right rig">
                                    <button type="button" id="btn-cancelar"
                                            class="btn btn-warning col-lg-5 mr-5">Cancelar</button>
                                    <button class="btn btn-success col-lg-5 pull-right" id="btn-salvar" type="submit"
                                            disabled><i class="fa fa-save"></i>&nbsp;Salvar</button>
                                </div>
                            </div>
                        </form>
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

        $('#caminho').append('<li><a><g:link action="index">Utilizadores</g:link>  </a></li>');
        $('#caminho').append('<li><a><g:link action="create">Novo</g:link>  </a></li>');

        $('#password-confirm').on('input', function () {
            password = $('#password').val();
            passwordConfirm = $(this).val();

            if (password === passwordConfirm) {
                $('#btn-salvar').removeAttr('disabled');
            } else {
                $('#btn-salvar').prop('disabled', true);
            }
        });

        $('#btn-cancelar').click(function () {
            window.location.reload();
        });

        $('#form_create').submit(function () {
            event.preventDefault();
            var form_data = new FormData(this);                         //pega todos valores[inputs] no form
            swal({
                title: "Salvar?",
                imageUrl: "../assets/question.png",
                showCancelButton: true,
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function () {
                $.ajax({
                    url: "${g.createLink( controller: 'user', action:'salvarUser')}",
                    dataType: 'text',
                    cache: false,
                    contentType: false,
                    processData: false,
                    data: form_data,
                    type: 'POST',
                    success: function (data) {
                        var json = JSON.parse(data);
                        if (json['msg'] === 'existe') {
                            swal("Erro!", "Ja exsite um usuario com esse username!", "warning");
                        } else {
                            setTimeout(function () {
                                swal({
                                    title: "Certo!",
                                    text: "Usuario Salvo com Sucesso!",
                                    timer: 2500,
                                    type: "success",
                                    showConfirmButton: false
                                });

                                setInterval(function () {
                                    window.location.reload();
                                }, 1000);
                            }, 2000);
                        }
                    },
                    error: function (data) {
                        swal("Erro", "Ocorreu algum erro ao salvar Emprestimo \n" + data.msg, "error");
                    }
                });
            });
        });
    })
</script>
<script>
    $(document).ready(function () {
        $('#li_sistema').addClass('active');
        $('#li_list_users').addClass('active');
    });
</script>
</body>
</html>