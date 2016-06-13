<%
'========================================== 
' Questo script permette di gestire le funzioni 
' all'interno di un form di immssione / modifica dati
' lato client.
'
' N.B.:
'	Le pagine che fanno uso della libreria devono
'	includere questo modulo.
'
'	La direttiva ValidateRequest="false" impostata
'	all'inizio della pagina serve per
'	disabilitare la validazione integrata di .Net
'	per evitare segnalazioni specialmente nelle
'	aree di testo che potrebbero inviare
'	anche contenuti HTML
'
' I campi nascosti richiesti nel form corrente da questo script sono:
'	- FORM_SYS_FIELD_DATA_PATH				' Nome della tabella gestita o della Reference
'	- FORM_SYS_FIELD_REAL_TABLE_NAME		' Nome effettivo della tabella gestita
'	- FORM_SYS_FIELD_REQUEST_ACTION			' Tipo di azione richiesta <p_strAction>
'	- FORM_SYS_FIELD_FOCUS					' Eventuale campo di posizionamento in entrata
'
' N.B.: Inlcudere questo script dopo aver inizializzato
'		gli oggetti di sessione, vedi:
'		- _site.Lib.InitializeGlobalObjects()
'		- _site.Lib.StartApplication()
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
'========================================== 

' Eventuale inizializzazione degli oggetti
' globali per la gestione della pagina
' mediante le funzioni di libreria

' Definizione del percorso base che contiene tutte le pagine se diverso da quello attuale (vedi anche ResolveClientUrl)
Const _SITE_ROOT_ As String = ""     ' "~/"
'
If Not _site.Glb.PageInitialized Then
	_site.Glb.InitializeGlobal(Me)
End If

%>
<script type="text/javascript" language="javascript">
<!--
// ======================================================================
// Funzioni di supporto
//
// NOTA:
// L'utilizzo di queste funzioni (o parte di esse) in applicazioni non
// concesse da LogiCode Srl è perseguibile per legge.
//
// Tutti i diritti sono riservati a 
// LogiCode Srl
// Via Marco Perennio, 30
// 52100 - Arezzo (AR)
// www.logicode.it
// info@logicode.it
// Tel 0575-401315  Fax 0575-405361
// ======================================================================
var bFocusOpenOnClose = true;			

// Riporta True se il campo/reference specificato 
// è presente nel form
function FieldFormExist(sName)
{
	return ExternFieldFormExist(sName,document.forms.item(0));
}
// Riporta True se il campo/reference specificato 
// è presente nel form di un'altro documento
function ExternFieldFormExist(sName,frm)
{
	if( sName == "" || frm == null )
		return false;
	
	// Si posiziona nel primo campo valido
	for( nCo=0; nCo < frm.elements.length; nCo++ )
	{
		if( frm.elements.item(nCo).name == sName )
			return true;
	}
	return false;
}

// ======================================================================
// Riporta il nome della fonte dati relativa alla tabella reale corrente 
// Vedi: FORM_SYS_FIELD_REAL_TABLE_NAME
function GetFormTableName()
{
	return GetExternFormTableName(document.forms.item(0))
}
function GetExternFormTableName(frm)
{	
	if( ExternFieldFormExist("<%=FORM_SYS_FIELD_REAL_TABLE_NAME%>",frm) )
		return GetExternFormControl("<%=FORM_SYS_FIELD_REAL_TABLE_NAME%>",frm).value;
/*	{
		var sName = GetExternFormControl( "<%=FORM_SYS_FIELD_DATA_PATH%>", frm ).value;
		var nPos = sName.indexOf(".");
		if( nPos != -1 )
			return sName.substr(nPos+1);
		else
			return sName;
	}*/
	else if( ExternFieldFormExist("<%=FORM_SYS_FIELD_DATA_PATH%>",frm) 
				&& GetExternFormControl("<%=FORM_SYS_FIELD_DATA_PATH%>",frm).value.indexOf(".")==-1)
		return GetExternFormControl("<%=FORM_SYS_FIELD_DATA_PATH%>",frm).value;
	else
		// Gestione dati tabella non supportata
		return "";
}

// ======================================================================
// Riporta il nome della fonte dati relativa alla tabella Container corrente 
// solo nel caso in cui il nome specificato sia nel formato 
// [ContainerTableName].[ReferenceName] riporta il nome del
// Container, altrimenti vuoto ("")
// Vedi: FORM_SYS_FIELD_DATA_PATH
function GetFormContainerTableName()
{
	return GetExternFormContainerTableName(document.forms.item(0))
}
function GetExternFormContainerTableName(frm)
{	
	var sName = "", nPos;
	//if( ExternFieldFormExist("<%=FORM_SYS_FIELD_DATA_PATH%>", frm) )
		sName = GetExternFormControl( "<%=FORM_SYS_FIELD_DATA_PATH%>", frm ).value;
	nPos = sName.indexOf(".");
	if( nPos != -1 )
		return sName.substr(0,nPos);
	else
		// Container non presente
		return "";
}

// ======================================================================
// Riporta il Control del Form relativo al nome specificato
function GetFormControl( vItem )
{
	return GetExternFormControl(vItem, document.forms.item(0));
}
function GetExternFormControl( vItem, frm )
{
	// Identifica l'elemento
	var ctrl;
	if( typeof(vItem) == "string" )
		ctrl = frm.elements.namedItem(vItem);
	else
		ctrl = frm.elements.item(vItem);
	
	// Se si tratta di matrice riporta il primo elemento
	try
	{
		ctrl = ctrl.item(0);
	}
	catch( e )
	{
		// ...
	}	
	return ctrl;
}

// ======================================================================
// Questa funzione visualizza le informazioni
// relative ad un control del form
//
// N.B.: Per implementare automaticamente questa 
//		 funzionalità nei controls aggiungere
//		 la costante predefinita all'interno
//		 del TAG di definizione del campo.
//		 La costante è definita in <mod_site.Lib.Const>
//		 con il nome di HTML_FIXED_CONTROL_TAGS
// 
function SetStatus(objControl)
{
	// Imposta le informazioni relative al control
	window.status = " < " + objControl.title + " >";

	// Memorizza il nome dell'ultimo controls attivato
	// che viene reimpostato in entrata nel caso di
	// una chiamata a questa stessa pagina per aggiornare
	// dei dati
	if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value=objControl.name;
}

// ======================================================================
// Questa funzione effettua il posizionamento in un tag id con scroll 
function ScrollTo(id)
{
    try
    {
        var el = document.getElementById(id);
        ScrollToElement(el);
    } catch (e) { }
}
function ScrollToElement(el)
{
    try
    {
        //e.preventDefault();
        $('html, body').animate({ scrollTop: $(el).offset().top - 100 }, 800);
    } catch (e) { }
}

// ======================================================================
// Questa funzione effettua le operazioni di uscita da un campo
// relative ad un control del form
function FieldExit(objControl)
{
	//.. attualmente inutilizzato
}

