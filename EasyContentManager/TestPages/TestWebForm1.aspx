<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="TestWebForm1.aspx.vb" Inherits="EasyContentManager.TestWebForm1" %>
<%@ Register Src="~/Controls/TestUserControl1.ascx"  TagPrefix="uc" TagName="TestUC" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<%@ Register assembly="OO_DBMS Web Controls Library" namespace="OO_DBMS_Web_Controls_Library.CustomExtenders" tagprefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <LINK REL=stylesheet HREF="/Contents.css" type="text/css">
    <title></title>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
              <uc:TestUC ID="UC" runat="server" />
                dasjkdsdsakdnasljkdasjlk daskhdas hlkdashdlk sdlkashd hjks djlkashdlkas hdjlkas hdkashdksja dlks ljkash dlasjkd asljkd hasjld 
                <asp:Panel ID="Panel6" runat="server" 
                    style="position:relative; height: 144px; width: 346px;">
                    <asp:Panel ID="Panel8" runat="server" style="height: 100px; width: 100px; border-style:dashed">
                    </asp:Panel>
                    <asp:Panel ID="Panel7" runat="server" 
                        style="position:absolute; top: 0px; left: 0px; height: 45px; width: 47px;">
                        PROVA
                    </asp:Panel>
                </asp:Panel>

                <asp:CheckBox ID="CheckBox1" runat="server" Text="Check WebForm" />
                <asp:Panel ID="Panel2" runat="server" BorderStyle="Dashed" BorderWidth="1px" 
                    Height="127px" Width="100px">   
                    <asp:Panel ID="Panel3" Width="100%" runat="server" Height="20" BackColor="#FF3300">
                        <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                        <asp:Button ID="Button2" runat="server" Text="Button" 
                            style="position:absolute left:37px; top:165px" CssClass="LCDStyle"/>
                    </asp:Panel>
                </asp:Panel>
                
                <asp:Label ID="Label2" runat="server" CssClass="LCDStyle" Text="123456789"></asp:Label>
                
                <cc1:DragAndResizeExtender ID="Panel2_DragAndResizeExtender" runat="server" 
                    DragHandleID="Panel3" Enabled="True" TargetControlID="Panel2">
                </cc1:DragAndResizeExtender>
                <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
                <br />
                <asp:Table ID="Table1" runat="server">
                    <asp:TableRow runat="server">
                        <asp:TableCell runat="server"></asp:TableCell>
                    </asp:TableRow>
                </asp:Table>
                <asp:Panel ID="Panel5" runat="server">
                </asp:Panel>
                <table style="width:100%;">
                    <tr>
                        <td style="width:800; background-image: url('../public/Mappe/Immagine/Planimetria Generale.tif'); height: 800px; background-attachment: fixed; background-color: #F7FAFE;">
                            &nbsp;</td>
                    </tr>
                </table>
                <img alt="" src="" />
                <br />
                
                <asp:HyperLink ID="HyperLink1" runat="server" Target="_blank">HyperLink</asp:HyperLink>
                
                <asp:Image ID="Image1" runat="server" />
                <asp:Panel ID="Panel4" runat="server" 
                    BackImageUrl="../public/Mappe/Immagine/Planimetria Generale.tif" Height="557px">
                </asp:Panel>
                
                <br />


            </ContentTemplate>
        </asp:UpdatePanel>
    
    </div>
    <asp:Timer ID="Timer1" runat="server" Interval="5000" Enabled="False">
    </asp:Timer>
    </form>
</body>
</html>
