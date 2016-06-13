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
'		Azione richiesta per la griglia
'		Sono previste le seguenti azioni:
'				ACTION_ADD_NEW = "AddNew"
'					Attiva l'inserimento in entrata
'				ACTION_VIEW = "View"
'					Attiva la visualizzazione dei dati
'				ACTION_VIEW = "Edit"
'					Visualizza i dati con possibilità di modifica
'				ACTION_DELETE = "Delete"
'					Elimina i dati identificati da FORM_SYS_FIELD_DELETE_OID
'	FORM_SYS_FIELD_ENABLE_SELECT = "ooSYS_EnableSelect"
'		Se <> "" viene abilitata la selezione dei dati con la possibilità
'		di specificare il nome del frame di destinazione.
'		Specificando 'True' effettua la selezione nella pagina corrente, 
'		altrimenti specificando 'FRAME:[FrameName]' attiva la chiamata (submit)
'		nel frame relativo al nome indicato.
'		Per poter richiamare un altro frame la pagina di destinazione
'		deve seguire le seguenti regole:
'		- Deve contenere un Form che gestisce l'azione di selezione
'		- Il Form deve avere i seguenti campi relativi all'azione:
'				FORM_SYS_FIELD_DATA_PATH = "ooSYS_DataPath"
'				FORM_SYS_FIELD_REQUEST_ACTION = "ooSYS_RequestAction"
'				FORM_SYS_FIELD_OID = "ooSYS_OID"
'				FORM_SYS_FIELD_SOURCE_PAGE_NAME = "ooSYS_SourcePageName"
'	FORM_SYS_FIELD_READ_ONLY = "ooSYS_ReadOnly"
'		Se <> "" disabilita la possibilità di effettuare
'		modifiche sui dati, con le seguenti varianti:
'			READONLY_ONLY_ADD = "DisableAdd"
'				Disabilita solo la possibilità di aggiungere.
'			"True" o altro 
'				Disabilita qualsiasi modifica.
'	FORM_SYS_FIELD_OID = "ooSYS_OID"
'		In caso di selezione contiene l'OID relativo
'		ai dati selezionati
'	FORM_SYS_FIELD_DELETE_OID = "ooSYS_DeleteOIDs"
'		In caso di eliminazione è necessario
'		specificare l'OID o la lista degli OIDs.
'		Se più di uno suddividerli con la virgola (,)
'	FORM_SYS_FIELD_FOCUS = "ooSYS_FocusField"
'		Per eventuale posizionamento in un campo
'		del form in entrata.
'		Attualmente incluso solo per compatibilità
'		con <frmDataRow.asp> che usa lo stesso script 
'		lato client <scrClientScriptForm.asp>
'	FORM_SYS_FIELD_PRESENTATION_FIELDS = "ooSYS_PresentationFields"
'		Eventuale lista di campi da visualizzare per la 
'		presentazione dei dati.
'		Se non specificato verranno inclusi tutti i campi
'		presenti nella tabella e abilitati alla visualizzazione
'		per l'utente corrente.
'		Separare la lista dei campi mediante la virgola (,).
'	FORM_SYS_FIELD_PREVIEW_FIELDS = "ooSYS_PreviewFields"
'		Eventuale lista di campi da visualizzare in anteprima 
'		all'interno della griglia di presentazione dei dati.
'		I campi specificati devono essere immagini o dati presentabili
'		direttamente nella pagina HTML.
'		Separare la lista dei campi mediante la virgola (,).
'		E' possibile specificare un campo secondario per ogni campo
'		della lista di tipo file/immagine per visualizzare una 
'		rappresentazione di anterpima eventualmente presente
'		nei dati, separare le coppie di campi con i due punti (:) 
'		nel seguente modo:
'			[File/Immagine]:[ImmagineAnteprima],[Altro Campo],...
'	FORM_SYS_FIELD_TOTAL_FIELDS = "ooSYS_TotalFields"
'		Eventuale lista di campi da totalizzare in fondo 
'		alla griglia di presentazione dei dati.
'		I campi specificati devono essere di tipo numerico,
'		opzioni:
'		- (predefinito) vuoto ("") per attivare la sequenza
'		  di Default relativa ai campi numerici riconosciuti
'		  (Importi, Quantità, etc..).
'		  N.B.: se specificato FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS 
'				questa opzione si comporta come per nessuno ("NOTHING")
'		- Impostare i nomi dei campi separati dalla virgola (",")
'		- Impostare nessuno ("NOTHING") per disattivare i totali
'	FORM_SYS_FIELD_ORDER_FIELDS
'		Eventuale criterio di ordinamento (come per ORDER BY)
'	FORM_SYS_FIELD_ROW_SELECTION_IMAGE = "ooSYS_RowSelectionImage"
'		URL dell'immagine da visualizzare in corrispondenza
'		della funzione di selezione dei dati, se non specificato
'		imposta il tasto predefinito.
'	FORM_SYS_FIELD_DELETE_FILE = "ooSYS_DeleteFile"
'		URL dell'immagine da visualizzare in corrispondenza
'		della funzione di eliminazione dei dati, se non specificato
'		imposta il tasto predefinito.
'	FORM_SYS_FIELD_OPEN_IMAGE = "ooSYS_OpenImage"
'		URL dell'immagine da visualizzare in corrispondenza
'		della funzione di apertura dei dati, se non specificato
'		imposta il tasto predefinito.
'	FORM_SYS_FIELD_DEFAULT_LINKS_IMAGE = "ooSYS_DefaultLinksImage"
'		URL dell'immagine da visualizzare in corrispondenza
'		dei campi link (file o URL) selezionabili, i nomi dei campi
'		non devono comparire nella lista FORM_SYS_FIELD_PREVIEW_FIELDS, 
'		se non impostato visualizza il link effettivo contenuto in 
'		ogni campo.
'	FORM_SYS_FIELD_SEARCH_SEQUENCE = "ooSYS_SearchFieldSequence"
'		Se <> "" definisce la sequenza dei campi attivati
'		per la ricerca, opzioni:
'		- (predefinito) vuoto ("") per attivare la sequenza
'		  di Default relativa ai campi indicizzati.
'		  N.B.: se specificato FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS 
'				questa opzione si comporta come per nessuno ("NOTHING")
'		- Impostare asterisco ("*") per attivare
'		  la ricerca su tutti i campi.
'		- Impostare i nomi dei campi separati dalla virgola (",")
'		- Impostare nessuno ("NOTHING") per disattivare
'		  i campi di ricerca e ottenere sempre tutti i 
'		  dati contenuti nella tabella.
'	FORM_SYS_FIELD_SEARCH_WITH_COMBO = "ooSYS_SearchRefWithCombo"
'		Se <> "" attiva la ricerca sui campi reference 
'		mediante la selezione degli elementi presenti nella
'		tabella referenziata, opzioni:
'		- (predefinito) vuoto ("") la ricerca nei campi
'		  Reference viene attivata sul campo predefinito
'		  della tabella Referenziata nel caso delle Reference
'		  Multiple oppure Owned, mentre per le altre viene
'		  attivata quella con selezione (combo)
'		- Impostare "All" oppure "Yes" per attivare la ricerca
'		  con selezione (combo) su tutti i campi di tipo Reference
'		- Impostare i nomi dei campi separati dalla virgola (",")
'		- Impostare "NOTHING" per disattivare la selezione (combo)
'		  su tutte le Reference (anche per quelle predefinite)
'	FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS = "ooSYS_HideHeadAndFunctions"
'		Se <> "" (True) nasconde la struttura di contorno e i tasti funzione
'		visualizzando solo la tabella.
'		N.B.: questo parametro disabilita anche le impostazioni
'			  predefinite di FORM_SYS_FIELD_SEARCH_SEQUENCE e di
'			  FORM_SYS_FIELD_TOTAL_FIELDS
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

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Grid"

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
    ' Inizializzazione degli oggetti globali
    If Not _site.InitApplicationObjects(Me, False, True) Then
        ' Termina l'applicazione
        _site.Lib.EndApplication(True)
    End If

    ' Controlli 
    If _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH) = "" Or _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION) = "" Then

        '_site.Glb.RspMsg(FORM_SYS_FIELD_DATA_PATH & "=" & _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH))
        '_site.Glb.RspMsg(FORM_SYS_FIELD_REQUEST_ACTION & "=" & _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION))
        '_site.Glb.RspMsg(FORM_SYS_FIELD_DATA_PATH & "=" & Request(FORM_SYS_FIELD_DATA_PATH))
        '_site.Glb.RspMsg(FORM_SYS_FIELD_REQUEST_ACTION & "=" & Request(FORM_SYS_FIELD_REQUEST_ACTION))
        'Response.Write("<--" & Request.QueryString.AllKeys(2) & "=" & Request.QueryString(2) & "-->")
        '_site.Glb.RspMsg(Request.RawUrl)

        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Glb.RspErr("Operazione non valida!")
        Else
            _site.Glb.RspErr("Invalid operation!")
        End If
        Response.End()
    End If