// ======================================================================
// Questa funzione tenta di attivare un control del form
function ActivateControl( sFieldName )
{
	// Verifica se è necessario attivare
	// il gruppo specificato che contiene il campo
	var sGroups = "";
	if( FieldFormExist("ooSys_TableGroups") )
		sGroups = GetFormControl("ooSys_TableGroups").value;
	//
	var nCo = 0, arrGroup = sGroups.split(",");
	var sFoundGrp = "", sGroupFields = "";
	if( sGroups.length > 0 )
	{
		for( nCo = 0; nCo < arrGroup.length; nCo++ )
		{
			if( FieldFormExist("ooSys_TableGroup_"+arrGroup[nCo]) )
			{
				sGroupFields = "," + GetFormControl("ooSys_TableGroup_"+arrGroup[nCo]).value + ",";	
				if( sGroupFields.indexOf(","+sFieldName+",") != -1 )
				{
					sFoundGrp = arrGroup[nCo];
					break;
				}
			}
		}
	}
	if( FieldFormExist("ooSys_TableGroupName") )	
	{
		<%
		If _site.Glb.GetBoolean(_site.Glb.GetParam("ALL_FIELDS_IN_MAIN_GROUP")) Then
		%>
		if( GetFormControl("ooSys_TableGroupName").value != "" 
				&& GetFormControl("ooSys_TableGroupName").value != sFoundGrp ) 
		<%
		Else
		%>
		if( GetFormControl("ooSys_TableGroupName").value != sFoundGrp ) 
		<%
		End If
		%>
		{
			// Necessario posizionarsi nel gruppo
			ShowGroupFields(sFoundGrp,"");
		}
	}
		
	// Tenta di attivare un campo semplice
	var objCtrl;
	if( FieldFormExist(sFieldName) )
		objCtrl = document.forms.item(0).elements.namedItem(sFieldName);
	// Tenta di attivare un tasto della reference
	else if( FieldFormExist("Set_" + sFieldName) )
		objCtrl = document.forms.item(0).elements.namedItem("Set_" + sFieldName);
	else if( FieldFormExist("Add_" + sFieldName) )
		objCtrl = document.forms.item(0).elements.namedItem("Add_" + sFieldName);
	else if( FieldFormExist("Sel_" + sFieldName) )
		objCtrl = document.forms.item(0).elements.namedItem("Sel_" + sFieldName);

	// Tenta di attivare il control		
	ScrollToElement(objCtrl);
	try
	{
	    objCtrl.focus();
	    if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	        GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sFieldname;
	}
	catch( e )
	{
		// Tenta di attivare il priimo elemento 
		// si si tratta di una matrice
		try
		{
		    objCtrl(0).focus();
		    if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
			    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sFieldname;
        }
		catch( e )
		{
			// nessun errore
		}
	}
}		

// ======================================================================
// Queste funzioni controllano l'attivazione di una finestra PopUp
// alla volta.
// 
// N.B.: Per assicurare la chiusura delle finestre è necessario
//		 richiamare la funzione ClosePopUpWindow() in uscita
//		 dalla pagina, vedi evento window_onload() già definito
//		 di seguito.
//
// (vedi funzioni che fanno riferimento a objPopUpWindow di seguito)
var objPopUpWindow;			// Gestisce una finestra correlata
//
function ClosePopUpWindow()	
{
	try
	{
		// Chiude la finestre correlate
        if( IsValidPopUpWindow() )
				objPopUpWindow.close();
	}
	catch( e )
	{
		// nessun errore
	}
}
function IsValidPopUpWindow()
{
	try
	{
		// Chiude la finestre correlate
		if( objPopUpWindow != undefined && objPopUpWindow != null )
		{
			if( !objPopUpWindow.closed )
				return true;
		}
	}
	catch( e )
	{
		// nessun errore
	}
}
//
function OpenPopUpImageManager( sFilePath, sTitle, nXDim, nYDim )
{
	var sPage = "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_IMAGE_MANAGER")))%>";
	var sParams = "<%=FORM_SYS_FIELD_IMAGES_PATH%>=" + sFilePath + "&<%=FORM_SYS_FIELD_IMAGES_TITLE%>=" + sTitle;
	//
	OpenPopUpWindow( sPage, sParams, nXDim, nYDim, true, true );
}
//
function OpenPopUpWindow( sPage, sParams, nXDim, nYDim, bScroll, bSizable )
{

	// Identifica le dimensioni, se non specificate (0) imposta
	// quelle predefinite rispetto alla dimensione dello schermo
	var nWidth = nXDim, nHeight = nYDim;
	if( nWidth == 0 )
		nWidth = window.screen.width * <%=Replace(_site.Glb.GetParam("DEFAULT_DATA_ROW_FORM_WIDTH"), ",", ".")%>;

	if( nHeight == 0 )
		nHeight = window.screen.height * <%=Replace(_site.Glb.GetParam("DEFAULT_DATA_ROW_FORM_HEIGHT"), ",", ".")%>;

	// Impostazione proprietà
	var sSizable = "no", sScroll = "no";
	if( bScroll )
		sScroll = "yes";
	if( bSizable )
		sSizable = "yes";

	// Incrementa il livello di form corrente
	var nPopUpLevel = 1;
	if( FieldFormExist("<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>") )
	{
		if( !isNaN(parseInt(GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value)) )
			nPopUpLevel = parseInt(GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value)+1;
	}
	var sNewParams = sParams, sDiv = "?";
	if( sNewParams != "" )
		sNewParams = sNewParams + "&";
	sNewParams = sNewParams + "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>=" + nPopUpLevel;
    if( sPage.indexOf("?") >= 0 )
        sDiv = "&";
    
	// Identifica la posizione di PopUp rispetto alla finestra precedente
	// Per ogni livello sposta la finestra in basso a destra
	var nLeft = (nPopUpLevel*(window.screen.width/100));
	var nTop = (nPopUpLevel*(window.screen.height/100));

	// Chiude eventuale finestra PopUp attiva
	ClosePopUpWindow();

	// Apre la finestra per il calcolo del codice fiscale
	objPopUpWindow = window.open( sPage + sDiv + sNewParams, 
		"_blank", "status=yes,location=no,menubar=no,scrollbars=" + sScroll + "," +
					"width=" + nWidth + ",height=" + nHeight + "," + 
					"left=" + nLeft + ",top=" + nTop + ",resizable=" + sSizable );
}
function OpenPopUpWindowFile( sURL, nXDim, nYDim, bScroll, bSizable )
{
	// Identifica le dimensioni, se non specificate (0) imposta
	// quelle predefinite rispetto alla dimensione dello schermo
	var nWidth = nXDim, nHeight = nYDim;
	if( nWidth == 0 )
		nWidth = window.screen.width * <%=Replace(_site.Glb.GetParam("DEFAULT_DATA_ROW_FORM_WIDTH"), ",", ".")%>;
	if( nHeight == 0 )
		nHeight = window.screen.height * <%=Replace(_site.Glb.GetParam("DEFAULT_DATA_ROW_FORM_HEIGHT"), ",", ".")%>;

	// Impostazione proprietà
	var sSizable = "no", sScroll = "no";
	if( bScroll )
		sScroll = "yes";
	if( bSizable )
		sSizable = "yes";
		
	// Identifica la posizione centrale rispetto allo schermo
	var nLeft = (window.screen.width-nWidth)/2;
	var nTop = (window.screen.height-nHeight)/2;

//alert(sNewParams);	

	// Chiude eventuale finestra PopUp attiva
	ClosePopUpWindow();
	
	// Apre la finestra per il calcolo del codice fiscale
	objPopUpWindow = window.open( sURL, 
		"_blank", "status=yes,location=no,menubar=no,scrollbars=" + sScroll + "," +
					"width=" + nWidth + ",height=" + nHeight + "," + 
					"left=" + nLeft + ",top=" + nTop + ",resizable=" + sSizable );
}

