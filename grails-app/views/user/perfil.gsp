<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main"/>
    <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}"/>
    <title><g:message code="default.show.label" args="[entityName]"/></title>
</head>

<body>
<!-- Main content -->
<section class="content">
    <div class="row">
        <div class="col-md-3">
            <div class="box box-primary">
                <div class="box-body box-profile" style="background-color: white">
                    <asset:image src="avatar.png" class="profile-user-img img-responsive img-circle" id="foto-aluno"/>
                    <p class="profile-username text-center">${user.nome}</p>

                    <p class="text-muted text-center">${user.perfil.designacao}</p>
                    <ul class="list-group list-group-unbordered mb-3">
                        <li class="list-group-item">
                            <b>Nome:</b> <a class="pull-right">${user.nome}</a>
                        </li>
                        <li class="list-group-item">
                            <b>Username:</b> <a class="pull-right">${user.username}</a>
                        </li>
                        <li class="list-group-item">
                            <b>Contacto Principal:</b> <a class="pull-right">${user.contacto1}</a>
                        </li>
                        <li class="list-group-item">
                            <b>Contacto Opcional:</b> <a class="pull-right">${user.contacto2}</a>
                        </li>
                    </ul>
                    <button id="btn-Editar" class="btn btn-primary btn-block mb-3"><b>Editar Dados</b></button>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="active"><a href="#settings" data-toggle="tab">Informar Novos Dados</a></li>
                </ul>

                <div class="tab-content">
                    <div class="tab-pane active" id="settings">
                        <form class="form-horizontal pr-2" id="form_update">
                            <br>
                            <br>

                            <div class="row mb-4">
                                <div class="col-lg-6">
                                    <label for="nomeCompleto" class="form-label">Nome Completo:</label>
                                    <input type="text" class="form-control" id="nomeCompleto" name="nomeCompleto"
                                           value="${user.nome}" readonly>
                                </div>

                                <div class="col-lg-6">
                                    <label for="username" class="form-label">Username:</label>
                                    <input type="text" class="form-control" id="username" name="username"
                                           value="${user.username}" readonly>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-lg-6">
                                    <label for="contacto1" class="form-label">Contacto Principal:</label>
                                    <input type="text" class="form-control" id="contacto1" name="contacto1"
                                           value="${user.contacto1}" readonly>
                                </div>

                                <div class="col-lg-6">
                                    <label for="contacto2" class="form-label">Contacto Opcional:</label>
                                    <input type="text" class="form-control" id="contacto2" name="contacto2"
                                           value="${user.contacto1}" readonly>
                                </div>
                            </div>

                            <div class="row mb-4">
                                <div class="col-lg-6">
                                    <label for="password" class="form-label">Nova Password:</label>
                                    <input type="password" class="form-control password" id="password" name="password"
                                           readonly>
                                </div>

                                <div class="col-lg-6">
                                    <label for="password-confirm" class="form-label">Confirma Password:</label>
                                    <input type="password" class="form-control password" id="password-confirm"
                                           name="password-confirm" readonly>
                                </div>
                            </div>
                            <hr style="border: #ccc 1px solid">
                            <br>

                            <div class="row mb-4">
                                <div class="col-lg-6 pull-right rig">
                                    <button type="button" id="btn-cancelar"
                                            class="btn btn-warning col-lg-5 mr-5">Cancelar</button>
                                    <button class="btn btn-success col-lg-5 pull-right" id="btn-actualizar"
                                            disabled>Submeter</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<!-- jQuery 3 -->
<asset:javascript src="jquery-3.3.1.slim.min.js"/>
<script>
    $(document).ready(function () {
        var parametros = [];

        $('#form_update').submit(function (e) {
            e.preventDefault();
            parametros.push($('#nomeCompleto').val());
            parametros.push($('#username').val());
            parametros.push($('#contacto1').val());
            parametros.push($('#contacto2').val());
            parametros.push($('#password').val());
            swal({
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
                        window.location = '<g:createLink controller="logout" action="index"/>';
                    },
                    error: function () {
                        swal("Erro", "Ocorreu algum erro ao actualizar perfil", "error");
                    }
                });
            });
        });

        $('#btn-Editar').click(function () {
            $('input').removeAttr('readonly')
            $('#btn-actualizar').removeAttr('disabled')
        });

        $('#btn-cancelar').click(function () {
            $('input').prop('readonly', 'true')
        });

        $('.password').on('input', function () {
            pass = $('#password').val();
            pass_ver = $('#password-confirm').val();
            // return (pass===pass_ver)? $('#btn-actualizar').removeAttr('disabled'):$('#btn-actualizar').prop('disabled','true')
        })
    });
</script>
<script>
    $(document).ready(function () {
        // $('#li_sistema').addClass('active');
    });
</script>
</body>
</html>
