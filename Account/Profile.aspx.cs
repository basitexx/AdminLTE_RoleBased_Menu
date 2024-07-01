using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using ProjectMain.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;

namespace ProjectMain.Account
{
    
    public partial class Profile : System.Web.UI.Page
    {        
        public string Photo;
        public string Jtitle;
        public string Department;
        public string Phone;
        public string City;
        public string Email;
        public string AlertMessage;
        public string LastLoginStr;
        public string RegisterDateStr;

        protected void Page_Load(object sender, EventArgs e)
        {
            //LogoutUser();
            if (!IsPostBack)
            {
                bool isAuth = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
                if (isAuth)
                {
                    PopulateInfo();
                    //inform signout
                    AlertMessage = "If you change Username or Password. you will need to login again!";                 
                    RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 1 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";
                }
            }            
        }

        private void PopulateInfo()
        {
            //because the username has been changed on the fly, the user needs to relogin.
            string userName = Context.User.Identity.GetUserName();

            var context = new hawic_dbEntities();
            int userID = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).ID;

            // then render the photo from db    
            byte[] PhotoByte = context.tbl_Staff.FirstOrDefault(p => p.ID == userID).Photo;
            if (PhotoByte != null)
                Photo = @"data:image / jpeg; base64," + Convert.ToBase64String(PhotoByte);
            else
                Photo = "/Content/img/no-photo-avatar.jpg";

            /// populate the form fields for editing purpose.
            //get the current staff
            tbl_Staff currentStaff = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName);

            //Personal
            txtTitle.Text = currentStaff.Title;
            txtFullName.Text = currentStaff.FullName;
            txtJobTitle.Text = currentStaff.JobTitle;
            SqlDataSourceDeptList.SelectParameters["deptId"].DefaultValue
                = currentStaff.Department.ToString();
            SqlDataSourceDeptList.DataBind();
            UddlDepartment.DataBind();
            SqlDataSourceSubCityList.DataBind();
            UddlSubCity.DataBind();
            //Address                                        
            UddlSubCity.SelectedValue = currentStaff.SubCity.ToString();

            RdtxtPhone.Text = currentStaff.PhoneNo;

            //Account
            txtUsername.Text = currentStaff.AccountID;
            var UserContext = new RoleAdminEntities();
            txtEmail.Text = UserContext.AspNetUsers.FirstOrDefault(p => p.UserName == userName).Email;

            string TmpLastLoginDate;
            if (Session["LastLogin"] != null)
                TmpLastLoginDate = Session["LastLogin"].ToString();
            else
                TmpLastLoginDate = DateTime.Now.ToString();

            string TmpRegisterDate =  currentStaff.RegisterDate.ToString();

            if (TmpLastLoginDate.Length > 0)
            {
                DateTime LastLoginDate = DateTime.Parse(TmpLastLoginDate);

                LastLoginStr = LastLoginDate.ToString("ddd, dd MMMM yyyy HH: mm");
            }
            if (TmpRegisterDate.Length > 0)
            {
                DateTime RegisterDate = DateTime.Parse(TmpRegisterDate);
                RegisterDateStr = RegisterDate.ToString("dddd, dd MMMM yyyy");
            }

            UserContext.Dispose();
            context.Dispose();

            //For About Me Box and Profile
            h3FullName.InnerText = currentStaff.FullName;
            pJtitle.InnerText = currentStaff.JobTitle;
            ((SiteMaster)this.Master).setNamePhoto();