// ======================================================================
// Riporta il frame richiesto
// ritorna anche da eventuali finestre PopUp attive
// N.B.: se il frame non viene trovato notifica l'errore (se richiesto)
//	 riportando comunque l'ultimo frame identificato
// ======================================================================
function GetFrame( sFrameName, bNotifyErrors )
{
	// Ciclo di ricerca del frame
	var wndOld = undefined;
	var wnd = window.window;	// Accorgimento necessario per supportare browser differenti da IE (per es. Firefox)
	while(wnd.name.toUpperCase() != sFrameName.toUpperCase()) {
		if( wndOld == wnd ) {
			if( bNotifyErrors )
				alert("frame [" + sFrameName + "] non identificato!");
			return wnd;	// riporta l'ultimo frame trovato
		}
		wndOld = wnd;
	<%
	' Se è attiva una connessione protetta non è possibile
	' accedere a eventuali finestre sottostanti
	If UCase(Request.ServerVariables.Item("HTTPS")) = "OFF" Then
		%>
		try { 
    		while( wnd.opener != undefined 
		            && wnd.frames.length == 0
    		        && wnd.opener != null ) {
	            wndOld = wnd;		
	    		wnd = wnd.opener.top;
		    }
		}
        catch(e){wnd = wndOld;}
	<%	
	End If
	%>

		// Ricerca il frame
		var wnd1 = wnd;
		try { 
			wnd = wnd.parent.window;
			if( wnd.name.toUpperCase() == sFrameName.toUpperCase() )
				return wnd; 
		}
		catch(e) { // l'accesso alla finestra potrebbe non essere possibile 
		}
		if( wnd == undefined )
			wnd = wnd1;

		wnd1 = wnd;
		try { 
			wnd = wnd.top.frames[sFrameName]; 
		}
		catch(e) { 
			wnd = wnd.top;
		}
		if( wnd == undefined )
			wnd = wnd1;

	}
	//

	return wnd;
}
function GetTopFrame(bIncludePopUp)
{
	// Ciclo di ricerca del frame
	var wnd = window.window;	// Accorgimento necessario per supportare browser differenti da IE (per es. Firefox)
	var wndOld;
    try { 
		if( wnd.top != undefined && wnd.top != null )
            wnd = wnd.top; 
    } catch(e) {}
    try { 
		if( wnd.parent != undefined && wnd.parent != null )
            wnd = wnd.parent; 
    } catch(e) {}
	<%
	' Se è attiva una connessione protetta non è possibile
	' accedere a eventuali finestre sottostanti
	If UCase(Request.ServerVariables.Item("HTTPS")) = "OFF" Then
		%>
	try {
		while( bIncludePopUp 
		            && wnd.frames.length == 0
		            && wnd.opener != undefined 
		            && wnd.opener != null ) {
		    wndOld = wnd;
			wnd = wnd.opener;
	        try { 
    			if( wnd.top != undefined && wnd.top != null )
		            wnd = wnd.top; 
	        } catch(e1) {}
	        try { 
    			if( wnd.parent != undefined && wnd.parent != null )
		            wnd = wnd.parent; 
	        } catch(e1) {}
		}
	}
	catch(e) { 
	    wnd = wndOld;
	}
	<%	
	End If
	%>
	//
	return wnd;
}
// ======================================================================
// Riporta il frame (oggetto) che contiene l'applicazione in esecuzione
// ritorna anche da eventuali finestre PopUp attive
// ======================================================================
function GetApplicationFrame()
{
<%
' Identifica il frame di destinazione
Dim sFrame
sFrame = ""
If CStr(Session("g_strMainFrameName")) <> "" Then
	sFrame = Session("g_strMainFrameName")
ElseIf Request(FORM_SYS_FIELD_CLIENT_ACTION_FRAME) <> "" Then 
	sFrame = Request(FORM_SYS_FIELD_CLIENT_ACTION_FRAME)
Else
	sFrame = FRAME_CONTENT_PAGES
End If
%>
	return GetFrame("<%=sFrame%>", true);
}
function GetContentFrame()
{
	var wnd = GetFrame("<%=FRAME_CONTENT_PAGES%>", false);
	if(wnd.name.toUpperCase() != "<%=FRAME_CONTENT_PAGES%>".toUpperCase())
		wnd = GetApplicationFrame();
	return wnd;
}

// ======================================================================
// Riporta il frame (oggetto) che contiene l'applicazione in esecuzione
// rimanendo nell'eventuale finestra PopUp attiva
// ======================================================================
function GetApplicationFrameStayPopUp()
{
	if( window.opener != undefined && window.opener != null )
		return window.top;
	else
		return GetApplicationFrame();
}

// ======================================================================
// Aggiorna il frame specificato se presente nella pagina corrente
// ======================================================================
function ReloadFrame( sFrameName )
{
	var wnd = GetFrame(sFrameName,false);
	if( wnd.name != "LogoutFrame" 
	        && wnd.name.toUpperCase() == sFrameName.toUpperCase() )
		wnd.location = wnd.location;
		//wnd.location.reload;
}

// ======================================================================
// Riporta true se esiste il frame specificato
// ======================================================================
function ExistFrame( sFrameName )
{
	var wnd = GetFrame(sFrameName, false);
	if( wnd.name.toUpperCase() == sFrameName.toUpperCase() )
		return true;	
	else
		return false;
}

// ======================================================================
// Richiama la pagina di uscita dall'applicazione
// ======================================================================
function EndApplication( bConfirm )
{
	// Chiede conferma per l'uscita
	if( bConfirm ) {
<%
If _site.Language = OODBMS_LocaleLanguage.ollItalian Then
	%>	
		if( !window.confirm( "Confermi l'uscita?" ) )
<%	
Else
	%>	
		if( !window.confirm( "Confirm the exit?" ) )
<%	
End If
%>	
			return;
	}
	//
	var wnd = GetApplicationFrame();
	if( wnd != window.top || wnd.opener == undefined || wnd.opener == null )
		wnd.location = "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_APP_END")))%>";

	// Eventuale chiusura della pagina 
	if( window.opener != undefined && window.opener != null )
		window.close();
}

