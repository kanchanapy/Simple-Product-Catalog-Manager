﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminMain.aspx.cs" Inherits="ContentManager.Admin.AdminMain" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Instructions</h2>
<pre>This is the main page where authorized administrators can manage product catalog.

If you are not authorized, you will be redirected to the login page.
Please click on the relevant operations to manage site content.

Categories and products support create, update and delete operations.

When clicked on 'Manage Products' in a category, this will show all products from that

Each category can be assigned either a blank parent category,  which means it is the

Each product can be assigned to multiple categories, including category as well as its

Deleting a category, will ask for confirmation, and if a "yes" response is received, 


</asp:Content>