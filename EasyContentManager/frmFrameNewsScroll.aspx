<%
' Pagina di visualizzazione News e Informazioni di tipo fisso (senza scorrimento)
' contenute nell'oggetto dati memorizzato nella sessione <g_objNewsScroll> di
' tipo clsDataSource della tabella NotizieWeb
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	24/01/2004
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "News and Info - Scroll"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "FrameNewsScroll"

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

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
<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>"   id=<%=sFormName%>   name=<%=sFormName%>>
<%
' < Inclusione delle funzioni Form Java lato client >
%>
<%'UPGRADE_NOTE: Language element '#INCLUDE' was migrated to the same language element but still may have a different behavior. Copy this link in your browser for more: ms-its:C:\Programmi\ASP to ASP.NET Migration Assistant\AspToAspNet.chm::/1011.htm  %>
<%'UPGRADE_NOTE: The file 'OOLib/srcClientScriptForm.asp' was not found in the migration directory. Copy this link in your browser for more: ms-its:C:\Programmi\ASP to ASP.NET Migration Assistant\AspToAspNet.chm::/1003.htm  %>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<%

' Eventuale inizializzazione dell'applicazione 
If Not _site.InitApplicationObjects(Me,False,False) Then
	Response.Write( "Applicazione terminata o sessione scaduta.")
	Response.End	
End If

' Identifica le specifiche della tabella con le Notizie
' e tutti i dati relativi a notizie valide di tipo a 
' scorrimento
Dim objNews = Session("g_objNewsScroll")

' Solo se presenti
If Not objNews.DataEmpty Then
	%>
	  <table width="100%" border=0 cellspacing=0>
<%	
	' Cliclo di elaborazione notizie
	Dim nSwapColor = False
	While Not objNews.Eof
		If nSwapColor Then
			%>
			<tr><td width="100%" bgColor="#f0f0f0" style="FONT-SIZE: xx-small">
<%			
		Else
			%>
			<tr><td width="100%" style="FONT-SIZE: xx-small">
<%			
		End If
		%>
		<font face="Arial" color=black>
		<img src="images/SignalFilled.gif" border=0 width="6" height="9">&nbsp;
<%		
		'
		If objNews.ColValueStr("Collegamento") <> "" Then
			
			Dim sTitle = ""
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				sTitle = "Clicca per dettagli"
			Else
				sTitle = "Click for details"
			End If
			
			' Identifica l'URL del dispositivo
			Dim sUrl = "", sValue = objNews.ColValueStr("Collegamento")
			_site.Lib.GetEncodedURL(sValue, objNews.ColField("Collegamento").DataType, sValue, sUrl)
			
			%>
			<a href='javascript:OpenPopUpWindow( "<%=sUrl%>", "", 0, 0, true, true )' title="<%=sTitle%>">
<%			
		End If
		%>
		<font face="Arial" color=black>
		<i><%=objNews.FormattedColValue("DataInizioValidità")%>&nbsp;-&nbsp;<%=objNews.ColValueStr("Titolo")%></i>
		</font>
<%		
		If objNews.ColValueStr("Collegamento") <> "" Then
			%>			
			</a>
<%			
		End If
		%>
		<br><%=objNews.ColValueStr("TestoNotizia")%>
		</font>
		</td></tr>
<%		
		'
		objNews.RowNext()
		nSwapColor = Not nSwapColor
	End While
	%>
 	  </table>
<%	
End If
%>
</form>
</BODY>
</HTML>

