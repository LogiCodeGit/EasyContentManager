<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TestUserControl1.ascx.vb" Inherits="EasyContentManager.WebUserControl1" %>
<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
</asp:ScriptManagerProxy>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
        <asp:CheckBox ID="CheckBox1" runat="server" Text="Check Control" 
            AutoPostBack="True" />
    </ContentTemplate>
</asp:UpdatePanel>




