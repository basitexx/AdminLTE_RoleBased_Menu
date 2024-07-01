<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EmployeeDetailsCS.ascx.cs" Inherits="ProjectMain.Admin.EmployeeDetailsCS" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>
<!-- InputMask -->
<script src="/plugins/moment/moment.min.js"></script>
<script src="/plugins/inputmask/jquery.inputmask.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">

<!-- modal ends here -->
<script type="text/javascript">



    // BS-Stepper Init        
    $(document).ready(function () {

        $('[data-mask]').inputmask()
        $('#txtPhone').mask('0000-0000');
        $('#txtPhone').value = "12345";
    });



</script>

<!-- card for personal info  -->
<div class="col-md-6" style="float: left">
    <div class="card" style="text-align: left">
        <div class="card-header">
            <h3 class="card-title">Personal Info</h3>
            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                    <i class="fas fa-minus"></i>
                </button>
            </div>
        </div>
        <div class="card-body">
            <div class="form-group">
                <label for="txtTitle">Title</label>
                <asp:TextBox runat="server" class="form-control" ID="txtTitle" placeholder="Enter Title" required="required" Text='<%# Bind( "Title") %>'> </asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtFullName">Full Name</label>
                <asp:TextBox runat="server" class="form-control" ID="txtFullName" placeholder="Enter full name" required="required" Text='<%# Bind( "FullName") %>' />
            </div>
            <div class="form-group">
                <label for="txtJobTitle">Job Title</label>
                <asp:TextBox runat="server" class="form-control" ID="txtJobTitle" placeholder="Enter job title" required="required" Text='<%# Bind( "JobTitle") %>' />
            </div>
            <div class="form-group">
                <label for="UddlDepartment">Department</label>
                <asp:DropDownList ID="UddlDepartment" runat="server" CssClass="form-control"
                    Width="100%"
                    DataSourceID="SqlDataSourceDeptList"
                    DataTextField="DepartmentName" DefaultMessage="Select SubCity..."
                    DataValueField="ID">
                </asp:DropDownList>

                <asp:SqlDataSource ID="SqlDataSourceDeptList" runat="server"
                    ConnectionString="<%$ ConnectionStrings:HawicConnection %>" SelectCommand="SELECT * FROM [tbl_Department]"></asp:SqlDataSource>
            </div>
            <div style="margin-bottom: 2.25rem"></div>
        </div>
        <!-- /.card-body -->
    </div>
    <!-- /.card for personal -->
</div>
<!-- card for adress  -->
<div class="col-md-6" style="float: right">
    <div class="card" style="text-align: left">
        <div class="card-header">
            <h3 class="card-title">Address & Account</h3>
            <div class="card-tools">
                <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                    <i class="fas fa-minus"></i>
                </button>
            </div>
        </div>
        <div class="card-body">           
            <div class="form-group">
                <label for="UddlSubCity">Sub city</label>
                <asp:DropDownList ID="UddlSubCity" runat="server" CssClass="form-control"
                    Width="100%"
                    DataSourceID="SqlDataSourceSubCityList"
                    DataTextField="SubCity" DefaultMessage="Select SubCity..."
                    DataValueField="ID">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlDataSourceSubCityList" runat="server"
                    ConnectionString="<%$ ConnectionStrings:HawicConnection %>" SelectCommand="SELECT * FROM [tbl_SubCity]"></asp:SqlDataSource>
            </div>
             <div class="form-group">
                <label for="RdtxtPhone">Phone No</label>
                <telerik:RadMaskedTextBox ID="RdtxtPhone" Width="100%" runat="server" required="required" SelectionOnFocus="SelectAll"
                    Text='<%# DataBinder.Eval(Container, "DataItem.PhoneNo") %>' PromptChar="_" Mask="(##) ##-######"
                    TabIndex="3">
                </telerik:RadMaskedTextBox>
                <asp:RequiredFieldValidator ID="validatePhone" CssClass="text-danger" runat="server" ErrorMessage="* Phone number is required" ControlToValidate="RdtxtPhone"></asp:RequiredFieldValidator>
             </div>
            <div class="form-group">
                <label for="txtBoxUsername">Username</label>
                <asp:TextBox runat="server" class="form-control" ID="txtUsername" placeholder="Enter username" Text='<%# Bind( "AccountID") %>'></asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtEmail">Email address</label>
                <asp:TextBox runat="server" type="email" class="form-control" ID="txtEmail" Text='<%# Bind( "Email") %>' placeholder="Enter email"> </asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtPass1">New Password</label>
                <asp:TextBox runat="server" type="password" class="form-control" ID="txtPass1" placeholder="Leave this blank if not chaning"> </asp:TextBox>
            </div>
            <div class="form-group">
                <label for="txtPass2">Comfirm Password</label>
                <asp:TextBox runat="server" type="password" class="form-control" ID="txtPass2" placeholder="Leave this blank if not chaning"> </asp:TextBox>
            </div>
            <asp:CompareValidator CssClass="text-danger" ID="CompareValidator1" runat="server" ErrorMessage="The passwords not match" ControlToValidate="txtPass1" ControlToCompare="txtPass2">
            </asp:CompareValidator>
            <div class="form-group">
                <asp:CheckBox runat="server" ID="ChkDisable" CssClass="form-control text-danger" Text=" Disable User?" />
            </div>
        </div>
        <!-- ./card body -->
    </div>
    <!-- card adress -->   
</div>
<div class="card-footer col-md-12" style="align-content: baseline; text-align: center; padding-right: 0rem">
     <asp:UpdateProgress runat="server" AssociatedUpdatePanelID="updateGrid">
        <ProgressTemplate>
            <img src="../dist/img/progressBar.gif" style="width: 20rem; height: 5rem; padding-bottom: 1rem" />
        </ProgressTemplate>
    </asp:UpdateProgress>

    <asp:Button ID="btnUpdate" runat="server" class="btn btn-primary" Text='<%# (Container is GridEditFormInsertItem) ? "Insert" : "Update" %>'
        CommandName='<%# (Container is GridEditFormInsertItem) ? "PerformInsert" : "Update" %>'></asp:Button>

    <asp:Button CausesValidation="false" ID="btnCancel" Text="Cancel" CssClass="btn btn-warning" runat="server"
        CommandName="Cancel" formnovalidate></asp:Button>
   
</div>

