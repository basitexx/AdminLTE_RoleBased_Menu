using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(ProjectMain.Startup))]
namespace ProjectMain
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
