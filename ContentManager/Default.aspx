<%@ Page Title="" Language="C#" MasterPageFile="~/Main.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="ContentManager.Default" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="contentHeader"><h3>LATEST PRODUCTS</h3></div>
    <p>This is the main page where you can browse for products based on the categories on the right.
        Please share your experience and feedback to help us improve our site.
    </p>
    <p>What you see on the right is a ASP.NET repeater which is linked to SQL server DB table tblCategory.</p>
    <p>Please click on a category and view its corresponding description here.</p>
    <p>If you are the Database administrator, please click on link on top right corner and enter
        admin, test123 as your username/password.
    </p>
</asp:Content>
