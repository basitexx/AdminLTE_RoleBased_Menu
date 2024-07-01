using System;
using System.Data;
using System.Collections;
using System.Web.UI;
using Telerik.Web.UI;

namespace ProjectMain.Admin
{
    public partial class EmployeeDetailsCS : System.Web.UI.UserControl
    {

        private object _dataItem = null;

        protected void Page_Load(object sender, System.EventArgs e)
        {
            // Put user code to initialize the page here
        }

        public object DataItem
        {
            get
            {
                return this._dataItem;
            }
            set
            {
                this._dataItem = value;
            }
        }

    }
}