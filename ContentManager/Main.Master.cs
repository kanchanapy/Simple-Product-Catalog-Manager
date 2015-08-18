using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContentManager
{
    public partial class Main : System.Web.UI.MasterPage
    {
        SqlConnection con;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                con = new SqlConnection();

                var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
                string strConnString = conString.ConnectionString;

                con.ConnectionString = strConnString;

                con.Open();

                SqlCommand cmd = new SqlCommand("SELECT CategoryId, CatName FROM tblCategories WHERE ParentCategoryId = 0", con);

                SqlDataReader reader = cmd.ExecuteReader();

                rptCategory.DataSource = reader; 
                rptCategory.DataBind();
                reader.Close();              

                con.Close();

            }

        }

        protected void lnkCategory_Command(Object sender, CommandEventArgs e)
        {
            Response.Redirect("Category.aspx?catid=" + e.CommandArgument);
        }

        protected void btnLogin_Click(Object sender, EventArgs e)
        {
            if (txtUsername.Text == "admin" && txtPassword.Text == "test123")
            {
                Session["AdminLogin"] = true;
                Response.Redirect("Admin/AdminMain.aspx");
            }
            else
            {
                lblErrLogin.Text = "Incorrect Username/Password!";
            }
        }
    }
}