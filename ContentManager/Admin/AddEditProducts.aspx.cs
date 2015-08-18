using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;

namespace ContentManager.Admin
{
    public partial class AddEditProducts : System.Web.UI.Page
    {
        int productId, catId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["pid"] != null)
            {
                productId = int.Parse(Request.QueryString["pid"]);
                             
            }
            else
            {
                btnAdd.Visible = true;
                btnUpdate.Visible = false;
                lblAddEditProducts.Text = "Add";
            }

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
            SqlDataReader reader;
            SqlCommand cmd;

            cmd = new SqlCommand("dbo.getOrderedCategoryList", con);
            cmd.CommandType = CommandType.StoredProcedure;
            reader = cmd.ExecuteReader();
            lstCategory.DataSource = reader; 
            lstCategory.DataTextField = "CatName";
            lstCategory.DataValueField = "CategoryId";
            lstCategory.DataBind();
            reader.Close();

            if (productId > 0)
            {
                cmd = new SqlCommand("SELECT * FROM tblProducts WHERE ProductId = " + productId, con);
                reader = cmd.ExecuteReader();

                try
                {
                    reader.Read();
                    txtProductName.Text = reader["ProductName"].ToString();
                    txtDescription.Text = Server.HtmlDecode(reader["Description"].ToString());
                    txtPrice.Text = reader["Price"].ToString();
                    LoadSelectedCategories(reader["CategoryIds"].ToString());                    
                }
                finally
                {
                    reader.Close();                    
                }
            }
            else if (catId > 0)
            {
                lstCategory.SelectedValue = catId.ToString();
            }

            con.Close();
            
        }

        protected void btnCancel_Click(Object sender, EventArgs e)
        {
            if (catId > 0)
                Response.Redirect("Products.aspx?catid=" + catId);
            else
                Response.Redirect("Products.aspx"); 
        }

        protected void btnUpdate_Click(Object sender, EventArgs e)
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            SqlConnection con = new SqlConnection(conString.ConnectionString);

            SqlCommand cmd = new SqlCommand("UPDATE tblProducts SET ProductName = @ProductName, Description = @Description, Price = @Price, " +
                                            "CategoryIds = @CategoryIds, DateModified = getdate() WHERE ProductID = " + productId, con);

            createParametersList(cmd);

            // Open the connection and execute the reader.
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            if (catId > 0)
                Response.Redirect("Products.aspx?catid=" + catId);
            else
                Response.Redirect("Products.aspx"); 

        }

        protected void btnAdd_Click(Object sender, EventArgs e)
        {
            var conString = ConfigurationManager.ConnectionStrings["ProductsCatalogConn"];
            SqlConnection con = new SqlConnection(conString.ConnectionString);

            SqlCommand cmd = new SqlCommand("INSERT INTO tblProducts(ProductName,Description,Price,CategoryIds) VALUES (@ProductName,@Description,@Price,@CategoryIds)", con);

            createParametersList(cmd);

            // Open the connection and execute the reader.
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            if (catId > 0)
                Response.Redirect("Products.aspx?catid=" + catId);
            else
                Response.Redirect("Products.aspx");            
        }

        private void createParametersList(SqlCommand cmd)
        {
            // Add the input parameter and set its properties.
            SqlParameter parameter = new SqlParameter();
            parameter.ParameterName = "@ProductName";
            parameter.SqlDbType = SqlDbType.NVarChar;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = txtProductName.Text;
            cmd.Parameters.Add(parameter);

            parameter = new SqlParameter();
            parameter.ParameterName = "@Description";
            parameter.SqlDbType = SqlDbType.NText;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = Server.HtmlEncode(txtDescription.Text);
            cmd.Parameters.Add(parameter);

            parameter = new SqlParameter();
            parameter.ParameterName = "@Price";
            parameter.SqlDbType = SqlDbType.Decimal;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = txtPrice.Text;
            cmd.Parameters.Add(parameter);

            String strCategory = "";

            for (int i = 0; i < lstCategory.Items.Count; i++)
            {
                if(lstCategory.Items[i].Selected)
                {
                    strCategory += lstCategory.Items[i].Value + ";";
                }               
            }

            parameter = new SqlParameter();
            parameter.ParameterName = "@CategoryIds";
            parameter.SqlDbType = SqlDbType.NVarChar;
            parameter.Direction = ParameterDirection.Input;
            parameter.Value = strCategory;
            cmd.Parameters.Add(parameter);
       
        }

        protected void listCategory_DataBound(object sender, EventArgs e)
        {
            for(int i=0;i<lstCategory.Items.Count;i++)
            {
                 lstCategory.Items[i].Text = Server.HtmlDecode(lstCategory.Items[i].Text); 
            }   
            
        }

        private void LoadSelectedCategories(String strCategories)
        {
            if (strCategories != "")
            {
                for (int i = 0; i < lstCategory.Items.Count; i++)
                {
                    foreach (string category in strCategories.Split(';'))
                    {
                        if (category != lstCategory.Items[i].Value) continue;
                        lstCategory.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }       
    }
}