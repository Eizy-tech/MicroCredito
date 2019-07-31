<%@ page import="microcredito.UserDetailService" %>
<%
    def userDetailService = grailsApplication.classLoader.loadClass('microcredito.UserDetailService').newInstance()
%>
<table class="table table-bordered text-center table-striped" style="border: 2px; margin-bottom: 0px">
    <thead class="thead-light" style="background-color: #00a65a0d">
    <tr>
        <th style="text-align: left">ID Cliente</th>
        <th style="text-align: left">Nome do Cliente</th>
        <th>Estado</th>
        <th>Data de Registo</th>
        <th style="text-align: left">Reistado Por:</th>
        %{--<sec:ifLoggedIn>--}%
            %{--<g:if test="${userDetailService.user(user).perfil.id[0]==1}">--}%
        <th>Accoes</th>
            %{--</g:if>--}%
        %{--</sec:ifLoggedIn>--}%
    </tr>
    </thead>
    <tbody>
    <g:each in="${clienteList}" var="cliente">
        <tr>
            <td style="text-align: left">${cliente.codigo}</td>
            <td style="text-align: left">${cliente.nome}</td>
            <g:if test="${cliente.estado == 'Activo'}">
                <td style="color: green; font-weight: bold">${cliente.estado}</td>
            </g:if>
            <g:else>
                <td style="color: red; font-weight: bold">${cliente.estado}</td>
            </g:else>
            <td><g:formatDate date="${cliente.dataRegisto}" format="dd MMM yyyy"/></td>
            <td style="text-align: left">${cliente.userRegisto.nome}</td>
            <td style="">
                <sec:ifLoggedIn>
                    <g:if test="${userPerfil == 1}">
                        <g:if test="${cliente.estado == 'Activo'}">
                            <button nome="${cliente.nome}" estado="1" id="btn-estado-${cliente.id}" id-cliente="${cliente.id}"
                                    class="btn btn-danger btn-sm estado-cliente">Bloquear</button>
                        </g:if>
                        <g:else>
                            <button nome="${cliente.nome}" estado="0" id="btn-estado-${cliente.id}" id-cliente="${cliente.id}"
                                    class="btn btn-success btn-sm estado-cliente">Activar</button>
                        </g:else>
                    </g:if>
                </sec:ifLoggedIn>

                <button class="btn btn-primary btn-sm cliente-dados" data-cliente-id="${cliente.id}"><i class="fa fa-info"></i>&nbsp;
                    Detalhes
                </button>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>

<div class="row" style="margin: 5px 0; padding: 0px">
    <div class="col-md-6" style="align-content: start">
        <g:if test="${filtro == true}">
            <div class="pagination dataTables_paginate paging_simple_numbers">
                <util:remotePaginate action="filtro" total="${clienteCount ?: 0}" update="lista" params="${params}"
                                     next="Proximo" prev="Anterior"/>
            </div>
        </g:if>

        <g:if test="${filtro == false}">
            <div class="pagination dataTables_paginate paging_simple_numbers">
                <g:paginate total="${clienteCount ?: 0}" next="Proximo" prev="Anterior"/>
            </div>
        </g:if>
    </div>
    %{--<div class="col-md-6" style="align-content: end; padding-top: 15px">--}%
    <div class="col-md-6" style="align-content: end">
        <div class="pagination dataTables_paginate paging_simple_numbers pull-right">
            <a href="#" class="step pull-right"
               style="background-color: #008d4c; color: #fff">Total de Registros = ${clienteCount}</a>
        </div>
    </div>
</div>

<div class="modal fade" id="modal-detalhes-cliente">
</div>

