<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="ProjectMain.Account.Profile" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function getPageName() {
            let pageValue = 'Default';  // get the page name by api as a single jeson as fileName as parameter
            return pageValue;
            console.log("Page declared as :" + pageValue);
        };
        function getPageTitle() {
            let pageValue = 'Home';  // get the page name by api as a single jeson as fileName as parameter
            return pageValue;
            //console.log("Page declared as :" + pageValue);
        };
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <div class="container-fluid">
                <div class="row mb-2" id="divTopHeader">
                    <div class="col-sm-6">
                        <!--<img src="../Content/hawi-logo.jpg" style="float: left; height: 2rem; width: 2rem; border-radius: 100px; border: 1px solid" />-->
                        <i class="fa-solid fa-gear" style="float: left; height: 2rem; width: 2rem; margin-top: .6rem; width: 1.25rem"></i>
                        <h1>My Profile</h1>
                    </div>
                    <div class="col-sm-6">
                        <ol class="breadcrumb float-sm-right">
                            <li class="breadcrumb-item"><a href="#">Home</a></li>
                            <li class="breadcrumb-item active">User Profile</li>
                        </ol>
                    </div>
                </div>
            </div>
            <!-- /.container-fluid -->
        </section>

        <!-- Main content -->
        <section class="content">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-4">
                        <!-- Profile Image -->
                        <div class="card card-primary card-outline">
                            <div class="card-body box-profile">
                                <div class="text-center">
                                    <a href="#" style="font-size: xx-small" onclick="showBrowseDialog()">
                                        <img src='<%= Photo %>' class="profile-user-img img-fluid img-circle" alt="No Photo" />
                                        <br />
                                        Change Photo</a>
                                    <br />
                                    <asp:FileUpload ID="FileUpload1" Style="display: none" runat="server" onchange="upload()" />
                                    <asp:Button runat="server" ID="hideButton" Text="" Style="display: none;" OnClick="hideButton_Click"
                                        CausesValidation="false" formnovalidate />

                                    <script type="text/javascript">
                                        function showBrowseDialog() {
                                            var fileuploadctrl = document.getElementById('<%= FileUpload1.ClientID %>');
                                            fileuploadctrl.click();
                                        }

                                        function upload() {
                                            var btn = document.getElementById('<%= hideButton.ClientID %>');
                                            btn.click();
                                        }
                                    </script>

                                </div>
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <h3 class="profile-username text-center" runat="server" id="h3FullName"></h3>
                                        <p class="text-muted text-center" runat="server" id="pJtitle"></p>

                                        <ul class="list-group list-group-unbordered mb-2">
                                            <li class="list-group-item">
                                                <b>Last Login</b> <a class="float-right"><%= LastLoginStr %></a>
                                            </li>
                                            <li class="list-group-item">
                                                <b>Register Date</b> <a class="float-right"><%= RegisterDateStr %></a>
                                            </li>
                                            <li class="list-group-item">
                                                <b>Total Tasks</b> <a class="float-right">13,287</a>
                                            </li>
                                        </ul>
                                        <asp:Button runat="server" ID="btnLogout" OnClick="btnLogout_Click" CssClass="btn btn-block btn-primary" CausesValidation="false" Text="Sign out" formnovalidate></asp:Button>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <!-- /.card-body -->
                        </div>
                        <!-- /.card -->
                        <!-- About Me Box -->
                        <div class="card card-primary card-outline">
                            <div class="card-header">
                                <h3 class="card-title">About Me</h3>
                            </div>
                            <!-- /.card-header -->
                            <div class="card-body" style="margin-bottom: -0.2rem">
                                <asp:UpdatePanel runat="server">
                                    <ContentTemplate>
                                        <strong><i class="fa fa-user-md mr-1"></i>Job Title</strong>
                                        <p class="text-muted" runat="server" id="pTitle">
                                        </p>

                                        <hr>
                                        <strong><i class="fas fa-book mr-1"></i>Department</strong>

                                        <p class="text-muted" runat="server" id="pDepartment">
                                        </p>

                                        <hr>

                                        <strong><i class="fas fa-map-marker-alt mr-1"></i>Location</strong>

                                        <p class="text-muted" runat="server" id="pLocation"></p>

                                        <hr>

                                        <strong><i class="fa fa-mobile mr-1"></i>Phone No</strong>

                                        <p class="text-muted" runat="server" id="pPhone">
                                        </p>

                                        <hr>
                                        <strong><i class="fa fa-envelope mr-1"></i>Email</strong>

                                        <p class="text-muted" runat="server" id="pEmail"></p>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <!-- /.card-body -->
                        </div>
                        <!-- /.card -->
                    </div>
                    <!-- /.col  left -->
                    <div class="col-md-8">
                        <div class="card collapsed-card">
                            <div class="card-header">
                                <a href="#" data-card-widget="collapse" title="Collapse">
                                    <h3 class="card-title">Update Profile</h3>
                                </a>
                                <div class="card-tools">
                                    <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                                        <i class="fas fa-minus"></i>
                                    </button>
                                </div>
                            </div>
                            <!-- /.card-header -->
                            <div class="card-body" id="divMainCardGrid">
                                <div class="tab-content" id="divFirstCardGrid">
                                    <div class="active tab-pane" id="activity">
                                        <!-- Post -->
                                        <div class="post">
                                            <asp:UpdatePanel runat="server" ID="updateGrid">
                                                <ContentTemplate>
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
                                                                    <asp:TextBox runat="server" class="form-control" ID="txtTitle" placeholder="Enter Title" required="required"> </asp:TextBox>
                                                                        </div>
                                                                <div class="form-group">
                                                                    <label for="txtFullName">Full Name</label>
                                                                    <asp:TextBox runat="server" class="form-control" ID="txtFullName" placeholder="Enter full name" required="required" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="txtJobTitle">Job Title</label>
                                                                    <asp:TextBox runat="server" class="form-control" ID="txtJobTitle" placeholder="Enter job title" required="required" />
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
                                                                        ConnectionString="<%$ ConnectionStrings:HawicConnection %>"
                                                                        SelectCommand="SELECT * FROM [tbl_Department] WHERE ID = @deptId">
                                                                        <SelectParameters>
                                                                            <asp:Parameter Name="deptId" Type="Int32" />
                                                                        </SelectParameters>
                                                                    </asp:SqlDataSource>

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
                                                                        ConnectionString="<%$ ConnectionStrings:HawicConnection %>"
                                                                        SelectCommand="SELECT * FROM [tbl_SubCity]"></asp:SqlDataSource>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="RdtxtPhone">Phone No</label>
                                                                    <telerik:RadMaskedTextBox ID="RdtxtPhone" Width="100%" runat="server" required="required" SelectionOnFocus="SelectAll"
                                                                        PromptChar="_" Mask="(##) ##-######"
                                                                        RequireCompleteText="true"
                                                                        TabIndex="3" data_validmask_msg="Phone number is incomplete">
                                                                    </telerik:RadMaskedTextBox>
                                                                    <asp:RequiredFieldValidator runat="server" ValidationGroup="form" ControlToValidate="RdtxtPhone" ErrorMessage="* Phone number is required." CssClass="text-danger" />
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="txtBoxUsername">Username</label>
                                                                    <asp:TextBox runat="server" class="form-control"
                                                                        ID="txtUsername" placeholder="Enter username" required="required"></asp:TextBox>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="txtEmail">Email address</label>
                                                                    <asp:TextBox runat="server" type="email" class="form-control" ID="txtEmail"
                                                                        placeholder="Enter email"> </asp:TextBox>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="txtPass1">New Password</label>
                                                                    <asp:TextBox runat="server" type="password"
                                                                        class="form-control" ID="txtPass1" placeholder="Leave this blank if not chaning" ValidationGroup="form"> </asp:TextBox>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label for="txtPass2">Comfirm Password</label>
                                                                    <asp:TextBox runat="server" type="password" class="form-control" ID="TxtConfirm"
                                                                        placeholder="Leave this blank if not chaning" ValidationGroup="form"> </asp:TextBox>
                                                                </div>
                                                                <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="TxtConfirm"
                                                                    ControlToValidate="txtPass1" ErrorMessage="* Passwords do not match" ValidationGroup="form" CssClass="text-danger"></asp:CompareValidator>
                                                                <br />
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

                                                        <asp:Button ID="btnUpdate" runat="server" class="btn btn-primary" Text="Save Changes" OnClick="btnUpdate_Click" ValidationGroup="form"></asp:Button>

                                                        <a href="/Account/profile" class="btn btn-warning">Cancel</a>
                                                    </div>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                        </div>
                                        <!-- ./post -->
                                    </div>
                                    <!-- ./tab pane -->
                                </div>
                                <!-- ./ tab-content -->
                            </div>
                            <!-- /.card-body -->
                        </div>
                        <!-- /.card -->
                        <hr />
                    </div>
                    <!-- /.col -->
                </div>
                <!-- /.row -->
            </div>
            <!-- /.container-fluid -->
        </section>
        <!-- /.content -->
    </div>

    <!-- /.content-wrapper -->
</asp:Content>
