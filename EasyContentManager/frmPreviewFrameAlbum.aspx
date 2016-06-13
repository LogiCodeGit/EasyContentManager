<%
' Pagina di anteprima dell'album.
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	21/03/2004
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Album Preview"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "PreviewFrameAlbum"

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
<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id=<%=sFormName%> name=<%=sFormName%>>
<%

' Inizializzazione degli oggetti globali
If Not _site.InitApplicationObjects(Me,True,False) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Imposta eventuale linguaggio di presentazione
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	_site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))
End If

' Campi nascosti per la memorizzazione dei paramentri di spostamento
_site.Frm.WriteInheritHiddenField("PageNumber")

' Identifica i dati della tabella
Dim tblAlbum = _site.DatLink.Table("AlbumWeb")

' -----------------------------------------------
' Identifica i parametri di ricerca in entrata
' per comporre la query (WHERE)
' -----------------------------------------------
Dim sSelOrder = _site.Glb.RequestField(FORM_SYS_FIELD_ORDER_FIELDS)		' Inizializza l'ordinamento
Dim objSearch = _site.Frm.ReadFormSearchCriterion(tblAlbum.ObjectName,sSelOrder)
Dim strWhere = objSearch.QueryString ' Legge la query di ricerca

' Se � in corso lo scorrimento delle pagine
' senza una ricerca da parte dell'utente
' nasconde la ricerca in modo predefinito
Dim sHideSearch = ""
'If _site.Glb.RequestField("PageNumber") <> "" AND strWhere = "" Then
If strWhere = "" Then
	sHideSearch = " style=""display: none"" "
End If
'
Session("PAGE_FRAME_INFO_FILTER") = "Contents"
%>

	<!--                        -->
	<!-- RICERCHE SU ALBUM      -->
	<!--                        -->
	<table width="100%" border=0 cellspacing=0 cellPadding=0>
	<tr><td width=5></td>
	<td>
		<table border=0 cellspacing=0 cellPadding=0>
	    <td align=left width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>"><img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_LEFT_IMG_GRAY")%>"></td>
	<%
Dim sCaption = "", sTitle = ""
If CStr(Session("g_LocaleLanguage")) = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "Cerca Album"
	sTitle = "Accedi alla Ricerca"
Else
	sCaption = "Search Album"
	sTitle = "Acces to search"
End If
%>          
	    <td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_BACK_COLOR_GRAY")%>" height="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_HEIGHT")%>" align=left>
	    <A title="<%=sTitle%>" href='javascript:ShowHideSelections();'>
	    <font size=1 color="white"><b>&nbsp;<%=sCaption%>&nbsp;</b></font>
	    </a>
	    </td>
	    <td align=right width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>"><img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_RIGHT_IMG_GRAY")%>"></td>
	    </table>
	<script language="javascript">
	function ShowHideSelections()
	{
		if(tblSelections.style.display=="") 
			tblSelections.style.display="none"; 
		else 
			tblSelections.style.display=""; 
		return;
	}
	</script>    
	</td>
	</tr>
	<tr><td width=5></td>
	<td>
	<table id="tblSelections" width="100%" border=0 cellspacing=0 <%=_site.Glb.GetParam("HTML_FIXED_GRID_TABLE_TAGS")%>  style="border: 1 dashed #C6C3C6" <%=sHideSearch%>>
	<tr <%=_site.Glb.GetParam("HTML_FIXED_MAIN_FUNCTION_TR_TAGS")%> width="100%">
	<!--<tr style="background-color: #CECFFF; COLOR: #FF8A21" width="100%">-->
	<td width="1%" align=left>
	&nbsp;
	</td><td <%=_site.Glb.GetParam("HTML_FIXED_GRID_TABLE_TAGS")%>>
		<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sTitle = "Seleziona l'argomento interessato"
Else
	sTitle = "Select for interesting topic"
End If

' Include la ricerca per dispositivo (solo quelli in anteprima)
_site.Frm.WriteTableRowReferenceForSearch(tblAlbum.Ref("Argomento"), True, _
			"onchange='document.forms.item(0).submit();' title='" & sTitle & "'", _
			"Ambito=1 Or Ambito=9", False)
	%>
	&nbsp;&nbsp;&nbsp;
	<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "Ricerca per Parola"
Else
	sCaption = "Keyword Search"
End If
	%>
	&nbsp;&nbsp;&nbsp;<font size=-2><%=sCaption%></font>&nbsp;
	<%
' Include la ricerca per descrizione porta
_site.Frm.WriteTableRowInputFieldForSearch(tblAlbum.Col("Testo"), True, sCaption, False)
	%>
	&nbsp;&nbsp;&nbsp;
	<%
