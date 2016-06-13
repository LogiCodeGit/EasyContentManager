<%
' Pagina contente il menù dell'Operatore.
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
' - Devono essere stati inizializzati i dati dell'operatore
'	come utente correntemente loggato
Dim bError = False
Dim objDSUser As OODBMSObjLib.clsDataSource = Session("g_objDSLoggedUser")
If objDSUser Is Nothing Then
	_site.Glb.RspErr("L'operatore non risulta validato")
	bError = True
ElseIf objDSUser.RowInvalid Then
	_site.Glb.RspErr("I dati dell'operatore non sono più disponibili")
	bError = True
ElseIf objDSUser.Table.ObjectName <> "Operatori" Then 
	_site.Glb.RspErr("I dati dell'operatore non sono validi")
End If

' In Caso di errore termina la pagina
If bError Then Response.End()
%>

<table id="Menu_Operatore"  width=80%>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td width="2%"></td><td colspan="3" title="Menù <%=objDSUser.Table.PresentationName%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+2 color=silver><i><b>&nbsp;Menù <%=objDSUser.Table.PresentationName%><font face="Arial" size=+1 color=lightgrey> -  <%=objDSUser.ColValueStr("Nome")%></font></i></b></font></td></tr>
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
' Menù profilo Amministratore
' ***************************
If _site.DatLink.Database.UALevel = OODBMS_UserAccessLevel.odulUserAdmin Then
	%>

<tr><td width=45% valign=top>


<ul type="square">
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Operatori" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Operatori</A>
</li>
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Contatti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Contatti / Team</A>
</li>
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Clienti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Clienti / Registrazioni</A>
</li>

</ul>

<hr>

<ul type="square">

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=ImmaginiTestata" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=Immagine"%>">
Immagini Testata / Headers</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Argomenti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=ImmagineAnteprima"%>">
Attività / Argomenti</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=LavoriEffettuati" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=Immagine"%>">
Lista Lavori / Track record</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=NotizieWeb" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=Immagine"%>">
News / Media / Pubblicazioni</A>
</li>

</ul>
   
<hr>

<ul type="square">

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Settori" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=ImmagineAnteprima"%>">
Settori</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=TipiNotizia" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=ImmagineAnteprima"%>">
Tipi Notizie</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Documenti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Documentazione / Allegati</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Contenuti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=Immagine"%>">
Contenuti / Testi</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Collegamenti" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Collegamenti / Links</A>
</li>

</ul>

</td><td width=10%>&nbsp;</td>
<td width=45% valign=top>


<ul type="square">
<!--
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=TipiDocumento" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Tipi Documento</A>
</li>
-->

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Richieste" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
FAQ / Richieste</A>
</li>

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=Agenda" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT & "&" & FORM_SYS_FIELD_SEARCH_SEQUENCE & "=Descrizione,Riferimento,DataScadenza,Urgente,Archiviato" & "&_SearchOrder_DefaultField=DataScadenza&_SearchOrder_DefaultFieldDesc=True&_SearchArchiviato=OFF"%>">
Agenda</A>
</li>

</ul>

<hr>

<ul type="square">
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=" & _site.DatLink.Database.GetSysTableName_LoggedUsers & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Accessi Utenti</A>
</li>
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=" & _site.DatLink.Database.GetSysTableName_LockedRows & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Blocco / Sblocco Dati</A>
</li>
</ul>

<hr>


<ul type="square">
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=" & _site.DatLink.Database.GetSysTableName_Parameters & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Parametri di Sitema</A>
</li>
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_APP_CHECK_UPDATE"))%>">
Controllo / Aggiornamento Applicazione</A>
</li>
</ul>

<hr>

<ul type="square">
<li>
<A HREF="<%=_site.Frm.ComposeFormRequestActionLink("Operatori", ACTION_EDIT, objDSUser.RowOID)%>">
Modifica Profilo</A>
</li>
<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CUSTOM_PAGE_MANAGER")) & "?" & FORM_SYS_FIELD_PAGE_NAME & "=" & _site.Glb.GetParam("CUSTOM_PAGE_SUBDIR") & "/WhoWeAre.htm"%>">
Pagina 'CHI SIAMO'</A>
</li>
</ul>

<hr>
<ul type="square">

        <li>
        <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=TabellePersonali" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
        CONFIGURA TABELLE PERSONALI</A>
        </li>

        <li>
        <A HREF="<%="ProcessDestLocation.aspx" & "?" & FORM_SYS_FIELD_DATA_PATH & "=TabellePersonali" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=CheckUpdateStruct"%>&<%=FORM_SYS_FIELD_RETURN_APP_URL%>=<%_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_MENU_OPERATORE"))%>">
        AGGIORNA TABELLE PERSONALI</A>
        </li>
</ul>

<%
    ' Gestione delle tabelle personali
    Dim objMyTbls As OODBMSObjLib.clsDataSource = Nothing
    If _site.Lib.GetDataSource(objMyTbls, "TabellePersonali") AndAlso objMyTbls.RowCount > 0 Then
        
%>

<hr>
<ul type="square">

    <%
        While Not objMyTbls.EOF
            ' Solo se visibile nel menù principale
            If objMyTbls.ColValueBool("Visibile") Then
    %>
        <li>
        <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=" & EasyContentManagerDB.MY_TABLES_PREFIX & objMyTbls.ColValueStr("NomeTabella") & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
        MY: <%=objMyTbls.ColValueStr("Descrizione")%></A>
        </li>

    <%
    End If
    objMyTbls.RowNext()
End While
    %>

</ul>

<%
End If
%>


</td></tr>

<%	
	' ***************************
	' Menù profilo Operatore
	' ***************************
ElseIf _site.DatLink.Database.UALevel = OODBMS_UserAccessLevel.odulUserDefault Then 
	%>
<!--
<ul type="square">

<li>
<A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=NotizieWeb" & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
Novità e Notizie</A>
</li>
</ul>

<hr>
    -->
<%
    ' Gestione delle tabelle personali
    Dim objMyTbls As OODBMSObjLib.clsDataSource = Nothing
    If _site.Lib.GetDataSource(objMyTbls, "TabellePersonali") AndAlso objMyTbls.RowCount > 0 Then
        
%>

<hr>
<ul type="square">

    <%
        While Not objMyTbls.EOF
            ' Solo se visibile nel menù principale
            If objMyTbls.ColValueBool("Visibile") Then
    %>
        <li>
        <A HREF="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")) & "?" & FORM_SYS_FIELD_DATA_PATH & "=" & EasyContentManagerDB.MY_TABLES_PREFIX & objMyTbls.ColValueStr("NomeTabella") & "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_EDIT%>">
        <%=objMyTbls.ColValueStr("Descrizione")%></A>
        </li>

    <%
    End If
    objMyTbls.RowNext()
End While
    %>

</ul>

<%
End If
%>


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

