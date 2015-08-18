<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="ContentManager.Admin.Categories" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div align="right"><asp:Button ID="btnAdd" runat="server" Text="Add New Category" OnClick="btnAdd_Click" /></div><br />
    <asp:DataGrid ID="GridCategory" runat="server" AllowPaging="False" DataKeyField="CategoryId"
        AutoGenerateColumns="False" CellPadding="5" ForeColor="#333333" GridLines="None" BorderStyle="Solid" BorderColor="SkyBlue"
        OnPageIndexChanged="Grid_PageIndexChanged" OnDeleteCommand="GridCategory_Delete" OnItemCreated="GridCategory_ItemCreated" Width="100%" style="white-space:pre">
        <Columns>
            <asp:BoundColumn HeaderText="Id" DataField="CategoryId" HeaderStyle-Width="40"></asp:BoundColumn>
            <asp:BoundColumn HeaderText="Category Name" DataField="CatName"></asp:BoundColumn>   
            <asp:HyperLinkColumn HeaderText="" DataNavigateUrlField="CategoryId" DataNavigateUrlFormatString="Products.aspx?catid={0}" 
            Text="Manage Products"  HeaderStyle-Width="120" />   
            <asp:HyperLinkColumn HeaderText="" DataNavigateUrlField="CategoryId" DataNavigateUrlFormatString="AddEditCategory.aspx?catid={0}" 
            Text="Edit"  HeaderStyle-Width="40" />   
            <asp:ButtonColumn ButtonType="LinkButton" Text="Delete" CommandName="Delete" HeaderStyle-Width="40" />           
        </Columns>     
        <AlternatingItemStyle BackColor="#EEEEEE" />
        <ItemStyle BackColor="#FFFFFF" ForeColor="#333333"  />
        <HeaderStyle BackColor="SteelBlue" ForeColor="White" />        
    </asp:DataGrid>
</asp:Content>