' Visualizza il tasto per andare alle ricerche
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	_site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT STYLE=""COLOR: blue; FONT-SIZE: xx-small; FONT-FAMILY: Verdana,Helvetica; border: 1px solid #808080"" " & " NAME=""" & CONFIRM_SEARCH & """ VALUE=""" & CONFIRM_SEARCH & """ TITLE=""Aggiorna la ricerca"">")
Else
	_site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT STYLE=""COLOR: blue; FONT-SIZE: xx-small; FONT-FAMILY: Verdana,Helvetica; border: 1px solid #808080"" " & " NAME=""" & CONFIRM_SEARCH & """ VALUE=""" & CONFIRM_SEARCH_ENG & """ TITLE=""Refresh the search"">")
End If
%>
		</td>
		</tr>
		</table>
		<br>

	<!-- FINE RICERCA -->

<%

' Identifica il numero massimo di elementi in relazione
' alla pagina corrente
Dim nPage = 0
If IsNumeric(_site.Glb.RequestField("PageNumber")) Then
	
	' Numero della pagina
	nPage = CInt(_site.Glb.RequestField("PageNumber"))
	
	' Se la stringa di selezione non corrisponde		
	' quella precedente ignora l'eventuale 
	' selezione della pagina
	On Error Resume Next
	If CStr(Session("QueryString")) <> strWhere Then
		nPage = 0
	End If
	On Error GoTo 0
	Session("QueryString") = strWhere
	
End If

' Identifica le specifiche della tabella con le Notizie
' e tutti i dati relativi a notizie valide di tipo a 
' scorrimento
If strWhere <> "" Then strWhere = strWhere & " AND "
With tblAlbum
	strWhere = strWhere & .GetFieldQueryCriteria("DataInizioValidit�", CDate(Today), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchLessOrEqual)
	strWhere = strWhere & " AND (" & .GetFieldQueryCriteria("DataFineValidit�", CDate(Today), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchGreaterOrEqual) & " OR " & .GetFieldQueryCriteria("DataFineValidit�", System.DBNull.Value) & ")"
	'strWhere = strWhere & " AND Scorrimento"
End With
'If Session("PAGE_FRAME_INFO_FILTER") > "" Then
'	strWhere = strWhere & " AND CorniceDestinazione='" & Session("PAGE_FRAME_INFO_FILTER") & "'"
'End If
'
    Dim objAlbum As OODBMSObjLib.clsDataSource, sUrl = ""
If Not _site.Lib.GetDataSource(objAlbum, "AlbumWeb", False, strWhere, "Priorit� DESC,DataInserimento DESC", "", (CShort(nPage / _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION")) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION") + _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION") + 1) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")) Then
	_site.Frm.Break_FormConstruction()
End If

' Se non si tratta della prima pagina si posiziona
If nPage > 0 Then
	On Error Resume Next
	objAlbum.Recordset.AbsolutePosition = (nPage * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")) + 1
	On Error GoTo 0
End If

If objAlbum.Eof Then
	' Assicura che sia visibile la ricerca
	%>
		<script language=javascript>
			tblSelections.style.display="";
		</script>
		<br><i>Nessuna presentazione trovata...</i>
<%	
	' Solo se presenti
Else
	%>
	  <table width="100%" border=0 cellspacing=0 style="border: 1 dotted #C0C0C0">
<%	

	' Dimensione delle immagini in anteprima
	Dim nDefImageWidth = 100
	Dim nDefImageHeight = 0		' In proporzione alla larghezza

	' Cliclo di elaborazione notizie
	Dim nSwapColor = False
	Dim nCount = 0
	While Not objAlbum.Eof And nCount < _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")
		%>
<%		
		If nSwapColor Then
			%>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>" ><td height=10 colspan=2 ></td></tr>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>"  style="CURSOR: HAND"
				onClick='javascript:window.location.href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_SHOW_FRAME_ALBUM"))%>?OID=<%=objAlbum.RowOID%>"'
				onMouseOver="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_SELECTED")%>'"
				onMouseOut="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>'">
			<td align=center valign=top width="5%" style="FONT-SIZE: xx-small">
<%			
		Else
			%>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>"><td height=10 colspan=2 ></td></tr>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>"  style="CURSOR: HAND"
				onClick='javascript:window.location.href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_SHOW_FRAME_ALBUM"))%>?OID=<%=objAlbum.RowOID%>"'
				onMouseOver="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_SELECTED")%>'"
				onMouseOut="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>'">
			<td align=center valign=top width="5%" style="FONT-SIZE: xx-small">
<%			
		End If
		
		' Identifica eventuale immagine relativa alla notizia
		Dim sValue = objAlbum.FormattedColValue("Immagine")
		' Identifica eventuale immagine relativa all'argomento
		If sValue = "" Then sValue = objAlbum.GetReference("Argomento").FormattedColValue("ImmagineAnteprima")
		'
		If sValue <> "" Then
			
			' Identifica la risorsa e l'URL in relazione
			' al sito Web corrente
			_site.Lib.GetEncodedURL(sValue, objAlbum.ColField("Immagine").DataType, sValue, sUrl, True)
			%>
				<img src="<%=sUrl%>" border=0  WIDTH=<%=nDefImageWidth%>>&nbsp;