// ======================================================================
// Richiama la pagina corrente con gli stessi parametri specificati 
// in entrata aggiungendo il parametro FORM_SYS_FIELD_EXTENDED_ACTION
// con il contenuto specificato
// ======================================================================
function ReloadPage( sExtendedAction )
{
    // Se possibile attiva l'aggiornamento mediante submit()
    var done = false, eFail;
    if( document.forms.length > 0 ){
        try{
            if( sExtendedAction.length > 0 && FieldFormExist("<%=FORM_SYS_FIELD_EXTENDED_ACTION%>") )  
                GetFormControl("<%=FORM_SYS_FIELD_EXTENDED_ACTION%>").value = sExtendedAction;
            if( FieldFormExist("<%=FORM_SYS_FIELD_FORM_CONFIRM%>") )
                GetFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>").value="";
            document.forms.item(0).submit();
            done = true;
        }
        catch(e){
            eFail=e;
        }
    }

<%
' Identifica i parametri dalla QueryString oppure dal Form
Dim sParams
sParams = _site.Glb.GetURLQuerySysFields()

' Se la stringa dei parametri contiene caratteri non validi 
' usa l'invio mediante submit del form
If Instr(sParams, Chr(13)) = 0 AndAlso Instr(sParams, Chr(10)) = 0 Then	
%>
    // Altrimenti aggiorna mediante location
    if(!done){
        // Imposta il parametro
        //var sParams = "<%=Server.HtmlEncode(sParams)%>";
        var sParams = "<%=sParams%>";
        /*var nPos = sParams.indexOf("&amp;<%=FORM_SYS_FIELD_EXTENDED_ACTION%>");
        if( nPos == -1 )*/
        nPos = sParams.indexOf("&<%=FORM_SYS_FIELD_EXTENDED_ACTION%>");
        if( nPos != -1 )
            sParams = sParams.substr(1,nPos-1);
        if( sParams.length > 0 )
            //sParams = sParams + "&amp;";
            sParams = sParams + "&";
        sParams = sParams + "<%=FORM_SYS_FIELD_EXTENDED_ACTION%>=" + sExtendedAction;
        // 
        //alert("<%=Request.ServerVariables.Item("URL")%>?" + sParams);	
        window.location = "<%=Request.ServerVariables.Item("URL")%>?" + sParams;
        done = true;
    }
<%
End If
%>
    // Notifica eventuale errore
    if(!done && eFail){
        <%
        If _site.Language = OODBMS_LocaleLanguage.ollItalian Then
            %>	
            alert("Operazione non supportata");
        <%	
        Else
            %>	
            alert("Unsupported operation");
        <%	
        End If
        %>	
    }
}

// ======================================================================
// Funzioni di Inserimento / Visualializzazione / Modifica / Cancellazione
// ======================================================================
function ViewRowEx(vntOID,sDataPath,sParams)	// N.B.: per impostare <sParams> vedi frmDataRow
{
	// Eventuale oggetto Container globale specificato in questo form
	var sContainerObjName = "";
	if( FieldFormExist( "<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>" ) )
		GetFormControl( "<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>" ).value;
	if( sParams != "" )
		sParams = "&" + sParams;
	
	// Apre la finestra PopUp
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_ROW")))%>",
				"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sDataPath
					+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
					+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_VIEW%>"
					+ "&<%=FORM_SYS_FIELD_OID%>=" + vntOID
					+ sParams, 
					0, 0, true, true );
}
function ViewRow(vntOID,sDataPath)
{
	ViewRowEx(vntOID,sDataPath,"");
}
function ViewEditRow(vntOID)
{
	// Eventuale oggetto Container globale specificato in questo form
	var sContainerObjName = GetFormControl( "<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>" ).value;
	var sSelectionEnabled = "", sDataPath = "<%=_site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH)%>";
	if( FieldFormExist( "<%=FORM_SYS_FIELD_ENABLE_SELECT%>" ) )
		sSelectionEnabled = GetFormControl( "<%=FORM_SYS_FIELD_ENABLE_SELECT%>" ).value;
	if( sDataPath == "" && FieldFormExist( "<%=FORM_SYS_FIELD_DATA_PATH%>" ) )
		sDataPath = GetFormControl( "<%=FORM_SYS_FIELD_DATA_PATH%>" ).value;
	//
	ViewEditRowEx(vntOID,sDataPath,"",sContainerObjName,sSelectionEnabled)
}
function ViewEditRowEx(vntOID,sDataPath,sParams,sContainerObjName,sSelectionEnabled)
{
    // Valida eventuali parametri aggiuntivi
	if( sParams != "" )
		sParams = "&" + sParams;
		
	// Apre la finestra PopUp
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_ROW")))%>",
				"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sDataPath
					+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
					+ "&<%=FORM_SYS_FIELD_ENABLE_SELECT%>=" + sSelectionEnabled
					+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_EDIT%>"
					+ "&<%=FORM_SYS_FIELD_OID%>=" + vntOID
					+ sParams, 
					0, 0, true, true );
}
function InsertRow()
{
	// Eventuale oggetto Container globale specificato in questo form
	var sContainerObjName = GetFormControl( "<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>" ).value;
	var sSelectionEnabled = GetFormControl( "<%=FORM_SYS_FIELD_ENABLE_SELECT%>" ).value;

	// Apre la finestra PopUp
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_ROW")))%>",
				"<%=FORM_SYS_FIELD_DATA_PATH%>=<%=Request(FORM_SYS_FIELD_DATA_PATH)%>"
					+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
					+ "&<%=FORM_SYS_FIELD_ENABLE_SELECT%>=" + sSelectionEnabled
					+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_ADD_NEW%>", 
					0, 0, true, true );
}
function DeleteRow()
{
	// Chiede conferma di cancellazione
<%
If _site.Language = OODBMS_LocaleLanguage.ollItalian Then
	%>	
	if( !window.confirm( "Eliminare gli elementi selezionati?" ) )
<%	
Else
	%>	
	if( !window.confirm( "Delete the selected elements?" ) )
<%	
End If
%>	
		return;
	
	// Attiva l'elminazione dei dati richiamando
	// questa stessa pagina con l'azione "Insert"
	// Il campo FORM_SYS_FIELD_DELETE_OID del form corrente,
	// contiene gli OIDs da eliminare, se 
	// gli OIDs sono più di uno vengono suddivisi 
	// da virgola (,)
	document.forms.item(0).action=document.location.pathname;
    //GetFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>").value="<%=CONFIRM_DELETE_ENG%>";
	GetFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>").value="<%=ACTION_DELETE%>";
	document.forms.item(0).submit();
}
function SubmitUpdate() 
{
    bFocusOpenOnClose = false;	// Evita di riattivare il focus nell'eventuale finestra chiamante (opener)
    //GetFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>").value="<%=CONFIRM_UPDATE%>";
    GetFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>").value="<%=CONFIRM_UPDATE_ENG%>";
	document.forms.item(0).submit();
}
function SubmitApply() 
{
    bFocusOpenOnClose = false;	// Evita di riattivare il focus nell'eventuale finestra chiamante (opener)
    //GetFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>").value="<%=CONFIRM_APPLY%>";
    GetFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>").value="<%=CONFIRM_APPLY_ENG%>";
	document.forms.item(0).submit();
}

