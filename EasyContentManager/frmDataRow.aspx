<%
' N.B.: per ulteriori informazioni sulla proprietà 'ValidateRequest'
'		leggere il documento (How To: Protect From Injection Attacks in ASP.NET)
'		http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnpag2/html/paght000003.asp
'		In relatà l'impostazione a 'false' è necessaria solo per la pagina
'		'frmDataRow.aspx' che permette l'invio di campi (FORM) con
'		codice HTML
%>
<%@ Page ValidateRequest="false" %>

<%
    ' Abilitazione editor HTML inline per le caselle di testo multi-linea (textarea)
    ' Vedere anche CKEditor: http://ckeditor.com
    Dim blnEnableInlLineEditor As Boolean = True
    Dim strTextAreaInLineClass As String = "ckeditor"
    Dim strEditorScriptFile As String = "CKEditor/ckeditor.js"
    
%>

<%

' Pagina di Visualizzazione/Modifica/Inserimento dati.
'
' Parametri da specificare in entrata (Request):
'	
'	FORM_SYS_FIELD_DATA_PATH = "ooSYS_DataPath"
'		Nome della tabella o della Reference
'		Se si tratta di una reference è necessario specificare
'		il nome completo [TableName].[ReferenceName]
'	FORM_SYS_FIELD_CONTAINER_OBJECT_NAME = "ooSYS_ContainerObjectName"
'		In caso di Reference è necessario specificare 
'		il nome dell'oggetto globale contenente i dati del Container
'		che gestisce la Reference, altrimenti può essere vuoto ("")
'	FORM_SYS_FIELD_FORM_PUPUP_LEVEL = "ooSYS_FormPopUpLevel"
'		Livello di PopUp del form rispetto a quelli precedenti.
'		E' necessario che sia progressivo per il corretto 
'		funzionamento dell'applicazione
'	FORM_SYS_FIELD_REQUEST_ACTION = "ooSYS_RequestAction"
'		Azione richiesta per il form
'		Sono previste le seguenti azioni:
'				ACTION_ADD_NEW = "AddNew"
'					Attiva l'inserimento
'				ACTION_INSERT = "Insert"
'					Archivia i dati inseriti
'				ACTION_EDIT = "Edit"
'					Attiva la modifica
'				ACTION_UPDATE = "Update", ACTION_APPLY = "Apply"
'					Archivia i dati modificati
'               CONFIRM_UPDATE, CONFIRM_APPLY
'					Conferma dei dati con uscita dalla maschera 
'                   (come per FORM_SYS_FIELD_FORM_CONFIRM)
'				ACTION_UPDATE_VALUES = "UpdateValues"			
'					Imposta i valori senza archiviarli
'				ACTION_VIEW = "View"
'					Visualizza i dati
'	FORM_SYS_FIELD_PRESENTATION_FIELDS = "ooSYS_PresentationFields"
'		Eventuale lista di campi da visualizzare per la 
'		presentazione dei dati.
'		Se non specificato verranno inclusi tutti i campi
'		presenti nella tabella e abilitati alla visualizzazione
'		per l'utente corrente.
'		Separare la lista dei campi mediante la virgola (,).
'		N.B.: E' possibile configurare la sequenza predefinita
'			  di visualizzazione campi di ogni tabella impostando
'			  l'apposito parametro (vedi tabella parametri di sistema)
'			  con il seguente nome (Default Row Sequence):
'				DRS_[TableName]
'	FORM_SYS_FIELD_HIDE_FIELDS = "ooSYS_HideFields"
'		Eventuale lista di campi da nascondere per la 
'		presentazione dei dati.
'		Separare la lista dei campi mediante la virgola (,).
'	FORM_SYS_FIELD_PREVIEW_FIELDS = "ooSYS_PreviewFields"
'		Eventuale lista di campi da visualizzare in anteprima 
'		all'interno del form di presentazione dei dati.
'		I campi specificati devono essere immagini o dati presentabili
'		direttamente nella pagina HTML.
'		Separare la lista dei campi mediante la virgola (,).
'		E' possibile specificare un campo secondario per ogni campo
'		della lista di tipo file/immagine per visualizzare una 
'		rappresentazione di anterpima eventualmente presente
'		nei dati, separare le coppie di campi con i due punti (:) 
'		nel seguente modo:
'			[File/Immagine]:[ImmagineAnteprima],[Altro Campo],...
'	FORM_SYS_FIELD_DELETE_REFERENCE_NAME = "ooSYS_DeleteReferenceName"
'		Questo parametro attiva l'eliminazione di Reference, può contenere 
'		il nome della Reference che richiede l'eliminazione dei dati,
'		in questo caso il relativo parametro, identificato dal nome,
'		(letto mediante _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_REFERENCE_NAME))
'		contiene l'OID o la lista degli OIDs dei record da eliminare
'       per le Ref.Multiple (per quelle singole non è necessario l'OID)
'	FORM_SYS_FIELD_ENABLE_SELECT = "ooSYS_EnableSelect"
'		Se <> "" indica che è in corso una 
'		selezione di dati, in questo caso i dati 
'		richiesti in Visualizzazione/Modifica vengono
'		attivati in modalità selezione (cioè senza leggerli
'		dalla Reference del Container che potrebbe non
'		avere ancora impostato il dato della Reference)
'	FORM_SYS_FIELD_OID = "ooSYS_OID"
'		In caso di visualizzazione/modifica è necessario
'		specificare l'OID 
'   FORM_SYS_FIELD_DEFAULT_FIELDS_VALUES = "ooSYS_DefaultFieldsValues"
'       In caso di aggiunta è possibile specificare coppie di 
'       campi/valori separati dal carattere '|'
'           Es.: ooSYS_DefaultFieldsValues=Nome|Daniele|Cognome|Magliacani
'	FORM_SYS_FIELD_FORM_CONFIRM = "ooSYS_Confirm"
'		Indica l'operazione di conferma dei dati
'		Sono previste le seguenti conferme:
'               CONFIRM_UPDATE, CONFIRM_UPDATE_ENG, CONFIRM_UPDATE_[lang]
'					Attiva la conferma dei dati con uscita dalla maschera
'				CONFIRM_APPLY, CONFIRM_APPLY_ENG, CONFIRM_APPLY_[lang]
'					Attiva la conferma dei dati senza dalla maschera
'	FORM_SYS_FIELD_FOCUS = "ooSYS_FocusField"
'		Per eventuale posizionamento in un campo
'		del form in entrata
'	FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS = "ooSYS_HideHeadAndFunctions"
'		Se <> "" nasconde la struttura di contorno e i tasti funzione
'		visualizzando solo i dati.
'	FORM_SYS_FIELD_USE_DEST_ACTION_FOR_POPUP_LEVEL = "ooSYS_UseDestinationActionForPopUpLevel"
'		Se impostato <> "" richiama comunque la funzione di definizione delle azioni 
'		(GetDestLocation()) per questo livello di finestra (PopUp) nel caso in cui 
'		fosse > 0.
'		Altrimenti viene gestita come finestra secondaria legata alla precedente 
'		mediante notifiche.
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	06/04/2003

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "DataRow"

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<!-- Pagina con supporto ad Ajax Control Toolkit -->
<%
' N.B.: necessario aggiungere nella pagina:
'   <%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp"
'       e all'interno del form:
'   <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
'   </asp:ToolkitScriptManager>
'
' vedi anche modSiteAction.aspx
If _bAjaxEnabled Then
    ' N.B.: deve essere stata abilitata anche la libreria mediante l'impostazione _site.Frm.EnableAjaxToolKit()
    '       specificando il prefisso dei tags ("asp"), vedi in _site.Lib.modOODBMS_Form
    _site.Frm.EnableAjaxToolKit("asp")