%{--Mudanca do estado--}%
<script>
    $(document).on('click', '.estado-cliente', function () {
        var estado = +$(this).attr('estado');
        var idCliente = $(this).attr('id-cliente');
        var dados = [];
        var nomeCli = $(this).attr('nome');
        // alert(idCliente+'-'+nomeCli)
        dados.push(idCliente);
        dados.push(estado);

        var estadoInfo = '';
        var estadoInfo1 = '';

        if (estado == 1) {
            estadoInfo = 'o bloqueio';
            estadoInfo1 = 'bloqueado';
        } else {
            estadoInfo = 'a activacao';
            estadoInfo1 = 'activo';
        }
        swal({
            title: "Confirmar " + estadoInfo + " do/a cliente " + nomeCli + "?",
            imageUrl: "../assets/question.png",
            showCancelButton: true,
            closeOnConfirm: false,
            showLoaderOnConfirm: true
        }, function () {
            $.ajax({
                url: "${g.createLink( controller: 'cliente', action:'mudaEstadoCliente')}",
                contentType: 'application/json',
                type: "POST",
                data: JSON.stringify(dados),
                success: function (data) {
                    location.reload();
                    setTimeout(function () {
                        swal({
                            title: "Certo!",
                            text: "Cliente " + estadoInfo1 + " com Sucesso!",
                            timer: 2500,
                            type: "success",
                            showConfirmButton: false
                        });
                    }, 1000);
                },
                error: function () {
                    swal("Erro", "Ocorreu algum erro ao mudar estado do/a cliente.", "error");
                }
            });
        });

        // alert($(this).attr('estado')+'---'+$(this).attr('id'));
    });
</script>
<script>
    var nome = null;
    var estado = null;
    // var idUser = null;
    var dataRange1 = null;
    var dataRange2 = null;
</script>
<script>
    function filtrar() {
        // alert(dataRange1+'-'+dataRange2);
        estado = $('#estadoSlect').val();
        // idUser = $('#userSelect').val();
        nome = $('#search_field').val();
        <g:remoteFunction action="filtro" params="{'estado': estado, 'dataRange1': dataRange1, 'dataRange2': dataRange2, 'nome':nome}" update="lista"/>
        // $('#search_field').select2();
    }


    $(document).ready(function () {

        $('#li_clientes').addClass('active');
        $('#li_list_cliente').addClass('active');
        $('#btn-logout').trigger('click');

        %{--<g:link controller="logout" >Sair</g:link>--}%

        $(document).on('click', '.cliente-dados', function () {
            inscricaoID = $(this).attr('data-cliente-id');
            <g:remoteFunction action="getClienteDetalhes" params="{'id': inscricaoID}" update="modal-detalhes-cliente"/>
            $('#modal-detalhes-cliente').modal({
                show: true, backdrop: "static"
            })
        });

        // alert('');

        // $('#search_field').val($('#search_field option:last-child').val()).trigger('change');

        $(document).on('input', '#search_field', function () {
            filtrar()
            // alert('')
        })
    })
</script>
<script>
    $('.select_filtro').change(function () {
        filtrar();
    });
</script>

<script>
    $(function () {

        // //Date range as a button
        $('#daterange-btn').daterangepicker(
            {
                ranges: {
                    'Todos': [moment().subtract(73000, 'days'), moment().add(36500, 'days')],
                    'Hoje': [moment(), moment()],
                    'Ontem': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                    'Ultimos 7 dias': [moment().subtract(6, 'days'), moment()],
                    'Ultimos 30 dias': [moment().subtract(29, 'days'), moment()],
                    'Mes Passado': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],
                    'Este Mes': [moment().startOf('month'), moment().endOf('month')],
                    'Proximos 7 dias': [moment(), moment().add(6, 'days')],
                    'Proximos 30 dias': [moment(), moment().add(29, 'days')],
                    'Proximo Mes': [moment().add(1, 'month').startOf('month'), moment().add(1, 'month').endOf('month')],

                },
                startDate: moment().subtract(29, 'days'),
                endDate: moment()
            },
            function (start, end) {
                $('#daterange-btn span').html(start.format('D.MMM.YYYY') + ' - ' + end.format('D.MMM.YYYY'))
                //Caso seja selecionado para ver todos
                if (end.format('D.MMM.YYYY') == moment().add(36500, 'days').format('D.MMM.YYYY')) {
                    $('#daterange-btn span').html('<i class="fa fa-calendar"></i> Selecione um Periodo [Registo]')
                }
                dataRange1 = start.format('DD.MM.YYYY');
                dataRange2 = end.format('DD.MM.YYYY');
                filtrar();
            }
        )
    })
</script>