// Aggiorna i valori correnti rileggendo quelli 
// eventualmente modificati senza archiviare
// nel database
function RefreshValues( doc )
{

	// Attiva l'aggiornamento dei dati richiamando
	// questa stessa pagina:
	// - Se si tratta di Form effettua il Refresh
	// - Se si tratta di griglia effettua il Refresh
	if( doc.forms.length > 0 )
	{
		// Richiama questa stessa pagina con submit	
		doc.forms.item(0).action=doc.location.pathname;
		doc.forms.item(0).target = "_self";

//alert(doc.forms.item(0).action);		
		// Controlla se presente il campo di coferma da impostare
		// su Refresh
		if( ExternFieldFormExist("<%=FORM_SYS_SEARCH_CONFIRM%>",doc.forms.item(0)) ) 
		{
		    // Eventuale aggiornamento della ricerca attuale
		    if( window.opener && window.opener.document == doc )
                // Chiude il popup aperto senza aggiornare la ricerca
                window.close();
            else
                GetExternFormControl("<%=FORM_SYS_SEARCH_CONFIRM%>",doc.forms.item(0)).click();
		} 
		else if( ExternFieldFormExist("<%=FORM_SYS_FIELD_FORM_CONFIRM%>",doc.forms.item(0)) )
		{
		    // Imposta la conferma sulla modalità aggiornamento
		    // per rivisualizzazione dati
		    //GetExternFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>",doc.forms.item(0)).value="<%=CONFIRM_REFRESH%>";
		    //GetExternFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>",doc.forms.item(0)).click();
		    
		    ////doc.window.location = doc.window.location;
		    GetExternFormControl("<%=FORM_SYS_FIELD_FORM_CONFIRM%>",doc.forms.item(0)).value="";
		    doc.forms.item(0).submit();
		}
		else
		    // Reimposta la videata per aggiornare la visualizzazione
		    doc.forms.item(0).submit();
	}
	//else if(doc.window)
	//    doc.window.location = doc.window.location;
	else
	    doc.location = doc.location;
}

// ======================================================================
// Visualizza i campi relativia al gruppo specificato
// Specificare vuoto "" per il gruppo principale
// ======================================================================
function ShowGroupFields( sName, sRemarkableFieldName )
{
	// Scrorre tutti i campi per visualizzare
	// quelli presenti nel gruppo
	//try
	//{
		var sFocusFld = sRemarkableFieldName, sFldPrefix = "Field_";
		var sFldGroupAll = "," + GetFormControl("ooSys_TableGroupAll").value + ",";
		var sGroupFields = "";
		if( sName.length > 0 )
			// Identifica i campi contenuti nel gruppo
			sGroupFields = "," + GetFormControl("ooSys_TableGroup_"+sName).value + ",";
		for( nCo=0; nCo < TableFields.rows.length; nCo++ )
		{
			// Identifica la riga che contiene il campo
			var rw = TableFields.rows.item(nCo)
			var bShow = false;
			if( rw.id.substr(0,sFldPrefix.length) == sFldPrefix )
			{
				// Verifica se visualizzare il campo
				var sFldName = rw.id.substr(sFldPrefix.length);
				if( sName.length == 0 )		// Si tratta del gruppo principale se il nome = ""
				<%
				If _site.Glb.GetBoolean(_site.Glb.GetParam("ALL_FIELDS_IN_MAIN_GROUP")) Then
				%>
					bShow = true;
				<%
				Else
				%>
					bShow = (sFldGroupAll.indexOf(","+sFldName+",")==-1);
				<%
				End If
				%>
				else
					bShow = (sGroupFields.indexOf(","+sFldName+",")!=-1);
				//
//alert(sName + "\n" + sFldName + "\n" + bShow);
				if( bShow )
				{
					rw.style.display = "";
					if( sFocusFld.length == 0)
						sFocusFld = sFldName;
				}
				else
					rw.style.display = "none";
			}
		}
		
		// Imposta il gruppo corrente
		GetFormControl("ooSys_TableGroupName").value = sName;
		
		// Attiva il campo rilevante
		if( sFocusFld.length > 0 )
			ActivateControl(sFocusFld);
	/*}
	catch(e)
	{
		alert(e);
	}*/
}

// ======================================================================
// Selezione dei dati della griglia.
// Se <sDestFrame> è vuoto ("") attiva l'impostazione (submit) nel
// form corrente, altrimenti in quello del frame specificato.
// ======================================================================
function SelectRow( vntOID, sDestFrame )
{
	if( sDestFrame == "" )
	{
		// Attiva la selezione dei dati richiamando
		// questa stessa pagina con l'azione "Select"
		// Il campo FORM_SYS_FIELD_OID del form corrente,
		// contiene l'OID selezionato
		document.forms.item(0).action=document.location.pathname;
		GetFormControl("<%=FORM_SYS_FIELD_OID%>").value=vntOID;
		GetFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>").value="<%=ACTION_SELECT%>";
		document.forms.item(0).submit();
	}
	else
	{
		// Imposta la selezione nel form di destinazione
		var frame, frm, sMissing = "";
		try
		{
			//frame = document.frames.item(sDestFrame);
			frame = document.frames[sDestFrame];
			frm = frame.document.forms.item(0)
		}
		catch(e)
		{
			alert( "Form del frame di destinazione <" + sDestFrame + "> non trovato!" );
			return;
		}
		
		// Attiva la selezione dei dati richiamando
		// la pagina del frame specificato con l'azione "Select"
		// Imposta i dati di selezione nei campi.
		if( ExternFieldFormExist("<%=FORM_SYS_FIELD_REQUEST_ACTION%>",frm) )
			GetExternFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>",frm).value="<%=ACTION_SELECT%>";
		else
			sMissing = "<%=FORM_SYS_FIELD_REQUEST_ACTION%>";
		if( ExternFieldFormExist("<%=FORM_SYS_FIELD_OID%>",frm) )
			GetExternFormControl("<%=FORM_SYS_FIELD_OID%>",frm).value=vntOID;
		else
			sMissing = "<%=FORM_SYS_FIELD_OID%>";
		if( ExternFieldFormExist("<%=FORM_SYS_FIELD_DATA_PATH%>",frm) )
			GetExternFormControl("<%=FORM_SYS_FIELD_DATA_PATH%>",frm).value=GetFormControl("<%=FORM_SYS_FIELD_DATA_PATH%>").value;
		else
			sMissing = "<%=FORM_SYS_FIELD_DATA_PATH%>";
		if( ExternFieldFormExist("<%=FORM_SYS_FIELD_SOURCE_PAGE_NAME%>",frm) )
			GetExternFormControl("<%=FORM_SYS_FIELD_SOURCE_PAGE_NAME%>",frm).value="<%=_site.Lib.GetCurrentPageName(Me)%>";
		else
			sMissing = "<%=FORM_SYS_FIELD_SOURCE_PAGE_NAME%>";
		if( sMissing != "" )
		{
			alert( "Campo <" + sMissing + "> mancante nel form del frame di destinazione <" + sDestFrame + ">" );
			return;
		}
		frm.action=frame.document.location.pathname;
		frm.submit();
	}
}

