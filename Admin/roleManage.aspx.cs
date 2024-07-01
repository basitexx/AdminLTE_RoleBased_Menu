using Microsoft.AspNet.Identity;
using ProjectMain.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ProjectMain.Admin
{
    public partial class roleManage : System.Web.UI.Page
    {
        public static int pg = 0;
        public string pageName;
        protected void Page_Load(object sender, EventArgs e)
        {
            //if the role has access to this page proceed, else go to Default => login
            //set the pageName here
            pageName = "roleManage";

            if (!IsPostBack)
            {
                //determine the role access to this page and redirect if not allowed.
                bool isAuth = (HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
                if (isAuth)
                {
                    string userName = Context.User.Identity.GetUserName();
                    var context = new hawic_dbEntities();
                    //get user Role and UserId                   
                    int UserId = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).ID;

                    //check at Menu_Role for RoleId or UserId for this specific MenuID                    
                    var Usercontext = new RoleAdminEntities();

                    string RoleId = Usercontext.AspNetUserRoles.FirstOrDefault(p => p.UserId == UserId.ToString()).RoleId;
                    // although department Id has associated role and permission

                    int MenuId = Usercontext.MenuMasters.FirstOrDefault(p => p.FileName == pageName).ID; // get the menu ID based on pageName at menumaster

                    Menu_Role roleFound = Usercontext.Menu_Role.FirstOrDefault(p =>
                    (p.UserId == UserId.ToString() || p.RoleId == RoleId) && p.MenuId == MenuId);

                    Usercontext.Dispose();
                    context.Dispose();
                    if (roleFound == null)
                    {
                        //not authorized! we can show not authorized page or redirect to home
                        Response.Redirect("/401");
                    }

                }
                else
                {
                    Response.Redirect("/Account/login");
                }
            }
            else
            {
                if (Request.Form["__EVENTTARGET"] == "btnContinue")
                {
                    //just for the confirm     
                    pg = 1;
                    btnContinue_Click(this, new EventArgs());
                }
            }
        }


        protected void ddlUserList_SelectedIndexChanged(object sender, Telerik.Web.UI.DropDownListEventArgs e)
        {
            System.Threading.Thread.Sleep(1000);
            //select dept from staff and assign to var for dept
            int uID = Convert.ToInt32(ddlUserList.SelectedValue);
            var context = new hawic_dbEntities();
            string deptResult = context.tbl_Staff.FirstOrDefault(p => p.ID == uID).Department.ToString();

            SqlDataSourceDeptList.SelectParameters["ID"].DefaultValue = deptResult.ToString();
            SqlDataSourceDeptList.DataBind();

            UddlDepartment.DataBind();



            //* Load the Menu Trees Below
            string userId = ddlUserList.SelectedValue.ToString();
            string RoleId = UddlDepartment.SelectedValue.ToString();
            string RoleText = UddlDepartment.SelectedText;

            SqlDataSourceRoleMenu.SelectParameters["Role"].DefaultValue = RoleId;
            SqlDataSourceRoleMenu.DataBind();
            RadTreeViewRoleMenu.DataBind();
            H3MenuFrom.InnerHtml = "Access from '<b>" + RoleText + "</b>'";


            H4OtherMenu.InnerText = "Other Permisions";
            //RadTreeViewRoleMenu.FindNodeByValue("").Checked = true; // do this for each userId menu

            ////

            SqlDataSourceOtherMenu.SelectParameters["RoleId"].DefaultValue = RoleId;
            SqlDataSourceOtherMenu.SelectParameters["UserId"].DefaultValue = userId;
            SqlDataSourceOtherMenu.DataBind();
            RadTreeViewOtherMenu.DataBind();
            //H4OtherMenu.InnerText = "UserId= " + userId + " RoleID= " + RoleId;

            List<string> CheckedIds = new List<string>();
            var contextUser = new RoleAdminEntities();

            //get menu list of the user to be checked here
            List<Menu_Role> roleList = contextUser.Menu_Role.Where(p => p.UserId == userId).ToList();

            foreach (RadTreeNode node in RadTreeViewOtherMenu.GetAllNodes())
            {
                foreach (Menu_Role role in roleList) // menu list of the user to be checked here
                {
                    if (node.Value == role.MenuId.ToString())
                    {
                        //before checking it, lets check if its a parent Node and skip if it is parent to some child;
                        if (node.Nodes.Count == 0)
                            node.Checked = true;
                    }
                }
            }

            context.Dispose();
        }

        protected void btnContinue_Click(object sender, EventArgs e)
        {
            string AlertMessage;
            //H3MenuFrom.InnerText = "Its just submitted";
            if (ddlUserList.SelectedIndex < 0)
            {
                AlertMessage = "There nothing to save. Please select a USER before saving changes";
                RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 1 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";            
            }
            else
            {
                try
                {
                    var context = new RoleAdminEntities();
                    string userId = ddlUserList.SelectedValue.ToString();
                    //IList<RadTreeNode> nodeCollection = RadTreeViewOtherMenu.CheckedNodes;
                    foreach (RadTreeNode node in RadTreeViewOtherMenu.GetAllNodes())
                    {
                        if (node.Checked == true)
                        {
                            // get the ID of the menu to update on the role table for the User                
                            // get the Menu_Role table and populate by the UserId and nodeValue for ID.
                            //check if there is already there before inserting

                            int MenuID = Convert.ToInt32(node.Value);
                            Menu_Role MenuRoletoAdd = context.Menu_Role.FirstOrDefault(p => (p.UserId == userId && p.MenuId == MenuID));
                            if (MenuRoletoAdd == null) // its a new menu, so add it
                            {
                                Menu_Role MenuRole = new Menu_Role
                                {
                                    MenuId = MenuID,
                                    UserId = userId
                                };
                                context.Menu_Role.Add(MenuRole);
                            }
                        }
                        else
                        {
                            int MenuID = Convert.ToInt32(node.Value);
                            Menu_Role MenuRoletoRemove = context.Menu_Role.FirstOrDefault(p => (p.UserId == userId && p.MenuId == MenuID));
                            if (MenuRoletoRemove != null)
                            {
                                context.Menu_Role.Remove(MenuRoletoRemove);
                            }
                        }
                    }

                    context.SaveChanges();
                    context.Dispose();

                    AlertMessage = "The changes has been saved succefully!";
                    RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";
                }
                catch (Exception ex)
                {
                    AlertMessage = "ERROR Occured. Please contact Administrator.( " + ex.Message + " )";
                    RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 2 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";            

                    /* AlertMessage = "Error has occured during the change. please contact administrator!" + Environment.NewLine + ex.Message;
                     RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 2 + ",'"+ AlertMessage+"');", true);  *///FailureText.Text = "Invalid login attempt";
                }
            }

        }
    }
}