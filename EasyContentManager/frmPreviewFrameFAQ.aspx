<%
' Pagina di anteprima delle richieste (FAQ).
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	13/04/2010
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'	<MaxFAQ>		(opzionale)
'		Numero massimo di notizie visualizzabili, se specificato
'		identifica le più recenti
'	
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "FAQ Preview"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "PreviewFrameFAQ"

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
<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id=<%=sFormName%> name=<%=sFormName%> target="<%=FRAME_CONTENT_PAGES%>">
<%

' Inizializzazione degli oggetti globali
If Not _site.InitApplicationObjects(Me,True,False) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If
'
Session("PAGE_FRAME_INFO_FILTER") = "Contents"

' Imposta eventuale linguaggio di presentazione
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	_site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))
End If

' Campi nascosti per la memorizzazione dei paramentri di spostamento
_site.Frm.WriteInheritHiddenField("PageNumber")

' Identifica i dati della tabella
Dim tblFAQ = _site.DatLink.Table("Richieste")

' -----------------------------------------------
' Identifica i parametri di ricerca in entrata
' per comporre la query (WHERE)
' -----------------------------------------------
Dim sSelOrder = _site.Glb.RequestField(FORM_SYS_FIELD_ORDER_FIELDS)		' Inizializza l'ordinamento
Dim objSearch = _site.Frm.ReadFormSearchCriterion(tblFAQ.ObjectName,sSelOrder)
Dim strWhere = objSearch.QueryString ' Legge la query di ricerca
If objSearch.Exist("Richiesta") Then
	' Aggiunge anche la ricerca per risposta
	With objSearch.Item("Richiesta")
		strWhere = strWhere & " OR " & _
			tblFAQ.Columns.Item("Risposta").QueryString( .Value, True, .MatchCriteria, .ValueTo)
	End With
End If

