using Microsoft.AspNet.Identity;
using ProjectMain.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ProjectMain
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        public string pageValue { set; get; }
        public string userID { set; get; }
        public static string FullName { set; get; }
        public static string JobTitle { set; get; }
        public static string LastLogin { set; get; }
        public static string RegisterDate { set; get; }
        public static int intUserID { set; get; }
        public static string Photo { set; get; }

        protected void Page_Load(object sender, EventArgs e)
        {
            //LogoutUser();
            /*  if (IsPostBack)
              {*/
            //If there is no signed in user, resirect to login

            bool isAuth = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
            if (isAuth)
            {
                InitializePage();
            }
            else
            {
                Response.Redirect("/Account/login");
            }
            //}
        }

        private void LogoutUser()
        {
            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            Response.Redirect("/Account/login");
        }

        private void InitializePage()
        {
            //authenticated
            string uId = Context.User.Identity.GetUserId();
            string userName = Context.User.Identity.GetUserName();
            //
            //In this case we take userID from staff table based on accountID;
            var context = new hawic_dbEntities();
            userID = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).ID.ToString();
            FullName = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).FullName.ToString();
            JobTitle = context.tbl_Staff.FirstOrDefault(p => p.AccountID == userName).JobTitle.ToString();           

            intUserID = Convert.ToInt32(userID);

            // then render the photo from db    
            byte[] PhotoByte = context.tbl_Staff.FirstOrDefault(p => p.ID == intUserID).Photo;
            if (PhotoByte != null)
                Photo = @"data:image / jpeg; base64," + Convert.ToBase64String(PhotoByte);
            else
                Photo = "/Content/img/no-photo-avatar.jpg";

            linkName.InnerText = FullName;
            imageProfile.Src = Photo;

            context.Dispose();
            // ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "populateMenu('" + userID + "')", true);  //FailureText.Text = "Invalid login attempt";
        }

        public  void setNamePhoto()
        {
            InitializePage();           
        }
        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Context.GetOwinContext().Authentication.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            Response.Redirect("/Account/login");



        }
    }
}