// ======================================================================
// Selezione dei dati Parent
// Richiama la pagina di gestione della griglia di 
// selezione PAGE_NAME_DATA_GRID.
// Se l'utente conferma la selezione viene richiamato
// l'evento <OnSelectRow()>
// ======================================================================
function SelectParent( sParentName )
{
	// Controlli
	if( GetFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>").value != "<%=ACTION_ADD_NEW%>" )
	{
        // Notifica avvetimento se non si tratta di inserimento
        if( !window.confirm( "ATTENZIONE! Questa operazione permette di variare " +
                "i riferimenti relativi ai dati della sezione " + sParentName +
                "\n\nContinuare ?" ) )
            return;
	}

	// Nome dell'oggetto Container globale gestito da questo form
	var sContainerObjName = "<%=ODBMS_DS_FORM_PREFIX%>" 
					+ GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value;

	// Richiama la griglia per la selezione della Parent
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")))%>",
				"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sParentName
				+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
				+ "&<%=FORM_SYS_FIELD_ENABLE_SELECT%>=True"
				+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_VIEW%>", 
					0, 0, true, true );
}

// ======================================================================
// Selezione / Aggiunta / Cancellazione di Reference
//
// N.B.: <sReferenceName> deve essere il nome completo
//		 [TableName].[RefName]
// ======================================================================
function SelectReference( sReferenceName, bSearchOnEntry )
{
	// Nome dell'oggetto Container globale gestito da questo form
	var sContainerObjName = "<%=ODBMS_DS_FORM_PREFIX%>" 
					+ GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value;
	// Attiva la ricerca in entrata se richiesto
	var sSearchParam = "";
	if( bSearchOnEntry )
		sSearchParam = "&<%=FORM_SYS_SEARCH_CONFIRM%>=<%=CONFIRM_SEARCH_ENG%>";

    // Imposta campo corrente per eventuale riposizionamento
	if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sReferenceName;

	// Richiama la griglia per la selezione della Reference
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_GRID")))%>",
				"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sReferenceName
				+ sSearchParam
				+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
				+ "&<%=FORM_SYS_FIELD_ENABLE_SELECT%>=True"
				+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_VIEW%>", 
					0, 0, true, true );
}
function AddReference( sReferenceName )
{
	// Nome dell'oggetto Container globale gestito da questo form
	var sContainerObjName = "<%=ODBMS_DS_FORM_PREFIX%>" 
					+ GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value;
					
    // Imposta campo corrente per eventuale riposizionamento
	if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sReferenceName;
    
    // Apre la finestra di aggiunta reference specificando
	// il container corrente
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_ROW")))%>",
		"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sReferenceName
			+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
			+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_ADD_NEW%>",
		0, 0, true, true );
}
function ViewReference( sReferenceName, vntRefOID )
{
	// Nome dell'oggetto Container globale gestito da questo form
	var sContainerObjName = "<%=ODBMS_DS_FORM_PREFIX%>" 
					+ GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value;
					
    // Imposta campo corrente per eventuale riposizionamento
	if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sReferenceName;
    
    // Apre la finestra di aggiunta reference specificando
	// il container corrente
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_ROW")))%>",
		"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sReferenceName
			+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
			+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_VIEW%>"
			+ "&<%=FORM_SYS_FIELD_OID%>=" + vntRefOID, 
		0, 0, true, true );
}
function EditReference( sReferenceName, vntRefOID )
{
	// Nome dell'oggetto Container globale gestito da questo form
	var sContainerObjName = "<%=ODBMS_DS_FORM_PREFIX%>" 
					+ GetFormControl( "<%=FORM_SYS_FIELD_FORM_PUPUP_LEVEL%>" ).value;
					
    // Imposta campo corrente per eventuale riposizionamento
	if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sReferenceName;
    
    // Apre la finestra di aggiunta reference specificando
	// il container corrente
	OpenPopUpWindow( "<%=ResolveClientUrl(_SITE_ROOT_ & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_DATA_ROW")))%>",
		"<%=FORM_SYS_FIELD_DATA_PATH%>=" + sReferenceName
			+ "&<%=FORM_SYS_FIELD_CONTAINER_OBJECT_NAME%>=" + sContainerObjName
			+ "&<%=FORM_SYS_FIELD_REQUEST_ACTION%>=<%=ACTION_EDIT%>"
			+ "&<%=FORM_SYS_FIELD_OID%>=" + vntRefOID, 
		0, 0, true, true );
}
function DeleteReference( sReferenceName )
{
	// Chiede conferma di cancellazione
	if( !window.confirm( "Eliminare gli elementi selezionati?" ) )
		return;
	
    // Imposta campo corrente per eventuale riposizionamento
	if( FieldFormExist("<%=FORM_SYS_FIELD_FOCUS%>") )
	    GetFormControl("<%=FORM_SYS_FIELD_FOCUS%>").value = sReferenceName;

    // Attiva l'elminazione dei dati richiamando
	// questa stessa pagina impostando il nome della
	// Reference in <FORM_SYS_FIELD_DELETE_REFERENCE_NAME>
	// Il campo identificato dal nome della reference specificata
	// viene complitato in automatico dal submit() con gli
	// OIDs da eliminare, se gli OIDs sono più di uno vengono suddivisi 
	// da virgola (,)
	// Questa compilazione avviene in automatico perchè i 
	// campi checkbox impostati per l'eliminazione hanno tutti lo
	// stesso nome della Reference
	document.forms.item(0).action=document.location.pathname;
	GetFormControl("<%=FORM_SYS_FIELD_DELETE_REFERENCE_NAME%>").value=sReferenceName;
	document.forms.item(0).submit();
}

// ======================================================================
// Annulla l'impostazione di un file di tipo embedded.
// L'eliminazione avviene impostando <> "" il campo nascosto 
// relativo al campo del file specificato.
// Il nome del campo nascosto è composto nel seguente modo:
// _f_Del[sFieldName]
// Inoltre modifica la visualizzazione dei tasti View_[FieldName] e 
// Del_[FieldName]
// ======================================================================
function DeleteEmbeddedFileNameField( sFieldName )
{
	// Chiede conferma di cancellazione
	if( !window.confirm( "Eliminare l'impostazione di questo file ?" ) )
		return;
		
	// Annulla il campo
	GetFormControl("_f_Del"+sFieldName).value = "True";

	// Disabilita il tasto di visualizzazione 
	GetFormControl("View_"+sFieldName).disabled = true;
	GetFormControl("View_"+sFieldName).value = "eliminato";
	GetFormControl("Del_"+sFieldName).style.display = "none";
}

