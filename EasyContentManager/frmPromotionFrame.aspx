<%
' Pagina di anteprima delle porte.
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'	"Rete"	(opzionale)
'		Eventuale OID per filtro su rete
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Ports Promotion"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "Porte"

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

' Eventuale inizializzazione dell'applicazione 
If Not _site.InitApplicationObjects(Me,True,False) Then
	Response.End	
End If
'
Session("PAGE_FRAME_INFO_FILTER") = "Contents"

' Imposta eventuale linguaggio di presentazione
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	_site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))
End If

' Identifica eventuale filtro su rete
Dim objRete = Nothing, sFilter_Rete = ""
If _site.Glb.RequestField("Rete")<>"" Then
	With _site.DatLink.GetDataSource("Reti")
		If .FindRowOID(_site.Glb.RequestField("Rete"),True) Then
			
			' Rete identificato
			objRete = .ThisDS
			
			' Attiva il filtro sui dispositivi / porte
			sFilter_Rete = "Dispositivi.OID_Rete=" & objRete.RowOID

		End If
	End With
End If

' Identifica le specifiche della tabella porte
Dim objPorte = _site.DatLink.Table("Porte")

' Imposta per propagare il parametro "Rete" nelle
' chiamate successive
_site.Frm.WriteInheritHiddenField("Rete")

%>

<table width="100%" border=0 cellspacing=0>

<!-- Eventuali notizie -->
<tr><td width=2%></td>
<td>

<!--                                   -->
<!-- #INCLUDE FILE="LinksFixed.aspx" -->
<!--                                   -->

</td></tr>
</table>

<!--                        -->
<!-- PORTE IN ANTEPRIMA -->
<!--                        -->
<table width="100%" border=0 cellspacing=0 cellPadding=0>
<tr><td width=5></td>
<td>
	<table border=0 cellspacing=0 cellPadding=0>
    <td align=left width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>"><img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_LEFT_IMG_GRAY")%>"></td>
<%
Dim sCaption = "", sTitle = ""
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "Cerca " 
	If Not IsNothing(objRete) Then
		sCaption = sCaption & objRete.ColValueStr("Nome")
	Else
		sCaption = sCaption & "Porte"
	End If
	sTitle = "Accedi alla Ricerca"
Else
	sCaption = "Search " 
	If Not IsNothing(objRete) Then
		If objRete.ColValueStr("NomeInglese")= "" Then
			sCaption = sCaption & objRete.ColValueStr("Nome")
		Else
			sCaption = sCaption & objRete.ColValueStr("NomeInglese")
		End If
	Else
		sCaption = sCaption & "Ports"
	End If
	sTitle = "Acces to search"
End If
%>          
    <td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_BACK_COLOR_GRAY")%>" height="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_HEIGHT")%>" align=center>
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
	<!--<table id="tblSelections" style="display: none" width="100%" border=0 cellspacing=0 <%=_site.Glb.GetParam("HTML_FIXED_GRID_TABLE_TAGS")%>  style="border: 1 dashed #C6C3C6">-->
	<table id="tblSelections" width="100%" border=0 cellspacing=0 <%=_site.Glb.GetParam("HTML_FIXED_GRID_TABLE_TAGS")%>  style="border: 1 dashed #C6C3C6">
	<tr <%=_site.Glb.GetParam("HTML_FIXED_MAIN_FUNCTION_TR_TAGS")%> width="100%">
	<!--<tr style="background-color: #CECFFF; COLOR: #FF8A21" width="100%">-->
	<td width="1%" align=left>&nbsp;
	
	</td><td>
	<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sTitle = "Seleziona il dispositivo interessato"
Else
	sTitle = "Select for interesting sector"
End If

' Definisce il filtro sui dispositivi
Dim sWhere_Porte = ""
sWhere_Porte = "Anteprima"
If sFilter_Rete <> "" Then
	If sWhere_Porte <> "" Then sWhere_Porte = sWhere_Porte & " AND "
	sWhere_Porte = sWhere_Porte & sFilter_Rete
End If

' Include la ricerca per dispositivo (solo quelli in anteprima)
_site.Frm.WriteTableRowReferenceForSearch(objPorte.Ref("Dispositivo"), True, _
		"onchange='document.forms.item(0).submit();' title='" & sTitle & "'", _
		sWhere_Porte, False, "Nome")
	%>
	&nbsp;&nbsp;&nbsp;
	<%
' Include la ricerca per impianto (solo quelli in anteprima)
_site.Frm.WriteTableRowReferenceForSearch(objPorte.Ref("Impianto"), True, _
		"onchange='document.forms.item(0).submit();' title='" & sTitle & "'", _
		sWhere_Porte, False, "Nome")
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
_site.Frm.WriteTableRowInputFieldForSearch(objPorte.col("Nome"), True, sCaption, False)
	%>
	&nbsp;&nbsp;&nbsp;
	<%
