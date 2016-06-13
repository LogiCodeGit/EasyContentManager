<%
' Pagina contente il menù del Cliente.
'
' Parametri da specificare in entrata (Request):
'	<nessuno>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	06/05/2003

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Menù"

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

' Definizione del tasto di uscita dalla sessione
Dim sTitle = "", sCaption = ""
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sTitle = "Fine della sessione utente"
	sCaption = "Fine sessione"
Else
	sTitle = "End of the user session"
	sCaption = "End Session"
End If
Dim sEndSessionKey = "<input " & _site.Glb.GetParam("HTML_FIXED_EXIT_BUTTON_STYLE") & " type=button value=""<    " & sCaption & " "" onclick='javascript:window.location=""" & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_LOGOUT")) & """;' title=""" & sTitle & """>"

' Controlli 
' - Devono essere stati ini(zializzati i dati del client
'	come utente correntemente loggato
Dim bError = False
Dim objDSUser As OODBMSObjLib.clsDataSource = Session("g_objDSLoggedUser")
If objDSUser Is Nothing Then
	_site.Glb.RspErr("Il Cliente non risulta validato")
	bError = True
ElseIf objDSUser.RowInvalid Then 
	_site.Glb.RspErr("I dati del cliente non sono più disponibili")
	bError = True
ElseIf objDSUser.Table.ObjectName <> "Clienti" Then 
	_site.Glb.RspErr("I dati del cliente non sono validi")
End If

' In Caso di errore termina la pagina
If bError Then Response.End()
%>

<table id="Menu_Cliente"  width=80%>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td width="2%"></td><td colspan="3" title="Menù <%=objDSUser.Table.PresentationName%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+2 color=silver><i><b>&nbsp;Menù <%=objDSUser.Table.PresentationName%><font face="Arial" size=+1 color=lightgrey> -  <%=objDSUser.ColValueStr("Descrizione")%></font></i></b></font></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td colspan="2"></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td width="1%"></td>
<td>

<font face="Arial" size=+1>

<table width=100%>
<tr <%=_site.Glb.GetParam("HTML_FIXED_MAIN_FUNCTION_TR_TAGS")%>><td align=right>
<%
' Eventuale tasto di fine sessione
If Not objDSUser Is Nothing Then
	%>
		<%=sEndSessionKey%>
		<br>
<%	
End If
%>
</td></tr>
</table>
<br>
<table width=100%>

<%
' ***************************
' Menù profilo Cliente
' ***************************
If _site.DatLink.Database.UALevel = OODBMS_UserAccessLevel.odulUserAdmin Then
	%>

<tr><td width=45% valign=top>


</td></tr>

<%	
	' ***************************
	' Menù profilo ...
	' ***************************
ElseIf _site.DatLink.Database.UALevel = OODBMS_UserAccessLevel.odulUserDefault Then 
	%>

<tr><td width=45% valign=top>


</td></tr>

<%	
	' ***************************
	' Menù profilo Cliente
	' ***************************
ElseIf _site.DatLink.Database.UALevel = OODBMS_UserAccessLevel.odulUserGuest Then 
	%>

<tr><td width=45% valign=top>

<ul type="square">

<li>
<!-- FORM_SYS_FIELD_SEARCH_WITH_COMBO & "=Compagnia,Ramo" & "&" & FORM_SYS_FIELD_SEARCH_SEQUENCE & "=TargaRiferimento,Cliente,NumeroPolizza,DataEffetto,DataScadenza,Compagnia,Ramo,TipoMovimento -->
    <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Reti"%>">
    Reti</A>
</li>

<li>
    <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Dispositivi" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
    Dispositivi</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Impianti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Impianti</A>
</li>

<li>
    <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Porte" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
    Porte</A>
</li>

<li>
    <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Allarmi" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
    Allarmi</A>
</li>

<!--<li>
<A HREF="<=GetLinkBasket_Allarmi%>">
Carrello / Ordine</A>
</li>
<li>
<A HREF="<=_site.Glb.GetParam("PAGE_NAME_BASKET_CLIENTI")%>">
Ricerche</A>
</li>
<li>
<A HREF="<=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=LicenzeSoftware" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_VIEW & "&" & FORM_SYS_FIELD_READ_ONLY & "=True"%>">
Licenze Software</A>
</li>-->
</ul>

<hr>

<ul type="square">
<li>
<A HREF="<%=_site.Frm.ComposeFormRequestActionLink("Clienti", ACTION_EDIT, objDSUser.RowOID)%>">
Modifica Profilo Cliente</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Documenti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Documentazione / Allegati</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Agenda" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_SEARCH_SEQUENCE & "=Descrizione,Riferimento,DataScadenza,Urgente,Archiviato" & "&_SearchOrder_DefaultField=DataScadenza&_SearchOrder_DefaultFieldDesc=True&_SearchArchiviato=OFF"%>">
Agenda</A>
</li>

</ul>

<hr>

<!--
<ul type="square">
<li>
<A HREF="<=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Allarmi" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_VIEW & "&" & FORM_SYS_FIELD_READ_ONLY & "=True"%>">
Ordini/Acquisti Effettuati</A>
</li>
<li>
<A HREF="<=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=PagamentiCartaCredito" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_VIEW & "&" & FORM_SYS_FIELD_READ_ONLY & "=True"%>">
Pagamenti On-Line</A>
</li>
<li>
<A HREF="<=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=PagamentiCliente" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_VIEW & "&" & FORM_SYS_FIELD_READ_ONLY & "=True"%>">
Altri Pagamenti</A>
</li>
<li>
<A HREF="<=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Richieste" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_VIEW & "&" & FORM_SYS_FIELD_READ_ONLY & "=True"%>">
FAQ & Informazioni Richieste</A>
</li>
</ul>
-->

</td></tr>
<%	
	' ***************************
	' Altro
	' ***************************
Else
	%>
	Nessuna funzione abilitata.
<%	
	' ***************************
	' Fine tipi menù
	' ***************************
End If
%>

</table>

<table width=100%>
<tr <%=_site.Glb.GetParam("HTML_FIXED_MAIN_FUNCTION_TR_TAGS")%>><td align=left>
<%
' Eventuale tasto di fine sessione
If Not objDSUser Is Nothing Then
	%>
		<%=sEndSessionKey%>
<%	
End If
%>
</td></tr>
</table>


</font>

</td></tr>
</table>

</BODY>
</HTML>