// ======================================================================
// Notifica l'impostazione di un dato al form chiamante.
// Identifica la finestra che gestisce il dato in modo da
// aggiornarlo e rivisualizzare la situazione corrente
// ======================================================================
function NotifyOpener_SetParent( sContainerTableName, vntContainerOID, sParentOIDColumnName, vntParentOID )
{
	var doc = document, frm, docLast, wnd = window.top;	
	for(;;)
	{

		// Identifica il documento del form container
		/*while(wnd.parent != null && wnd.parent != wnd && wnd.parent == undefined )
			wnd = wnd.parent;*/
		if( wnd.opener == undefined || wnd.opener == null )
			break;	// fine controlli
		wnd = wnd.opener;
		doc = wnd.document;
	
		// Identifica la corrispondenza del container
		if( doc.forms.length > 0 )
		{
			// Il nome della tabella deve corrispondere
			frm = doc.forms.item(0);
			if( sContainerTableName == GetExternFormTableName(frm) )
			{
				// L'OID deve corrispondere
				if( ExternFieldFormExist("<%=FORM_SYS_FIELD_OID%>" ,frm) )
				{
					if( vntContainerOID == GetExternFormControl("<%=FORM_SYS_FIELD_OID%>" ,frm).value )
					{
						// Imposta la Parent
						if( ExternFieldFormExist(sParentOIDColumnName,frm) )
						{
							GetExternFormControl(sParentOIDColumnName,frm).value = vntParentOID;
							
							// Memorizza l'oggetto per la successiva notifica
							// di aggiornamento dati
							docLast = doc;
							break;
						}
					}				
				}
			}
		}
	}
	//
	if( docLast != undefined )
		// Completa l'operazione richiedendo la rivisualizzazione
		// dei dati eventualmente aggiornati
		RefreshValues( docLast );
}
function NotifyOpener_UpdateData( sTableName, vntOID )
{
	var doc = document, frm, docLast, wnd = window.top;	
	for(;;)
	{
		// Identifica il documento del form container
		/*while(wnd.parent != null && wnd.parent != wnd && wnd.parent == undefined )
			wnd = wnd.parent;*/
		if( wnd.opener == undefined || wnd.opener == null )
			break;	// fine controlli
		wnd = wnd.opener;
		doc = wnd.document;
		
		// Identifica la corrispondenza del container
		if( doc.forms.length > 0 )
		{
			// Il nome della tabella deve corrispondere
			frm = doc.forms.item(0);
			if( sTableName == GetExternFormTableName(frm) )
			{
				// L'OID deve corrispondere
				/*if( ExternFieldFormExist("<%=FORM_SYS_FIELD_OID%>" ,frm) )
				{
					if( vntOID == GetExternFormControl("<%=FORM_SYS_FIELD_OID%>" ,frm).value )
					{*/
						// Memorizza l'oggetto per la successiva notifica
						// di aggiornamento dati
						docLast = doc;
						break;
				/*	}				
				}*/
			}
		}
	}
	//
	if( docLast != undefined )
		// Completa l'operazione richiedendo la rivisualizzazione
		// dei dati eventualmente aggiornati
		RefreshValues( docLast );

    else
	{
	    // Verifica anche eventuali frames
	    // nel documento corrente
	    if( window.parent.frames.length > 0 )
        {
		    var nCo, doc = window.parent.document;
		    for( nCo = 0; nCo < doc.frames.length; nCo++ )
		    {
			    // Identifica il documento nel frame
			    docFrame = doc.frames[nCo].document;
				
			    // Identifica la corrispondenza del container
			    if( docFrame.forms.length > 0 )
			    {
				    // Il nome della tabella deve corrispondere
				    frm = docFrame.forms.item(0);
				    if( sTableName == GetExternFormTableName(frm) )
				    {
					    // L'OID deve corrispondere
					    /*if( ExternFieldFormExist("<%=FORM_SYS_FIELD_OID%>" ,frm) )
					    {
						    if( vntOID == GetExternFormControl("<%=FORM_SYS_FIELD_OID%>" ,frm).value )
						    {*/
							    // Notifica l'aggiornamento dati al frame
							    RefreshValues( docFrame );
							    return;
					    /*	}				
					    }*/
				    }
			    }
            }
		}			
        // Se il documento chiamante (container) non è stato identificato chiude comunque
        // la maschera se esiste un livello inferiore
		if( wnd.opener == undefined || wnd.opener == null )
        {
		    //RefreshValues(doc);
            wnd.location = wnd.location
            wnd.close();
        }
	}
}
function NotifyOpener_SetReference( sContainerTableName, vntContainerOID, sReferenceOIDColumnName, vntReferenceOID )
{
	var doc = document, frm, docLast, wnd = window.top;
	for(;;)
	{
		// Identifica il documento del form container
		/*while(wnd.parent != null && wnd.parent != wnd && wnd.parent == undefined )
			wnd = wnd.parent;*/
		if( wnd.opener == undefined || wnd.opener == null )
			break;	// fine controlli
		wnd = wnd.opener;
		doc = wnd.document;

		// Identifica la corrispondenza del container
		if( doc.forms.length > 0 )
		{
			// Il nome della tabella deve corrispondere
			frm = doc.forms.item(0);
//alert(doc.forms.length);
//alert(frm.action);
//alert("(" + sContainerTableName + ")\n(" + GetExternFormTableName(frm) + ")\n" + vntContainerOID + "\n" + sReferenceOIDColumnName + "\n" + (GetExternFormTableName(frm)==sContainerTableName));		
//alert(sContainerTableName + "\n" + GetExternFormContainerTableName(frm) + "\n" + vntContainerOID + "\n" + sReferenceOIDColumnName);		
			//if( sContainerTableName == GetExternFormContainerTableName(frm) )
			if( sContainerTableName == GetExternFormTableName(frm) )
			{
//alert("OK: " + sContainerTableName );		
				// L'OID deve corrispondere
				if( ExternFieldFormExist("<%=FORM_SYS_FIELD_OID%>" ,frm) )
				{
//alert("OID " + vntContainerOID + "=" + GetExternFormControl("<%=FORM_SYS_FIELD_OID%>" ,frm).value + " - " + (vntContainerOID == GetExternFormControl("<%=FORM_SYS_FIELD_OID%>" ,frm).value));
					// Controlla se l'OID corrisponde oppure se si tratta di inserimento
					var sRequestAct = "";
					if( GetExternFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>" ,frm) )
					    sRequestAct = GetExternFormControl("<%=FORM_SYS_FIELD_REQUEST_ACTION%>" ,frm).value;
//alert(sRequestAct);
					if( ( sRequestAct == "<%=ACTION_INSERT%>" || sRequestAct == "<%=ACTION_ADD_NEW%>" )
						||	vntContainerOID == GetExternFormControl("<%=FORM_SYS_FIELD_OID%>" ,frm).value )
					{
//alert("OK: " + sContainerTableName + " OID: " + vntContainerOID );		
						// Imposta la Reference solo se specificata
						if( ExternFieldFormExist(sReferenceOIDColumnName,frm) )
							GetExternFormControl(sReferenceOIDColumnName,frm).value = vntReferenceOID;
							
						// Memorizza l'oggetto per la successiva notifica
						// di aggiornamento dati
						docLast = doc;
//alert(docLast.forms.item(0).action);								
						break;
					}				
				}
			}
			else if( sContainerTableName == GetExternFormContainerTableName(frm) )
			{
				//...da verificare anche l'OID del Container
				// Memorizza l'oggetto per la successiva notifica
				// di aggiornamento dati
				docLast = doc;
				//break;
			}
		}
	}
	//
	if( docLast != undefined )
		// Completa l'operazione richiedendo la rivisualizzazione
		// dei dati eventualmente aggiornati
		RefreshValues( docLast );
}



// ======================================================================
// Riporta un oggetto di tipo XMLHttpRequest tentandone la creazione
// nei più diffusi browser supportati
// ======================================================================
function NewHttpRequest() {
    var xmlhttp=false;
     try {
      xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
     } catch (e) {
      try {
       xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
      } catch (E) {
       xmlhttp = false;
      }
     }
    if (!xmlhttp && typeof XMLHttpRequest!='undefined') {
	    try {
		    xmlhttp = new XMLHttpRequest();
	    } catch (e) {
		    xmlhttp=false;
	    }
    }
    if (!xmlhttp && window.createRequest) {
	    try {
		    xmlhttp = window.createRequest();
	    } catch (e) {
		    xmlhttp=false;
	    }
    }
    //
    if( xmlhttp )
        return xmlhttp;
    else
        return undefined;
}

// ======================================================================
// Attiva l'editor HTML sul contenuto (value) del control specificato
// ======================================================================
function EditHTMLCtrl( ctrl, bTextOnly, bBodyOnly )
{
	var sResult = EditHTMLText( ctrl.value, bTextOnly, bBodyOnly );
	if( sResult.length > 0 )
	{
		ctrl.value = sResult;
		return true;
	}
	else
		return false;
}
function EditHTMLText( sHTMLText, bTextOnly, bBodyOnly )
{
	// Identifica i dati da editare
	var args = new Array(), rets = null;
	var sResult = "";
	args["HTMLContent"] = sHTMLText;
	if( bTextOnly )
		// Attiva la modalità solo testo
		args["TextOnly"] = "true";
	if( bBodyOnly )
		// Attiva la modalità solo BODY
		args["BodyOnly"] = "true";

	// Avvia l'editor
	rets = showModalDialog( "<%=ResolveClientUrl(_SITE_ROOT_ & "DHTMLEditor/frmDHTMLEditor.aspx")%>",
                            args,
                            "resizable:1; help:0; status:0; dialogWidth:50em; dialogHeight:30em");

	// Acquisisce eventuale esito
	if( rets != null ) 
	{
		for( elem in rets ) 
		{
			if( "HTMLContent" == elem && rets["HTMLContent"] != null) 
				sResult = rets["HTMLContent"];
		}
	}
	//
	return sResult;
}

// ===================================================================
// Gestisce l'inserimento assistito della data e ora
// ===================================================================
function AssistDateTimeInsertion(ctrl) {
    // Assiste l'inserimento della data
    if (ctrl.value.length == 2
        || ctrl.value.length == 5)
        ctrl.value = ctrl.value + '/';
    // Eventuale spazio tra la data e l'ora
    if (ctrl.value.length == 10 && (ctrl.maxlength==0 || ctrl.maxlength > 10))
        ctrl.value = ctrl.value + ' ';
    // Assiste l'inserimento dell'ora
    if (ctrl.value.length == 13
        || ctrl.value.length == 16)
        ctrl.value = ctrl.value + ':';
    ctrl.value = ctrl.value.replace('//','/');
    ctrl.value = ctrl.value.replace('/-','/');
    ctrl.value = ctrl.value.replace('::',':');
    ctrl.value = ctrl.value.replace('  ',' ');
}

// ======================================================================
// Ridimensiona la finestra adattandola all'unica immagine presente
// ======================================================================
function ResizeWndToImage() 
{
   	try
   	{
		if( document.images[0] ) 
			window.resizeTo(document.images[0].width +30, document.images[0].height+60);
	}
	catch(e) 
	{
	}
}

// ======================================================================
// Legge il contenuto di un file riportando una stringa codificata
// per l'invio al server
// ======================================================================
function GetEncodedFileContent( sFilePath )
{
   	// Caricamento del file
   	var fso;
   	try
   	{
   		fso = new ActiveXObject("Scripting.FileSystemObject")
   	}
   	catch( e )
   	{
		alert( "Impossibile eseguire questa operazione se le impostazioni di sicurezza del browser non lo permettono..." +
				"\n\nL'errore è: " + e.description );
		return "";
	}
   	if( !fso.FileExists(sFilePath) )
   	{
       alert( "Errore: " + sFilePath + " file non trovato"  );
       return "";
	}
   	try
   	{
	   	sFileBuf = fso.OpenTextFile(sFilePath, 1).ReadAll();
   	}
   	catch( e )
   	{
		alert( "Impossibile leggere il file specificato..." +
				"\n\nL'errore è: " + e.description );
		return "";
	}
	//alert(sFileBuf);
	return sFileBuf;
}
//-->
</script>

<!--
	Eventi predefiniti
-->
<SCRIPT LANGUAGE=javascript>
<!--
// VAR. INFORMATIVA
var nSessionTimout = <%=Session.Timeout%>;
var sURL = "";

// Richiamato dal Browser in entrata nella pagina
function StartOperations()
{
	// Attiva la pagina corrente
	try
	{
        window.focus();
	}
	catch( e )
	{
		// ignora eventuale errore
	}
    
    // Memorizza l'URL attuale
    sURL = document.location;
        
    // Posizionamento nel campo in entrata
	if( document.forms.length > 0 )	{
		var nCo, sFocusName = "";
		
		// Se specificato, si posiziona nel campo indicato
		// dall'applicazione
		if( FieldFormExist( "<%=FORM_SYS_FIELD_FOCUS%>" ) )
			sFocusName = GetFormControl( "<%=FORM_SYS_FIELD_FOCUS%>" ).value;
		if( sFocusName != "" )
			ActivateControl( sFocusName );
		else {
			// Se presente si posiziona sul primo gruppo
			if( FieldFormExist("ooSys_TableGroups") )
				ShowGroupFields("","");
			else {
				// Si posiziona nel primo campo valido
				for( nCo=0; nCo < document.forms.item(0).elements.length; nCo++ ) {
					if( GetFormControl( nCo ).type != "hidden" ) {
						// Controlla che sia un controllo abilitato e visibile
						if(	!GetFormControl( nCo ).disabled 
								&& !GetFormControl( nCo ).readOnly
								&& GetFormControl( nCo ).style.display != "none" ) {
							//alert(GetFormControl( nCo ).name + " " + GetFormControl( nCo ).readOnly);
   							try {
								GetFormControl( nCo ).focus();
							}
							catch( e ) {
								// ignora eventuale errore
							}
							break;
						}				
					}
				}
			}
		}
	}
}

// Richiamato dal Browser in uscita dalla pagina 
function CloseOperations()
{
	// Chiude eventuale finestra PopUp attiva
	ClosePopUpWindow();

	// Se la finestra era stata chiamata da un'altra
	// di livello inferiore l'attiva
    if( bFocusOpenOnClose )
//	if( document.readyState == "complete"
//			|| document.readyState == 4 )	// (complete) se è in caricamento non si tratta di chiusura della finestra
	{
		if( window.opener != undefined && window.opener != null )
		{
			try
			{
                // Riattiva la finestra sottostante solo se non è in corso il passaggio ad un'altro indirizzo
				if( !window.opener.closed && document.location == sURL )
                {
                    window.opener.focus();
                }
			}
			catch( e )
			{
				// ignora eventuale errore
			}
		}
	}
}

// Inizializzazioni per gli eventi dalla pagina -->
window.onload = StartOperations;
window.onunload = CloseOperations;
//-->
</script>

