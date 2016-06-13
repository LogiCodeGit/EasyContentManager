<%
' Pagina di gestione presentazione immagini.
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	03/01/2005
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_IMAGES_PATH = "ooSYS_ImagesPath"
'		Nome completo della/e immagine/i.
'		Può contenere anche Willcards (?,*)
'	FORM_SYS_FIELD_IMAGES_TITLE = "ooSYS_ImagesTitle"
'		Eventuale titolo relativo alla/e immagine/i
'	FORM_SYS_FIELD_READ_ONLY = "ooSYS_ReadOnly"
'		Se = "False" abilita la possibilità di effettuare
'		modifiche alle immagini.
'		L'impostazione predefinita attiva automaticamente
'		la modalità a sola lettura se l'utente non
'		risulta validato.
'	FORM_SYS_FIELD_DELETE_FILE = "ooSYS_DeleteFile"
'		File dell'immagine da eliminare
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Image Manager"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "ImageManager"

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
If Not _site.InitApplicationObjects(Me,False,True) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Controlli 
If _site.Glb.RequestField(FORM_SYS_FIELD_IMAGES_PATH) = "" Then
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Glb.RspErr("Operazione non valida!")
	Else
		_site.Glb.RspErr("Invalid operation!")
	End If
	Response.End()
End If

' Identifica la possibilità di modificare le immagini
    Dim bEditMode As Boolean = _site.Glb.GetBoolean(Session("g_blnUserLogged"))
If bEditMode Then
	If _site.DatLink.DataBase.UALevel < OODBMS_UserAccessLevel.odulUserAdmin Then
		bEditMode = False
	ElseIf _site.Glb.RequestField(FORM_SYS_FIELD_READ_ONLY) <> "" Then
		bEditMode = False
	End If
End If

' Imposta il campo nascosto relativo al livello di
' visualizzazione (PopUp) del form corrente
    Dim nFormLevel As String = _site.Glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL)
If nFormLevel = "" Then nFormLevel = 0
_site.Frm.WriteHiddenField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL, nFormLevel)

' Imposta i campi nascosti necessari per questa pagina
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_IMAGES_PATH)
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_IMAGES_TITLE)
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_READ_ONLY)
_site.Frm.WriteHiddenField(FORM_SYS_FIELD_DELETE_FILE,"")

' Identifica i files presenti
    Dim sBaseURL As String = _site.Glb.GetBasePageURL(_site.Glb.RequestField(FORM_SYS_FIELD_IMAGES_PATH))
    Dim sPath As String = _site.Glb.GetAbsoluteFilePath(sBaseURL)

' Visualizza eventuale titolo
    Dim sTitle As String = _site.Glb.RequestField(FORM_SYS_FIELD_IMAGES_TITLE)
If sTitle = "" Then
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sTitle = "ANTEPRIMA / IMMAGINI"
	Else
		sTitle = "PREVIEW / IMAGES"
	End If
End If
%>

<font face="Comic Sans MS">
<table id="Row_ImageManager">
<tr><td colspan="3" title="<%=sBaseURL%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+1 color=silver><i><b>&nbsp;<%=sTitle%>&nbsp;</i></b></font><font face="Arial" size=+1 color=lightgrey></font>
</td></tr>
</table>
</font>
<br>
<%

' Eventuale elimninazione di una immagine
If _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_FILE) <> "" Then
        Try
            Dim sDelFile As String = _site.Glb.GetAbsoluteFilePath(_site.Glb.RequestField(FORM_SYS_FIELD_DELETE_FILE))
            System.IO.File.Delete(sDelFile)
        Catch ex As Exception
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                _site.Glb.RspMsg("IMMAGINE ELIMINATA...")
            Else
                _site.Glb.RspMsg("IMAGE DELETED...")
            End If
        End Try
        
        '       On Error Resume Next
        'Dim fso = Server.CreateObject("Scripting.FileSystemObject")
        '       Dim sDelFile = _site.Glb.GetAbsoluteFilePath(_site.Glb.RequestField(FORM_SYS_FIELD_DELETE_FILE))
        'If Err.Number = 0 Then fso.DeleteFile(sDelFile)
        'If Err.Number <> 0 Then 
        '	_site.Glb.RspErr(Err.Description)
        'Else
        '	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
        '		_site.Glb.RspMsg("IMMAGINE ELIMINATA...")
        '	Else
        '		_site.Glb.RspMsg("IMAGE DELETED...")
        '	End If		
        'End If
        'On Error Goto 0
End If

' Visualizzazion immagine/i
    Dim arrFiles() As String = Split(_site.Glb.GetDirFileList(sPath, , 1), ",")
