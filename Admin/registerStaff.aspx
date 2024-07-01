<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="registerStaff.aspx.cs" Inherits="ProjectMain.Admin.registerStaff" %>

<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- modal ends here -->
    <script type="text/javascript">
        function getPageName() {
            let pageValue = '<%= pageName %>';  // get the page name by api as a single jeson as fileName as parameter
            return pageValue;
            //console.log("Page declared as :" + pageValue);
        }
        function getPageTitle() {
            let pageValue = 'Staff Management';  // get the page name by api as a single jeson as fileName as parameter
            return pageValue;
            //console.log("Page declared as :" + pageValue);
        };                
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   
    <script type="text/javascript">
        function RowDblClick(sender, eventArgs) {
            sender.get_masterTableView().editItem(eventArgs.get_itemIndexHierarchical());
        }

        function onPopUpShowing(sender, args) {
            args.get_popUp().className += " popUpEditForm";
        }
    </script>
    <div class="container-fluid">
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper" id="divTopHeader">
            <!-- Content Header (Page header) -->
            <section class="content-header">
                <div class="container-fluid">
                    <div class="row mb-2">
                        <div class="col-sm-6">
                            <i class="fa-solid fa-gear" style="float: left; height: 2rem; width: 2rem; margin-top: .6rem; width: 1.25rem"></i>
                            <h1>&nbsp;Staff Registration</h1>
                        </div>
                        <div class="col-sm-6">
                            <ol class="breadcrumb float-sm-right">
                                <li class="breadcrumb-item"><a href="/">Home</a></li>
                                <li class="breadcrumb-item active">Staff Registration</li>
                            </ol>
                        </div>
                    </div>
                </div>
                <!-- /.container-fluid -->
            </section>

            <!-- Main content -->
            <section class="content">
                <div class="row">
                    <!-- left column -->

                    <!-- Grid view Card show Staff List  -->

                    <div class="col-lg-12">
                        <!-- jquery validation -->
                        <div class="card card-primary" id="divListCard">
                            <div class="card-header" id="divListCardHeader">
                                <h3 class="card-title">Staff List<small>&nbsp;|&nbsp;Manage staff list</small></h3>
                            </div>
                            <!-- /.card-header -->
                            <!-- Notifiaction card div-->
                            <!-- form start -->

                            <!-- main card div for the whole task -->
                            <div class="card-body" id="divMainCardGrid">
                                <div id="divFirstCardGrid"></div>

                                <asp:UpdatePanel ID="updateGrid" runat="server">                                   
                                    <ContentTemplate>                                        
                                        <telerik:RadGrid RenderMode="Lightweight" ID="RadGrid1" runat="server"  OnPreRender="RadGrid1_PreRender" 
                                            AllowPaging="True" ShowFooter="True" EnableLinqExpressions="false" FilterType="CheckList" AllowFilteringByColumn="true" AllowSorting="True" AutoGenerateColumns="False" ShowStatusBar="True"
                                            DataSourceID="SqlDataSourceStaffGrid" OnUpdateCommand="RadGrid1_UpdateCommand" OnItemDataBound="RadGrid1_ItemDataBound"
                                            OnInsertCommand="RadGrid1_InsertCommand" OnDeleteCommand="RadGrid1_DeleteCommand" OnSortCommand="RadGrid1_SortCommand" Skin="Bootstrap">
                                              <GroupingSettings CaseSensitive="false" />
                                            <ClientSettings EnableRowHoverStyle="true" Selecting-AllowRowSelect="true"></ClientSettings>
                                            <MasterTableView AutoGenerateColumns="false" CommandItemDisplay="Top" DataKeyNames="ID" EditFormSettings-PopUpSettings-KeepInScreenBounds="true" AllowSorting="true" AllowFilteringByColumn="true" DataSourceID="SqlDataSourceStaffGrid">
                                                <Columns>
                                                    <telerik:GridEditCommandColumn UniqueName="EditCommandColumn">
                                                    </telerik:GridEditCommandColumn>

                                                    <telerik:GridBoundColumn DataField="ID" Display="false" DataType="System.Int32" FilterControlAltText="Filter ID column" HeaderText="ID" ReadOnly="True" ShowNoSortIcon="True" SortExpression="ID" UniqueName="ID">
                                                    </telerik:GridBoundColumn>

                                                    <telerik:GridBoundColumn DataField="Title" AllowFiltering="false" FilterControlAltText="Filter Title column" HeaderText="Title" ShowNoSortIcon="False" SortExpression="Title" UniqueName="Title">
                                                    </telerik:GridBoundColumn>

                                                    <telerik:GridBoundColumn  DataField="FullName" CurrentFilterFunction="Contains" ShowFilterIcon="true" AutoPostBackOnFilter="true" FilterControlAltText="Filter FullName column" HeaderText="Full Name" ShowNoSortIcon="False" SortExpression="FullName"  UniqueName="FullName">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="JobTitle" AllowFiltering="false" FilterControlAltText="Filter JobTitle column" HeaderText="Job Title" ShowNoSortIcon="False" SortExpression="JobTitle" UniqueName="JobTitle">                                                    
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn DataField="PhoneNo" AllowFiltering="false" FilterControlAltText="Filter PhoneNo column" HeaderText="Phone No" ShowNoSortIcon="False" SortExpression="PhoneNo" UniqueName="PhoneNo">
                                                    </telerik:GridBoundColumn>

                                                    <telerik:GridDropDownColumn AllowFiltering="false" UniqueName="SubCity" ListTextField="SubCity"
                                                        ListValueField="ID" DataSourceID="SqlDataSourceSubCityList" HeaderText="Sub City"
                                                        DataField="SubCity" DropDownControlType="RadComboBox" AllowSorting="true">
                                                    </telerik:GridDropDownColumn>

                                                    <telerik:GridDropDownColumn AllowFiltering="false" UniqueName="Department" ListTextField="DepartmentName"
                                                        ListValueField="ID" DataSourceID="SqlDataSourceSubDepartment" HeaderText="Department"
                                                        DataField="Department" DropDownControlType="RadComboBox" AllowSorting="true">
                                                    </telerik:GridDropDownColumn>

                                                    <telerik:GridBoundColumn AllowFiltering="false" DataField="AccountID" FilterControlAltText="Filter AccountID column" HeaderText="User Name" ShowNoSortIcon="False" SortExpression="AccountID" UniqueName="AccountID">
                                                    </telerik:GridBoundColumn>

                                                    <telerik:GridBoundColumn Display="false" DataField="Email" FilterControlAltText="Filter Email column" HeaderText="Email" ShowNoSortIcon="False" SortExpression="Email" UniqueName="Email">
                                                    </telerik:GridBoundColumn>

                                                    <telerik:GridBoundColumn Display="false" UniqueName="RegisterDate" HeaderText="Registered Date" DataField="RegisterDate" FilterControlAltText="Filter RegisterDate column" SortExpression="RegisterDate"
                                                        DataFormatString="{0:d}">
                                                    </telerik:GridBoundColumn>
                                                </Columns>

                                                <EditFormSettings UserControlName="EmployeeDetailsCS.ascx" EditFormType="WebUserControl">
                                                    <EditColumn UniqueName="EditCommandColumn">
                                                    </EditColumn>
                                                </EditFormSettings>
                                            </MasterTableView>
                                            <ClientSettings>
                                                <ClientEvents OnRowDblClick="RowDblClick" OnPopUpShowing="onPopUpShowing" />
                                            </ClientSettings>
                                        </telerik:RadGrid>

                                         <asp:SqlDataSource ID="SqlDataSourceSubCityList" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:HawicConnection %>" SelectCommand="SELECT * FROM [tbl_SubCity]"></asp:SqlDataSource>

                                        <asp:SqlDataSource ID="SqlDataSourceSubDepartment" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:HawicConnection %>" SelectCommand="SELECT * FROM [tbl_Department]"></asp:SqlDataSource>

                                        <asp:SqlDataSource ID="SqlDataSourceStaffGrid" runat="server" ConnectionString="<%$ ConnectionStrings:HawicConnection %>" 
                                            SelectCommand="SELECT ID, Title, FullName, JobTitle, PhoneNo, SubCity, Department, AccountID,Email, RegStatus, RegisterDate FROM tbl_Staff" 
                                            UpdateCommand="UPDATE tbl_Staff
