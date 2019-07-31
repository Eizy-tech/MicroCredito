<!doctype html>
<html lang="en" class="no-js">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>
        <g:layoutTitle default="Micro Credito"/>
    </title>
    <asset:link rel="icon" href="logo.jpg" type="image/x-ico"/>

    <asset:stylesheet src="bootstrap.min.css"/>
    <asset:stylesheet src="css/solid.min.css"/>
    <asset:stylesheet src="css/fontawesome.min.css"/>
    <asset:stylesheet src="css/v4-shims.min.css"/>
    <asset:stylesheet src="select2/select2.css"/>

    %{--<asset:stylesheet src="all.css"/>--}%
    <asset:stylesheet src="iCheck/flat/all.css"/>
    <asset:stylesheet src="AdminLTE.min.css"/>

    <asset:stylesheet src="allskins.min.css"/>
    <asset:stylesheet src="style.css"/>
    %{--Fader--}%
    <asset:stylesheet src="bootstrap-select/bootstrap-select.css"/>
    <asset:stylesheet src="jquery-editable-select/jquery-editable-select.css"/>
    <asset:stylesheet src="sweetalert/sweetalert.css"/>
    <asset:stylesheet src="date-picker/datepicker.min.css"/>

    %{--Mabjaia--}%
    <asset:stylesheet src="export/tableexport.min.css"/>
    <asset:stylesheet src="paginacao/paginacao.css"/>
    <style>
    .box-primary {
        background-color: #f9fafcfa;
    }

    .box-success {
        background-color: #f9fafcfa;
    }
    </style>

    <g:layoutHead/>
</head>
%{--sidebar-collapse--}%
<body class="hold-transition skin-blue sidebar-mini">
<%@ page import="microcredito.UserDetailService" %>
<%
    def userDetailService = grailsApplication.classLoader.loadClass('microcredito.UserDetailService').newInstance()
%>
<%@ page import="microcredito.Emprestimo1Service" %>
<%
    def emprestimoServic = grailsApplication.classLoader.loadClass('microcredito.Emprestimo1Service').newInstance()
%>

