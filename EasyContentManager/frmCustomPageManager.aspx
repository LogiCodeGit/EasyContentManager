<%@ Page validateRequest=false  %>
<%
' Gestione pagine personalizzate (HTML).
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	01/09/2005
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_PAGE_NAME = "ooSYS_PageName"
'		Nome e indirizzario relativo della pagina.
'	FORM_SYS_FIELD_PAGE_TITLE = "ooSYS_PageTitle"
'		Eventuale titolo relativo alla pagina.
'	FORM_SYS_FIELD_DELETE_FILE = "ooSYS_DeleteFile"
'		File della pagina da eliminare
'	FORM_SYS_FIELD_RESTORE_FILE = "ooSYS_RestoreFile"
'		File della pagina da recuperare (backup)
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Custom Page Manager"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "CustomPageManager"

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
' < Inclusione dell'intestazione >
%>
<!-- #INCLUDE FILE="CustomHeader.aspx" -->

<!----------->
<!-- FORM --->
<!----------->
<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id=<%=sFormName%> name=<%=sFormName%>>
<%

' Inizializzazione degli oggetti globali
If Not _site.InitApplicationObjects(Me,False,True) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Controlli 
If _site.Glb.RequestField(FORM_SYS_FIELD_PAGE_NAME) = "" And _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_FILE)="" Then
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Glb.RspErr("Operazione non valida!")
	Else
		_site.Glb.RspErr("Invalid operation!")
	End If
	Response.End()
End If
' 
If Not Session("g_blnUserLogged") Then
	_site.Glb.RspErr("Utente non abilitato!")
	Response.End()
End If

' Imposta il campo nascosto relativo al livello di
' visualizzazione (PopUp) del form corrente
Dim nFormLevel = _site.Glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL)
If nFormLevel = "" Then nFormLevel = 0
_site.Frm.WriteHiddenField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL, nFormLevel)

' Imposta i campi nascosti necessari per questa pagina
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_PAGE_NAME)
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_PAGE_TITLE)
_site.Frm.WriteHiddenField(FORM_SYS_FIELD_DELETE_FILE,"")
_site.Frm.WriteHiddenField(FORM_SYS_FIELD_RESTORE_FILE,"")

' Verifica se è richiesto il ripristino di una pagina precedentemente salvata
Dim bRestorePage = False, sRestorePath = _site.Glb.RequestField(FORM_SYS_FIELD_RESTORE_FILE)
If sRestorePath <> "" Then 
        sRestorePath = _site.Glb.GetAbsoluteFilePath(_site.Glb.GetBasePageURL(sRestorePath))
	bRestorePage = True
End If

' Identifica il file della pagina
Dim bDelete = True, sPage = _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_FILE)
If sPage = "" Then 
	' Non si tratta di eliminazione
	sPage = _site.Glb.RequestField(FORM_SYS_FIELD_PAGE_NAME)
	bDelete = False
End If
'
    Dim sBaseURL = _site.Glb.GetBasePageURL(sPage)
    Dim sPath = _site.Glb.GetAbsoluteFilePath(sBaseURL)
Dim bBackExist = False, sBakPath = sPath & ".bak"

' Imposta il contenuto del file per la modifica
Dim bSaveContent = False, sContent = _site.Glb.RequestField(FORM_SYS_FIELD_PAGE_CONTENT)
If sContent = "" Then
	If bRestorePage Then
            sContent = _site.Glb.ReadFile(sRestorePath)
	ElseIf System.IO.File.Exists(sPath) Then
            sContent = _site.Glb.ReadFile(sPath)
	Else
		sContent = ""
	End If
Else
	bSaveContent = True
End If
_site.Frm.WriteHiddenField(FORM_SYS_FIELD_PAGE_CONTENT, Server.HTMLEncode(sContent))

' Visualizza eventuale titolo
Dim sTitle = _site.Glb.RequestField(FORM_SYS_FIELD_PAGE_TITLE)
If sTitle = "" Then
	sTitle = "GESTIONE PAGINA"
End If
%>

<font face="Comic Sans MS">
<table id="Row_PageManager">
<tr><td colspan="3" title="<%=sBaseURL%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+1 color=silver><i><b>&nbsp;<%=sTitle%>&nbsp;</i></b></font><font face="Arial" size=+1 color=lightgrey></font>
</td></tr>
</table>
</font>
<br>
<%

' Accesso alla pagina per verifiche
On Error Resume Next

' Verifica se esite la pagina di backup
If Err.Number = 0 Then 
	bBackExist = System.IO.File.Exists(sBakPath)
End If

' Eventuale eliminazione della pagina
If Err.Number = 0 Then 
	' Eventuale elimninazione di una pagina
	If bDelete Then
		
		' Prima di eliminare la pagina effettua una copia
		If Not bBackExist Then 
			System.IO.File.Copy(sPath,sBakPath,True)
			If Err.Number = 0 Then bBackExist = True
		End If
		
		' Elimina la pagina		
		If Err.Number = 0 Then System.IO.File.Delete(sPath)
		If Err.Number = 0 Then 
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				_site.Glb.RspMsg("PAGINA ELIMINATA...")
			Else
				_site.Glb.RspMsg("PAGE DELETED...")
			End If		
		End If

	' Salva il contenuto modificato nella pagina se necessario
	ElseIf bSaveContent Then

		' Prima di modificare la pagina effettua una copia
		If Not bBackExist AndAlso System.IO.File.Exists(sPath) Then 
			System.IO.File.Copy(sPath,sBakPath,True)
			If Err.Number = 0 Then bBackExist = True
		End If
		
		' Sovrascrive il file
            If Err.Number = 0 Then _site.Glb.WriteFile(sContent, sPath)
		
	End If

