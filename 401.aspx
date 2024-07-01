<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="401.aspx.cs" Inherits="ProjectMain.Err401" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Main content -->
    <section class="content">
      <div class="error-page">
        <h2 class="headline text-danger">401</h2>

        <div class="error-content">
          <h3><i class="fas fa-exclamation-triangle text-danger"></i> Oops! Something went wrong.</h3>

          <p>
            You may not be authorized to access this page.
            Meanwhile, you may click <a href="/">return to Home</a> or try to Login again.
          </p>                      
         
        </div>
      </div>
      <!-- /.error-page -->

    </section>
    <!-- /.content -->
</asp:Content>