' Identifica il tipo di operazione e le eventuali abilitazioni
    Dim strEnableSelect As String = _site.Glb.RequestField(FORM_SYS_FIELD_ENABLE_SELECT)
'
    Dim sAction As String = _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION)
    Dim bInsert As Boolean = False
    Dim bDelete As Boolean = False
    Dim bSelected As Boolean = False
    Dim bSearchEnabled As Boolean = False
    Select Case sAction
	
        Case ACTION_ADD_NEW
            sAction = ACTION_VIEW
            bInsert = True
		
        Case ACTION_DELETE, _
                CONFIRM_DELETE_ENG, CONFIRM_DELETE
            sAction = ACTION_VIEW
            bDelete = True
		
        Case ACTION_SELECT
            sAction = ACTION_VIEW
            bSelected = True
		
    End Select

' Identifica i dati della tabella o della Reference
    Dim sTableName As String = "", sRefName As String = ""
    _site.Frm.SplitDataPathElements(_site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH), sTableName, sRefName)
    If Not _site.DatLink.Database.Tables.Exist(CStr(sTableName)) Then
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Glb.RspErr("Origine " & sTableName & " non definita")
        Else
            _site.Glb.RspErr("Source " & sTableName & " undefined")
        End If
        Response.End()
    End If
    '
    Dim objTable As OODBMSObjLib.clsDataObject
    If _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME) <> "" And sRefName <> "" Then
        ' Dati da Reference
        objTable = _site.DatLink.Table(sTableName).References.Item(sRefName).ReferencedTable
    Else
        ' Dati da tabella 
        objTable = _site.DatLink.Table(sTableName)
    End If

    ' Effettua la validazione dell'azione
    If Not _site.Frm.ValidateUserAction(objTable.ObjectName, _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION)) Then
        _site.WriteFunctionKey_FormExit(Page)
        _site.Frm.Break_PageConstruction()
    End If

    ' Eventuale disabilitazione del titolo e dei tasti funzione
    Dim bHideHeadAndFunctions As Boolean = False
    If _site.Glb.RequestField(FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS) <> "" Then
        bHideHeadAndFunctions = True
    End If

