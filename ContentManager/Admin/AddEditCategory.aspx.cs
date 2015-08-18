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
    public partial class AddEditCategory : System.Web.UI.Page
    {
        private int catId;
        SqlConnection con;

        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["catid"] != null)
            {
                catId = int.Parse(Request.QueryString["catid"]);
            }
            else
            {
                btnAdd.Visible = true;
                btnUpdate.Visible = false;
                lblAddEdit.Text = "Add";
            }

            if (!Page.IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            con = new SqlConnection(conString.ConnectionString);
            con.Open();

            LoadParentCategories();

            if (catId > 0)
            {
                SqlCommand cmd = new SqlCommand("SELECT * FROM tblCategories WHERE CategoryId = " + catId, con);
                SqlDataReader reader = cmd.ExecuteReader();
                try
                {
                    reader.Read();
                    txtCatName.Text = reader["CatName"].ToString();
                    ddlParentCategory.SelectedValue = reader["ParentCategoryId"].ToString();
                }
                finally
                {
                    reader.Close();
                }
            }

            con.Close();
           
        }

        private void LoadParentCategories()
        {
            SqlCommand cmd = new SqlCommand("dbo.getOrderedCategoryList", con);
            cmd.CommandType = CommandType.StoredProcedure;
            if(catId > 0)
            {
                SqlParameter parameter = new SqlParameter();
                parameter.ParameterName = "@catid";
                parameter.SqlDbType = SqlDbType.Int;
                parameter.Direction = ParameterDirection.Input;
                parameter.Value = catId;
                cmd.Parameters.Add(parameter);
            }
            
            SqlDataReader reader = cmd.ExecuteReader();
            ddlParentCategory.DataSource = reader; 
            ddlParentCategory.DataTextField = "CatName";
            ddlParentCategory.DataValueField = "CategoryId";
            ddlParentCategory.DataBind();
            reader.Close();

            ddlParentCategory.Items.Insert(0, new ListItem("", "0"));
        }

        protected void ddlParentCategory_DataBound(object sender, EventArgs e)
        {
            for (int i = 1; i < ddlParentCategory.Items.Count; i++)
            {
                ddlParentCategory.Items[i].Text = Server.HtmlDecode(ddlParentCategory.Items[i].Text);
            }

        }

        protected void btnCancel_Click(Object sender, EventArgs e)
        {
            Response.Redirect("Categories.aspx");
        }

        protected void btnUpdate_Click(Object sender, EventArgs e)
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            con = new SqlConnection(conString.ConnectionString);

            SqlCommand cmd = new SqlCommand("UPDATE tblCategories SET CatName = @CatName, ParentCategoryId = @ParentCategoryId WHERE CategoryID = " + catId, con);

            CreateParametersList(cmd);

            // Open the connection and execute the reader.
            con.Open();

            cmd.ExecuteNonQuery();         

            con.Close();

            Response.Redirect("Categories.aspx");
        }

        protected void btnAdd_Click(Object sender, EventArgs e)
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            con = new SqlConnection(conString.ConnectionString);

            SqlCommand cmd = new SqlCommand("INSERT INTO tblCategories(CatName, ParentCategoryId) VALUES (@CatName,@ParentCategoryId);SELECT SCOPE_IDENTITY()", con);

            CreateParametersList(cmd);

            // Open the connection and execute the reader.
            con.Open();

            catId = int.Parse(cmd.ExecuteScalar().ToString());            

            con.Close();

            Response.Redirect("Categories.aspx");
        }

        private void CreateParametersList(SqlCommand cmd)
        {
            // Add the input parameter and set its properties.
            SqlParameter parameter = new SqlParameter();
            parameter.ParameterName = "@CatName";
            parameter.SqlDbType = SqlDbType.NVarChar;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = txtCatName.Text;
            cmd.Parameters.Add(parameter);

            parameter = new SqlParameter();
            parameter.ParameterName = "@ParentCategoryId";
            parameter.SqlDbType = SqlDbType.Int;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = ddlParentCategory.SelectedValue;
            cmd.Parameters.Add(parameter);
          
        }
       
    }
}