<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ProjectMain._Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://code.jquery.com/jquery-1.9.1.js"></script>
<script src="https://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>

<script type="text/javascript">
    function MethodHello() {
     
        $(function (request, response) {
            $.ajax({
                url: "Default.aspx/MethodHello",                
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                success: function (data) {
                    response=($.map(data.d, function (item) {
                        alert("Success");
                        return { value: item }
                    }))
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    var err = errorThrown;
                    alert("failure" + textStatus);
                   // alert(textStatus);
                }
            });            
        });
        //console.log("RES= "+res);
    }
    </script>
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
<!-- Add custom styles and js in the content head  -->
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
</asp:Content>
