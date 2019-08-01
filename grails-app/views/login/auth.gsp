<html>
    <head>
        <meta name="layout" content="logintemplate" />
        <title><g:message code='springSecurity.login.title'/></title>
        <style type="text/css" media="screen">
        </style>
        <asset:stylesheet src="login.css" />
    </head>

    <body >
        <g:if test='${flash.message}'>
            <div class="login_message">${flash.message}</div>
        </g:if>
        <div class="container" style="width: auto; margin-top: 50px">
            <div class="card card-container">
                <!-- <img class="profile-img-card" src="//lh3.googleusercontent.com/-6V8xOA6M7BA/AAAAAAAAAAI/AAAAAAAAAAA/rzlHcD0KYwo/photo.jpg?sz=120" alt="" /> -->
                %{--<img id="profile-img" class="profile-img-card" src="//ssl.gstatic.com/accounts/ui/avatar_2x.png" />--}%
                %{--<asset:image src="avatar_2x.png" id="profile-img" class="profile-img-card"/>--}%
                <asset:image src="logo.jpg" id="profile-img" class="img-rounded center-block" style="width: 75%"/>
                %{--<p id="profile-name" class="profile-name-card" style="color: #568c78">BEM VINDO</p>--}%
                %{--<p id="profile-name" class="profile-name-card" style="color: #568c78">ACESSO A MICROCREDITO</p>--}%

                <form action="${postUrl ?: '/login/authenticate'}" method="POST" id="loginForm" class="form-signin" autocomplete="off">
                    %{--<label for="username"><g:message code='springSecurity.login.username.label'/>:</label>--}%
                    <span id="reauth-email" class="reauth-email"></span>
                    <input type="text" class="form-control" name="${usernameParameter ?: 'username'}" id="username" placeholder="Utilizador"  required autofocus style="margin-bottom: 20px"/>
                    <input type="password" class="form-control" name="${passwordParameter ?: 'password'}" id="password" placeholder="Senha"/>
                    <br>
                    <div id="remember" class="checkbox hidden">
                        <label>
                            <input type="checkbox" value="Lembre-me" class="chk" name="${rememberMeParameter ?: 'remember-me'}" id="remember_me" <g:if test='${hasCookie}'>checked="checked"</g:if>/>
                        </label>
                        <label for="remember_me"><g:message code='springSecurity.login.remember.me.label'/></label>
                    </div>

                    %{--<input class="btn btn-lg btn-primary btn-block btn-signin mt-4" type="submit" id="submit" value="Entrar"/>--}%
                <button class="btn btn-lg btn-primary btn-block btn-signin mt-4" type="submit" id="submit">Entrar&nbsp;&nbsp;<i class="fa fa-sign-in"></i></button>
                </form>
            </div>
        </div>
        <script>
            (function() {
                document.forms['loginForm'].elements['${usernameParameter ?: 'username'}'].focus();
            })();
        </script>
    </body>
</html>