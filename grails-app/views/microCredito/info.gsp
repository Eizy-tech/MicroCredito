<!DOCTYPE html>
<html lang="pt">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="layout" content="logintemplate" />
    <title>Contacte-nos</title>

    <asset:stylesheet src="bootstrap.min.css"/>
    <asset:stylesheet src="css/solid.min.css"/>
    <asset:stylesheet src="css/fontawesome.min.css"/>
    <asset:stylesheet src="css/v4-shims.min.css"/>
    <asset:stylesheet src="select2/select2.css"/>

    %{--<asset:stylesheet src="all.css"/>--}%
    <asset:stylesheet src="iCheck/flat/all.css"/>
    <asset:stylesheet src="AdminLTE.min.css"/>

    <asset:stylesheet src="allskins.min.css"/>
</head>
<body>

<asset:javascript src="jquery-3.3.1.slim.min.js"/>
<asset:javascript src="sweetalert/sweetalert.min.js"/>
<asset:javascript src="sweetalert/dialogs.js"/>
    <script type="text/javascript">
        $(document).ready(function () {
            swal({
                type: 'error',
                title: "<h1>Erro no sistema</h1>",
                text: "<p>Por favor contacte a <strong>Eizy Technology</strong> para a resolução do erro. <br>" +
                    "Contactos: <strong >+258 82 96 18 729 <br></strong>" +
                    "Email: <strong>eizytec@eizytec.com</strong>" +
                    "</p>",
                html: true
            }, function () {
                window.location = '/logout';
            });
        })
    </script>
</body>