SET ID = @ID, Title = @Title, FullName = @FullName,Department = @Department, JobTitle = @JobTitle, PhoneNo = @PhoneNo, SubCity = @SubCity, Woreda = @Woreda, RegStatus =@RegStatus, RegisterDate = @RegisterDate 
FROM tbl_Staff">
                                            <UpdateParameters>
                                                <asp:Parameter Name="ID" />
                                                <asp:Parameter Name="Title" />
                                                <asp:Parameter Name="FullName" />
                                                <asp:Parameter Name="JobTitle" />
                                                <asp:Parameter Name="PhoneNo" />
                                                <asp:Parameter Name="SubCity" />
                                                <asp:Parameter Name="Woreda" />
                                                <asp:Parameter Name="RegStatus" />
                                                <asp:Parameter Name="RegisterDate" />
                                                <asp:Parameter Name="Department" />
                                            </UpdateParameters>
                                        </asp:SqlDataSource>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="card-footer" style="align-content: baseline;">
                                <p>You can see the list of registered staff and do more..</p>

                            </div>
                        </div>
                    </div>
                    <!--/.col (left) -->
                    <!-- /.row -->
                </div>
            </section>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->
    </div>
    <!-- /.content-fluid -->

    <script>
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
                $([document.documentElement, document.body]).animate({
                    scrollTop: $("#divTopHeader").offset().top
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
                $([document.documentElement, document.body]).animate({
                    scrollTop: $("#divTopHeader").offset().top
                }, 1000);
            }
        } 
    </script>

</asp:Content>