End If
%>

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
<META NAME="GENERATOR" Content="LogiCode Easy Content Manager">
<TITLE><%=PAGE_DESCRIPTION%> - <%=_site.Glb.GetParam("APP_NAME")%></TITLE>
<%
    ' Inclusione dello script per l'editor 
    If blnEnableInlLineEditor Then
        Response.Write("<script src=""" & strEditorScriptFile & """></script>")
    End If

    ' Attivazione della classe di libreria globale per in-line editor
    If blnEnableInlLineEditor Then
        _site.Glb.sUseInLineHtmlEditorTextAreaClass = strTextAreaInLineClass
    End If
    
%>
</HEAD>
<BODY>
<%

    ' Inizializzazione degli oggetti globali
    If Not _site.Lib.InitializeGlobalObjects(Me) Then
        ' Termina l'applicazione
        _site.Lib.EndApplication(True)
    End If

    ' Controlli 
    If _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH) = "" Or _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION) = "" Then
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Glb.RspErr("Operazione non valida")
        Else
            _site.Glb.RspErr("Invalid operation")
        End If
        Response.End()
    End If

    ' Identifica i dati della tabella o della Reference
    Dim sContainerTableName As String = "", sRefName As String = ""
    _site.Frm.SplitDataPathElements(_site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH), sContainerTableName, sRefName)
    If Not _site.DatLink.Database.Tables.Exist(CStr(sContainerTableName)) Then
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Glb.RspErr("Origine " & sContainerTableName & " non definita")
        Else
            _site.Glb.RspErr("Source " & sContainerTableName & " undefined")
        End If
        Response.End()
    End If
    '
    '_site.Glb.RspErr sContainerTableName
    '_site.Glb.RspErr sRefName
    '_site.Glb.RspErr _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME)
    'Response.End
    Dim objTable As OODBMSObjLib.clsDataObject
    If _site.Glb.RequestField(FORM_SYS_FIELD_REAL_TABLE_NAME) <> "" Then
        ' Dati da tabella effettiva
        objTable = _site.DatLink.Table(_site.Glb.RequestField(FORM_SYS_FIELD_REAL_TABLE_NAME))
    ElseIf _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME) <> "" And sRefName <> "" Then
        ' Dati da Reference
        objTable = _site.DatLink.Table(sContainerTableName).References.Item(sRefName).ReferencedTable
    Else
        ' Dati da tabella da percorso dati
        objTable = _site.DatLink.Table(sContainerTableName)
    End If

    ' Identifica il tipo di operazione e le eventuali abilitazioni
    Dim bRowInsert As Boolean = False
    Dim bRowReadOnly As Boolean = False
    Dim sConfirmAction As String = _site.Glb.RequestField(FORM_SYS_FIELD_FORM_CONFIRM)
    Dim sRequestAction As String = _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION)
    Dim sOperation As String = "", sTitle As String = objTable.PresentationName
    '
    Select Case sRequestAction
	
        Case ACTION_ADD_NEW, ACTION_INSERT
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                sOperation = "nuovo"
            Else
                sOperation = "new"
            End If
            bRowInsert = True
            
            ' Imposta l'azione di aggiornamento dei dati
            If sConfirmAction = CONFIRM_UPDATE OrElse sConfirmAction = CONFIRM_UPDATE_ENG Then
                sRequestAction = ACTION_UPDATE
            ElseIf sConfirmAction = CONFIRM_APPLY OrElse sConfirmAction = CONFIRM_APPLY_ENG Then
                sRequestAction = ACTION_APPLY
            End If
            
        Case ACTION_EDIT
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                sOperation = "visualizzazione / modifica"
            Else
                sOperation = "view / edit"
            End If
		
            ' Controllo se utente abilitato
            If Not objTable.CanUserEdit Then
                ' Abilita solo visualizzazione
                sRequestAction = ACTION_VIEW
                sOperation = "visualizzazione"
                bRowReadOnly = True ' Disabilita la modifica
                
                ' Imposta l'azione di aggiornamento dei dati
            ElseIf sConfirmAction = CONFIRM_UPDATE OrElse sConfirmAction = CONFIRM_UPDATE_ENG Then
                sRequestAction = ACTION_UPDATE
            ElseIf sConfirmAction = CONFIRM_APPLY OrElse sConfirmAction = CONFIRM_APPLY_ENG Then
                sRequestAction = ACTION_APPLY
            End If
		
        Case ACTION_UPDATE, ACTION_APPLY
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                sOperation = "modifica"
            Else
                sOperation = "edit"
            End If
		
            ' Identifica eventuale tasto <Applica> premuto
            ' al posto di <Update>
            If InStr(sConfirmAction, CONFIRM_APPLY) > 0 _
                    Or InStr(sConfirmAction, CONFIRM_APPLY_ENG) > 0 Then
                sRequestAction = ACTION_APPLY
            End If

        Case CONFIRM_UPDATE, CONFIRM_UPDATE_ENG, CONFIRM_APPLY, CONFIRM_APPLY_ENG
            ' Stessa operazione del tasto di SUBMIT (FORM_SYS_FIELD_FORM_CONFIRM)
            sConfirmAction = sRequestAction
            If sConfirmAction = CONFIRM_UPDATE Or sConfirmAction = CONFIRM_UPDATE_ENG Then
                sRequestAction = ACTION_UPDATE
            Else
                sRequestAction = ACTION_APPLY
            End If

        Case ACTION_VIEW
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                sOperation = "visualizzazione"
            Else
                sOperation = "view"
            End If
            bRowReadOnly = True
		
    End Select

    ' Visualizza eventuale OID per l'elemento in visualizzazione/modifica (nel tooltip)
    If Not bRowInsert AndAlso RTrim(_site.Glb.RequestField(FORM_SYS_FIELD_OID)) <> "" Then
        sTitle &= " [OID: " & RTrim(_site.Glb.RequestField(FORM_SYS_FIELD_OID)) & "]"
    End If

    ' Effettua la validazione dell'azione
    If Not _site.Frm.ValidateUserAction(objTable.ObjectName, sRequestAction) Then
        _site.WriteFunctionKey_FormExit(Page)
        _site.Frm.Break_PageConstruction()
    End If
%>
<!--
	*********************
	Composizione del Form
	*********************
-->
<%
    ' Identifica il nome del form
    Dim sFormName As String = _site.Lib.GetCurrentPageName(Me) & objTable.ObjectName

    ' Se la tabella prevede colonne che prevedono files
    ' di tipo Embedded attiva l'invio dei files da 
    ' parte del Client mediante il Form
    Dim sMutipartFormOption As String = ""
    If objTable.HaveEmbeddedFileInTableChain Then
        sMutipartFormOption = " ENCTYPE=""multipart/form-data"" "
    End If

    ' Eventuale disabilitazione del titolo e dei tasti funzione
    Dim bHideHeadAndFunctions As Boolean = False
    If _site.Glb.RequestField(FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS) <> "" Then
        bHideHeadAndFunctions = True
    End If

%>

<font face="Comic Sans MS">
<table id="Row_<%=objTable.ObjectName%>">
<tr><td colspan="4">&nbsp;</td></tr>
<%
' Eventuale disabilitazione del titolo e 
' della struttura di contorno
If Not bHideHeadAndFunctions Then
	%>
<tr><td width="2%"></td><td colspan="3" title="<%=sTitle%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+2 color=silver><i><b>&nbsp;<%=objTable.Description%></i></b></font><font face="Arial" size=+1 color=lightgrey><i><b> - <%=sOperation%></i></b></font></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td colspan="2"></td></tr>
<%	
End If
%>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td width="1%"></td>
<td>
<font face="Verdana">
<form method="POST" <%=sMutipartFormOption%> ACTION="<%=Request.ServerVariables.Item("URL")%>" id=<%=sFormName%> name=<%=sFormName%>>

<%
' < Inclusione delle funzioni Form Java lato client >
%>
	<%'UPGRADE_NOTE: Language element '#INCLUDE' was migrated to the same language element but still may have a different behavior. Copy this link in your browser for more: ms-its:C:\Programmi\ASP to ASP.NET Migration Assistant\AspToAspNet.chm::/1011.htm  %>
<%'UPGRADE_NOTE: The file 'OOLib/srcClientScriptForm.asp' was not found in the migration directory. Copy this link in your browser for more: ms-its:C:\Programmi\ASP to ASP.NET Migration Assistant\AspToAspNet.chm::/1003.htm  %>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<FONT SIZE=-1>
<%

    ' Imposta il campo nascosto necessario per gestire il livello PopUp del form
    Dim nFormLevel As Integer = _site.Frm.WriteHiddenFieldForFormLevel()

    ' Se si tratta di aggiunta imposta eventuali 
    ' campi predefiniti
    ' ... adesso li gestisce in _site.Frm.ExecuteDataFormAction()
    'If objDataSource.RowAdding _
    '        AndAlso _site.Glb.RequestField(FORM_SYS_FIELD_DEFAULT_FIELDS_VALUES) <> "" Then
    '    
    '    Dim arrFldVals() As String = Split(_site.Glb.RequestField(FORM_SYS_FIELD_DEFAULT_FIELDS_VALUES), "|")
    '    If arrFldVals.Length > 1 Then objDataSource.SetValueArray(arrFldVals)
    '
    'End If

    ' ----------------------------------
    ' Esegue l'azione richiesta sui dati
    ' ----------------------------------
    Dim objDataSource As OODBMSObjLib.clsDataSource, strErrFieldName As String = "", strErrMessage As String = ""
    Dim blnGoToNextDestination As Boolean
    Dim blnResult As Boolean = _site.Frm.ExecuteDataFormAction( _
            _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH), _
            _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME), _
            nFormLevel, sRequestAction, _
            _site.Glb.RequestField(FORM_SYS_FIELD_OID), _
            sConfirmAction, _
            _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_REFERENCE_NAME), _
            objDataSource, strErrFieldName, strErrMessage, _
            blnGoToNextDestination)

    ' Verifica l'esito
    If blnResult Then

        If blnGoToNextDestination Then
		
            ' Scrive il codice per spostarsi nella prossima destinazione
            If _site.WriteClientDestinationAction(Page, _site.Lib.GetCurrentPageName(Me), _
                        sRequestAction, _
                        _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH)) Then

                If sConfirmAction <> "" And sRequestAction <> ACTION_APPLY Then
                    ' Dati confermati
                    ' Termina il form
                    _site.WriteFunctionKey_FormExit(Page)
                    _site.Frm.Break_FormConstruction()
                End If
					
            Else
		
                ' Destinazione non trovata
                ' Termina il form
                _site.WriteFunctionKey_FormExit(Page)
                _site.Frm.Break_FormConstruction()

            End If
	
        ElseIf sConfirmAction <> "" _
                And sRequestAction <> ACTION_APPLY _
                And strErrMessage = "" And strErrFieldName = "" Then
	
            ' Dati confermati, nessuna successiva destinazione
            ' Termina il form
            _site.WriteFunctionKey_FormExit(Page, _
                                            sRequestAction, _
                                            _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH))
            _site.Frm.Break_FormConstruction()
	
        End If
	
    ElseIf sRequestAction <> ACTION_APPLY Then

        ' Termina il form
        _site.WriteFunctionKey_FormExit(Page)
        _site.Frm.Break_FormConstruction()
	
    End If
%>
</FONT>

<%
If objTable.GroupNamesCount > 0 Then
%>
	<!-- SELEZIONE DEI GRUPPI -->
	<table border=0 cellspacing=0 cellPadding=0><tr>
	<%
	Dim sGrpName = "", sGeneral = "GENERALE", fontStyle = ""		' Gruppo predefinito
	If _site.Language <> OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then sGeneral = "GENERAL"
	Dim nCo As Integer, arrGroups = Split(sGeneral & "," & objTable.GetGroupNames, ",")
	For nCo = 0 To UBound(arrGroups)
		If nCo = 0 Then
			' Gruppo predefinito
			sGrpName = ""
			fontStyle = "style=""font-weight:bolder"""
		Else
			' Gruppi personalizzati
			sGrpName = arrGroups(nCo)
			fontStyle = ""
		End If
	%>
	    <td align=left width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>"><img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_LEFT_IMG_GRAY")%>"></td>
		<td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_BACK_COLOR_GRAY")%>" height="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_HEIGHT")%>" align=center>
		<A title="<%=arrGroups(nCo)%>" href='javascript:SelectGroup("<%=sGrpName%>");'>
		<font id="GrpFont_<%=sGrpName%>" size=1 color="white" <%=fontStyle%>>&nbsp;<%=_site.Glb.GetPresentationName(arrGroups(nCo),False)%>&nbsp;</font>
		</a>
		</td>
		<td align=right width="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_IMG_WIDTH")%>"><img src="<%=_site.Glb.GetParam("HTML_FIXED_LINKS_RIGHT_IMG_GRAY")%>"></td>
    <%
    Next
    %>
    </tr>
    </table>
	<script language=javascript>
	function SelectGroup(sName)
	{
	    // Deseleziona il gruppo corrente
	    window.document.all("GrpFont_" + GetFormControl("ooSys_TableGroupName").value).style.fontWeight = "normal";

		// Seleziona il gruppo
		ShowGroupFields(sName, "");

		// Evidenzia il gruppo selezionato
		window.document.all("GrpFont_" + sName).style.fontWeight = "bolder";
    }
	</script>
	<br>