            pTitle.InnerText = Jtitle = currentStaff.JobTitle;
            pDepartment.InnerText= Department = UddlDepartment.SelectedItem.Text;
            pPhone.InnerText = Phone = currentStaff.PhoneNo;
            pLocation.InnerText = "Addis Ababa, "+ UddlSubCity.SelectedItem.Text;
            pEmail.InnerText = txtEmail.Text;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            LogoutUser();
        }

        private void LogoutUser()
        {
            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            Response.Redirect("/Account/login");
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    //update Method.                 
                    bool logout = false; // used to logout the user if the username and password is updated.
                    System.Threading.Thread.Sleep(1500);

                    int UserID = SiteMaster.intUserID;
                    var context = new hawic_dbEntities();
                    tbl_Staff employeeToUpdate = context.tbl_Staff.FirstOrDefault(p => p.ID == UserID);
                    string OldUsername = employeeToUpdate.AccountID;

                    if (employeeToUpdate == null)
                    {
                        AlertMessage = "Unable to locate the Employee for updating.";
                        RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 2 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";                    
                    }
                    else
                    {
                        //update here.                    
                        employeeToUpdate.Title = txtTitle.Text;
                        employeeToUpdate.FullName = txtFullName.Text;
                        employeeToUpdate.JobTitle = txtJobTitle.Text;

                        employeeToUpdate.SubCity = Convert.ToInt32(UddlSubCity.SelectedValue);
                        employeeToUpdate.PhoneNo = RdtxtPhone.Text;

                        string userName = txtUsername.Text;
                        string email = txtEmail.Text;
                        string newPass = txtPass1.Text;
                        //Check if the username can be changed in identity
                        
                        tbl_Staff checkUserName = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName);

                        if (OldUsername != userName && checkUserName != null) // means someone elses is used
                        {
                            //then fire the exception
                            throw new Exception("The username is already taken");
                        }
                        else
                        {
                            if (userName != OldUsername) // means username is updated.
                                logout = true;

                            var Usercontext = new RoleAdminEntities();
                            AspNetUser UserTbl =
                                Usercontext.AspNetUsers.FirstOrDefault(p => p.UserName == OldUsername);// get the used to update

                            UserTbl.UserName = userName;
                            UserTbl.Email = email;
                            try
                            {
                                Usercontext.SaveChanges();
                                //Reset password if there is any
                                if (newPass.Length > 1) // there is password reset
                                {
                                    ResetPassword(userName, newPass);
                                    logout = true;
                                }
                                employeeToUpdate.AccountID = userName;                                

                                context.SaveChanges();
                                Usercontext.Dispose();
                                context.Dispose();
                                
                                AlertMessage = "Changes saved successfully";
                                RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 0 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";

                                if (logout == true)
                                {
                                    System.Threading.Thread.Sleep(2000);
                                    LogoutUser();
                                }
                                else
                                    PopulateInfo();
                            }
                            catch (Exception ex)
                            {
                                Usercontext.Dispose();
                                context.Dispose();
                                throw ex;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {

                    AlertMessage = ex.Message;
                    RadScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "showAlert(" + 2 + ",'" + AlertMessage + "');", true);  //FailureText.Text = "Invalid login attempt";
                }
            }
        }
           
        //method to change profile photo
        protected void hideButton_Click(object sender, EventArgs e)
        {
            if (FileUpload1.HasFile)
            {
                try
                {                   
                    byte[] bytes;
                    using (BinaryReader br = new BinaryReader(FileUpload1.PostedFile.InputStream))
                    {
                        bytes = br.ReadBytes(FileUpload1.PostedFile.ContentLength);
                    }

                    var context = new hawic_dbEntities();
                    int userID = Convert.ToInt32(SiteMaster.intUserID);
                    
                    tbl_Staff staff = context.tbl_Staff.FirstOrDefault(p => p.ID == userID);
                    staff.Photo = bytes;
                    staff.ContentType = FileUpload1.PostedFile.ContentType;
                    context.SaveChanges();                    

                    // then render the photo from db    
                    byte[] PhotoByte = context.tbl_Staff.FirstOrDefault(p => p.ID == userID).Photo;
                    if (PhotoByte != null)
                        Photo = @"data:image / jpeg; base64," + Convert.ToBase64String(PhotoByte);
                    else                         
                        Photo = "/Content/img/no-photo-avatar.jpg";

                    context.Dispose();
                    ((SiteMaster)this.Master).setNamePhoto();
                }
                catch (Exception) { }
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
    }
}