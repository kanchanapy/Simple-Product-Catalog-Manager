<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="ContentManager.Admin.Products" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div align="right"><asp:Button ID="btnAdd" runat="server" Text="Add New Product" OnClick="btnAdd_Click" /></div><br />
    <asp:DataGrid ID="Grid" runat="server" PageSize="10" AllowPaging="True" DataKeyField="ProductId" 
        AutoGenerateColumns="False" CellPadding="4" GridLines="None" BorderStyle="Solid" BorderColor="SkyBlue"
        OnPageIndexChanged="Grid_PageIndexChanged" Width="100%">
        <Columns>
            <asp:BoundColumn HeaderText="Id" DataField="ProductId" HeaderStyle-Width="60"></asp:BoundColumn>
            <asp:BoundColumn HeaderText="Title" DataField="ProductName"></asp:BoundColumn>
            <asp:BoundColumn HeaderText="Price" DataField="Price"></asp:BoundColumn>         
            <asp:HyperLinkColumn HeaderText="" DataNavigateUrlField="ProductId" DataNavigateUrlFormatString="AddEditProducts.aspx?pid={0}" 
            Text="Edit"  HeaderStyle-Width="40" />             
        </Columns>     
        <AlternatingItemStyle BackColor="#EEEEEE" />
        <ItemStyle BackColor="#FFFFFF" ForeColor="#333333"  />
        <HeaderStyle BackColor="SteelBlue" ForeColor="White" /> 
        <PagerStyle BackColor="SteelBlue" ForeColor="White" HorizontalAlign="Center" Mode="NextPrev" NextPageText="Next" PrevPageText="Prev" />
    </asp:DataGrid>
    <br />
    <p align="center"><asp:LinkButton runat="server" ID="lnkBack" Text="Back to Categories" OnClick="lnkBack_Click" Visible="false" /></p>
</asp:Content>
