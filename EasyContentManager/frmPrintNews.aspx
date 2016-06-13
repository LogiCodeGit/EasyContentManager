<%
' VISUALIZZAZIONE DI UNA NOTIZIA PER LA STAMPA
'
' N.B.: Questa pagina inizializza automaticamente l'applicazione se non
'		è stata prima richiamata frmAppStart.asp
'
' Parametri:
'	FORM_SYS_FIELD_RETURN_APP_URL = "ooSYS_ReturnAppURL"	(opzionale)
'		Eventuale URL della pagina da richiamare all'uscita
'		dall'applicazione.
'		Impostare "_this_" per indicare di ritornare alla
'		pagina chiamante.
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'
' Per visualizzare la notizia è necessario specificare:
'	<OID>
'		Object ID del record relativo all'porta
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	05/04/2004

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "News Print"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

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

<!----------->
<!-- FORM --->
<!----------->
<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>">

<%
' Inizializzazione degli oggetti globali
If Not _site.InitApplicationObjects(Me,True,False) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Imposta eventuale linguaggio di presentazione
_site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))

' Imposta eventuale URL della pagina di uscita
If _site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) <> "" Then
	If _site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) = "_this_" Then
		_site.Lib.SetReturnAppURL(_site.GetCurrentURL(Page))  'Request.ServerVariables.Item("HTTP_REFERER"))
	Else
		_site.Lib.SetReturnAppURL(_site.URLParamDecode(_site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL)))
	End If
End If

' La pagina prevede la possibilità di specificare 
' l'OID della notizia
' (vedi specifiche nella pagina)
    Dim objNews As OODBMSObjLib.clsDataSource, vntOID = _site.Glb.RequestField("OID")
If vntOID = "" Then
	
	' Identifica l'OID della prima notizia dispobibile
	If _site.Lib.GetDataSource(objNews, "NotizieWeb", OODBMSObjLib.OODBMS_QueryOptions.oqoSimple, "", "", "", 1) Then
		If Not objNews.DataEmpty Then
			vntOID = objNews.RowOID
		End If
	End If
	
Else
	
	' Identifica la notizia mediante l'OID 
	If _site.Lib.GetDataSource(objNews, "NotizieWeb", OODBMSObjLib.OODBMS_QueryOptions.oqoSimple, "NotizieWeb.OID=" & vntOID, "", "", 0) Then
		If objNews.DataEmpty Then vntOID = ""
	End If
	
End If
'
If vntOID = "" Then
	
	_site.Glb.RspErr("Notizia non identificata, potrebbe essere stata elminata.")
	_site.WriteFunctionKey_Exit(Page)
	Response.End()
	
Else
	
	' Imposta l'oggetto di sessione con i dati degli
	' elementi in modo che la pagina di presentazione
	' (di seguito inclusa) riesca a costruire la
	' vista per ogni elemento
	Session("objCurrentElement") = objNews
	
	' Include la pagina di presentazione della notizia	
	Dim bEnablePrintKey = False
	%>
		<!-- #INCLUDE FILE="ElementPresentationNews.aspx" -->
<%	
End If
%>
<script language=javascript>
	// Attiva la stampa
	window.document.execCommand("Print");
</script>
</form>
</BODY>
</HTML>

