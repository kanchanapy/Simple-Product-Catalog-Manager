using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContentManager.Admin
{
    public partial class Products : System.Web.UI.Page
    {
        int catId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["catid"] != null)
            {
                catId = int.Parse(Request.QueryString["catid"]);
                lnkBack.Visible = true;
            }
            
            if (!Page.IsPostBack)
            {
                BindData();
            }
        }

        private void BindData()
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            SqlConnection con = new SqlConnection(conString.ConnectionString);
            SqlCommand cmd;

            if (catId > 0)
            {
                cmd = new SqlCommand("dbo.getProductsbyCategory", con);
                cmd.CommandType = CommandType.StoredProcedure;

                SqlParameter parameter = new SqlParameter();
                parameter.ParameterName = "@catid";
                parameter.SqlDbType = SqlDbType.Int;
                parameter.Direction = ParameterDirection.Input;
                parameter.Value = catId;
                cmd.Parameters.Add(parameter);

            }
            else
                cmd = new SqlCommand("SELECT ProductId, ProductName, Price FROM tblProducts", con);
            
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();

            da.Fill(ds);

            
            if (ds.Tables[0].Rows.Count > 0)
            {
                Grid.DataSource = ds;
                Grid.DataBind();
            }
            else
            {
                Grid.Visible = false;
            }

        }

        protected void Grid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            Grid.CurrentPageIndex = e.NewPageIndex;
            BindData();
        }

        protected void btnAdd_Click(Object sender, EventArgs e)
        {
            if (catId > 0)
                Response.Redirect("AddEditProducts.aspx?catid=" + catId);
            else
                Response.Redirect("AddEditProducts.aspx");
        }

        protected void lnkBack_Click(Object sender, EventArgs e)
        {
            Response.Redirect("Categories.aspx");           
        }
    }
}