<a>
<%			
		End If
		'
		If nSwapColor Then
			%>
			</td><td>
<%			
		Else
			%>
			</td><td>
<%			
		End If
		%>

		<font face="Arial" color=black>
<%		
		'sInfoLink = objAlbum.ColValueStr("Collegamento")
		Dim sInfoLink = ""
		If sInfoLink <> "" Then
			
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				sTitle = "Clicca per dettagli"
			Else
				sTitle = "Click for details"
			End If
			
			' Identifica l'URL del dispositivo
			sValue = sInfoLink
			_site.Lib.GetEncodedURL(sValue, objAlbum.ColField("Collegamento").DataType, sValue, sUrl)
			%>
			<a href='javascript:OpenPopUpWindow( "<%=sUrl%>", "", 0, 0, true, true )' title="<%=sTitle%>">
<%			
		End If
		%>
		<b<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TITLE_TAGS")%>>
		<%
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian _
					Or objAlbum.ColValueStr("TitoloInglese") = "" Then
			Response.Write( objAlbum.ColValueStr("Titolo") )
		Else
			Response.Write( objAlbum.ColValueStr("TitoloInglese") )
		End If
		%></b>
		<br><i><font size=-2><%=objAlbum.FormattedColValue("DataInizioValidit�")%></font></i>
		</p>
		</font>
<%		
		If objAlbum.ColValueStr("Collegamento") <> "" Then
			%>			
			</a>
<%			
		End If
		
		Dim sText = ""
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian _
					Or objAlbum.ColValueStr("TestoInglese") = "" Then
			sText = objAlbum.ColValueStr("Testo")
		Else
			sText = objAlbum.ColValueStr("TestoInglese")
		End If
		If Len(sText) > _site.Glb.GetParam("HTML_FIXED_PREVIEW_PREVIEW_TEXT_MAX_LEN") + 4 Then
			sText = Left(sText, _site.Glb.GetParam("HTML_FIXED_PREVIEW_PREVIEW_TEXT_MAX_LEN"))
		End If
		sText = sText & " ..."
		%>

		<%=sText%>
		</td></tr>
<%		
		If nSwapColor Then
			%>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>"><td height=10 colspan=2 style="border-bottom: 1 dotted #C0C0C0"></td></tr>
<%			
		Else
			%>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>"><td height=10 colspan=2 style="border-bottom: 1 dotted #C0C0C0"></td></tr>
<%			
		End If
		
		objAlbum.RowNext()
		nSwapColor = Not nSwapColor
		nCount = nCount + 1
		
	End While
	%>
		</table>
<%	
End If
'
If objAlbum.RowCount > _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") Then
	%>
	<br>
	<br>
	<center>
	<table><tr><td>
	Pagina&nbsp;
<%	
	' Eventuale ritorno a pagina precedente
	If nPage > 0 Then
		Response.Write("<a href='javascript:PagePrevious();'>[&lt;]</a>")
	End If
	
	' Ciclo di impostazione delle pagine selezionabili
	Dim nStart = CShort(nPage / _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION") - 1) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION")
	If nStart < 1 Then nStart = 1
	If nStart + _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") <= nPage Then nStart = nStart + (_site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") / 2)
	Dim nEnd = CShort(nPage / _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION") + 1) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION")
	'If nEnd>_site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") And nEnd-_site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") > nPage Then nEnd = nEnd - (_site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")/2)
	Dim nCo As Integer
	For nCo = nStart To nEnd
		If nCo = nPage + 1 Then
			Response.Write("&nbsp;<b>" & nCo & "</b>")
		Else
			Response.Write("&nbsp;<a href='javascript:PageSeek(" & (nCo - 1) & ");'>" & (nCo) & "</a>")
		End If
		If nCo * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") >= objAlbum.RowCount Then Exit For
	Next 
	
	' Eventuale ritorno a pagina precedente
	If (nPage + 1) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") < objAlbum.RowCount Then
		Response.Write("&nbsp;<a href='javascript:PageNext();'>[&gt;]</a>")
	End If
	
	%>
	</td></tr></table>
	</center>
<%	
End If
%>	
<script language=javascript>
function PageNext()
{
	GetFormControl("PageNumber").value="<%=(nPage + 1)%>";
	document.forms.item(0).submit();
}
function PagePrevious()
{
	GetFormControl("PageNumber").value="<%=(nPage - 1)%>";
	document.forms.item(0).submit();
}
function PageSeek(nPageNumber)
{
	GetFormControl("PageNumber").value=nPageNumber;
	document.forms.item(0).submit();
}
</script>

</form>
</BODY>
</HTML>