<div class="wrapper">
    <header class="main-header">
        <a class="logo" href="<g:createLink controller="emprestimo" action="index"/>">
            %{--<span class="logo-mini"><b style="color: #000">E</b>MC</span>--}%
            %{--<span class="logo-lg"><b>MICROCREDITO</b></span>--}%

            <span class="logo-mini"><b style="color: #000">P</b>MC</span>
            <span class="logo-lg"><b>PROSPERIDADE</b>&nbsp;MC</span>
        </a>
        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top">
            <!-- Sidebar toggle button-->
            <a class="sidebar-toggle" data-toggle="push-menu" role="button">
                <span class="sr-only">Toggle navigation</span>
            </a>
            <!-- Navbar Right Menu -->
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <!-- Messages: style can be found in dropdown.less-->
                    <li class="dropdown messages-menu">
                        <ul class="dropdown-menu">
                            <li class="header">You have 4 messages</li>
                            <li>
                                <!-- inner menu: contains the actual data -->
                                <ul class="menu">
                                    <li><!-- start message -->
                                        <a href="#">
                                            <div class="pull-left">
                                                %{--<asset:image src="user2-160x160.jpg" alt="User Image" class="img-circle"/>--}%
                                            </div>
                                            <h4>
                                                Support Team
                                                <small><i class="fa fa-clock-o"></i> 5 mins</small>
                                            </h4>

                                            <p>Why not buy a new awesome theme?</p>
                                        </a>
                                    </li>
                                    <!-- end message -->
                                    <li>
                                        <a href="#">
                                            <div class="pull-left">
                                                %{--<asset:image src="user3-128x128.jpg" alt="User Image" class="img-circle"/>--}%
                                            </div>
                                            <h4>
                                                EIZYTEC Design Team
                                                <small><i class="fa fa-clock-o"></i> 2 hours</small>
                                            </h4>

                                            <p>Why not buy a new awesome theme?</p>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <div class="pull-left">
                                                %{--<asset:image src="user4-128x128.jpg" alt="User Image" class="img-circle"/>--}%
                                            </div>
                                            <h4>
                                                Developers
                                                <small><i class="fa fa-clock-o"></i> Today</small>
                                            </h4>

                                            <p>Why not buy a new awesome theme?</p>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <div class="pull-left">
                                                %{--<asset:image src="user3-128x128.jpg" alt="User Image" class="img-circle"/>--}%
                                            </div>
                                            <h4>
                                                Sales Department
                                                <small><i class="fa fa-clock-o"></i> Yesterday</small>
                                            </h4>

                                            <p>Why not buy a new awesome theme?</p>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <div class="pull-left">
                                                %{--<asset:image src="user4-128x128.jpg" alt="User Image" class="img-circle"/>--}%
                                            </div>
                                            <h4>
                                                Reviewers
                                                <small><i class="fa fa-clock-o"></i> 2 days</small>
                                            </h4>

                                            <p>Why not buy a new awesome theme?</p>
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer"><a href="#">See All Messages</a></li>
                        </ul>
                    </li>
                    <!-- Notifications: style can be found in dropdown.less -->
                    <li class="dropdown notifications-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" id="modaldevedores">
                            <i class="fa fa-bell-o"></i>
                            <span class="label label-warning">${emprestimoServic.quantosPagamHoje()}</span>
                        </a>
                    </li>
                    <!-- Tasks: style can be found in dropdown.less -->
                    <li class="dropdown tasks-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-flag-o"></i>
                            <span class="label label-danger">--</span>
                        </a>
                    </li>
                    <sec:ifNotLoggedIn>
                        <li class="dropdown user user-menu">
                            <g:link controller="Login">Entrar</g:link>
                        </li>
                    </sec:ifNotLoggedIn>
                <!-- User Account: style can be found in dropdown.less -->
                    <sec:ifLoggedIn>
                        <li class="dropdown user user-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"
                               aria-haspopup="true" aria-expanded="false">
                                %{--<asset:image src="" alt="User Image" class="img-circle"/>--}%
                                <i class="fa fa-user-tie"></i><sec:username/><span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <!-- User image -->
                                <li class="user-header">
                                    %{--<asset:image src="" alt="User Image" class="img-circle"/>--}%
                                    <p>
                                        <g:set var="user" value="${sec.username()}"/>
                                        <span><i class="fa fa-user-tie"></i><sec:username/></span>
                                        <small>
                                            ${userDetailService.user(user).nome}
                                        </small>
                                    </p>
                                </li>
                                <!-- Menu Body -->
                                <li class="user-body" style="background-color: #dedcdc">
                                    <div class="row">
                                        <div class="col-xs-4 text-center">
                                            <a href="#">Meus Clientes
                                                <span class="pull-right-container">
                                                    <small class="label pull-right bg-yellow">Brevemente</small>
                                                </span>
                                            </a>
                                        </div>

                                        <div class="col-xs-4 text-center">
                                            <a href="#">Minhas Multas
                                                <span class="pull-right-container">
                                                    <small class="label pull-right bg-yellow">Brevemente</small>
                                                </span>
                                            </a>
                                        </div>

                                        <div class="col-xs-4 text-center">
                                            <a href="#">Minhas Dividas
                                                <span class="pull-right-container">
                                                    <small class="label pull-right bg-yellow">Brevemente</small>
                                                </span>
                                            </a>
                                        </div>
                                    </div>
                                    <!-- /.row -->
                                </li>
                                <!-- Menu Footer-->
                                <li class="user-footer" style="background-color: #dedcdc">
                                    <div class="pull-left">
                                        %{--<a href="#" class="btn btn-success btn-flat">Perfil</a>--}%
                                        <g:link controller="user" action="perfil"
                                                class="btn btn-success btn-flat">Perfil</g:link>
                                    </div>

                                    <div class="pull-right">
                                        <g:link controller="logout" class="btn btn-success btn-flat">Sair</g:link>
                                    </div>
                                </li>
                            </ul>
                        </li>
                    </sec:ifLoggedIn>
                <!-- Control Sidebar Toggle Button -->
                    <li>
                        <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
                    </li>
                </ul>
            </div>

        </nav>
    </header>
    <!-- Left side column. contains the logo and sidebar -->
    <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
            <!-- Sidebar user panel -->
            <div class="user-panel ">
                <div class="">
                    <asset:image src="logo.jpg" alt="User Image" class="img-rounded center-block" style="width: 70%"/>
                </div>

                <div class="pull-left info">
                    %{--<sec:ifLoggedIn>--}%
                    %{--<SPAN><sec:username/> <i class="fa fa-user-tie"></i></SPAN>--}%

                    %{--</sec:ifLoggedIn>--}%
                </div>
            </div>
        <!-- search form -->
        %{--<form action="#" method="get" class="sidebar-form">--}%
        %{--<div class="input-group">--}%
        %{--<input type="text" name="q" class="form-control" placeholder="Search...">--}%
        %{--<span class="input-group-btn">--}%
        %{--<button type="submit" name="search" id="search-btn" class="btn btn-flat">--}%
        %{--<i class="fa fa-search"></i>--}%
        %{--</button>--}%
        %{--</span>--}%
        %{--</div>--}%
        %{--</form>--}%
        <!-- /.search form -->
        <!-- sidebar menu: : style can be found in sidebar.less -->
            <sec:ifLoggedIn>
                <ul class="sidebar-menu" data-widget="tree">
                    <li class="header">MENU DE NAVEGACAO</li>
                    <li class="treeview" id="li_emprestimos">
                        <a href="#">
                            <i class="fa fa-money-bill-alt"></i> <span>Emprestimos</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li id="li_list_emprestimo"><g:link controller="emprestimo"><i
                                    class="fa fa-list"></i> Listagem</g:link></li>
                            <li id="li_novo_emprestimo"><g:link controller="emprestimo" action="create"><i
                                    class="fa fa-plus-square"></i> Novo</g:link></li>
                        </ul>
                    </li>
                    <li class="treeview" id="li_prestacoes">
                        <a href="#">
                            <i class="fa fa-money-bill-wave"></i>
                            <span>Pagamentos</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            %{--<li id="li_list_prestacao"><g:link controller="emprestimo"><i class="fa fa-list"></i> Listagem</g:link></li>--}%
                            <sec:ifLoggedIn>
                                <g:if test="${userDetailService.user(user).perfil.id[0] == 1}">
                                    <li id="li_validacao">
                                        <g:link controller="prestacao" action="validacao"><i class="fa fa-check"></i> Validacao</g:link>
                                    </li>
                                </g:if>
                            </sec:ifLoggedIn>
                            <li id="li_relatorio_prestacoes">
                                <g:link controller="emprestimo" action="relatorio"><i
                                        class="fa fa-list-ul"></i> Relatorio</g:link>
                            </li>
                        </ul>
                    </li>
                    <li class="treeview" id="li_clientes">
                        <a href="#">
                            <i class="fa fa-people-carry"></i>
                            <span>Clientes</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li id="li_list_cliente"><g:link controller="cliente"><i
                                    class="fa fa-list"></i> Listagem</g:link></li>
                        </ul>
                    </li>
                    <sec:ifLoggedIn>
                        <g:if test="${userDetailService.user(user).perfil.id[0] == 1}">
                            <li class="treeview" id="li_sistema">
                                <a href="#">
                                    <i class="fa fa-support"></i> <span>Sistema</span>
                                    <span class="pull-right-container">
                                        <i class="fa fa-angle-left pull-right"></i>
                                        %{--<small class="label pull-right bg-yellow">Brevemente</small>--}%
                                    </span>
                                </a>
                                <ul class="treeview-menu">
                                    <li id="li_list_contas">
                                        <g:link controller="contaBancaria" action="index"><i
                                                class="fa fa-circle-o"></i> Contas Bancarias</g:link>
                                    </li>
                                    <li id="li_list_users">
                                        <g:link controller="user" action="index"><i
                                                class="fa fa-circle-o"></i> Utilizadores</g:link>
                                    </li>
                                </ul>
                            </li>
                        </g:if>
                    </sec:ifLoggedIn>
                %{--<li>--}%
                %{--<a href="#">--}%
                %{--<i class="fa fa-book"></i> <span>Documentacao</span>--}%
                %{--<span class="pull-right-container">--}%
                %{--<small class="label pull-right bg-yellow">Brevemente</small>--}%
                %{--</span>--}%
                %{--</a>--}%
                %{--</li>--}%
                    <hr/>
                    %{--<li class="header">LABELS</li>--}%
                    %{--<li><a href="#"><i class="fa fa-circle-o text-red"></i> <span>Important</span></a></li>--}%
                    %{--<li><a href="#"><i class="fa fa-circle-o text-yellow"></i> <span>Warning</span></a></li>--}%
                    %{--<li><a href="#"><i class="fa fa-circle-o text-aqua"></i> <span>Information</span></a></li>--}%
                </ul>
            </sec:ifLoggedIn>
        </section>
        <!-- /.sidebar -->
    </aside>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper" style="background-color: rgba(0, 78, 5, 0.45);"><!--#00a65a73-->
    <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>
                <ol class="breadcrumb" id="caminho">
                    <li><a <g:link controller="emprestimo" action="index"><i
                            class="fa fa-dashboard"></i> Inicio</g:link></a></li>
                </ol>
            </h1>
        </section>

        %{--PreLoader--}%
        %{--<div class="page-loader-wrapper">--}%
        %{--<div class="loader">--}%
        %{--<div class="preloader">--}%
        %{--<div class="spinner-layer pl-green">--}%
        %{--<div class="circle-clipper left">--}%
        %{--<div class="circle"></div>--}%
        %{--</div>--}%
        %{--<div class="circle-clipper right">--}%
        %{--<div class="circle"></div>--}%
        %{--</div>--}%
        %{--</div>--}%
        %{--</div>--}%
        %{--<p>Por Favor Aguarde...</p>--}%
        %{--</div>--}%
        %{--</div>--}%
        %{--End of Preloader--}%

        <!-- Main content -->
        <section class="">
            <div class="row" style="padding-left: 15px; padding-right: 15px">
                <div class="col-lg-12 col-md-12 col-xs-12 mb-lg-5">
                    <g:layoutBody/>
                </div>
            </div>
        </section>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <footer class="main-footer"
            style="align-content: center; text-align: center; padding-top: 3px; padding-bottom: 3px">
        <div class="pull-right hidden-xs">
            <b><small>Versao</small></b> 1.0
        </div>
        %{--<asset:image  alt="EIZY LOGO" class="float-left"/>--}%

        <strong style="align-content: center; text-align: center">Copyright &copy; 2019<d id="footer-date"></d> <a
                target="_blank" href="http://eizytec.com">EIZY TECNOLOGY, Lda</a>.</strong> Todos direitos reservados

    </footer>

    <div class="control-sidebar-bg"></div>
