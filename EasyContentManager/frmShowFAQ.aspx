<%
' VISUALIZZAZIONE DI UNA FAQ
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
Const PAGE_DESCRIPTION As String = "FAQ View"

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
<base target="_blank">
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

' Eventuale filtro su frame di destinazione
Session("PAGE_FRAME_INFO_FILTER") = ""

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
    Dim objFAQ As OODBMSObjLib.clsDataSource, vntOID = _site.Glb.RequestField("OID")
If vntOID = "" Then
	
	' Identifica l'OID della prima notizia dispobibile
	If _site.Lib.GetDataSource(objFAQ, "Richieste", OODBMSObjLib.OODBMS_QueryOptions.oqoSimple, "", "", "", 1) Then
		If Not objFAQ.DataEmpty Then
			vntOID = objFAQ.RowOID
		End If
	End If
	
Else
	
	' Identifica la notizia mediante l'OID 
	If _site.Lib.GetDataSource(objFAQ, "Richieste", OODBMSObjLib.OODBMS_QueryOptions.oqoSimple, "Richieste.OID=" & vntOID, "", "", 0) Then
		If objFAQ.DataEmpty Then vntOID = ""
	End If
	
End If
'
If vntOID = "" Then
	
	_site.Glb.RspErr("FAQ non identificata, potrebbe essere stato elminata.")
	_site.WriteFunctionKey_Exit(Page)
	Response.End()
	
Else
	
	' Imposta l'oggetto di sessione con i dati degli
	' elementi in modo che la pagina di presentazione
	' (di seguito inclusa) riesca a costruire la
	' vista per ogni elemento
	Session("objCurrentElement") = objFAQ
	
	' Imposta per visualizzare il tasto di stampa
	Dim bEnablePrintKey = True
	
	' Include la pagina di presentazione della notizia	
	%>
		<!-- #INCLUDE FILE="ElementPresentationFAQ.aspx" -->
<%	
End If

' Identifica eventuali notizie correlate
Dim strWhere = ""
If Not objFAQ.ReferenceEmpty("Dispositivo") Then
    strWhere = objFAQ.ColRefQueryString("Dispositivo")
Else    'If Not objFAQ.ReferenceEmpty("Argomento") Then
    'If Len(strWhere)>0 Then strWhere = strWhere & " OR "
    strWhere = objFAQ.ColRefQueryString("Argomento")
End If
If Len(strWhere)>0 Then strWhere = "(" & strWhere & ") AND "
strWhere = strWhere & objFAQ.RowOIDQueryString( ,  , OODBMSObjLib.OODBMS_MatchCriteria.omcMatchNotEqual)
'
If Not _site.Lib.GetDataSource(objFAQ, "Richieste", False, strWhere, "", "", 0) Then
	_site.Frm.Break_FormConstruction()
End If

' Solo se presenti
If Not objFAQ.DataEmpty Then
	
	' Impostazione delle diciture in relazione alla lingua
	Dim sRelate = ""
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sRelate = "FAQ Correlate"
	Else
		sRelate = "Relate FAQ"
	End If
	
	%>
		<br><font color=RoyalBlue><b><%=sRelate%></b></font><br>

<%	
	' Lista delle notizie correlate
	While Not objFAQ.Eof
		%>
			(<%=objFAQ.FormattedColValue("DataInserimento")%>) -
			<a href='javascript:window.location.href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_SHOW_FRAME_FAQ"))%>?OID=<%=objFAQ.RowOID%>"' target="_self">
				<%=Left(objFAQ.ColValueStr("Richiesta"),100)%>...
			</a><br>
<%		
		objFAQ.RowNext()
	End While
	
End If
%>
<br>

</form>
</BODY>
</HTML>

