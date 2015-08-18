<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddEditCategory.aspx.cs" Inherits="ContentManager.Admin.AddEditCategory" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
     <div id="contentHeader">
        <h3><asp:Label ID="lblAddEdit" runat="server" Text="Edit" />&nbsp;Category</h3>
    </div>
    <table style="width: 80%" border="0" cellpadding="5" align="center">       
        <tr>
            <td>
                Category Title:<br />            
                <asp:TextBox ID="txtCatName" runat="server" MaxLength="63" Style="width: 90%" required />
            </td>
        </tr>  
         <tr>
            <td>Select Parent Category (Optional):<br />
                <asp:DropDownList ID="ddlParentCategory" OnDataBound="ddlParentCategory_DataBound" runat="server" Style="width: 90%" />                 
            </td>
        </tr>    
        <tr>            
            <td align="center">
                <asp:Button ID="btnUpdate" runat="server" Text="Update" OnClick="btnUpdate_Click" /><asp:Button
                    ID="btnAdd" runat="server" Text="Add" OnClick="btnAdd_Click" Visible="false" />
                <asp:Button UseSubmitBehavior="false" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
            </td>
        </tr>
    </table>
</asp:Content>
