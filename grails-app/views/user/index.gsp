<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'user.label', default: 'User')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="box box-primary" style="padding: 10px; font-size: 14px; align-content: center">
            <div class="">
                <div class="box box-success">
                    <div class="box-header with-border" style="background-color: #ecf0f5">
                        <h3 class="box-title"><i class="fa fa-list"></i><strong>&nbsp;Lista de Utilizadores</strong></h3>
                    </div>
                    <div class="box-body">
                        <table class="table myTable table-bordered table-striped">
                            <thead class="thead-light" style="background-color: #00a65a0d">
                                <tr class="myHead">
                                    <th scope="col">Nome Completo</th>
                                    <th scope="col">UserName</th>
                                    <th scope="col">Contacto Principal</th>
                                    <th scope="col">Contacto Opcional</th>
                                    <th scope="col">Perfil</th>
                                    <th scope="col">Estado</th>
                                    <th scope="col">Accoes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <g:each in="${userList}" var="user">
                                    <g:if test="${user.perfil.id != 1}">
                                        <tr>
                                            <td>${user.nome}</td>
                                            <td>${user.username}</td>
                                            <td>${user.contacto1}</td>
                                            <td>${user.contacto2}</td>
                                            <td>${user.perfil.designacao}</td>
                                            <g:if test="${user.enabled == true}">
                                                <td style="color: green; font-weight: bold">Activo</td>
                                            </g:if>
                                            <g:if test="${user.enabled == false}">
                                                <td style="color: red; font-weight: bold">Bloqueado</td>
                                            </g:if>

                                            <td style="">
                                                <g:if test="${user.enabled == true}">
                                                    <button id="" data-id="${user.id}" class="btn btn-danger btn-sm btn-bloquear"><i class="fa fa-close"></i>&nbsp;Bloquear</button>
                                                </g:if>
                                                <g:if test="${user.enabled == false}">
                                                    <button id="" data-id="${user.id}" class="btn btn-primary btn-sm btn-desbloquear"><i class="fa fa-check"></i>&nbsp;Desbloquear</button>
                                                </g:if>
                                            </td>
                                        </tr>
                                    </g:if>
                                </g:each>
                            </tbody>
                            <tfoot>

                            </tfoot>
                        </table>
                    </div>
                    <div class="box-footer">
                        <g:link class="btn btn-success pull-right" action="create"><i class="fa fa-pen"></i>&nbsp;Novo</g:link>
                    </div>
                </div>
            </div>
        </div>

    <asset:javascript src="jquery-3.3.1.slim.min.js"/>
    %{--<asset:javascript src="bootstrap.min.js"/>--}%
    <script type="text/javascript">
        $(document).ready(function () {
            $('#caminho').append('<li><a><g:link action="index">Utilizadores</g:link>  </a></li>');
            $('.btn-bloquear').on('click',function () {
                var id = $(this).attr('data-id');
                swal({
                    title: "Desejas bloquear esse utilizador?",
                    imageUrl: "../assets/question.png",
                    showCancelButton: true,
                    closeOnConfirm: false,
                    showLoaderOnConfirm: true
                }, function () {
                    $.ajax({
                        url: "${g.createLink( controller: 'user', action:'bloquear')}",
                        type: "POST",
                        data: {'id':id},
                        success: function (data) {
                            setTimeout(function () {
                                swal({
                                    title: "Certo!",
                                    text: "Utilizador bloqueado com Sucesso!",
                                    timer: 2500,
                                    type: "success",
                                    showConfirmButton: false
                                });
                                setInterval(function () {
                                    location.reload();
                                }, 1000)
                            }, 2000);
                        },
                        error: function () {
                            swal("Erro", "Ocorreu algum erro ao bloquear utilizador", "error");
                        }
                    });
                });
            });


            $('.btn-desbloquear').on('click',function () {
                var id = $(this).attr('data-id');
                swal({
                    title: "Desejas bloquear esse utilizador?",
                    imageUrl: "../assets/question.png",
                    showCancelButton: true,
                    closeOnConfirm: false,
                    showLoaderOnConfirm: true
                }, function () {
                    $.ajax({
                        url: "${g.createLink( controller: 'user', action:'desbloquear')}",
                        type: "POST",
                        data: {'id':id},
                        success: function (data) {
                            setTimeout(function () {
                                swal({
                                    title: "Certo!",
                                    text: "Utilizador desbloqueado com Sucesso!",
                                    timer: 2500,
                                    type: "success",
                                    showConfirmButton: false
                                });
                                setInterval(function () {
                                    location.reload();
                                }, 1000)
                            }, 2000);
                        },
                        error: function () {
                            swal("Erro", "Ocorreu algum erro ao desbloquear utilizador", "error");
                        }
                    });
                });
            })
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