If UBound(arrFiles)<0 Then
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		_site.Glb.RspMsg("Immagine/i non disponibile/i...")
		_site.Glb.RspMsg("")
            _site.Glb.RspMsg("Percorso: " & _site.Glb.GetBasePageURL(sPath))
	Else
		_site.Glb.RspMsg("Image/s unavailable...")
		_site.Glb.RspMsg("")
            _site.Glb.RspMsg("Path: " & _site.Glb.GetBasePageURL(sPath))
	End If
	
' Unica immagine
ElseIf UBound(arrFiles)=0 Then

	' Identifica i dati dell'immagine
        Dim sURL As String = arrFiles(0)
        Dim sBasePath As String = _site.Glb.GetBasePageURL(sURL)
        Dim sFilePath As String = _site.Glb.GetAbsoluteFilePath(sBasePath)
        Dim nLen As Long = 0
        Try
            nLen = FileLen(sFilePath)
        Catch ex As Exception
        End Try
%>
	ZOOM&nbsp;
	<select id="ZoomSelect" name="ZoomSelect" onchange='javascript:ChangeImageDim()'>
		<%
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		%>
			<option selected id="Default">Originale</option>
		<%
		Else
		%>
			<option selected id="Default">Original</option>
		<%
		End If
		%>
		<%
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		%>
			<option id="FitOrz">Adatta Orizzontale</option>
		<%
		Else
		%>
			<option id="FitOrz">Adapt Orizontal</option>
		<%
		End If
		%>
		<%
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		%>
			<option id="FitVert">Adatta Verticale</option>
		<%
		Else
		%>
			<option id="FitVert">Adapt Vertical</option>
		<%
		End If
		%>
		<option id="Dim5">5%</option>
		<option id="Dim10">10%</option>
		<option id="Dim25">25%</option>
		<option id="Dim50">50%</option>
		<option id="Dim100">100%</option>
		<option id="Dim150">150%</option>
		<option id="Dim200">200%</option>
		<option id="Dim300">300%</option>
		<option id="Dim400">400%</option>
		<option id="Dim800">800%</option>
	</select>
	<%
		' Se l'utente risulta validato abilita
		' la possibilità di eliminare / impostare l'immagine
		If bEditMode Then
			%>
			&nbsp;&nbsp;
			<%
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				_site.Frm.WriteFunctionKey("ELIMINA","onclick='javascript:DeleteImg(""" & sBasePath & """)'","Elimina l'immagine")
			Else
				_site.Frm.WriteFunctionKey("DELETE","onclick='javascript:DeleteImg(""" & sBasePath & """)'","Delete image")
			End If
		End If
	%>
	
	<br><hr><br>
	<center>
	<a href='<%=sUrl%>' title="<%=nLen%> bytes, <%=Server.HtmlEncode(sBasePath)%>" target=_self>
	<img onload="javascript:DoLoad()" border=1 id="ImageView" name="ImageView" src="<%=sURL%>" title="<%=nLen%> bytes, <%=Server.HtmlEncode(sBasePath)%>">
	</a>
	</center>
	
	<!-- MODIFICA DIMENSIONI IMMAGINE -->
	<script language=javascript>

		var nOriginalWidth = 0;
		var nOriginalHeight = 0;
		var nLastWndWidth = 0, nLastWndHeight = 0;
		//
		function ChangeImageDim()
		{
			var zs = document.forms.item(0).ZoomSelect;
			var iv = document.forms.item(0).ImageView;
			//var nZoom = 0;
			if (zs.selectedIndex == 1) 
			{
			    iv.style.width = "100%";
			    iv.style.height = "";
			}
			else if (zs.selectedIndex == 2) {
			    iv.style.width = "";
			    iv.style.height = "100%";
			}
			else
			{
			    var nWndWidth = nOriginalWidth;
			    var nWndHeight = nOriginalHeight;
			    if (zs.selectedIndex == 0)
			        /*nZoom = 100*/;
			    else 
			    {
			        var nZoom = zs.options.item(zs.selectedIndex).text.replace("%", "").valueOf();
			        nWndWidth = nOriginalWidth / 100 * nZoom;
			        nWndHeight = nOriginalHeight / 100 * nZoom;
			    }
			    //
			    iv.style.width = nWndWidth;
			    iv.style.height = nWndHeight;

			    // Ridimensiona la pagina in relazione alle dimensioni dell'immagine
			    nWndWidth = nWndWidth + 300;
			    nWndHeight = nWndHeight + 250;
			    if( nWndWidth > window.screen.width )
				    nWndWidth = window.screen.width;
			    if( nWndHeight > window.screen.height )
				    nWndHeight = window.screen.height;
			    if( nWndWidth > nLastWndWidth )
				    nLastWndWidth = nWndWidth;
			    if( nWndHeight > nLastWndHeight )
				    nLastWndHeight = nWndHeight;
			    try
			    {
				    window.resizeTo(nLastWndWidth,nLastWndHeight);
			    }
			    catch(e){/*errore..*/}
		    }
		}
		//
		function DoLoad()
		{
			nOriginalWidth = document.forms.item(0).ImageView.width;
			nOriginalHeight = document.forms.item(0).ImageView.height;
			
			// Ridimensiona la pagina in entrata
			ChangeImageDim();
		}
		//
		//DoLoad();

	</script>
<%

' Visualizzazione delle immagini
Else
	' Definizione del numero di elementi per riga
    Dim nMaxRowElements As Integer = 4
    Dim nCountRowElements As Integer = 0

	' Dimensione delle immagini in anteprima
    Dim nDefImageWidth As Integer = 100
    Dim nDefImageHeight As Integer = 0      ' In proporzione alla larghezza (100)
	
	' Tabella di presentazione 
	%>
		<table border=0 cellspacing=30 style="border-left: 1 dashed #C0C0C0">
		<tr>
	<%		
	
	' Cliclo di presentazione 
	Dim nCo As Integer
	For nCo = 0 To UBound(arrFiles)
		
		' Eventualmente inizializza una nuova riga
		If nCountRowElements = nMaxRowElements Then
			_site.Frm.WriteLn("</tr><tr>")
			nCountRowElements = 0
		End If
		nCountRowElements = nCountRowElements + 1
		
		' Identifica i dati dell'immagine
	        Dim sURL As String = arrFiles(nCo)
	        Dim sBasePath As String = _site.Glb.GetBasePageURL(sURL)
	        Dim sFilePath As String = _site.Glb.GetAbsoluteFilePath(sBasePath)
	        Dim nLen As Long
	        Try
	            nLen = FileLen(sFilePath)
	        Catch ex As Exception
	        End Try
	        ' Visualizzazione dell'immagine
		%>
			<td align=center valign=middle style="border-left: 1 dashed #C0C0C0; border-bottom: 1 dashed #C0C0C0">
			<%
			' Se l'utente risulta validato abilita
			' la possibilità di eliminare l'immagine
			If bEditMode Then
				If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
					_site.Frm.WriteFunctionKey("ELIMINA","onclick='javascript:DeleteImg(""" & sBasePath & """)'","Elimina l'immagine")
				Else
					_site.Frm.WriteFunctionKey("DELETE","onclick='javascript:DeleteImg(""" & sBasePath & """)'","Delete image")
				End If
				%>
				<br>
				<%
			End If
			%>
			<a id="open" href='javascript:OpenPopUpImageManager("<%=sUrl%>",<%=_site.Glb.FormatStrForJScript(sTitle & "...  [" & CStr(nCo + 1) & "/" & CStr(UBound(arrFiles) + 1) & "]")%>,0,0)' 
						title="<%=nLen%> bytes, <%=Server.HtmlEncode(sBasePath)%>">
			<img width=<%=nDefImageWidth%> src="<%=sURL%>" border=1>
			</a>
			</td>
		<%			
		
	Next
End If
%>
	</tr>
	</table>
	
<%

' Attiva la funzione di aggiunta immagini se utente abilitato
If bEditMode Then
'	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then	
'		Response.Write("NUOVA IMMAGINE ")
'	Else
'		Response.Write("NEW IMAGE ")
'	End If
%>
<!--	<input type=file id="IMAGEADD"><input type=submit id="ADD">-->
<%
End If

' Imposta la funzione di elimnazione se utente abilitato		
If bEditMode Then
%>	
	<script language=javascript>
	function DeleteImg(sBasePath)
	{
		// Richiede conferma
<%		
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
%>	
		if( confirm("Confermi l'eliminazione dell'immagine ?\r\r" + sBasePath ) ) 
<%
	Else
%>
		if( confirm("Confirm delete the image ?\r\r" + sBasePath ) ) 
<%
	End If
%>
		{
			// Richiede l'eliminazione dell'immagine
			document.forms.item(0).<%=FORM_SYS_FIELD_DELETE_FILE%>.value = sBasePath;
			document.forms.item(0).submit();
		}
	}
	</script>	
<%
End If
%>
<br>
<hr>
<%
_site.WriteFunctionKey_Exit(Page)
%>
&nbsp;
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	_site.Frm.WriteFunctionKey("AGGIORNA","onclick='javascript:document.forms.item(0).submit()'","Aggiorna la visualizzazione")
Else
	_site.Frm.WriteFunctionKey("REFRESH","onclick='javascript:document.forms.item(0).submit()'","Refresh view")
End If
%>
</form>
</BODY>
</HTML>

