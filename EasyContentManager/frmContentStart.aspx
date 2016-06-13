<%
    ' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->
<html>
<head>
<meta http-equiv="refresh" content="1;url=frmPromotionFrame.aspx">

<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
<title>HOME</title>

<SCRIPT ID=clientEventHandlersJS LANGUAGE=javascript>
<!--

function window_onload() {
	// Attiva la visualizzazione della scritta Loading...
	lblLoading.style.display="";
}

//-->
</SCRIPT>
<base target="_self">
</head>

<body LANGUAGE=javascript onload="return window_onload()">
<P>
<TABLE cellSpacing=1 cellPadding=1 width="100%" height="100%" border=0 style="WIDTH: 100%; HEIGHT: 100%">
  <TR>
    <TD style="border-right: 1 solid #C0C0C0">&nbsp;</TD>
    <TD valign=top align=right>
		<FONT size=4 color=silver ><EM>
        <BR><FONT 
      face=Arial><STRONG>&nbsp;</STRONG></FONT><FONT face=Arial><STRONG>&nbsp;
        &nbsp;&nbsp;<BR></STRONG></FONT></EM></FONT>
        <i><font color="#3333CC"><FONT size="7" face="Trebuchet MS">Easy Content Manager 
      </FONT><font face="Comic Sans MS">&nbsp;</font></font></i>
        <FONT size=2 face="Verdana"><BR></FONT><STRONG><FONT 
      color=blue><br>
        </FONT><font color="#3333CC">
      I tuoi contenuti sempre disponibili...</font></STRONG>      
        <FONT 
      color=blue>      
      &nbsp;</FONT></TD></TR>
  
  <TR>
    <TD style="border-right: 1 solid #C0C0C0">&nbsp;</TD>
	<td colspan=3 align=right xx-small" FONT-SIZE: valign="bottom">
	<font size="1"><i>Powered by <a href="http://www.logicode.it" target="_blank"> LogiCode srl</a></i></font>
	</td>
	</TR>
  <TR>
    <TD valign=center align=middle style="border-right: 1 solid #C0C0C0; border-top: 1 solid #C0C0C0">
      <FONT face=Verdana color=blue><U><EM><STRONG><%=_site.Glb.GetParam("COMPANY_NAME")%><BR></STRONG></EM></U><FONT 
      color=gray size=2><%=_site.Glb.GetParam("COMPANY_DESCRIPTION")%></FONT></FONT></TD>
      <TD style="border-top: 1 solid #C0C0C0">
		<table width="100%" border=0>
			<tr id=lblLoading style="display: none"><td align=center valign=middle>
				<font color=red><b><i>Loading...</i></b></font>
			</td></tr>
		</table>      
      </TD>

     </TR></TABLE>

</body>

</html>