' Se è stato specificato un numero massimo di notizie
' non attiva la possibilità di ricercare
Dim sCaption = "", sTitle = "", sHideSearch = ""
If _site.Glb.RequestField("MaxFAQ") = "" Then

	' Se è in corso lo scorrimento delle pagine
	' senza una ricerca da parte dell'utente
	' nasconde la ricerca in modo predefinito
	'If _site.Glb.RequestField("PageNumber") <> "" AND strWhere = "" Then
	If strWhere = ""  Then
		sHideSearch = "style=""display: none"""
	End If
	%>

		<!--                        -->
		<!-- RICERCHE SU NOTIZIE    -->
		<!--                        -->
		<table width="100%" border=0 cellspacing=0 cellPadding=0>
		<tr><td width=5></td>
		<td>
			<table border=0 cellspacing=0 cellPadding=0>
			<td align=left width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>">
			<img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_LEFT_IMG_GRAY")%>"></td>
		<%
	If CStr(Session("g_LocaleLanguage")) = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sCaption = "Cerca FAQ"
		sTitle = "Accedi alla Ricerca"
	Else
		sCaption = "Search FAQ"
		sTitle = "Acces to search"
	End If
	%>          
			<td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_BACK_COLOR_GRAY")%>" height="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_HEIGHT")%>" align=left>
			<A title="<%=sTitle%>" href='javascript:ShowHideSelections();'>
			<font size=1 color="white"><b>&nbsp;<%=sCaption%>&nbsp;</b></font>
			</a>
			</td>
			<td align=right width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>">
			<img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_RIGHT_IMG_GRAY")%>"></td>
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

	' Include la ricerca per argomento
	_site.Frm.WriteTableRowReferenceForSearch(tblFAQ.Ref("Argomento"), True, _
			"onchange='document.forms.item(0).submit();' title=""" & sTitle & """", _
			"Ambito=2 Or Ambito=9", False)
		%>
		&nbsp;&nbsp;&nbsp;
			<%
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sTitle = "Seleziona il dispositivo interessato"
	Else
		sTitle = "Select for interesting product"
	End If

	' Include la ricerca per dispositivo
	_site.Frm.WriteTableRowReferenceForSearch(tblFAQ.Ref("Dispositivo"), True, _
			"onchange='document.forms.item(0).submit();' title=""" & sTitle & """", _
			"", False)
		%>
		&nbsp;
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
	_site.Frm.WriteTableRowInputFieldForSearch(tblFAQ.Col("Richiesta"), True, sCaption, False)
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

		<!-- FINE RICERCA NOTIZIE -->

<%
End If

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
'If strWhere <> "" Then strWhere = strWhere & " AND "
'With tblFAQ
'	strWhere = strWhere & .GetFieldQueryCriteria("DataInizioValidità", CDate(Today), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchLessOrEqual)
'	strWhere = strWhere & " AND (" & .GetFieldQueryCriteria("DataFineValidità", CDate(Today), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchGreaterOrEqual) & " OR " & .GetFieldQueryCriteria("DataFineValidità", System.DBNull.Value) & ")"
'	'strWhere = strWhere & " AND Scorrimento"
'End With
'If Session("PAGE_FRAME_INFO_FILTER") > "" Then
'	strWhere = strWhere & " AND CorniceDestinazione='" & Session("PAGE_FRAME_INFO_FILTER") & "'"
'End If

' Include solo le richieste pubbliche
' e con risposta
If strWhere <> "" Then strWhere = strWhere & " AND "
With tblFAQ
	strWhere = strWhere & "(" & .GetFieldQueryCriteria("Risposta", DBNull.Value, True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchNotEqual) & _
	                        " OR " & .GetFieldQueryCriteria("Collegamento", DBNull.Value, True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchNotEqual) & ")"
	strWhere = strWhere & " AND Pubblica"
End With

'
Dim objFAQ As OODBMSObjLib.clsDataSource, sUrl = "", nMaxItemsPage = _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")
Dim nRequestMax = 0, nMaxItems = (CShort(nPage / _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION")) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION") + _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_PAGES_SELECTION") + 1) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")
If _site.Glb.RequestField("MaxFAQ") <> "" Then
	' Restringe il numero massimo di elementi se specificato nei parametri
	nRequestMax = CInt(_site.Glb.RequestField("MaxFAQ"))
	If nRequestMax < nMaxItems Then
		nMaxItems = nRequestMax
		nMaxItemsPage = nMaxItems
	End If
End If
'
If Not _site.Lib.GetDataSource(objFAQ, "Richieste", False, strWhere, "DataInserimento DESC", "", nMaxItems) Then
	_site.Frm.Break_FormConstruction()
End If

' Se non si tratta della prima pagina si posiziona
If nPage > 0 Then
	On Error Resume Next
	objFAQ.Recordset.AbsolutePosition = (nPage * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE")) + 1
	On Error GoTo 0
End If

If objFAQ.Eof Then
	' Assicura che sia visibile la ricerca
	%>
		<script language=javascript>
			try
			{
				//if( FieldFormExist("tblSelections") )
					tblSelections.style.display="";
			}
			catch( e ){	}	
		</script>
		<br><i>Nessuna FAQ trovata...</i>
<%	
	' Solo se presenti
Else
	%>
	  <table width="100%" border=0 cellspacing=0 style="border: 1 dotted #C0C0C0">
<%	

	' Dimensione delle immagini in anteprima
	Dim nDefImageWidth = 70
	Dim nDefImageHeight = 0		' In proporzione alla larghezza

	' Cliclo di elaborazione notizie
	Dim nSwapColor = False
	Dim nCount = 0
	While Not objFAQ.Eof And nCount < nMaxItemsPage
		%>
<%		
		If nSwapColor Then
			%>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>" ><td height=10 colspan=2 ></td></tr>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>" style="CURSOR: HAND"
				onClick='javascript:GetContentFrame().location.href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_SHOW_FRAME_FAQ"))%>?OID=<%=objFAQ.RowOID%>"'
				onMouseOver="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_SELECTED")%>'"
				onMouseOut="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_ALTERNATE")%>'">
			<td align=center valign=top width="5%" style="FONT-SIZE: xx-small">
<%			
		Else
			%>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>"><td height=10 colspan=2 ></td></tr>
			<tr bgColor="<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>" style="CURSOR: HAND"
				onClick='javascript:GetContentFrame().location.href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_SHOW_FRAME_FAQ"))%>?OID=<%=objFAQ.RowOID%>"'
				onMouseOver="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR_SELECTED")%>'"
				onMouseOut="this.style.background='<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TEXT_BG_COLOR")%>'">
			<td align=center valign=top width="5%" style="FONT-SIZE: xx-small">
<%			
		End If
		
		' Identifica eventuale immagine relativa alla notizia
		Dim sValue = ""     'objFAQ.FormattedColValue("Immagine")
		' Identifica eventuale immagine relativa all'argomento o al dispositivo
		If sValue = "" AndAlso Not objFAQ.ReferenceEmpty("Dispositivo") Then 
		    With objFAQ.GetReference("Dispositivo")
		        sValue = RTrim(.FormattedColValue("ImmagineAnteprima"))
		        If sValue = "" Then sValue = RTrim(.FormattedColValue("Immagine"))
		    End With
		End If
		If sValue = "" AndAlso Not objFAQ.ReferenceEmpty("Argomento") Then sValue = objFAQ.GetReference("Argomento").FormattedColValue("ImmagineAnteprima")
		'
		If sValue <> "" Then
			' Identifica la risorsa e l'URL in relazione
			' al sito Web corrente
			_site.Lib.GetEncodedURL(sValue, OODBMSObjLib.OODBMS_DataType.odbdImageFileEmbedded, sValue, sUrl)
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
		Dim sInfoLink = objFAQ.ColValueStr("Collegamento")
		If sInfoLink <> "" Then
			
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				sTitle = "Clicca per dettagli"
			Else
				sTitle = "Click for details"
			End If
			
			' Identifica l'URL del dispositivo
			sValue = sInfoLink
			_site.Lib.GetEncodedURL(sValue, objFAQ.ColField("Collegamento").DataType, sValue, sUrl)
			%>
			<a href='javascript:OpenPopUpWindow( "<%=sUrl%>", "", 0, 0, true, true )' title="<%=sTitle%>">
<%			
		End If
		%>
		<b<%=_site.Glb.GetParam("HTML_FIXED_PREVIEW_TITLE_TAGS")%>>
		<%
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
			Response.Write( objFAQ.ColValueStr("Argomento") & " / " & objFAQ.ColValueStr("Dispositivo") )
		Else
			Response.Write( objFAQ.ColValueStr("Argomento") & " / " & objFAQ.ColValueStr("Dispositivo") )
			'Response.Write( objFAQ.ColValueStr("Argomento.DescrizioneInglese") & " / " & objFAQ.ColValueStr("Dispositivo") )
		End If
		%></b>
		<br><i><font size=-2><%=objFAQ.FormattedColValue("DataInserimento")%></font></i>
		</p>
		</font>
<%		
		If objFAQ.ColValueStr("Collegamento") <> "" Then
			%>			
			</a>
<%			
		End If
		
		Dim sText = ""
		'If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian _
		'		Or objFAQ.ColValueStr("Richiesta") = "" Then
		'	sText = objFAQ.ColValueStr("Richiesta")
		'Else
			sText = objFAQ.ColValueStr("Richiesta")
		'End If
		'		
		If Len(sText) > _site.Glb.GetParam("HTML_FIXED_PREVIEW_PREVIEW_TEXT_MAX_LEN") + 4 Then
			sText = Left(sText, _site.Glb.GetParam("HTML_FIXED_PREVIEW_PREVIEW_TEXT_MAX_LEN"))
		    sText = sText & " ..."
		End If

		Dim sTextResp = ""
		'If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian _
		'		Or objFAQ.ColValueStr("Risposta") = "" Then
		'	sTextResp = objFAQ.ColValueStr("Risposta")
		'Else
			sTextResp = objFAQ.ColValueStr("Risposta")
		'End If
		'		
		If Len(sTextResp) > _site.Glb.GetParam("HTML_FIXED_PREVIEW_PREVIEW_TEXT_MAX_LEN") + 4 Then
			sTextResp = Left(sTextResp, _site.Glb.GetParam("HTML_FIXED_PREVIEW_PREVIEW_TEXT_MAX_LEN"))
		    sTextResp = sTextResp & " ..."
		End If

		%>
		<font color="#009AFF">
		<%=sText%>
		</font>
        <br />
        <hr />
        <b><%=IIF(_site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian,"Risposta","Response")%>:</b>
        <br /><br />
		<%=sTextResp%>
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
		
		objFAQ.RowNext()
		nSwapColor = Not nSwapColor
		nCount = nCount + 1
		
	End While
	%>
		</table>
<%	
End If
'
If objFAQ.RowCount > _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") _
				And nRequestMax = 0 Then
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
		If nCo * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") >= objFAQ.RowCount Then Exit For
	Next 
	
	' Eventuale ritorno a pagina precedente
	If (nPage + 1) * _site.Glb.GetParam("HTML_FIXED_PREVIEW_MAX_ELEMENTS_PER_PAGE") < objFAQ.RowCount Then
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