<%
Else
%>


<%
End If
%>

<%

    ' Se i dati risultano bloccati disabilita
    ' eventuale modifica
    Dim bLocked As Boolean = False
    If Not objDataSource.RowAdding Then
	
        bLocked = objDataSource.LockedRow
        If bLocked Then
		
            ' Il record risulta bloccato
            sOperation = sOperation & " (bloccato)"
		
            ' Se il record risulta bloccato imposta
            ' sola lettura
            bRowReadOnly = True
		
        End If
	
    End If

    ' Controllo se invertire la tabella Parent
    ' in aggiunta dati per adattare la successione
    ' dei campi nel miglior modo
    Dim blnInvertParent As Boolean = False
    If objDataSource.RowAdding Then
        If objDataSource.InvertParentAddPresentation Then
            ' Esplicitamente richiesto nella proprietà
            ' del DataSource
            blnInvertParent = True
        ElseIf objDataSource.Table.HaveParent Then
            ' Se parametro non specificato inverte
            ' solo se la Parent è stata già impostata
            ' mediante il relativo OID
            If Not objDataSource.Table.ParentTable.CanUserAdd Then
                blnInvertParent = True
            ElseIf objDataSource.RowAdding Then
                'UPGRADE_WARNING: Use of Null/IsNull() detected. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1049"'
                If Not IsDBNull(objDataSource.ParentRowOID) Then
                    blnInvertParent = True
                End If
            End If
		
        End If
    Else
        ' In Visualizzazione / Modifica visualizza
        ' dalla prima Child (corrente) all'ultima
        ' Parent
        blnInvertParent = True
    End If

    ' Identifica eventuale sequenza di presentazione
    Dim sPresentationSequence As String = RTrim(_site.Glb.RequestField(FORM_SYS_FIELD_PRESENTATION_FIELDS))
    If Len(sPresentationSequence) = 0 Then
        sPresentationSequence = objDataSource.GetSysParam("DRS_" & objTable.ObjectName)
    End If

    ' Composizione dei campi di input per il form corrente
    If Not _site.Frm.WriteTableInputFields(objTable.ObjectName, objDataSource, bRowInsert, _
                            bRowReadOnly Or bLocked, blnInvertParent, _
                            strErrFieldName, strErrMessage, _
                            sPresentationSequence, _
                            _site.Glb.RequestField(FORM_SYS_FIELD_PREVIEW_FIELDS), _
                            _site.Glb.RequestField(FORM_SYS_FIELD_HIDE_FIELDS)) Then
        _site.WriteFunctionKey_FormExit(Page)
        _site.Frm.Break_FormConstruction()
    End If

