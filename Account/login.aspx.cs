using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Owin;
using ProjectMain.Models;

namespace ProjectMain.Account
{
    public partial class Login : System.Web.UI.Page
    {
        public string AlertMessage { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            bool val1 = (System.Web.HttpContext.Current.User != null) && System.Web.HttpContext.Current.User.Identity.IsAuthenticated;
            if (val1)
            {
                IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            System.Threading.Thread.Sleep(1000);
            // CreateUser();
            // Validate the user password
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signinManager = Context.GetOwinContext().GetUserManager<ApplicationSignInManager>();

            //do not allow not IsEnabled users to loggin at all.
            var UserContext = new RoleAdminEntities();
            AspNetUser usr = UserContext.AspNetUsers.FirstOrDefault(p => p.UserName == txtUsername.Text);
            if(usr != null)
            {
                if(usr.isEnabled == false)
                {
                    AlertMessage = "This account has been disabled.<br/>Please contact Administrator!";
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "notify('" + AlertMessage + "')", true);  //FailureText.Text = "Invalid login attempt";                   
                    return;
                }
            }           
            // This doen't count login failures towards account lockout
            // To enable password failures to trigger lockout, change to shouldLockout: true
            var result = signinManager.PasswordSignIn(txtUsername.Text, txtPassword.Text, ChkRemember.Checked, shouldLockout: false);
      
            switch (result)
            {
                case SignInStatus.Success:
                    //log loggedin time here/ retrive last time login and put it on session first.
                    Session["LastLogin"] = UserContext.AspNetUsers.FirstOrDefault(p => p.UserName == txtUsername.Text).LastLogIn;
                    UserContext.AspNetUsers.FirstOrDefault(p => p.UserName == txtUsername.Text).LastLogIn = DateTime.Now;
                    UserContext.SaveChanges(); UserContext.Dispose();
                    IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
                    break;
                case SignInStatus.LockedOut:
                    Response.Redirect("/Account/Lockout");
                    break;
                case SignInStatus.RequiresVerification:
                    Response.Redirect(String.Format("/Account/TwoFactorAuthenticationSignIn?ReturnUrl={0}&RememberMe={1}",
                                                    Request.QueryString["ReturnUrl"],
                                                    false),
                                      true);
                    break;
                case SignInStatus.Failure:
                default:
                    AlertMessage = "The Login has faild. Please try again";
                    ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "notify('"+ AlertMessage + "')", true);  //FailureText.Text = "Invalid login attempt";
                                                                                                               //ErrorMessage.Visible = true;
                    break;
            }           
        }

        protected void CreateUser()
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = txtUsername.Text, Email = txtUsername.Text + "@hawi.com" };
            IdentityResult result = manager.Create(user, txtPassword.Text);
            if (result.Succeeded)
            {
                // For more information on how to enable account confirmation and password reset please visit https://go.microsoft.com/fwlink/?LinkID=320771
                //string code = manager.GenerateEmailConfirmationToken(user.Id);
                //string callbackUrl = IdentityHelper.GetUserConfirmationRedirectUrl(code, user.Id, Request);
                //manager.SendEmail(user.Id, "Confirm your account", "Please confirm your account by clicking <a href=\"" + callbackUrl + "\">here</a>.");

                signInManager.SignIn(user, isPersistent: false, rememberBrowser: false);
                //Get the user ID and assign a default role
                IdentityHelper.RedirectToReturnUrl(Request.QueryString["ReturnUrl"], Response);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "text", "notify()", true);  //FailureText.Text = "Invalid login attempt";
            }
        }
    }
}