%>
<!--
	*********************
	Composizione del Form
	*********************
-->
<%
' Identifica il nome del form
Dim sFormName = _site.Lib.GetCurrentPageName(Me) & objTable.ObjectName
%>

<table id="Grid_<%=objTable.ObjectName%>">
<!--<tr><td colspan="4">&nbsp;</td></tr>-->

<%
' Eventuale disabilitazione del titolo e 
' della struttura di contorno
If Not bHideHeadAndFunctions Then
%>

<tr><td width="2%"></td><td colspan="3" title="<%=objTable.Description%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+2 color=silver><i><b>&nbsp;<%=objTable.PresentationName%></i></b></font></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td colspan="2"></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td width="1%"></td>
<td>

<%	
Else
	%>

<tr><td width="2%"></td><td width="3%">&nbsp;</td><td width="1%"></td>
<td>

<%	
End If
%>

<!----------->
<!-- FORM --->
<!----------->
<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>"  id=<%=sFormName%>  name=<%=sFormName%>>
<%
' < Inclusione delle funzioni Form Java lato client >
%>
<%'UPGRADE_NOTE: Language element '#INCLUDE' was migrated to the same language element but still may have a different behavior. Copy this link in your browser for more: ms-its:C:\Programmi\ASP to ASP.NET Migration Assistant\AspToAspNet.chm::/1011.htm  %>
<%'UPGRADE_NOTE: The file 'OOLib/srcClientScriptForm.asp' was not found in the migration directory. Copy this link in your browser for more: ms-its:C:\Programmi\ASP to ASP.NET Migration Assistant\AspToAspNet.chm::/1003.htm  %>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<%

    ' Campi nascosti per le abilitazioni
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_READ_ONLY)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_ENABLE_SELECT)

    ' Imposta il campo nascosto con il nome identificativo dei dati
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_DATA_PATH)

    ' Imposta il campo nascosto che identifica il tipo di azione
    _site.Frm.WriteHiddenField(FORM_SYS_FIELD_REQUEST_ACTION, sAction)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_FORM_CONFIRM)

    ' Imposta il campo nascosto con il nome dell'oggetto Container
    ' eventualmente connesso a questi dati
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME)

    ' Imposta il campo nascosto relativo al livello di
    ' visualizzazione (PopUp) del form corrente
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL)

    'Imposta il campo nascosto per la selezione dei dati
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_OID)

    ' Imposta i campi con le opzioni di presentazione
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_PRESENTATION_FIELDS)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_PREVIEW_FIELDS)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_ROW_SELECTION_IMAGE)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_DELETE_FILE)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_OPEN_IMAGE)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_DEFAULT_LINKS_IMAGE)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_TOTAL_FIELDS)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_ORDER_FIELDS)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_SELECTED_ITEMS)

    ' Imposta il campo nascosto per eventuale dato sul quale 
    ' posizionarsi in entrata
    Dim strFocusFieldName As String = ""
    _site.Frm.WriteHiddenField(FORM_SYS_FIELD_FOCUS, strFocusFieldName)

    ' Imposta il campo nascosto con il nome della tabella effettiva contenente i dati
    _site.Frm.WriteHiddenField(FORM_SYS_FIELD_REAL_TABLE_NAME, objTable.ObjectName)

    ' Imposta il campi nascosti per i parametri di ricerca
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_SEARCH_SEQUENCE)
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_SEARCH_WITH_COMBO)

    ' Campo nascosto per la definizione del tipo di azione da
    ' intraprendere per le finestre PopUp
    _site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_USE_DEST_ACTION_FOR_POPUP_LEVEL)

    ' ----------------------------------
    ' In caso di selezione imposta i dati
    ' nell'eventuale Container e notifica
    ' la modifica al relativo form chiamante
    ' ----------------------------------
    Dim bError = False, objContainer As OODBMSObjLib.clsDataSource
    If bSelected Then
	
        '_site.Glb.RspErr _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME)
        'Response.End
        ' Se il livello del form è quello principale
        ' identifica la pagina di destinazione
        If _site.Glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL) <= "0" Or _site.Glb.RequestField(FORM_SYS_FIELD_USE_DEST_ACTION_FOR_POPUP_LEVEL) <> "" Then
		
            ' Scrive il codice per andare alla pagina destinazione
            If Not _site.WriteClientDestinationAction(Page, _site.Lib.GetCurrentPageName(Me), ACTION_SELECT, _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH)) Then
			
                ' Destinazione non trovata, termina la pagina
                _site.WriteFunctionKey_FormExit(Page)
                _site.Frm.Break_FormConstruction()
			
            End If
		
            ' Se è stato specificato il Container tenta
            ' di notificare l'impostazione
        Else
		
            If _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME) <> "" Then
			
                ' Identifica l'oggetto Container
                objContainer = Session(_site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME))
                If IsNothing(objContainer) Then
                    _site.Glb.RspErr("I dati (" & FORM_SYS_FIELD_CONTAINER_OBJECT_NAME & ") non sono più disponibili")
                    bError = True ' Errore
				
                    ' Se si tratta di reference tenta di impostarla
                    ' nel form del Container 
                ElseIf sRefName <> "" Then
				
                    ' Imposta la Reference
                    If Not _site.Lib.SetReference(objContainer, sRefName, _site.Glb.RequestField(FORM_SYS_FIELD_OID)) Then
                        bError = True ' Errore
					
                        ' Notifica l'impostazione della Reference al form Container
                        ' mediante lo script lato Client
                    ElseIf Not _site.Frm.WriteClientNotifierForSetReference(_site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME), sRefName, _site.Glb.RequestField(FORM_SYS_FIELD_OID)) Then
                        bError = True ' Errore
                    End If
				
                    ' Se si tratta di dati di una tabella Parent imposta
                    ' nel form del Container 
                Else
				
                    ' Imposta la Parent
                    If Not _site.Lib.SetParent(objContainer, sTableName, _site.Glb.RequestField(FORM_SYS_FIELD_OID)) Then
                        bError = True ' Errore
                        ' Notifica l'impostazione della Parent al form Container
                        ' mediante lo script lato Client
                    ElseIf _site.Frm.WriteClientNotifierForSetParent(_site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME), sTableName, _site.Glb.RequestField(FORM_SYS_FIELD_OID)) Then
                        bError = True ' Errore
                    End If
				
                End If
			
                ' Tenta di notificare l'impostazione al livello
                ' di form precedente che gestisce gli stessi dati
            Else
			
                If Not _site.Frm.WriteClientNotifierForUpdateData(sTableName, _site.Glb.RequestField(FORM_SYS_FIELD_OID)) Then
                    bError = True ' Errore
                End If
			
            End If
		
            ' Termina la pagina
            If Not bError Then
                If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                    _site.Glb.RspMsg("Impostazione effettuata...")
                Else
                    _site.Glb.RspMsg("Setting completed...")
                End If
            End If
            '
            _site.WriteFunctionKey_FormExit(Page)
            _site.Frm.Break_FormConstruction()
		
        End If
	
    End If

    ' Identifica eventuali selezioni sui campi da
    ' presentare
    Dim sFields As String = _site.Glb.RequestField(FORM_SYS_FIELD_PRESENTATION_FIELDS)

    ' Identifica i parametri con impostazioni
    ' predefinite (vedi definizioni parametri)
    Dim sTotalFields As String = _site.Glb.RequestField(FORM_SYS_FIELD_TOTAL_FIELDS)
    Dim sSearchSequence = _site.Glb.RequestField(FORM_SYS_FIELD_SEARCH_SEQUENCE)

    ' Eventuale disabilitazione dei tasti funzione
    If bHideHeadAndFunctions Then
	
        ' Disabilita i parametri con le impostazioni 
        ' predefinite (vedi definizione dei parametri)
        If sTotalFields = "" Then sTotalFields = "NOTHING"
        If sSearchSequence = "" Then sSearchSequence = "NOTHING"
	
    End If

    ' -----------------------------------------------
    ' Identifica i parametri di ricerca in entrata
    ' per comporre l'eventuale query (WHERE)
    ' -----------------------------------------------
    Dim sWhere As String = "", objSearch As OODBMSObjLib.clsSearch
    Dim sSelOrder As String = _site.Glb.RequestField(FORM_SYS_FIELD_ORDER_FIELDS)     ' Inizializza l'ordinamento
    If UCase(sSearchSequence) <> "NOTHING" Then
	
        objSearch = _site.Frm.ReadFormSearchCriterion(objTable.ObjectName, sSelOrder)
        sWhere = objSearch.QueryString ' Legge la query di ricerca
	
    End If

    ' ----------------------------------
    ' Effettua la lettura dei dati solo se:
    ' - Se la ricerca non è attiva 
    ' - Se è stato premuto il relativo tasto
    '   di ricerca
    ' - Se è stata richiesta una cancellazione
    ' ----------------------------------
    Dim sMax As String, nMax As Long, objDataSource As OODBMSObjLib.clsDataSource
    If UCase(sSearchSequence) = "NOTHING" _
                Or _site.Glb.RequestField(FORM_SYS_SEARCH_CONFIRM) <> "" _
                Or _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_OID) <> "" Then
	
        ' Controlla eventuale impostazione numero massimo di records
        sMax = _site.Glb.RequestField(FORM_SYS_SEARCH_FIELD_MAX_ELEMENTS)
        If sMax = "" Then sMax = "0"
        '
        If Not IsNumeric(sMax) Then
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                _site.Glb.RspErr("Numero massimo di elementi non valido!")
            Else
                _site.Glb.RspErr("Invalid max elements number!")
            End If
        Else
		
            ' Imposta il numero massimo + 1 per verificare
            ' la presenza di ulteriori elementi
            nMax = CInt(sMax)
            If nMax > 0 Then nMax = nMax + 1
		
            ' Identifica la sorgente dati (DataSource)
            ' Se si tratta di reference identifica i dati
            ' del container
            If _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME) <> "" And sRefName <> "" Then
			
                ' Identifica l'oggetto Container
                objContainer = Session(_site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME))
						
                ' NOTA: il nome della reference è nella forma completa ([TableName].[ReferenceName])
                If strEnableSelect <> "" Then
                    ' Permette la selezione dei dati per la Reference
                    If Not _site.Lib.GetReferenceSelection(objContainer, sRefName, _site.Glb.RequestField(FORM_SYS_FIELD_OID), _
                                        objDataSource, sWhere, _
                                        IIf(Len(sFields) > 0 AndAlso Left(sFields, 1) <> "*", "*," & sFields, sFields), _
                                        nMax, sSelOrder) Then
                        bError = True
                    End If
                Else
                    ' Legge i dati della Reference
                    If Not _site.Lib.GetReference(objContainer, sRefName, _site.Glb.RequestField(FORM_SYS_FIELD_OID), _
                                        objDataSource, sWhere, _
                                        IIf(Len(sFields) > 0 AndAlso Left(sFields, 1) <> "*", "*," & sFields, sFields), _
                                        nMax, sSelOrder) Then
                        bError = True
                    End If
                End If
            Else
			
                ' Legge i dati della tabella
                If Not _site.Lib.GetDataSource(objDataSource, sTableName, OODBMSObjLib.OODBMS_QueryOptions.oqoComplete, _
                                        sWhere, _
                                        sSelOrder, _
                                        IIf(Len(sFields) > 0 AndAlso Left(sFields, 1) <> "*", "*," & sFields, sFields), _
                                        nMax) Then
                    bError = True
                End If
			
            End If
		
        End If
	
    End If

    ' In caso di errore termina la pagina
    If bError Then
        _site.WriteFunctionKey_FormExit(Page)
        _site.Frm.Break_FormConstruction()
    End If

    ' ----------------------------------
    ' Esegue eventuale eliminazione dei dati
    ' ----------------------------------
    If Not IsNothing(objDataSource) Then
        If bDelete And _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_OID) <> "" Then
		
            ' Elimna i records identificati dagli OIDs specificati
            'If _site.Lib.DeleteRowByOIDs( objDataSource, _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_OID), True) Then
            If _site.Lib.DeleteRowByOIDs(objDataSource, _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_OID)) Then
			
                If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                    _site.Glb.RspMsg("Eliminazione effettuata...")
                Else
                    _site.Glb.RspMsg("Data deleted...")
                End If
                _site.Glb.RspMsg("")
			
            Else
                ' Termina il form
                '_site.WriteFunctionKey_FormExit
                '_site.Frm.Break_FormConstruction			
            End If
		
        End If
    End If

    ' Eventuale disabilitazione dei tasti funzione
    If Not bHideHeadAndFunctions Then
	
        ' Imposta il tasto di uscita iniziale
        _site.WriteFunctionKey_FormExit(Page)
	
        ' Tasto di aggiornamento visualizzazione
        ' richiamando (submit) questa stessa
        ' pagina (solo se non è attiva la ricerca)
        If UCase(sSearchSequence) = "NOTHING" Then
		
            'If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            '    _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT style=""FONT-SIZE: x-small""" & " NAME=""" & CONFIRM_REFRESH & """ VALUE=""" & CONFIRM_REFRESH & """ TITLE=""Aggiorna la visualizzazione dei dati"">")
            'Else
            '    _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT style=""FONT-SIZE: x-small""" & " NAME=""" & CONFIRM_REFRESH & """ VALUE=""" & CONFIRM_REFRESH_ENG & """ TITLE=""Refresh the visualization of the data"">")
            'End If
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT style=""FONT-SIZE: x-small""" & " VALUE=""" & CONFIRM_REFRESH & """ TITLE=""Aggiorna la visualizzazione dei dati"">")
            Else
                _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT style=""FONT-SIZE: x-small""" & " VALUE=""" & CONFIRM_REFRESH_ENG & """ TITLE=""Refresh the visualization of the data"">")
            End If
		
        End If
        '	
        _site.Frm.WriteLn("<br><br>")
	
    End If

    ' -----------------------------------------------
    ' Se richiesto effettua la pulizia dei campi
    ' di ricerca
    ' -----------------------------------------------
    If _site.Glb.RequestField(FORM_SYS_SEARCH_CLEAR) <> "" Then
	
        ' Ripulisce tutti i campi di ricerca
        _site.Glb.ClearRequestFields(FORM_SYS_SEARCH_FIELDS_PREFIX)
	
    End If

    ' -----------------------------------------------
    ' Composizione della griglia con i criteri di ricerca
    ' -----------------------------------------------
    If UCase(sSearchSequence) <> "NOTHING" Then
	
        ' Identifica i parametri di ricerca in entrata
        ' per comporre la query
        sSelOrder = _site.Glb.RequestField(FORM_SYS_FIELD_ORDER_FIELDS)     ' Inizializza l'ordinamento
        objSearch = _site.Frm.ReadFormSearchCriterion(objTable.ObjectName, sSelOrder)
        sWhere = objSearch.QueryString ' Legge la query di ricerca
	
        ' Se non ci sono parametri di ricerca in entrata
        ' ed è stata attivata la ricerca imposta per
        ' nascondere
        Dim bHideOnEntry = False
        If sWhere <> "" And _site.Glb.RequestField(FORM_SYS_SEARCH_CONFIRM) <> "" Then
            'If _site.Glb.RequestField(FORM_SYS_SEARCH_CONFIRM) <> "" Then
            'bHideOnEntry = True
        End If
	
        ' Tabella con i campi relativi alla ricerca
        If Not _site.Frm.WriteTableInputFieldsForSearch(objTable.ObjectName, sSearchSequence, bHideOnEntry, _site.Glb.RequestField(FORM_SYS_FIELD_SEARCH_WITH_COMBO)) Then
            _site.Frm.Break_PageConstruction()
        End If
        '
        _site.Frm.WriteLn("<br>")
	
        ' Visualizza il tasto di ricerca
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT " & _site.Glb.GetParam("HTML_FIXED_SEARCH_BUTTON_STYLE") & " NAME=""" & FORM_SYS_SEARCH_CONFIRM & """ VALUE=""" & CONFIRM_SEARCH & """ TITLE=""Aggiorna la ricerca dei dati"">")
        Else
            _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT " & _site.Glb.GetParam("HTML_FIXED_SEARCH_BUTTON_STYLE") & " NAME=""" & FORM_SYS_SEARCH_CONFIRM & """ VALUE=""" & CONFIRM_SEARCH_ENG & """ TITLE=""Refresh the search of the data"">")
        End If
	
        ' Annulla le impostazioni di ricerca
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT " & _site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE") & " NAME=""" & FORM_SYS_SEARCH_CLEAR & """ VALUE=""" & CONFIRM_SEARCH_CLEAR & """ TITLE=""Annulla le impostazioni di ricerca correnti"">")
        Else
            _site.Frm.WriteLn("&nbsp;<INPUT TYPE=SUBMIT " & _site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE") & " NAME=""" & FORM_SYS_SEARCH_CLEAR & """ VALUE=""" & CONFIRM_SEARCH_CLEAR_ENG & """ TITLE=""Reset current search setting"">")
        End If
	
        ' Imposta anche il numero massimo di elementi
        sMax = _site.Glb.RequestField(FORM_SYS_SEARCH_FIELD_MAX_ELEMENTS)
        If sMax = "" Then sMax = _site.Glb.GetParam("MAX_SEARCH_RESULT_ELEMENTS")
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Frm.WriteLn("&nbsp;&nbsp;&nbsp;Max.<INPUT TYPE=TEXT " & _site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE") & " SIZE=5 NAME=""" & FORM_SYS_SEARCH_FIELD_MAX_ELEMENTS & """ VALUE=""" & sMax & """ TITLE=""Numero massimo di elementi nella ricerca (impostare 0 per tutti)"">")
        Else
            _site.Frm.WriteLn("&nbsp;&nbsp;&nbsp;Max.<INPUT TYPE=TEXT " & _site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE") & " SIZE=5 NAME=""" & FORM_SYS_SEARCH_FIELD_MAX_ELEMENTS & """ VALUE=""" & sMax & """ TITLE=""Max search result elements (set 0 for all)"">")
        End If
	
        ' Se l'utente è abilitato visualizza il tasto per aggiungere dati
        ' (in caso di visualizzazione esito ricerca il tasto viene attivato dalla griglia)
        'If objTable.CanUserAdd And _site.Glb.RequestField(FORM_SYS_FIELD_READ_ONLY) = "" And _site.Glb.RequestField(FORM_SYS_SEARCH_CONFIRM) = "" Then
        If objTable.CanUserAdd And _site.Glb.RequestField(FORM_SYS_FIELD_READ_ONLY) = "" Then
            _site.Frm.WriteLn("&nbsp;&nbsp;&nbsp;")
            _site.Frm.WriteFunctionKey_AddRow()
        End If
        '	
        _site.Frm.WriteLn("<br><br>")
	
    End If

    'rsperr _site.Glb.RequestField(FORM_SYS_FIELD_CONTAINER_OBJECT_NAME) & "-" & objContainer.MemoryObjectID & "-" & objContainer.RowAdding & "," & objContainer.GetReference("Elementi").RowCount
    ' -----------------------------------------------
    ' Composizione della griglia con i dati richiesti
    ' -----------------------------------------------
    If Not IsNothing(objDataSource) Then
	
        ' Se il numero di elementi trovati supera il massimo
        ' visualizza messaggio di avvertimento
        Dim bTooElements = False
        sMax = _site.Glb.RequestField(FORM_SYS_SEARCH_FIELD_MAX_ELEMENTS)
        If IsNumeric(sMax) And sMax <> "0" And sMax <> "" Then
            If objDataSource.RowCount(True) > CInt(sMax) Then
                ' Troppi elementi trovati
                bTooElements = True
                If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                    _site.Glb.RspMsgSmall("ATTENZIONE:\nSono stati trovati oltre " & sMax & " elementi, impostare parametri di ricerca più restrittivi oppure aumentare il limite massimo.")
                Else
                    _site.Glb.RspMsgSmall("ATTENTION:\nFound over " & sMax & " elements, set mutch restrictive search parameters or increase the max limit.")
                End If
                _site.Glb.RspMsg("")
            End If
        End If
	
        ' Costruisce la griglia
        If Not _site.Frm.WriteDataGrid(objDataSource, "", strEnableSelect, _
                    _site.Glb.RequestField(FORM_SYS_FIELD_READ_ONLY), _site.Glb.RequestField(FORM_SYS_FIELD_PREVIEW_FIELDS), _
                    sTotalFields, _site.Glb.RequestField(FORM_SYS_FIELD_ROW_SELECTION_IMAGE), _
                    _site.Glb.RequestField(FORM_SYS_FIELD_DEFAULT_LINKS_IMAGE), _
                    _site.Glb.RequestField(FORM_SYS_FIELD_DELETE_FILE), _
                    _site.Glb.RequestField(FORM_SYS_FIELD_OPEN_IMAGE), _
                    sFields) Then
            _site.Frm.Break_PageConstruction()
        End If
	
        ' Eventuale segnale per rammentare che gli elementi
        ' sono più di quelli visualizzati
        If bTooElements Then
            If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
                _site.Glb.RspMsg("ALTRI...")
            Else
                _site.Glb.RspMsg("OTHERS...")
            End If
        End If
	
    End If

%>
<!--
	*********************
	Tasti funzione
	*********************
-->
<%
' Eventuale disabilitazione del tasto di uscita
If Not bHideHeadAndFunctions And Not IsNothing(objDataSource) Then
	%>
	<br>
	<br>
<%	
	_site.WriteFunctionKey_FormExit(Page)
End If
%>

</form>
</td></tr>
</table>
</BODY>
</HTML>