</div>

%{--modal de Prestacoes de um determinado emprestimo--}%
<div class="modal fade" id="modal-devedores">
    <div class="vertical-alignment-helper">
        <div class="modal-dialog vertical-align-center">
            <div class="modal-content modal-lg centered">
                <div class="modal-body">
                    <span name="listaDevedores" id="listaDevedores">

                    </span>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-danger pull-right" data-dismiss="modal">Fechar</button>
                </div>
            </div>
        </div>
    </div>
</div>

%{--<asset:javascript src="v4-shims.min.js"/>--}%
<asset:javascript src="js/solid.min.js"/>
<asset:javascript src="js/regular.min.js"/>
<asset:javascript src="js/brands.min.js"/>
<asset:javascript src="jquery-3.3.1.slim.min.js"/>
<!-- jQuery 3 -->
<asset:javascript src="jquery.min.js"/>
<!-- Bootstrap 3.3.7 -->
<asset:javascript src="bootstrap.min.js"/>
<!-- FastClick -->
<asset:javascript src="popper.min.js"/>

<asset:javascript src="bootstable.js"/>

<asset:javascript src="fastclick.js"/>
<!-- AdminLTE App -->
<asset:javascript src="adminlte.min.js"/>
<!-- Sparkline -->
<asset:javascript src="jquery.sparkline.min.js"/>
<!-- SlimScroll -->
<asset:javascript src="jquery.slimscroll.min.js"/>
<!-- ChartJS -->
<asset:javascript src="demo.js"/>
%{--<asset:javascript src="iCheck/icheck.min.js"/>--}%
<asset:javascript src="iCheck/icheck.js"/>

