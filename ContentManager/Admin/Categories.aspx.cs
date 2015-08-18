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
    public partial class Categories : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                BindData();
            }
        }

        private void BindData()
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            SqlConnection con = new SqlConnection(conString.ConnectionString);

            //SqlCommand cmd = new SqlCommand("SELECT CategoryId, CatName FROM tblCategories", con);

            SqlCommand cmd = new SqlCommand("dbo.getOrderedCategoryList", con);
            cmd.CommandType = CommandType.StoredProcedure;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();

            da.Fill(ds);

            GridCategory.DataSource = ds;
            GridCategory.DataBind();
            
        }

        protected void Grid_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            GridCategory.CurrentPageIndex = e.NewPageIndex;
            BindData();
        }

        protected void GridCategory_ItemCreated(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton btn = (LinkButton)e.Item.Cells[4].Controls[0];
                btn.Attributes.Add("onclick", "return confirm('Are you sure you want to delete this, all sub categories will be deleted as well?')");
            }
        }

        protected void GridCategory_Delete(object source, DataGridCommandEventArgs e)
        {
            int catId = (int)GridCategory.DataKeys[(int)e.Item.ItemIndex];
            //Delete Category and its sub-categories and also remove the product references to the deleted categories
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            SqlConnection con = new SqlConnection(conString.ConnectionString);
            SqlCommand cmd = new SqlCommand("dbo.deleteCategory" , con);
            cmd.CommandType = CommandType.StoredProcedure;
            SqlParameter parameter = new SqlParameter();
            parameter.ParameterName = "@catid";
            parameter.SqlDbType = SqlDbType.Int;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = catId;
            cmd.Parameters.Add(parameter);

            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            //GridCategory.EditItemIndex = -1;
            BindData();
        }

        protected void btnAdd_Click(Object sender, EventArgs e)
        {
            Response.Redirect("AddEditCategory.aspx");
        }
       
    }
}