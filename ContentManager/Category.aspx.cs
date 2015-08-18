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
    public partial class Category : System.Web.UI.Page
    {
        int catId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["catid"] != null)
            {
                catId = int.Parse(Request.QueryString["catid"]);
            }            

            if (!Page.IsPostBack)
            {
                LoadData();
            }

        }

        private void LoadData()
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            SqlConnection con = new SqlConnection(conString.ConnectionString);
            con.Open();
            
            if (catId > 0)
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM tblCategories WHERE CategoryId = " + catId, con);
                SqlDataReader reader = cmd.ExecuteReader();
                try
                {
                    reader.Read();
                    lblCategory.Text = "You selected: " + reader["CatName"].ToString();                   
                }
                finally
                {
                    reader.Close();
                }
            }

            con.Close();

        }
    }
}