<asset:javascript src="vendor/jquery-validation/dist/jquery.validate.min.js"/>
<asset:javascript src="vendor/jquery-validation/dist/additional-methods.min.js"/>
<asset:javascript src="vendor/jquery-steps/jquery.steps.min.js"/>
<asset:javascript src="vendor/minimalist-picker/dobpicker.js"/>
<asset:javascript src="vendor/nouislider/nouislider.min.js"/>
<asset:javascript src="vendor/wnumb/wNumb.js"/>
<asset:javascript src="main-wizzard.js"/>
<asset:javascript src="moment/min/moment.min.js"/>
<asset:javascript src="bootstrap-daterangepicker/daterangepicker.js"/>
%{--Fader--}%
<asset:javascript src="select2/select2.full.min.js"/>
<asset:javascript src="bootstrap-select/bootstrap-select.js"/>
<asset:javascript src="jquery-editable-select/jquery-editable-select.js"/>
<asset:javascript src="sweetalert/sweetalert.min.js"/>
<asset:javascript src="sweetalert/dialogs.js"/>

<asset:javascript src="date-picker/datepicker.js"/>
<asset:javascript src="date-picker/datepicker.pt.js"/>

<asset:javascript src="export/tableExport.js"/>
<asset:javascript src="export/jquery.base64.js"/>
<asset:javascript src="export/libs/base64.js"/>
<asset:javascript src="export/jspdf.min.js"/>
%{--Fader--}%
<script>
    $(function () {
        $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
            checkboxClass: 'icheckbox_flat-green',
            radioClass: 'iradio_flat-green'
        });
    })
</script>
<script type="text/javascript">
    $('#modaldevedores').click(function () {               //open Modal de devedores pop-up
        <g:remoteFunction controller="emprestimo" action="devedoresHoje" update="listaDevedores"/>
        $('#modal-devedores').modal({
            show: true, backdrop: "static"
        });
    });
</script>
</body>
</html>