' Visualizza il tasto per andare alle ricerche
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	_site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT STYLE=""COLOR: blue; FONT-SIZE: xx-small; FONT-FAMILY: Verdana,Helvetica; border: 1px solid #808080"" " & " NAME=""" & CONFIRM_SEARCH & """ VALUE=""" & CONFIRM_SEARCH & """ TITLE=""Aggiorna la ricerca dei dati"">")
Else
	_site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT STYLE=""COLOR: blue; FONT-SIZE: xx-small; FONT-FAMILY: Verdana,Helvetica; border: 1px solid #808080"" " & " NAME=""" & CONFIRM_SEARCH & """ VALUE=""" & CONFIRM_SEARCH_ENG & """ TITLE=""Refresh the search of the data"">")
End If
%>
	</td>
	</tr>
	</table>
<%

' -----------------------------------------------
' Identifica i parametri di ricerca in entrata
' per comporre la query (WHERE)
' -----------------------------------------------
Dim sSelOrder = _site.Glb.RequestField(FORM_SYS_FIELD_ORDER_FIELDS)		' Inizializza l'ordinamento
Dim objSearch = _site.Frm.ReadFormSearchCriterion(objPorte.ObjectName,sSelOrder)
Dim sWhere As String = objSearch.QueryString ' Legge la query di ricerca
Dim bUserSel As Boolean = IIF(sWhere<>"",True,False)

' Aggiunge eventuale filtro sul dispositivo
If sFilter_Rete <> "" Then
	If sWhere <> "" Then sWhere = sWhere & " AND "
	sWhere = sWhere & sFilter_Rete
End If

' Se è stata impostata la ricerca per descrizione
' annulla il filtro per anteprima
Dim sPromotion = ""
If Not objSearch.Exist("Nome") Then
	
	' solo quelli in anteprima
	If sWhere <> "" Then sWhere = sWhere & " AND "
	sWhere = sWhere & "Anteprima"
	'
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sPromotion = "in anteprima "
	Else
		sPromotion = "in preview "
	End If
	
End If

' Accede all'archivio porte 
    Dim objPorts As OODBMSObjLib.clsDataSource
If _site.Lib.GetDataSource(objPorts, "Porte", OODBMSObjLib.OODBMS_QueryOptions.oqoSimple, sWhere, "", "", 0) Then
	
	If objPorts.RowCount > 0 Then
		
		' Definizione del numero di porte per riga
		Dim nMaxRowElements = 3
		Dim nCountRowElements = 0
		
		' Tabella di presentazione degli porte
		%>
			<table border=0 cellspacing=30 width="100%" style="border-left: 1 dashed #C0C0C0">
			<tr>
<%		
		' Imposta l'oggetto di sessione con i dati degli
		' porte in modo che la pagina di presentazione
		' (di seguito inclusa) riesca a costruire la
		' vista per ogni elemento
		Session("objCurrentElement") = objPorts
		
		' Cliclo di presentazione degli porte in anteprima
		While Not objPorts.Eof
			
			' Eventuale inizializza una nuova riga
			If nCountRowElements = nMaxRowElements Then
				_site.Frm.WriteLn("</tr><tr>")
				nCountRowElements = 0
			End If
			nCountRowElements = nCountRowElements + 1
			
			' < Inclusione modulo di interfaccia per la libreria OODBMS_Form >
			    %>
				<td>
				    <!----- # INCLUDE FILE="ElementPresentation_Porta.asp" ---->
                    <iframe src="Pages\ViewPortElement.aspx?OID=<%=objPorts.RowOID%>" height=200></iframe>
				</td>
				<%			
			
			' Prossimo porta
			objPorts.RowNext()
		End While
		
		' Toglie l'oggetto globale di sessione non più necessario
		'UPGRADE_NOTE: Object Session() may not be destroyed until it is garbage collected. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1029"'
		Session("objCurrentElement") = Nothing
		%>
			</tr>
			</table>
<%		
		
	Else
		
		_site.Frm.WriteLn("<table border=0 cellspacing=0><tr><td width=""5%"">&nbsp;</td><td>")
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
			_site.Glb.RspMsg("Nessuna porta trovata...")
		Else
			_site.Glb.RspMsg("No ports found...")
		End If
		_site.Frm.WriteLn("</td></tr></table>")
	End If
End If
%>
</td>
</tr>
</table>

<%
' Se cambia il linguaggio aggiorna i frames
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	%>
	<script language="javascript">
		ReloadFrame("Title");
		ReloadFrame("Links");
		ReloadFrame("RightLinks");
	</script>
<%	
End If

' Se non sono stati trovati porte chiude subito 
' la ricerca
If Not IsNothing(objPorts) Then
	If objPorts.DataEmpty AndAlso Not bUserSel Then
%>
		<script language=javascript>
		tblSelections.style.display="none"; 
		</script>
<%
	End If
End If

%>

</form>
</BODY>
</HTML>

