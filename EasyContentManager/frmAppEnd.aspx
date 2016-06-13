<%

' Pagina di chiusura dell'applicazione.
' Se richiamata come finestra PopUp si chiude automaticamente
' altrimenti ritorna alla pagina iniziale che ha richiamato
' l'applicazione (vedi <g_strCallerAppPageURL>)
'
' Parametri da specificare in entrata (Request):
'	<nessuno>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	14/05/2003

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "End"

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
<META NAME="GENERATOR" Content="LogiCode Easy Content Manager">
<TITLE><%=PAGE_DESCRIPTION%> - <%=_site.Glb.GetParam("APP_NAME")%></TITLE>
</HEAD>
<BODY>
<%

Response.Write(_site.Glb.GetParam("APP_NAME") & "<BR>")
Response.Write("<BR>")
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	Response.Write("chiusura...<BR>")
Else
	Response.Write("closing...<BR>")
End If

' Inizializzazione degli oggetti globali
If _site.Lib.InitializeGlobalObjects(Me) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(False)
End If
'
_site.Glb.RspMsg("")
_site.Glb.RspMsg("Ok.")
'_site.Glb.RspMsg("")
'_site.Glb.RspMsg("--")
'_site.Glb.RspMsg("")

' Elimina la var. di sessione per segnalare che 
' la gestione dei Frames è stata conclusa
If Session("ooSYS_FramesStarted") <> "" Then
    Session("ooSYS_FramesStarted") = Nothing
End If

' Eventuale inizializzazione dell'applicazione 
'If Not _site.InitApplicationObjects(Me,True,True) Then
'	Response.Write( "Impossibile riavviare l'applicazione o sessione scaduta.")
'	Response.End	
'End If

%>

</BODY>

<SCRIPT LANGUAGE="JavaScript">
<!--
	// Chiude la finestra
	if( typeof( window.opener ) != "undefined" && window.opener != null )
		window.close();
	else
	{
		var wnd = window;
		ReloadFrame("Title");
		ReloadFrame("Links");
		ReloadFrame("RightLinks");
		
<%

' N.B.:
' Dopo la chiusura della sessione inibisce
' il ritorno a qualsiasi pagina di servizio (frm)
' perchè la sessione va inizializzata di nuovo
If Session("g_strReturnAppURL") <> "" _
			AndAlso Left(Session("g_strReturnAppURL"),3) <> "frm" _
			AndAlso Instr(Session("g_strReturnAppURL"), "/frm" ) = 0 Then
	If Session("g_strReturnAppFrame") <> "" Then
            Response.Write("if(ExistFrame(""" & Session("g_strReturnAppFrame") & """))" & vbCrLf)
            Response.Write("	wnd = _site.GetFrame(""" & Session("g_strReturnAppFrame") & """); " & vbCrLf)
	End If
%>
		wnd.location = "<%=Session("g_strReturnAppURL")%>";
<%
Else
%>
		window.location = "frmAppStart.aspx";
<%
End If
%>		
	}
//-->
</SCRIPT>
<%
If Session("g_strReturnAppURL") <> "" Then
		_site.Lib.EndApplication(True)
End If
%>

</HTML>

