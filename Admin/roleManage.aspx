<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="roleManage.aspx.cs" Inherits="ProjectMain.Admin.roleManage" %>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function getPageName() {
            let pageValue = '<%= pageName %>';  // get the page name by api as a single jeson as fileName as parameter
            return pageValue;
            //console.log("Page declared as :" + pageValue);
        };
        function getPageTitle() {
            let pageValue = 'Role Permissions';  // get the page name by api as a single jeson as fileName as parameter
            return pageValue;
            //console.log("Page declared as :" + pageValue);
        };
</script>
    <!-- Add the minified version of files from the /dist/ folder. -->
    <!-- jquery-confirm files -->
    <link rel="stylesheet"
        type="text/css"
        href="../dist/css/jquery-confirm.min.css" />

    <script type="text/javascript" src="../dist/js/jquery-confirm.min.js"></script>
    <script type="text/javascript">
        var j = jQuery.noConflict();
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">    
    <div class="container-fluid">
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->
            <div class="content-header">
                <div class="container-fluid" id="divTopHeader">
                    <div class="row mb-2">
                        <div class="col-sm-6">
                            <img src="../Content/hawi-logo.jpg" style="float: left; height: 2rem; width: 2rem; border-radius: 100px; border: 1px solid; margin-top: 0.1rem" />
                            <h1>&nbsp;Users & Roles</h1>
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-6">
                            <ol class="breadcrumb float-sm-right">
                                <li class="breadcrumb-item"><a href="/">Home</a></li>
                                <li class="breadcrumb-item active">Manage Roles</li>
                            </ol>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->
                </div>
                <!-- /.container-fluid -->
            </div>
            <!-- /.content-header -->

            <!-- Main content -->
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="card card-primary" id="divListCard">
                                <div class="card-header" id="divListCardHeader">
                                    <h5 class="m-0">Permission List<small>&nbsp;|&nbsp;Add permissions for a user</small></h5>
                                </div>
                                <div id="divMainCardGrid">
                                </div>
                                <asp:UpdatePanel runat="server" ID="updatePanelRoles">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="ddlUserList" EventName="SelectedIndexChanged" />
                                    </Triggers>
                                    <ContentTemplate>

                                        <div class="card-body">
                                            <!-- User select  drop down-->
                                            <div class="col-md-5" style="float: left">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h3 class="card-title">User Info</h3>
                                                        <div class="card-tools">
                                                            <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                                                                <i class="fas fa-minus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="form-group">
                                                            <label for="ddlUserList">User</label>
                                                            <telerik:RadDropDownList ID="ddlUserList" runat="server"
                                                                Width="100%"
                                                                DataSourceID="SqlDataSourceUserList"
                                                                DataTextField="FullName" DefaultMessage="Select User..."
                                                                DataValueField="ID" AutoPostBack="true" OnSelectedIndexChanged="ddlUserList_SelectedIndexChanged">
                                                            </telerik:RadDropDownList>
                                                        </div>
                                                        <asp:SqlDataSource ID="SqlDataSourceUserList" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:HawicConnection %>"
                                                            SelectCommand="SELECT * FROM [tbl_Staff]"></asp:SqlDataSource>
                                                        <div class="form-group">
                                                            <label for="UddlDepartment">Department<small>&nbsp;| &nbsp; Will be shown below </small></label>
                                                            <telerik:RadDropDownList ID="UddlDepartment" runat="server"
                                                                Width="100%" DataSourceID="SqlDataSourceDeptList"
                                                                DataTextField="DepartmentName"
                                                                DataValueField="ID" Enabled="false">
                                                            </telerik:RadDropDownList>
                                                            <!-- loading giff -->
                                                            <asp:UpdateProgress runat="server" AssociatedUpdatePanelID="updatePanelRoles">
                                                                <ProgressTemplate>
                                                                    <img src="../dist/img/progressBar.gif" style="height: 2rem; width: 4rem" />
                                                                </ProgressTemplate>
                                                            </asp:UpdateProgress>
                                                        </div>
                                                        <asp:SqlDataSource ID="SqlDataSourceDeptList" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:HawicConnection %>"
                                                            SelectCommand="SELECT * FROM [tbl_Department] WHERE ([ID] = @ID)">
                                                            <SelectParameters>
                                                                <asp:SessionParameter DefaultValue="0" Name="ID" Type="Int32" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>
                                                        <br />
                                                    </div>
                                                    <!-- /.card-body -->
                                                    <div class="card-footer">
                                                    </div>
                                                </div>
                                                <!-- /.card for user -->
                                            </div>
                                            <!-- ./div for card-user -->
                                            <!-- tree view for the roles  -->
                                            <div class="col-md-7 accent-blue" style="float: right">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h3 class="card-title">Menu Tree</h3>
                                                        <div class="card-tools">
                                                            <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
                                                                <i class="fas fa-minus"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                    <div class="card-body">
                                                        <h3 runat="server" id="H3MenuFrom"></h3>
                                                        <telerik:RadTreeView ID="RadTreeViewRoleMenu" runat="server" CheckBoxes="false" DataFieldID="ID" DataFieldParentID="ParentID"
                                                            DataSourceID="SqlDataSourceRoleMenu" DataTextField="Name" DataValueField="ID" Skin="Material">
                                                        </telerik:RadTreeView>

                                                        <asp:SqlDataSource ID="SqlDataSourceRoleMenu" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"
                                                            SelectCommand="SELECT * FROM [fnGetMenuForRole](@Role )">
                                                            <SelectParameters>
                                                                <asp:Parameter DefaultValue="0" Name="Role" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>

                                                        <hr />
                                                        <h4 runat="server" id="H4OtherMenu"></h4>
                                                        <telerik:RadTreeView ID="RadTreeViewOtherMenu" runat="server" CheckBoxes="true" DataFieldID="ID" DataFieldParentID="ParentID"
                                                            DataSourceID="SqlDataSourceOtherMenu" DataTextField="Name" DataValueField="ID" 
                                                            TriStateCheckBoxes="true" CheckChildNodes="true" Skin="Bootstrap">
                                                            
                                                        </telerik:RadTreeView>

                                                        <asp:SqlDataSource ID="SqlDataSourceOtherMenu" runat="server"
                                                            ConnectionString="<%$ ConnectionStrings:DefaultConnection %>"
                                                            SelectCommand="EXEC [spGetOtherMenuList] @UserId, @RoleId">
                                                            <SelectParameters>
                                                                <asp:Parameter DefaultValue="0" Name="UserId" />
                                                                <asp:Parameter DefaultValue="0" Name="RoleId" />
                                                            </SelectParameters>
                                                        </asp:SqlDataSource>


                                                    </div>
                                                    <!-- /.card-body -->
                                                </div>
                                                <!-- /.card for tree -->
                                            </div>
                                            <!-- ./div for card tree -->
                                            <!-- ./div for main card body  -->
                                        </div>
                                        <!-- ./ card-body -->
                                        <div class="card-footer" style="text-align: center">
                                            <asp:Button runat="server" ID="btnContinue" CssClass="btn btn-primary" Text="Save Changes"
                                                ClientIDMode="Static" OnClick="btnContinue_Click" OnClientClick="Jconfirms(); return false;" />

                                            <a ID="btnCancel"  class="btn btn-warning" href="/Account/roleManage">Cancel</a>
                                        </div>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <!-- ./ card -->
                        </div>
                        <!-- /.col-lg-12 -->
                    </div>
                    <!-- /.row -->
                </div>
                <!-- /.container-fluid -->
            </div>
            <!-- /.content -->
        </div>
    </div>

    <script>

        // confirmation
        //var j = jQuery.noConflict();

        // confirmation
        var retVal;
        function Jconfirms() {
            j.confirm({
                title: 'Attention',
                content: 'You are changing access permission for the selected User! Are you sure to continue?',
                icon: 'fa fa-question-circle',
                animation: 'scale',
                closeAnimation: 'scale',
                opacity: 0.5,
                buttons: {
                    confirm: {
                        text: 'Yes, sure!',
                        btnClass: 'btn-orange',
                        action: function () {
                            //j.alert('A very critical action <strong>triggered!</strong>');
                            __doPostBack('btnContinue', '')
                        }
                    },
                    cancel: function () {
                        //j.alert('you clicked on <strong>cancel</strong>');                                        
                    }
                }
            });
            // __doPostBack(source, '');
            if (retVal == true) {
                return retVal;
            }
        }

        function DepreciatedshowAlert(val, paramMessage) {
             // this one is will be deleted upon succesful testing at master page


            var message = paramMessage;
            //check if the alert is still there and then maket it center then left
            var foud = document.getElementById("contentDiv");
            if (foud) {
               
                if (val == 0) {
                    title = "Success"
                    style = "alert alert-success alert-dismissible";
                    icon = "icon fas fa-check";
                    foud.setAttribute("class", style);

                }              
                else if (val == 1) {
                    title = "Warning"
                    style = "alert alert-warning alert-dismissible";
                    icon = "icon fas fa-exclamation-triangle";
                    foud.setAttribute("class", style);
                }
                else {
                    title = "Error"
                    style = "alert alert-danger alert-dismissible";
                    icon = "icon fas fa-ban";
                    foud.setAttribute("class", style);
                }

                //console.log(foud.getAttribute("class"));               
                j([document.documentElement, document.body]).animate({
                    scrollTop: j("#divTopHeader").offset().top
                }, 1000);
            }
            else {

                var foudParent = document.getElementById("alertDiv");
                if (foudParent) {
                    document.getElementById("alertDiv").remove();
                }

                var title = "";
                var style = "";
                var icon = "";                

                if (val == 0) {
                    title = "Success"
                    style = "alert alert-success alert-dismissible";
                    icon = "icon fas fa-check";
                }
                else if (val == 1) {
                    title = "Warning"
                    style = "alert alert-warning alert-dismissible";
                    icon = "icon fas fa-exclamation-triangle";                  
                }
                else {
                    title = "Error"
                    style = "alert alert-danger alert-dismissible";
                    icon = "icon fas fa-check";
                }


                //Create the success alert and display
                var alertDiv = document.createElement("div");
                alertDiv.setAttribute("Id", "alertDiv");
                alertDiv.setAttribute("class", "col-md-8");
                alertDiv.setAttribute("style", "margin-left:1rem; padding-top:1rem");

                var contentDiv = document.createElement("div");
                contentDiv.setAttribute("Id", "contentDiv");
                contentDiv.setAttribute("class", style);

                var buttonDismiss = document.createElement("input");
                buttonDismiss.setAttribute("type", "button");
                buttonDismiss.setAttribute("class", "close");
                buttonDismiss.setAttribute("data-dismiss", "alert");
                buttonDismiss.setAttribute("aria-hidden", "true");
                buttonDismiss.setAttribute("style", "border:none; background:transparent; font-size:larger");
                buttonDismiss.setAttribute("value", "x");
                contentDiv.appendChild(buttonDismiss);

                var msgTitle = document.createElement("h5");
                msgTitle.innerHTML = "\<i class=\"" + icon + "\"\>\</i\> " + title;
                contentDiv.appendChild(buttonDismiss);
                var content = document.createTextNode(message);

                contentDiv.appendChild(msgTitle);
                contentDiv.appendChild(content);

                alertDiv.appendChild(contentDiv);
                var refChild = document.getElementById("divFirstCardGrid");

                document.getElementById("divMainCardGrid").insertBefore(alertDiv, refChild);


                //document.getElementById("divMainCardGrid").focus();
                j([document.documentElement, document.body]).animate({
                    scrollTop: j("#divTopHeader").offset().top
                }, 1000);
            }
        }
    </script>


</asp:Content>
