using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContentManager.Admin
{
    public partial class Admin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["AdminLogin"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnLogout_Click(Object sender, EventArgs e)
        {
            Session["AdminLogin"] = null;
            Response.Redirect("~/Default.aspx");
        }
    }
}