%>
<br><br>&nbsp;
<!--
	*********************
	Tasti funzione
	*********************
-->
<%
    If Not bRowReadOnly Then
        _site.Frm.WriteFunctionKey_FormConfirm()
        If (Not objDataSource.RowAdding OrElse _site.Glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL) > "0") Then
            Response.Write("&nbsp;")
            _site.Frm.WriteFunctionKey_FormApply()
        End If
    End If
    Response.Write("&nbsp;")
    _site.WriteFunctionKey_FormExit(Page)
%>
</form>
</font>

</td></tr>
</table></font>

<script type="text/javascript" language="javascript">
    <%
    If objTable.GroupNamesCount > 0 Then
    %>
    // Inizializza il gruppo
	//ShowGroupFields("", "");
    <%
    End If 
    %>
</script>
<%
    If _bAjaxEnabled Then
        ' Disabilita la gestione dell'Ajax nella libreria per evitare problemi in altre pagine 
        ' dove non è supportato
        _site.Frm.EnableAjaxToolKit("")
    End If

    ' DEBUG
    'Response.Write("R1: " & _site.Lib.GetDataLink().Connection.RelativeBaseFilePath(_site.Lib.GetDataLink().Database.AppName) & "</br>")
    'Response.Write("R2: " & _site.Lib.GetDataLink().Database.RelativeBaseFilePath(_site.Lib.GetDataLink().Database.AppName) & "</br>")
    'Response.Write("R3: " & _site.Lib.GetDataLink().Database.RelativeBaseFilePath("") & "</br>")

    'Dim dsProd As OODBMSObjLib.clsDataSource = _site.Lib.GetDataLink().GetDataSource("My_Prodotti")
    'Dim colEmbedded As OODBMSObjLib.clsDefColumn = dsProd.Object.ColField("Immagine")
    'Dim sRelativeDestPath As String = dsProd.GetEmbeddedFilePathRelative("biglietti.png", colEmbedded)
    'Response.Write("R4: " & sRelativeDestPath & "</br>")
    'Dim sDestPath As String = dsProd.GetEmbeddedFilePathAbsolute(sRelativeDestPath, colEmbedded)
    'Response.Write("R5: " & sDestPath & "</br>")

%>
</BODY>
</HTML>
