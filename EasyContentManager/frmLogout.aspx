<%
' Pagina di uscita utente.
' N.B.: Se l'utente non è loggato esce immediatamente ritornando all'applicazione
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	10/05/2003
'
' Parametri in entrata:
'	FORM_SYS_FIELD_RETURN_APP_URL = "ooSYS_ReturnAppURL"	(opzionale)
'		Eventuale URL della pagina da richiamare all'uscita
'		dal form.
'
' Azioni attivate da questa pagina (PAGE_NAME_LOGOUT):
'		- ACTION_LOGOUT, nome della tabella di contesto LOGIN_TABLE_NAME
'			Richiede il Logout, l'identificativo è memorizzato
'			nella variabile globale di sessione	<g_strUserID>
'			e il DataSource contente tutti i dati dell'utente
'			nell'oggetto globale <g_objDSLoggedUser>
'		
' N.B.: Le azioni vengono usate per richiedere l'indirizzo 
'		di destinazione mediante la funzione configurabile
'		<GetDestLocation()> definita in <modSiteAction.asp>

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Uscita"

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

<TITLE><%=PAGE_DESCRIPTION%> - <%=_site.Glb.GetParam("APP_NAME")%></TITLE>
</HEAD>
<BODY>

<%
' < Inclusione dell'intestazione >
%>
<!-- #INCLUDE FILE="CustomHeader.aspx" -->


<%
' Inizializzazione degli oggetti globali
If Not _site.Lib.InitializeGlobalObjects(Me) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Se nessun utente risulta loggato riparte con l'applicazione
Dim sTableName AS String
If Session("g_objDSLoggedUser") Is Nothing Then
	
	' Riavvia l'applicazione
	If Not _site.WriteClientDestinationAction(Page, _site.Glb.GetParam("PAGE_NAME_APP_START"), ACTION_FIRST_ACCESS, Session("g_strAppWorkSpace")) Then
		_site.Lib.EndApplication(True)
	End If
	
	' Se confermato effettua l'uscita
ElseIf _site.Glb.RequestField("LOGOUT") <> "" Then 
	
	' Effettua l'uscita dell'utente
	sTableName = Session("g_objDSLoggedUser").Table.ObjectName
	If _site.Lib.UserLogout("", False) Then
		
		' Aggiorna il frame dei links
		Response.Write("<script language=""javascript"">ReloadFrame(""Links"");</script>")
		
		' Effettua il Logout
		If Not _site.WriteClientDestinationAction(Page, _site.Lib.GetCurrentPageName(Me), ACTION_LOGOUT, sTableName) Then
			_site.Lib.EndApplication(True)
		End If
		
	End If
	
Else
	
	' Imposta il nome della tabella con i dati di accesso
	On Error Resume Next
	sTableName = UCase(Session("g_objDSLoggedUser").Table.PresentationName)
	If Err.Number <> 0 Then ' Evita problemi di riavvio dopo errore interno
		_site.Lib.EndApplication(True)
	End If
	On Error GoTo 0
	'
	Dim nCo AS integer, sCaptionName = ""
	For nCo = 1 To Len(CStr(sTableName))
		sCaptionName = sCaptionName & Mid(sTableName, nCo, 1) & " "
	Next 
	
	' Diciture in relazione alla lingua
	Dim sExit = "", sEnd = "", sMsg = ""
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sExit = "U S C I T A"
		sEnd = "FINE"
		sMsg = "Confermare l'uscita premendo il tasto FINE, tutte le transazioni non completate verranno annullate."
	Else
		sExit = "L O G O U T"
		sEnd = "END"
		sMsg = "Confirm the exit pressing the END key, all the transactions you not complete come cancelled."
	End If
	%>

<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id="<%=_site.Lib.GetCurrentPageName(Me)%>" name=<%=_site.Lib.GetCurrentPageName(Me)%>>
<%
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_RETURN_APP_URL)
%>
<table border="0" width="100%" height="100%" cellpadding=20>
  <tr>
    <td>&nbsp;</td>
    <td height="10%"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="25%">&nbsp;</td>
    <td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_COLOR_PANEL")%>" style="border: 1 dashed #C6C3C6">
      <table border="0" width="100%">
        <tr>
        <td colspan="2" bgcolor="#DEDFDE" style="border-style: solid; border-width: 1" bordercolor="blue">
          <p align="center"><b><font color=red><%=sExit%>&nbsp;&nbsp;-&nbsp;&nbsp;<%=sCaptionName%></font></b></p>
        </td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;
          </td>
        </tr>
        <tr>
          <td>
            <p align="right">
          </td>
          <td>
            <p align="center"><input <%=_site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE")%> type="submit" value=" <%=sEnd%> " name="LOGOUT">&nbsp;&nbsp;
            <%	_site.WriteFunctionKey_Exit(Page)%>
            </p>
          </td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;
          </td>
        </tr>
        <tr>
          <td colspan="2" bordercolor="#FFFFFF" style="border-style: solid; border-width: 1" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF">
          <p align="center"><%=sMsg%></td>
        </tr>
      </table>
    </td>
    <td width="25%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td height="40%">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>
<%	
End If
%>

</BODY>
</HTML>

