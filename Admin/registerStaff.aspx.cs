using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using ProjectMain.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ProjectMain.Admin
{
    public partial class registerStaff : System.Web.UI.Page
    {
        public string pageName { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            //set the pageName here
            pageName = "registerStaff";

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
                    RadGrid1.MasterTableView.EditMode = (GridEditMode)Enum.Parse(typeof(GridEditMode), "EditForms");
                }
                else
                {
                    Response.Redirect("/Account/login");
                }
            }            
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {


            RadGrid1.Rebind();
            //ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ")", true);  //FailureText.Text = "Invalid login attempt";
            RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ");", true);  //FailureText.Text = "Invalid login attempt";
        }

        string columnName = "FullName";

        

        protected void RadGrid1_PreRender(object sender, System.EventArgs e)
        {            
            GridFilteringItem filteringItem = (GridFilteringItem)RadGrid1.MasterTableView.GetItems(GridItemType.FilteringItem)[0]; // Get the filtering item

            if (columnName != null) // If the columnName has been assigned, focus the filter TextBox
            {
                TextBox box = filteringItem[columnName].Controls[0] as TextBox;
                box.Focus();
               // box.Attributes.Add("onkeydown", "doFilter(this,event)");
            }

        }
                                      
        protected void RadGrid1_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
        {
            this.RadGrid1.DataSource = SqlDataSourceStaffGrid;
        }

        protected void RadGrid1_UpdateCommand(object source, GridCommandEventArgs e)
        {
            try
            {
                string AlertMessage;
                System.Threading.Thread.Sleep(1500);

                GridEditableItem editedItem = e.Item as GridEditableItem;
                UserControl userControl = (UserControl)e.Item.FindControl(GridEditFormItem.EditFormUserControlID);

                int ID = (int)editedItem.GetDataKeyValue("ID");

                var context = new hawic_dbEntities();
                tbl_Staff employeeToUpdate = context.tbl_Staff.FirstOrDefault(p => p.ID == ID);
                string userNameInEdit = employeeToUpdate.AccountID;

                if (employeeToUpdate == null)
                {
                    RadGrid1.Controls.Add(new LiteralControl("Unable to locate the Employee for updating."));
                    e.Canceled = true;
                    return;
                }

                Hashtable newValues = new Hashtable();

                newValues["Title"] = (userControl.FindControl("txtTitle") as TextBox).Text;
                newValues["FullName"] = (userControl.FindControl("txtFullName") as TextBox).Text;
                newValues["JobTitle"] = (userControl.FindControl("txtJobTitle") as TextBox).Text;
                newValues["PhoneNo"] = (userControl.FindControl("RdtxtPhone") as RadMaskedTextBox).Text;
                int DeptID = Convert.ToInt32((userControl.FindControl("UddlDepartment") as DropDownList).SelectedValue);
                newValues["Department"] = DeptID;
                newValues["SubCity"] = Convert.ToInt32((userControl.FindControl("UddlSubCity") as DropDownList).SelectedValue);
                string email = (userControl.FindControl("txtEmail") as TextBox).Text;
                newValues["Email"] = email;
                string userName = (userControl.FindControl("txtUserName") as TextBox).Text;
                newValues["AccountID"] = userName;
                string newPass = (userControl.FindControl("txtPAss1") as TextBox).Text;
                newValues["LastUpdate"] = DateTime.Now;
                bool IsEnabled = (userControl.FindControl("ChkDisable") as CheckBox).Checked;


                foreach (DictionaryEntry entry in newValues)
                {
                    if (entry.Value.ToString().Length > 0)
                        employeeToUpdate.GetType().GetProperty(entry.Key.ToString()).SetValue(employeeToUpdate, entry.Value);
                }

                //before saving, lets update the account at users.
                var Usercontext = new RoleAdminEntities();
                /* var userList = Usercontext.AspNetUsers.Where(p=> p.UserName == userName || p.Email == email).ToList();*/

                AspNetUser UserTbl =
                    Usercontext.AspNetUsers.FirstOrDefault(p => p.UserName == userNameInEdit); // if found, can't duplicate. else update


                tbl_Staff checkUserName = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName);

                if (userNameInEdit != userName && checkUserName != null) // means someone elses is used
                {
                    //then fire the exception
                    throw new Exception("The username is already taken");
                }
                else
                {
                    //before saving, lets update the account at users.
                    UserTbl.UserName = userName;
                    UserTbl.Email = email;
                    UserTbl.isEnabled = !IsEnabled;
                    Usercontext.SaveChanges();
                    Usercontext.Dispose();
                    //Reset password if there is any
                    if (newPass.Length > 1) // there is password reset
                        ResetPassword(userName, newPass);

                    context.SaveChanges();
                    //after saving employee lets update his role based on the department
                    //after staff is added then, add RoleInfo in aspNetUserRoles for the staff.ID
                    string staffID = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).ID.ToString();
                    string RoleString = DeptID.ToString();
                    var contextUser = new RoleAdminEntities();

                    AspNetUserRole roleTable = contextUser.AspNetUserRoles.FirstOrDefault(p => p.UserId == staffID && p.RoleId == RoleString);
                    if (roleTable != null)
                    {
                        //update
                        roleTable.RoleId = RoleString;
                    }
                    else
                    {
                        //insert
                        contextUser.AspNetUserRoles.Add(new AspNetUserRole { UserId = staffID, RoleId = RoleString }); //deptID as role
                    }
                    contextUser.SaveChanges();

                    context.Dispose();
                    contextUser.Dispose();
                    Label lbl = new Label();
                    lbl.Text = "Saved Succefully.";
                    lbl.CssClass = "bg-success";
                    RadGrid1.Controls.Add(lbl);
                    AlertMessage = "Changes saved successfully";
                    RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";

                }

                // RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ");", true);  //FailureText.Text = "Invalid login attempt";
            }
            catch (Exception ex)
            {
                Label lblError = new Label();
                lblError.Text = "Unable to update Staff. Reason: " + ex.Message;
                lblError.ForeColor = System.Drawing.Color.Red;
                RadGrid1.Controls.Add(lblError);

                e.Canceled = true;
                string AlertMessage = "ERROR occured during save changes. (" + lblError.Text + ")";
                RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 2 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";
            }
        }

        protected void RadGrid1_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item.IsInEditMode)
            {
                UserControl userControl = (UserControl)e.Item.FindControl(GridEditFormItem.EditFormUserControlID);

                DropDownList ddlSubCity = (userControl.FindControl("UddlSubCity") as DropDownList);

                string valueToSelect = DataBinder.Eval(e.Item, "DataItem.SubCity").ToString();

                if (ddlSubCity.Items.FindByValue(valueToSelect) != null)
                {
                    ddlSubCity.SelectedValue = valueToSelect;
                }

                ///department
                UserControl userControlDept = (UserControl)e.Item.FindControl(GridEditFormItem.EditFormUserControlID);

                DropDownList UddlDepartment = (userControlDept.FindControl("UddlDepartment") as DropDownList);

                string deptToSelect = DataBinder.Eval(e.Item, "DataItem.Department").ToString();

                if (UddlDepartment.Items.FindByValue(deptToSelect) != null)
                {
                    UddlDepartment.SelectedValue = deptToSelect;
                }

                //Update Disabled checkBox if its in Edit Mode.+
                if (e.Item is GridEditFormInsertItem || e.Item is GridDataInsertItem)
                {
                    // insert item
                    //do nothing.
                }
                else
                {
                    // edit item
                    //get the isEnabled status from ASpNetUsrs by the usercontext and assign teh value to user control
                    var UserContext = new RoleAdminEntities();
                    string UserNameinEdit = DataBinder.Eval(e.Item, "DataItem.AccountID").ToString();

                    CheckBox ChkIsDisabled = (userControlDept.FindControl("ChkDisable") as CheckBox);
                    bool IsEnabled = (bool)UserContext.AspNetUsers.FirstOrDefault(p => p.UserName == UserNameinEdit).isEnabled;
                    ChkIsDisabled.Checked = !IsEnabled;

                    UserContext.Dispose();
                }
            }
        }



        protected void RadGrid1_DeleteCommand(object sender, GridCommandEventArgs e)
        {

        }

        protected void RadGrid1_InsertCommand(object sender, GridCommandEventArgs e)
        {
            try
            {
                System.Threading.Thread.Sleep(1500);
                UserControl userControl = (UserControl)e.Item.FindControl(GridEditFormItem.EditFormUserControlID);

                var context = new hawic_dbEntities();
                tbl_Staff newEmployee = new tbl_Staff();

                Hashtable newValues = new Hashtable();

                newValues["Title"] = (userControl.FindControl("txtTitle") as TextBox).Text;
                newValues["FullName"] = (userControl.FindControl("txtFullName") as TextBox).Text;
                newValues["JobTitle"] = (userControl.FindControl("txtJobTitle") as TextBox).Text;
                newValues["PhoneNo"] = (userControl.FindControl("RdtxtPhone") as RadMaskedTextBox).Text;

                int DeptID = Convert.ToInt32((userControl.FindControl("UddlDepartment") as DropDownList).SelectedValue);
                newValues["Department"] = DeptID;
                newValues["SubCity"] = Convert.ToInt32((userControl.FindControl("UddlSubCity") as DropDownList).SelectedValue);
                //newValues["RegisterDate"] = (userControl.FindControl("HireDatePicker") as RadDatePicker).SelectedDate;                
                string userName = (userControl.FindControl("txtUserName") as TextBox).Text;
                string valEmail = (userControl.FindControl("txtEmail") as TextBox).Text;
                newValues["AccountID"] = userName;
                newValues["Email"] = valEmail;
                newValues["RegisterDate"] = DateTime.Now;
                string Password = (userControl.FindControl("txtPAss1") as TextBox).Text;
                bool isDisabled = (userControl.FindControl("ChkDisable") as CheckBox).Checked;


                foreach (DictionaryEntry entry in newValues)
                {
                    newEmployee.GetType().GetProperty(entry.Key.ToString()).SetValue(newEmployee, entry.Value);
                }

                //before saving the staff to the database. lets create the user account first. then retrive the ID and set to Employee
                //lets check if the username is not taken.
                tbl_Staff checkUserName = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName);
                if (checkUserName != null)// already taken
                {
                    throw new Exception("The username is already taken");
                }
                else
                {
                    string res = CreateUser(userName, valEmail, Password, isDisabled); //returns UserID
                    if (!res.StartsWith("ERROR"))
                    {
                        //before saving the staff to the database. lets create the user account first.                        
                        context.tbl_Staff.Add(newEmployee);
                        context.SaveChanges();
                        //after staff is added then, add RoleInfo in aspNetUserRoles for the staff.ID
                        string staffID = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).ID.ToString();

                        string RoleString = DeptID.ToString();
                        var contextUser = new RoleAdminEntities();
                        contextUser.AspNetUserRoles.Add(new AspNetUserRole { UserId = staffID, RoleId = RoleString }); //deptID as role
                        contextUser.SaveChanges();

                        context.Dispose(); contextUser.Dispose();

                        Label lbl = new Label();
                        lbl.Text = "Saved Succefully.";
                        lbl.CssClass = "bg-success";
                        RadGrid1.Controls.Add(lbl);
                        string AlertMessage = "Changes saved successfully";
                        RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";
                    }
                    else
                    {
                        throw new Exception(res);
                    }
                }
            }
            catch (Exception ex)
            {
                Label lblError = new Label();
                lblError.Text = "Unable to insert Employees. Reason: " + ex.Message;
                lblError.ForeColor = System.Drawing.Color.Red;
                RadGrid1.Controls.Add(lblError);

                e.Canceled = true;

                string AlertMessage = "(" + lblError.Text + ")";
                RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 2 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";
            }
        }
        protected string CreateUser(string paramUserName, string paramEmail, string paramPassword, bool isDisabled)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = paramUserName, Email = paramEmail };
            if (paramPassword.Length == 0)
                paramPassword = "12345678";

            IdentityResult result = manager.Create(user, paramPassword);
            if (result.Succeeded)
            {
                // For more information on how to enable account confirmation and password reset please visit https://go.microsoft.com/fwlink/?LinkID=320771
                //string code = manager.GenerateEmailConfirmationToken(user.Id);
                //string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                //manager.SendEmail(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                /*signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                //Get the user ID and assign a default role
                IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);*/
                var context = new RoleAdminEntities();
                string uId = context.AspNetUsers.FirstOrDefault(p => p.UserName == paramUserName).UserName.ToString();

                context.AspNetUsers.FirstOrDefault(p => p.UserName == paramUserName).isEnabled = !isDisabled;
                context.SaveChanges();
                context.Dispose();

                return uId;  //ID returned but nor used, can be used to set a role
            }
            else
            {
                // ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "notify()", true);  //FailureText.Text = "Invalid login attempt";
                return "ERROR: " + result.Errors.First().ToString();
            }
        }
        private void ResetPassword(string paramUserName, string newPassword)
        {
            // eski try to reset password using hasher and update
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var context = new RoleAdminEntities();

            AspNetUser user = context.AspNetUsers.First(p => (p.UserName == paramUserName));
            PasswordHasher ph = new PasswordHasher();
            string pwd = ph.HashPassword(newPassword);
            user.PasswordHash = pwd;
            context.SaveChanges();
            context.Dispose();

            /*var user = new ApplicationUser() { UserName = txtUsername.Text, Email = txtUsername.Text + "@hawi.com" };            
            IdentityResult result = manager.Create(user, txtPassword.Text);*/
        }

        protected void RadGrid1_SortCommand(object source, GridSortCommandEventArgs e)
        {
            /*GridTableView tableView = e.Item.OwnerTableView;
           
                e.Canceled = true;
                GridSortExpression expression = new GridSortExpression();
                expression.FieldName = "ID";
                if (tableView.SortExpressions.Count == 0 || tableView.SortExpressions[0].FieldName != "ID")
                {
                    expression.SortOrder = GridSortOrder.Descending;
                }
                else if (tableView.SortExpressions[0].SortOrder == GridSortOrder.Descending)
                {
                    expression.SortOrder = GridSortOrder.Descending;
                }
                else if (tableView.SortExpressions[0].SortOrder == GridSortOrder.Ascending)
                {
                    expression.SortOrder = GridSortOrder.None;
                }
                tableView.SortExpressions.AddSortExpression(expression);
                tableView.Rebind();*/

        }

        protected void btnsearch_Click(object sender, EventArgs e)
        {

            string name = "Dag";
            RadGrid1.MasterTableView.IsFilterItemExpanded = true;
            RadGrid1.MasterTableView.FilterExpression = "([FullName] = " + name + ")";
            GridColumn column = RadGrid1.MasterTableView.GetColumnSafe("FullName");
            column.CurrentFilterFunction = GridKnownFunction.Contains;
            column.CurrentFilterValue = name;

            /*RadGrid1.MasterTableView.Rebind();
            RadGrid1.Rebind();*/
            RadGrid1.DataBind();
        }
    }
}