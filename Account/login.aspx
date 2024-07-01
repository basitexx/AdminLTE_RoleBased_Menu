<%@ Page Title="Log in" Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="ProjectMain.Account.Login" Async="true" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hawi Medium Clinic | Log in</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugins/fontawesome-free/css/all.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="../../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../../dist/css/adminlte.min.css">
    <script>
        function notify(alertMsg) {

            var foudP = document.getElementById("alertP");
            if (foudP) {
                document.getElementById("alertP").remove();
            }

            var p = document.createElement("p");
            p.setAttribute("id", "alertP");
            p.setAttribute("style", "padding:0.5rem; padding-bottom:6px");
            p.setAttribute("class", "bg-danger");
            p.innerHTML = alertMsg;
            document.getElementById("notify").appendChild(p);
        }
        function focusUn() {
            document.getElementById("txtUsername").focus();
        }

        function removePrevAlert() {
            var foudP = document.getElementById("alertP");
            if (foudP) {
                document.getElementById("alertP").remove();
            }
        }
    </script>
</head>
<body class="hold-transition login-page" onload="focusUn()">
    <form runat="server">
        <asp:ScriptManager ID="scr1" runat="server"></asp:ScriptManager>
        <div class="login-box">
            <!-- /.login-logo -->
            <div class="card card-outline card-primary">
                <div class="card-header text-center">                
                    <a href="/" class="h1">
                        <img src="/Content/hawi-logo.jpg" alt="Clinic Logo" class="brand-image img-circle elevation-3" style="width:3rem">
                        <br /><b>Hawi</b><small>-Medium Clinic</small></a>
                </div>
                <div class="card-body">
                    <div id="notify" class="row text-danger" style="width: 100%; text-align: center; justify-content:center; margin-top: 5px;">
                        <asp:UpdateProgress runat="server" AssociatedUpdatePanelID="loginPanel">
                            <ProgressTemplate>                                
                                <img src="../dist/img/progressBar.gif" style="width:4rem" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                    <p class="login-box-msg">Sign in to start your session</p>

                    <asp:UpdatePanel ID="loginPanel" runat="server">
                        <ContentTemplate>
                            <div class="input-group mb-3">
                                <asp:TextBox runat="server" ID="txtUsername" type="text" class="form-control" placeholder="Username" required="required" />
                                <div class="input-group-append">
                                    <div class="input-group-text">
                                        <span class="fas fa-user"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="input-group mb-3">
                                <asp:TextBox runat="server" ID="txtPassword" type="password" class="form-control" placeholder="Password" required="required" />
                                <div class="input-group-append">
                                    <div class="input-group-text">
                                        <span class="fas fa-lock"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-8">
                                    <div class="icheck-primary">
                                        <asp:CheckBox runat="server" id="ChkRemember" Text="Remember Me"/>                                       
                                    </div>
                                </div>
                                <!-- /.col -->
                                <div class="col-4">
                                    <asp:Button ID="btnLogin" runat="server" Text="Sign In" 
                                        CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" OnClientClick="removePrevAlert()" />
                                    <!--<button type="submit" class="btn btn-primary btn-block">Sign In</button>  -->
                                </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <!--<div class="social-auth-links text-center mt-2 mb-3">
          <a href="#" class="btn btn-block btn-primary">
            <i class="fab fa-facebook mr-2"></i> Sign in using Facebook
          </a>
          <a href="#" class="btn btn-block btn-danger">
            <i class="fab fa-google-plus mr-2"></i> Sign in using Google+
          </a>
        </div>-->
                    <!-- /.social-auth-links -->
                    <!--
        <p class="mb-1">
          <a href="forgot-password.html">I forgot my password</a>
        </p>
        <p class="mb-0">
          <a href="register.html" class="text-center">Register a new membership</a>
        </p>-->
                </div>
                <!-- /.card-body -->
            </div>
            <!-- /.card -->
        </div>
        <!-- /.login-box -->
        <!-- jQuery -->
        <script src="../../plugins/jquery/jquery.min.js"></script>
        <!-- Bootstrap 4 -->
        <script src="../../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <!-- AdminLTE App -->
        <script src="../../dist/js/adminlte.min.js"></script>
    </form>
</body>
</html>
