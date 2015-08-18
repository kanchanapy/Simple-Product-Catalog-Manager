<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AddEditProducts.aspx.cs" Inherits="ContentManager.Admin.AddEditProducts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="contentHeader">
        <h3><asp:Label ID="lblAddEditProducts" runat="server" Text="Edit" />&nbsp;Product</h3>
    </div>
    <table style="width: 80%" border="0" cellpadding="5" align="center">        
        <tr>
            <td>Title: <br />           
                <asp:TextBox ID="txtProductName" runat="server" MaxLength="100" Style="width: 90%" required/>
            </td>
        </tr>
          <tr>
            <td>
                Description: <br />           
                <asp:TextBox ID="txtDescription" TextMode="MultiLine" Rows="3" runat="server" MaxLength="156" Style="width: 90%" ValidateRequestMode="Disabled" />
            </td>
        </tr>
        <tr>
            <td>
                Price: <br />           
                <asp:TextBox ID="txtPrice" TextMode="Number" runat="server" MaxLength="10" Style="width: 90%" step="0.01" required />
            </td>
        </tr>        
        <tr>
            <td>Select Categories: <br />
                <asp:ListBox ID="lstCategory" SelectionMode="Multiple" OnDataBound="listCategory_DataBound" Rows="15" runat="server" Style="width: 90%; white-space:pre" />                 
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