End If

' Eventuale ripristino di una pagina
If bRestorePage Then
	System.IO.File.Copy( sRestorePath, sPath, True )	
	If Err.Number = 0 Then 
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
			_site.Glb.RspMsg("PAGINA RIPRISTINATA...")
		Else
			_site.Glb.RspMsg("PAGE RESTORED...")
		End If		
	End If
End If
'
If Err.Number <> 0 Then 
	' Segnala eventuale errore di accesso alla pagina
	_site.Glb.RspErr(Err.Description)
End If
On Error Goto 0

' Visualizzazion immagine/i
If Dir(sPath) = "" Then
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Glb.RspMsg("Pagina non disponibile...")
		_site.Glb.RspMsg("")
            _site.Glb.RspMsg("Percorso: " & _site.Glb.GetBasePageURL(sPath))
	Else
		_site.Glb.RspMsg("Page unavailable...")
		_site.Glb.RspMsg("")
            _site.Glb.RspMsg("Path: " & _site.Glb.GetBasePageURL(sPath))
	End If
	
' Pagina
Else
%>
<iframe border=2 width="95%" height="70%" 
		 	name="PageContent" id="PageContent" src="<%=sBaseURL%>">
</iframe>
<%
End If
%>

<br>
<hr>

<%
' Attiva la funzione di modifica pagina se utente abilitato
'If bEditMode Then

	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Frm.WriteFunctionKey("MODIFICA","onclick='javascript:EditPage(""" & sBaseURL & """)'","Modifica la Pagina")
	Else
		_site.Frm.WriteFunctionKey("EDIT","onclick='javascript:EditPage(""" & sBaseURL & """)'","Edit Page")
	End If
	
	%>
	&nbsp;
	<%
	
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Frm.WriteFunctionKey("ELIMINA","onclick='javascript:DeletePage(""" & sBaseURL & """)'","Elimina l'immagine")
	Else
		_site.Frm.WriteFunctionKey("DELETE","onclick='javascript:DeletePage(""" & sBaseURL & """)'","Delete image")
	End If

	%>
	&nbsp;
	<%
	
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Frm.WriteFunctionKey("AGGIORNA","onclick='javascript:document.forms.item(0).submit()'","Aggiorna la visualizzazione")
	Else
		_site.Frm.WriteFunctionKey("REFRESH","onclick='javascript:document.forms.item(0).submit()'","Refresh view")
	End If

	' Se esiste una pagina di backup attiva il tasto di ripristino
	If bBackExist Then	
		%>
		&nbsp;
		<%
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		        _site.Frm.WriteFunctionKey("RIPRISTINA", "onclick='javascript:RestorePage(""" & _site.Glb.GetBasePageURL(sBakPath) & """)'", "Ripristina la pagina originale")
		    Else
		        _site.Frm.WriteFunctionKey("RESTORE", "onclick='javascript:RestorePage(""" & _site.Glb.GetBasePageURL(sBakPath) & """)'", "Restore original page")
		End If
	End If

	%>
	&nbsp;&nbsp;
	<%
	
	_site.WriteFunctionKey_Exit(Page)

'End If

' Imposta le funzioni di modifica se utente abilitato		
'If bEditMode Then
%>	
	<script language=javascript>
	function DeletePage(sBasePath)
	{
		// Richiede conferma
<%		
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
%>	
		if( confirm("Confermi l'eliminazione della pagina ?\r\r" + sBasePath ) ) 
<%
	Else
%>
		if( confirm("Confirm delete the page ?\r\r" + sBasePath ) ) 
<%
	End If
%>
		{
			// Richiede l'eliminazione dell'immagine
			document.forms.item(0).<%=FORM_SYS_FIELD_DELETE_FILE%>.value = sBasePath;
			document.forms.item(0).submit();
		}
	}
	function EditPage(sBasePath)
	{
		// Attiva la modifica dell'immagine
		var sResult = EditHTMLText(document.forms.item(0).<%=FORM_SYS_FIELD_PAGE_CONTENT%>.value, false, false);
		if( sResult.length > 0 )
		{
			// Imposta il nuovo contenuto per salvarlo sul server
			document.forms.item(0).<%=FORM_SYS_FIELD_PAGE_CONTENT%>.value = sResult;
			document.forms.item(0).submit();
		}
	}

	function RestorePage(sBasePath)
	{
		// Richiede conferma
<%		
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
%>	
		if( confirm("Confermi il ripristino della pagina originale ?\r\rN.B.: tutte le modifiche alla pagina corrente verranno perdute..." ) ) 
<%
	Else
%>
		if( confirm("Confirm restore the original page ?\r\rN.B.: all changes to current page will be lost..." ) ) 
<%
	End If
%>
		{
			// Richiede l'eliminazione dell'immagine
			document.forms.item(0).<%=FORM_SYS_FIELD_RESTORE_FILE%>.value = sBasePath;
			document.forms.item(0).submit();
		}
	}
<%
If Dir(sPath) > "" Then	
%>
	// Ricarica la pagina nel frame di antemprima
	// per acquisire eventuali modifiche
	PageContent.location.reload();
<%
End If
%>	
	</script>	
<%
'End If
%>

</form>
</BODY>
</HTML>

