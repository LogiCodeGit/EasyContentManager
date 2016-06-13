// ... da completare
// DHTML Editor Support Module for DHTMLEditor.ascx Web Control

//
// Constants
//
var MENU_SEPARATOR = "";								// Context menu separator
var PAGE_PRINT_TEMPLATE = "Print/PrintTemplate.htm";	// Pagina contenente la maschera di stampa
//
// Microsoft IE Command for ExecWB function
var WB_OPEN = 1;				// Open 
var WB_SAVE = 4;				// Save As 
var WB_PRINT = 6;				// Print
var WB_PRINTPREVIEW = 7;		// Print Preview
var WB_PRINTPAGESETUP = 8;		// Print Page Setup

//
// Globals
//
var docComplete = false;
var initialDocComplete = false;
var bReturnDlgOnSave = false;
var bTextOnly = false;

var QueryStatusToolbarButtons = new Array();
var QueryStatusEditMenu = new Array();
var QueryStatusFormatMenu = new Array();
var QueryStatusHTMLMenu = new Array();
var QueryStatusTableMenu = new Array();
var QueryStatusZOrderMenu = new Array();
var ContextMenu = new Array();
var GeneralContextMenu = new Array();
var TableContextMenu = new Array();
var AbsPosContextMenu = new Array();
var sContent = ""; 
var sLastFind = ""; 
var nTimeInterval = 0;
var bCommandExecuting = false;
var rangeLast = undefined;
var lastModify;
var bActiveObjects = false;

//
// Utility functions
//

// Constructor for custom object that represents an item on the context menu
function ContextMenuItem(string, cmdId) {
  this.string = string;
  this.cmdId = cmdId;
}

// Constructor for custom object that represents a QueryStatus command and
// corresponding toolbar element.
function QueryStatusItem(command, element) {
  this.command = command;
  this.element = element;
}

// Segnalazioni Errori / Warning
function AlertMsg( sOperation, sMessage, bWarning ) {
	if( !bWarning )
		alert( "- " + sOperation + " -\r\r" + sMessage);
}

// Riporta l'oggetto contenente il documento editabile (DOM) 
function GetDOM()
{
<%If bUseDHTMLSafe Then%>
	return tbContentElement.document;
<%Else%>
	return tbContentElement.DOM;
<%End If%>	
}

// Riporta i nomi dei comandi nella modalità MSHMTL editing (safe-for-scripting) 
// per IE7 & MS VIsta corrispondenti agli IDs nella modalità DHTML Editing Component
// Riporta vuoto ("") se il comando non è supportato.
//
// Vedi anche:
//	http://msdn.microsoft.com/library/default.asp?url=/workshop/author/dhtml/reference/methods/execcommand.asp
function GetSafeCMD(nID)
{
	var vRet = "";		//nID;
	switch(nID)
	{
		case DECMD_BOLD: vRet = "Bold"; break;
		case DECMD_COPY: vRet = "Copy"; break;
		case DECMD_CUT: vRet = "Cut"; break;   
		case DECMD_DELETE: vRet = "Delete"; break;
		case DECMD_DELETECELLS: vRet = "DeleteCells"; break;
		case DECMD_DELETECOLS: vRet = "DeleteCols"; break;
		case DECMD_DELETEROWS: vRet = "DeleteRows"; break;
		case DECMD_GETBACKCOLOR: vRet = "BackColor"; break;
		case DECMD_GETFONTNAME: vRet = "FontName"; break;	
		case DECMD_GETFONTSIZE: vRet = "FontSize"; break; 
		case DECMD_GETFORECOLOR: vRet = "ForeColor"; break;
		case DECMD_HYPERLINK: vRet = "CreateLink"; break;   
		case DECMD_IMAGE: vRet = "InsertImage"; break;
		case DECMD_INDENT: vRet = "Indent"; break;  
		case DECMD_INSERTCELL: vRet = "InsertCell"; break;
		case DECMD_INSERTCOL: vRet = "InsertCol"; break;
		case DECMD_INSERTROW: vRet = "InsertRow"; break;
		case DECMD_INSERTTABLE: vRet = "InsertTable"; break;
		case DECMD_ITALIC: vRet = "Italic"; break;
		case DECMD_JUSTIFYCENTER: vRet = "JustifyCenter"; break;
		case DECMD_JUSTIFYLEFT: vRet = "JustifyLeft"; break;  
		case DECMD_JUSTIFYRIGHT: vRet = "JustifyRight"; break;
		case DECMD_MAKE_ABSOLUTE: vRet = "2D-Position"; break;
		case DECMD_MERGECELLS: vRet = "MergeCells"; break;
		case DECMD_ORDERLIST: vRet = "InsertOrderedList"; break;
		case DECMD_OUTDENT: vRet = "Outdent"; break;  
		case DECMD_PASTE: vRet = "Paste"; break;  
		case DECMD_REDO: vRet = "Redo"; break;  
		case DECMD_REMOVEFORMAT: vRet = "RemoveFormat"; break;
		case DECMD_SELECTALL: vRet = "SelectAll"; break;  
		case DECMD_SETBACKCOLOR: vRet = "BackColor"; break;
		case DECMD_SETBLOCKFMT: vRet = "FormatBlock"; break;
		case DECMD_SETFONTNAME: vRet = "FontName"; break;
		case DECMD_SETFONTSIZE: vRet = "FontSize"; break;
		case DECMD_SETFORECOLOR: vRet = "ForeColor"; break;
		case DECMD_UNDERLINE: vRet = "Underline"; break;
		case DECMD_UNDO: vRet = "Undo"; break;
		case DECMD_UNLINK: vRet = "Unlink"; break;  
		case DECMD_UNORDERLIST: vRet = "InsertUnorderedList"; break;
	}
	//
	return(vRet);
}

// Converte un valore decimale in esadecimale per 
// l'attributo del colore
// (usato principalmente per la modalità MSHMTL editing)
function DecToHexColor(dVal) {
    var hVal = dVal.toString(16);
    if (hVal.length < 6) {
        var temp = "000000".substring(0,6-hVal.length);
        hVal = temp.concat(hVal);
    }
    return hVal;
}


// Esegue il comando specificato supportando le varie modalità DHTML
// - ExecCommand()
//		MSHMTL editing (safe-for-scripting)
//			bSuccess = object.execCommand(sCommand [, bUserInterface] [, vValue])
//		DHTML Component
//			HRESULT ExecCommand( DWORD nCmdID, DWORD nCmdExecOpt = OLECMDEXECOPT_DONTPROMPTUSER, const GUID* pguidCmdGroup = NULL )
//
// Vedi anche <dhtmled.js> che contiene le definizioni dei comandi
// in relazione alla modalità corrente.
//		
function ExecCommand(vCmdID, bUserInterface, vValueParam )
{
	var vResult = false;
	bCommandExecuting = true;
	try
	{
<%If bUseDHTMLSafe Then%>
		var bUI = false, sID = GetSafeCMD(vCmdID);
		if( sID == "" )
			AlertMsg("ExecCommand " + vCmdID, "Unsupported command!", false);
		else
		{
			// Ripristina eventuale selezione se si tratta di 
			// un comando di impostazione
			switch( vCmdID ) {
				case DECMD_GETBACKCOLOR: 
				case DECMD_GETFONTNAME: 
				case DECMD_GETFONTSIZE: 
				case DECMD_GETFORECOLOR: 
					break;	// nessun ripristino selezioni per i comandi di lettura
				default:
					if( rangeLast != undefined )
						rangeLast.select();
			}
		
			// Invia il comando
			if( bUserInterface == OLECMDEXECOPT_PROMPTUSER )
				bUI = true;
			if( tbContentElement.document.execCommand(sID, bUI, vValueParam) )
				vResult = tbContentElement.document.queryCommandValue(sID);
		}
<%Else%>
		vResult = tbContentElement.ExecCommand(vCmdID, bUserInterface, vValueParam);
<%End If%>	
	}
	catch(e)
	{
		//alert(e);
		AlertMsg("ExecCommand " + vCmdID, e, true);
	}
	//
	bCommandExecuting = false;
	//
	return vResult;
}


// Esegue il comando specificato supportando le varie modalità DHTML
// - QueryStatus()
//		MSHMTL editing (safe-for-scripting)
//			bEnabled = object.queryCommandEnabled(sCmdID)
//			bSupported = object.queryCommandSupported(sCmdID)
//			bDone = object.queryCommandState(sCmdID)
//			vCmdValue = object.queryCommandValue(sCmdID)
//			bIndeterminate = object.queryCommandIndeterm(sCmdID)
//
//		DHTML Component
//			HRESULT QueryStatus( DWORD nCmdID )
//
// Vedi anche <dhtmled.js> che contiene le definizioni dei comandi
// in relazione alla modalità corrente.
//		
function QueryStatus(vCmdID)
{
	try
	{
<%If bUseDHTMLSafe Then%>
		var bUI = false, sID = GetSafeCMD(vCmdID);
		//var vValue;
		if( sID == "" )
		{
			//alert("Unsupported command!");
			return DECMDF_NOTSUPPORTED;
		}
		if( vCmdID == DECMD_INSERTTABLE )
			// L'inserimento di tabelle è sempre abilitato
			// N.B.: le funzionalità non supportate sono state
			//		 implementate
			return DECMDF_ENABLED;
		//
		if( !tbContentElement.document.queryCommandSupported(sID) )
			return DECMDF_NOTSUPPORTED;
		if( !tbContentElement.document.queryCommandEnabled(sID) )
			return DECMDF_DISABLED;
		if( tbContentElement.document.queryCommandIndeterm(sID) )
			return DECMDF_NINCHED;
		if( tbContentElement.document.queryCommandState(sID) )
			return DECMDF_LATCHED;
		/*vValue = tbContentElement.document.queryCommandValue(sID);
		if( !vValue )*/
			return DECMDF_ENABLED;
		//return vValue;
<%Else%>
		return tbContentElement.QueryStatus(vCmdID);
<%End If%>	
	}
	catch(e)
	{
		//alert(e);
		AlertMsg("QueryStatus" + vCmdID, e, true);
		return DECMDF_DISABLED;
	}
}

//
// Event handlers
//
function window_onload() {

	try
	{
		// Initialze QueryStatus tables. These tables associate a command id with the
		// corresponding button object. Must be done on window load, 'cause the buttons must exist.
		var ii = 0;
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_BOLD, document.body.all["DECMD_BOLD"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_COPY, document.body.all["DECMD_COPY"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_CUT, document.body.all["DECMD_CUT"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_HYPERLINK, document.body.all["DECMD_HYPERLINK"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_INDENT, document.body.all["DECMD_INDENT"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_ITALIC, document.body.all["DECMD_ITALIC"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_JUSTIFYLEFT, document.body.all["DECMD_JUSTIFYLEFT"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_JUSTIFYCENTER, document.body.all["DECMD_JUSTIFYCENTER"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_JUSTIFYRIGHT, document.body.all["DECMD_JUSTIFYRIGHT"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_LOCK_ELEMENT, document.body.all["DECMD_LOCK_ELEMENT"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_MAKE_ABSOLUTE, document.body.all["DECMD_MAKE_ABSOLUTE"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_ORDERLIST, document.body.all["DECMD_ORDERLIST"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_OUTDENT, document.body.all["DECMD_OUTDENT"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_PASTE, document.body.all["DECMD_PASTE"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_REDO, document.body.all["DECMD_REDO"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_UNDERLINE, document.body.all["DECMD_UNDERLINE"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_UNDO, document.body.all["DECMD_UNDO"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_UNORDERLIST, document.body.all["DECMD_UNORDERLIST"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_INSERTTABLE, document.body.all["DECMD_INSERTTABLE"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_INSERTROW, document.body.all["DECMD_INSERTROW"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_DELETEROWS, document.body.all["DECMD_DELETEROWS"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_INSERTCOL, document.body.all["DECMD_INSERTCOL"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_DELETECOLS, document.body.all["DECMD_DELETECOLS"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_INSERTCELL, document.body.all["DECMD_INSERTCELL"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_DELETECELLS, document.body.all["DECMD_DELETECELLS"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_MERGECELLS, document.body.all["DECMD_MERGECELLS"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_SPLITCELL, document.body.all["DECMD_SPLITCELL"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_SETFORECOLOR, document.body.all["DECMD_SETFORECOLOR"]);
		QueryStatusToolbarButtons[ii++] = new QueryStatusItem(DECMD_SETBACKCOLOR, document.body.all["DECMD_SETBACKCOLOR"]);
		//
		ii = 0;
		QueryStatusEditMenu[ii++] = new QueryStatusItem(DECMD_UNDO, document.body.all["EDIT_UNDO"]);
		QueryStatusEditMenu[ii++] = new QueryStatusItem(DECMD_REDO, document.body.all["EDIT_REDO"]);
		QueryStatusEditMenu[ii++] = new QueryStatusItem(DECMD_CUT, document.body.all["EDIT_CUT"]);
		QueryStatusEditMenu[ii++] = new QueryStatusItem(DECMD_COPY, document.body.all["EDIT_COPY"]);
		QueryStatusEditMenu[ii++] = new QueryStatusItem(DECMD_PASTE, document.body.all["EDIT_PASTE"]);
		QueryStatusEditMenu[ii++] = new QueryStatusItem(DECMD_DELETE, document.body.all["EDIT_DELETE"]);
		//
		ii = 0;
		QueryStatusHTMLMenu[ii++] = new QueryStatusItem(DECMD_HYPERLINK, document.body.all["HTML_HYPERLINK"]);
		QueryStatusHTMLMenu[ii++] = new QueryStatusItem(DECMD_IMAGE, document.body.all["HTML_IMAGE"]);
		//
		ii = 0;
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_FONT, document.body.all["FORMAT_FONT"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_BOLD, document.body.all["FORMAT_BOLD"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_ITALIC, document.body.all["FORMAT_ITALIC"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_UNDERLINE, document.body.all["FORMAT_UNDERLINE"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_JUSTIFYLEFT, document.body.all["FORMAT_JUSTIFYLEFT"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_JUSTIFYCENTER, document.body.all["FORMAT_JUSTIFYCENTER"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_JUSTIFYRIGHT, document.body.all["FORMAT_JUSTIFYRIGHT"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_SETFORECOLOR, document.body.all["FORMAT_SETFORECOLOR"]);
		QueryStatusFormatMenu[ii++] = new QueryStatusItem(DECMD_SETBACKCOLOR, document.body.all["FORMAT_SETBACKCOLOR"]);
		//
		ii = 0;
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_INSERTTABLE, document.body.all["TABLE_INSERTTABLE"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_INSERTROW, document.body.all["TABLE_INSERTROW"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_DELETEROWS, document.body.all["TABLE_DELETEROW"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_INSERTCOL, document.body.all["TABLE_INSERTCOL"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_DELETECOLS, document.body.all["TABLE_DELETECOL"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_INSERTCELL, document.body.all["TABLE_INSERTCELL"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_DELETECELLS, document.body.all["TABLE_DELETECELL"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_MERGECELLS, document.body.all["TABLE_MERGECELL"]);
		QueryStatusTableMenu[ii++] = new QueryStatusItem(DECMD_SPLITCELL, document.body.all["TABLE_SPLITCELL"]);
		//
		ii = 0;
		QueryStatusZOrderMenu[ii++] = new QueryStatusItem(DECMD_SEND_TO_BACK, document.body.all["ZORDER_SENDBACK"]);
		QueryStatusZOrderMenu[ii++] = new QueryStatusItem(DECMD_BRING_TO_FRONT, document.body.all["ZORDER_BRINGFRONT"]);
		QueryStatusZOrderMenu[ii++] = new QueryStatusItem(DECMD_SEND_BACKWARD, document.body.all["ZORDER_SENDBACKWARD"]);
		QueryStatusZOrderMenu[ii++] = new QueryStatusItem(DECMD_BRING_FORWARD, document.body.all["ZORDER_BRINGFORWARD"]);
		QueryStatusZOrderMenu[ii++] = new QueryStatusItem(DECMD_SEND_BELOW_TEXT, document.body.all["ZORDER_BELOWTEXT"]);
		QueryStatusZOrderMenu[ii++] = new QueryStatusItem(DECMD_BRING_ABOVE_TEXT, document.body.all["ZORDER_ABOVETEXT"]);

		// Initialize the context menu arrays.
		ii = 0;
		GeneralContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Taglia","Cut")%>", DECMD_CUT);
		GeneralContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Copia","Copy")%>", DECMD_COPY);
		GeneralContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Incolla","Paste")%>", DECMD_PASTE);
		//
		ii = 0;
		TableContextMenu[ii++] = new ContextMenuItem(MENU_SEPARATOR, 0);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Inserisci Riga","Insert Row")%>", DECMD_INSERTROW);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Elimina Riga","Delete Rows")%>", DECMD_DELETEROWS);
		TableContextMenu[ii++] = new ContextMenuItem(MENU_SEPARATOR, 0);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Inserisci Colonna","Insert Column")%>", DECMD_INSERTCOL);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Elimina Colonne","Delete Columns")%>", DECMD_DELETECOLS);
		TableContextMenu[ii++] = new ContextMenuItem(MENU_SEPARATOR, 0);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Inserisci Cella","Insert Cell")%>", DECMD_INSERTCELL);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Elimina Celle","Delete Cells")%>", DECMD_DELETECELLS);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Unisci Celle","Merge Cells")%>", DECMD_MERGECELLS);
		TableContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Dividi Celle","Split Cells")%>", DECMD_SPLITCELL);
		//
		ii = 0;
		AbsPosContextMenu[ii++] = new ContextMenuItem(MENU_SEPARATOR, 0);
		AbsPosContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Porta in Fondo","Send to Back")%>", DECMD_SEND_TO_BACK);
		AbsPosContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Porta in Primo Piano","Bring to Front")%>", DECMD_BRING_TO_FRONT);
		AbsPosContextMenu[ii++] = new ContextMenuItem(MENU_SEPARATOR, 0);
		AbsPosContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Porta Indietro","Send Backward")%>", DECMD_SEND_BACKWARD);
		AbsPosContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Porta Avanti","Bring Forward")%>", DECMD_BRING_FORWARD);
		AbsPosContextMenu[ii++] = new ContextMenuItem(MENU_SEPARATOR, 0);
		AbsPosContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Sotto il Testo","Below Text")%>", DECMD_SEND_BELOW_TEXT);
		AbsPosContextMenu[ii++] = new ContextMenuItem("<%=IIF(bUseItalian,"Sopra il Testo","Above Text")%>", DECMD_BRING_ABOVE_TEXT);

		// Acquisizione di eventuali parametri
		for ( elem in window.dialogArguments )
		{
			switch( elem )
			{
				case "HTMLContent":
					
					// Imposta il contenuto da modificare
					sContent = window.dialogArguments[elem];
					
					// Attiva il flag per indicare di ritornare
					// alla finestra chiamante se viene effettuato
					// il salvataggio
					bReturnDlgOnSave = true;
					//
					break;
					
				case "TextOnly":
					
					// Imposta il flag per considerare solo il testo
					if( window.dialogArguments[elem].toString() != "" && window.dialogArguments[elem].toString().toUpperCase() != "FALSE" )
						bTextOnly = true;
						
					// In questo caso è necessario racchiudere il testo
					// all'interno dell'elemento <PRE> per mantenere
					// la formattazione
					if( sContent.substr(0,1) != "<" )
						sContent = "<PRE>" + sContent + "</PRE>";

					// Nasconde le funzioni della toolbar
					// relative alla formattazione del testo
					//TOOLBARS_onclick(FileToolbar, ToolbarMenuFile);
					TBSetState(ToolbarMenuFont,"unchecked");
					TBSetState(ToolbarMenuFmt,"unchecked");
					TBSetState(ToolbarMenuAbs,"unchecked");
					TBSetState(ToolbarMenuTable,"unchecked");
					/*TOOLBARS_onclick(FontToolbar, ToolbarMenuFont);
					TOOLBARS_onclick(FormatToolbar, ToolbarMenuFmt);
					TOOLBARS_onclick(AbsolutePositioningToolbar, ToolbarMenuAbs);
					TOOLBARS_onclick(TableToolbar, ToolbarMenuTable);*/					
					TBSetState(FontToolbar,"hidden");
					TBSetState(FormatToolbar,"hidden");
					TBSetState(AbsolutePositioningToolbar,"hidden");
					TBSetState(TableToolbar,"hidden");
					//
					break;
			}
		}

		// Impostazione del contenuto di editing
		if( sContent != "" )
		{

<%If bUseDHTMLSafe Then%>
			//while( GetDOM().readyState != "complete" )	// Busy
			//	WScript.Sleep(100);	// Attende la fine del caricamento
			GetDOM().write(sContent);
			GetDOM().close();
			sContent = "";

			// Attivazione contenuto IFRAME modificabile
			try {
			    GetDOM().designMode = "On";
			} catch(e){/*alert(e.message);*/}
			try {
			    tbContentElement.document.body.contentEditable="true";
			} catch(e){/*alert(e.message);*/}

<%Else%>
			//GetDOM().body.innerHTML = sContent;
			//tbContentElement.LoadDocument("about:blank",true);
			//tbContentElement.LoadURL("about:blank");
			//tbContentElement.NewDocument();
			
			// N.B.: Se il documento non è stato completato
			//		 imposta il contenuto in StartEditor()
			//while( tbContentElement.Busy )
			//	WScript.Sleep(100);	// Attende la fine del caricamento
			if( docComplete )
			{
				GetDOM().write(sContent);
				sContent = "";
			}
<%End If%>
		}

		// Riempie la lista dei Fonts
		setSystemFonts();
		
		// Riempie la lista delle formattazioni
		setParagraphStyle();

		// Attivazione dell'editor
		tbContentElement.focus();
	}
	catch(e)
	{
		alert( "Errore di inzializzazione: " + e + "\n\nVerificare che il sito '<%=Request.ServerVariables.Item("SERVER_NAME")%>' sia tra quelli attendibili e che i criteri di protezione del proprio Internet Browser permettano l'esecuzione dei controlli ActiveX, per l'esecuzione dell'Editor è necessario Internet Explorer 5 o succ..." );
		//
		window.close();
	}
	
}

function window_unonload()
{
	// Controlli in uscita
	//...
}

function StartEditor()
{
	try
	{

		// Controlli in attivazione
		if( sContent != "" )
		{
			// Imposta il contenuto in entrata
			GetDOM().write(sContent);
			sContent = "";
		}
		lastModify = GetDOM().lastModified;

<%If bUseDHTMLSafe Then%>

		// Attivazione contenuto IFRAME modificabile
		try {
		    GetDOM().designMode = "On";
		} catch(e){/*alert(e.message);*/}
		try {
		    tbContentElement.document.body.contentEditable="true";
		} catch(e){/*alert(e.message);*/}

		// Attivazione della gestione menù contestuali
		tbContentElement.document.oncontextmenu = tbContentElement_ShowContextMenu;
<%End If%>

	}
	catch(e)
	{
		AlertMsg("StartEditor",e,false);
	}
}

// Riporta le modifiche alla finestra chiamante
function ReturnDialogChanges()
{
	var args = new Array();
	if( bTextOnly )
		// Riporta solo il testo
		args["HTMLContent"] = GetDOM().documentElement.innerText; //GetDOM().body.innerText;
	else
		// Riporta HTML
		args["HTMLContent"] = GetDOM().documentElement.innerHTML;
	//
	window.returnValue = args;
	window.close();
}

function ObjTableInfo() {
	var sObjTableInfo = '<object ID="ObjectTableInfo" CLASSID="clsid:47B0DFC7-B7A3-11D1-ADC5-006008A5848C" WIDTH=0 HEIGHT=0 VIEWASTEXT></object>';
	var obj = document.all.item("ObjectTableInfo");
	if( obj == null )
	{
		document.body.insertAdjacentHTML('beforeEnd', sObjTableInfo);
		obj = document.all.item("ObjectTableInfo");
	}
	return obj;
}

// Attiva l'esecuzione del componente (COM) specificato
// se è prevista l'attivazione lato Client
function ActivateCOMObject( sObjID, bActivate ) {

	// Identifica le sezioni
	var devObject = GetDOM().all.item(sObjID);					// Oggetto (DIV)
	var devParam = GetDOM().all.item(sObjID + "_Parameters");	// Sezione parametri (DIV)
	var objCOM = GetDOM().all.item(sObjID + "_Object");			// Oggetto COM attivato (OBJECT)
	var img = GetDOM().all.item(sObjID + "_Image");				// Immagine che rappresenta l'oggetto (IMAGE)
	var sObjectTag = "";
	//
	if( devObject == null )
		AlertMsg("ActivateCOMObject",sObjID + " non identificato",false);
	else {
	
		if( bActivate ) {
			// Attiva/disattiva l'oggetto in relazione al tipo sepcificato 	
			switch(devObject.className) {
				case "OODataPanel":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:5CAB53A1-3B80-4B88-8A4B-AEBD0A636612\" width=100% height=100%></OBJECT>";
					break;
				case "OODataGrid":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:98F5CE6B-D41C-43D6-8A6F-74768B79761D\" width=100% height=100%></OBJECT>";
					break;
				case "OOBidimData":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:4F530E7A-5032-4F99-9755-DC7397FBB223\" width=100% height=100%></OBJECT>";
					break;
				case "OODataSelection":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:E78BE22B-7BAF-4F48-A6FB-2FA6F32BE6AD\" width=100% height=100%></OBJECT>";
					break;
				case "OODataReference":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:BFD7D686-A9FC-4D6E-AA30-56E508D75755\" width=100% height=100%></OBJECT>";
					break;
				case "OOShortSearch":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:DE0E2DD6-C3FD-4CEE-8958-24FAFE523E1E\" width=100% height=100%></OBJECT>";
					break;
				case "OODBDataTree":
					sObjectTag = "<OBJECT id=\"" + sObjID + "_Object\" classid=\"clsid:A00EC9C8-AF4F-43B1-9E53-2E76B883829B\" width=100% height=100%></OBJECT>";
					break;
			}
			if( sObjectTag.length > 0 && objCOM == null)
			{
				img.style.display = "none";
				devObject.insertAdjacentHTML("afterBegin", sObjectTag);
			}
		}
		else if( objCOM != null )
		{
			// Disattiva l'oggetto
			objCOM.removeNode(true);
			img.style.display = "";
		}
	}
}

function SwitchObjectsActivation() {
  
	// Attiva / Disattiva gli oggetti
	var elem, i, doc = GetDOM();
	try {
		bActiveObjects = !bActiveObjects;
		for( i=0; i<doc.all.length; i++ ) {
			elem = doc.all.item(i);
			if( elem.tagName.toUpperCase() == "DIV" && elem.className.substr(0,2) == "OO" ) 
				ActivateCOMObject(elem.id, bActiveObjects);
		}
		if( bActiveObjects )
		{
<%If bUseDHTMLSafe Then%>
			//GetDOM().designMode = "Off";
<%End If%>
			TBSetState(document.all.item("DECMD_ACTIVATE_OBJECTS"), "unchecked");
		}
		else
		{
			TBSetState(document.all.item("DECMD_ACTIVATE_OBJECTS"), "checked");
<%If bUseDHTMLSafe Then%>
			//GetDOM().designMode = "On";
<%End If%>
		}
	}
	catch(e) {
		AlertMsg("SwitchObjectsActivation",e,false);
	}
}

// Inserisce una tabella
function InsertTable() {

	try
	{

<%If bUseDHTMLSafe Then%>

		var args = new Array();
		var arr = null;

		// Display table information dialog
		args["NumRows"] = 2;
		args["NumCols"] = 3;
		args["TableAttrs"] = "BORDER=1";
		args["CellAttrs"] = "";
		args["Caption"] = "";

		arr = null;
		arr = showModalDialog( "Inc/instable.htm",
		                           args,
		                           "font-family:Verdana; font-size:12; status:0; dialogWidth:36em; dialogHeight:25em");
		if (arr != null) {

			// Initialize table object
			var nTotCol = arr["NumCols"].valueOf();
			var nTotRow = arr["NumRows"].valueOf();
			var nRow, nCol, sTable = "<table cols=" + arr["NumCols"] + " " + arr["TableAttrs"] + " title=\"" + arr["Caption"] + "\">";
			for( nRow = 0; nRow<nTotRow; nRow++) {
				sTable = sTable + "<tr>";
				for( nCol = 0; nCol<nTotCol; nCol++)
					sTable = sTable + "<td " + arr["CellAttrs"] + " >&nbsp;</td>";
				sTable = sTable + "</tr>";
			}
			sTable = sTable + "</table>";
			//
			pasteHTML(sTable);
		}

<%Else%>
		var pVar = ObjTableInfo();
		var args = new Array();
		var arr = null;

		// Display table information dialog
		args["NumRows"] = pVar.NumRows;
		args["NumCols"] = pVar.NumCols;
		args["TableAttrs"] = pVar.TableAttrs;
		args["CellAttrs"] = pVar.CellAttrs;
		args["Caption"] = pVar.Caption;

		arr = null;

		arr = showModalDialog( "Inc/instable.htm",
		                           args,
		                           "font-family:Verdana; font-size:12; status:0; dialogWidth:36em; dialogHeight:25em");
		if (arr != null) {

		  // Initialize table object
		  for ( elem in arr ) {
		    if ("NumRows" == elem && arr["NumRows"] != null) {
		      pVar.NumRows = arr["NumRows"];
		    } else if ("NumCols" == elem && arr["NumCols"] != null) {
		      pVar.NumCols = arr["NumCols"];
		    } else if ("TableAttrs" == elem) {
		      pVar.TableAttrs = arr["TableAttrs"];
		    } else if ("CellAttrs" == elem) {
		      pVar.CellAttrs = arr["CellAttrs"];
		    } else if ("Caption" == elem) {
		      pVar.Caption = arr["Caption"];
		    }
		  }
		  ExecCommand(DECMD_INSERTTABLE,OLECMDEXECOPT_DODEFAULT, pVar);
		}
<%End If%>		  
	}
	catch(e)
	{
		AlertMsg("InsertTable", e, false);
	}
}

function tbContentElement_ShowContextMenu() {
  var menuStrings = new Array();
  var menuStates = new Array();
  var state;
  var i, sElem;
  var idx = 0;

  // Rebuild the context menu.
  ContextMenu.length = 0;

  // Always show general menu
  for (i=0; i<GeneralContextMenu.length; i++) {
    ContextMenu[idx++] = GeneralContextMenu[i];
  }

  // Is the selection inside a table? Add table menu if so
  if (QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    for (i=0; i<TableContextMenu.length; i++) {
      ContextMenu[idx++] = TableContextMenu[i];
    }
  }

  // Is the selection on an absolutely positioned element? Add z-index commands if so
  if (QueryStatus(DECMD_LOCK_ELEMENT) != DECMDF_DISABLED) {
    for (i=0; i<AbsPosContextMenu.length; i++) {
      ContextMenu[idx++] = AbsPosContextMenu[i];
    }
  }

  // Set up the actual arrays that get passed to SetContextMenu
  for (i=0; i<ContextMenu.length; i++) {
    menuStrings[i] = ContextMenu[i].string;
    if (menuStrings[i] != MENU_SEPARATOR) {
      state = QueryStatus(ContextMenu[i].cmdId);
    } else {
      state = DECMDF_ENABLED;
    }
    if (state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED) {
      menuStates[i] = OLE_TRISTATE_GRAY;
    } else if (state == DECMDF_ENABLED || state == DECMDF_NINCHED) {
      menuStates[i] = OLE_TRISTATE_UNCHECKED;
    } else { // DECMDF_LATCHED
      menuStates[i] = OLE_TRISTATE_CHECKED;
    }
  }

<%If bUseDHTMLSafe Then%>
	
	// Visualizza il menù in relazione alle voci contenuto in DislpayMenu
	displayMenu();
	//
	return false;
	
<%Else%> 
	// Set the context menu
	tbContentElement.SetContextMenu(menuStrings, menuStates);
<%End If%>
 
}

function tbContentElement_ContextMenuAction(itemIndex) {

  if (ContextMenu[itemIndex].cmdId == DECMD_INSERTTABLE) {
    InsertTable();
  } else {
  
<%If bUseDHTMLSafe Then%>
		var bUseExec = false;
		//alert(ContextMenu[itemIndex].string);
		switch(ContextMenu[itemIndex].cmdId)
		{
			//case DECMD_INSERTCELL: break;
			default:
				bUseExec = true;
		}
		
		/********
		if( ContextMenu[0] == GeneralContextMenu[0] ) {
		}
		else if( ContextMenu[0] == TableContextMenu[0] ) {
		}
		else if( ContextMenu[0] == AbsPosContextMenu[0] ) {
		}
		******/
		//
		if( bUseExec )
			ExecCommand(ContextMenu[itemIndex].cmdId, OLECMDEXECOPT_DODEFAULT);
<%Else%> 
		ExecCommand(ContextMenu[itemIndex].cmdId, OLECMDEXECOPT_DODEFAULT);
<%End If%> 
  }
}

<%If bUseDHTMLSafe Then%>
	// Reading block format information in MSHMTL editing
	// (The equivalent of the DECMD_GETBLOCKFMT command)
	// 
	var _blockFormats = {		// Associative Array
	    "BODY"    : "Normal",
	    "P"       : "Normal",
	    "PRE"     : "Formatted",
	    "ADDRESS" : "Address",
	    "H1"      : "Heading 1",
	    "H2"      : "Heading 2",
	    "H3"      : "Heading 3",
	    "H4"      : "Heading 4",
	    "H5"      : "Heading 5",
	    "H6"      : "Heading 6",
	    "OL"      : "Numbered List",
	    "UL"      : "Bulleted List",
	    "DIR"     : "Directory List",
	    "MENU"    : "Menu List",
	    "DT"      : "Definition Term",
	    "DD"      : "Definition"
	};
	var _blockFormatsIT = {		// Associative Array
	    "BODY"    : "Normale",
	    "P"       : "Normale",
	    "PRE"     : "Formattato",
	    "ADDRESS" : "Indirizzo",
	    "H1"      : "Titolo 1",
	    "H2"      : "Titolo 2",
	    "H3"      : "Titolo 3",
	    "H4"      : "Titolo 4",
	    "H5"      : "Titolo 5",
	    "H6"      : "Titolo 6",
	    "OL"      : "Elenco Numerato",
	    "UL"      : "Elenco puntato",
	    "DIR"     : "Elenco ad albero",
	    "MENU"    : "Elenco a menu",
	    "DT"      : "Termine di definizione",
	    "DD"      : "Definizione"
	};

	function GetBlockFmt() {
	    try {
			var sFmt = "Normal";
			var itm = getElementUnderCaret();
			if( itm != null ) {
				while(itm != undefined) {
					var sFmt1 = _blockFormats[itm.tagName];
					if( sFmt1 != undefined ) {
						sFmt = sFmt1;
						break;
					}
					itm = itm.parentElement;
				}
			}
	    }
	    catch(e) {
	    }
	    return sFmt;
	}
	function GetBlockFmtIT() {
	    try {
			var sFmt = "Normale";
			var itm = getElementUnderCaret();
			if( itm != null ) {
				while(itm != undefined) {
					var sFmt1 = _blockFormatsIT[itm.tagName];
					if( sFmt1 != undefined ) {
						sFmt = sFmt1;
						break;
					}
					itm = itm.parentElement;
				}
			}
	    }
	    catch(e) {
	    }
	    return sFmt;
	}
<%End If%>

// DisplayChanged handler. Very time-critical routine; this is called
// every time a character is typed. QueryStatus those toolbar buttons that need
// to be in synch with the current state of the document and update.
function tbContentElement_DisplayChanged() {
  var i, s;
  var puMenu = document.all.item("puMenu");

  // Se è già in esecuzione un comando ignora i cambiamenti	
  if( bCommandExecuting )
    return;
  if( puMenu != null && puMenu.style.display.toUpperCase() != "NONE" )  
    return;

  for (i=0; i<QueryStatusToolbarButtons.length; i++) {
    s = QueryStatus(QueryStatusToolbarButtons[i].command);
    if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
      TBSetState(QueryStatusToolbarButtons[i].element, "gray");
    } else if (s == DECMDF_ENABLED  || s == DECMDF_NINCHED) {
       TBSetState(QueryStatusToolbarButtons[i].element, "unchecked");
    } else { // DECMDF_LATCHED
       TBSetState(QueryStatusToolbarButtons[i].element, "checked");
    }
  }

<%If bUseDHTMLSafe Then%>
	ParagraphStyle.disabled = false;
    ParagraphStyle.value = GetBlockFmt();
    if( ParagraphStyle.selectedIndex == -1 )
		ParagraphStyle.value = GetBlockFmtIT();
<%Else%>
  s = QueryStatus(DECMD_GETBLOCKFMT);
  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
    ParagraphStyle.disabled = true;
  } else {
    ParagraphStyle.disabled = false;
    ParagraphStyle.value = ExecCommand(DECMD_GETBLOCKFMT, OLECMDEXECOPT_DODEFAULT);
  }
<%End If%>
  s = QueryStatus(DECMD_GETFONTNAME);
  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
    FontName.disabled = true;
  } else {
    FontName.disabled = false;
    FontName.value = ExecCommand(DECMD_GETFONTNAME, OLECMDEXECOPT_DODEFAULT);
  }

  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
    FontSize.disabled = true;
  } else {
    FontSize.disabled = false;
    FontSize.value = ExecCommand(DECMD_GETFONTSIZE, OLECMDEXECOPT_DODEFAULT);
  }
}

function WBHelper() {
	var sObjWBHelper = '<object ID=ObjectWBHelper CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" WIDTH=0 HEIGHT=0 VIEWASTEXT></object>';
	var obj = GetDOM().all.item("ObjectWBHelper");

	if( obj == null )
	{
		GetDOM().body.insertAdjacentHTML('afterEnd', sObjWBHelper);
		obj = GetDOM().all.item("ObjectWBHelper");
	}
	return obj;
}

function MENU_FILE_OPEN_onclick() {

<%If bUseDHTMLSafe Then%>
	if( lastModify != GetDOM().lastModified ) {
<%Else%>
	if (tbContentElement.IsDirty) {
<%End If%>
	  if (!confirm("<%=IIF(bUseItalian,"Il documento è stato modificato!\n\nContinuare senza salvare ?","Document has changed!\n\nContinue without save ?")%>")) 
	  {
	    //MENU_FILE_SAVE_onclick();
	    return;
	  }
	}
	
	try
	{
<%If bUseDHTMLSafe Then%>
		var objWB = WBHelper();
		objWB.ExecWB(WB_OPEN,OLECMDEXECOPT_DODEFAULT);
<%Else%>
		tbContentElement.LoadDocument("", true);
		//docComplete = false;
<%End If%>
		tbContentElement.focus();
	}
	catch(e)
	{
		AlertMsg("Open",e,false);
	}
}

function MENU_FILE_SAVE_onclick() {

	// Se si tratta di modifica testo HTML mediante
	// una chiamata (showDialog..) riporta il contenuto
	// modificato
	if( bReturnDlgOnSave )
	{
		ReturnDialogChanges();
		return;
	}

	try
	{
<%If bUseDHTMLSafe Then%>
		//var objWB = WBHelper();
		//objWB.document.clear();
		//objWB.document.write(GetDOM().all.toString());
		//GetDOM().designMode = "Inherit";
		//GetDOM().close();
		//alert("1 " + GetDOM().designMode);
		tbContentElement.execScript("document.body.insertAdjacentHTML('afterEnd', '<object ID=ObjectWBHelper CLASSID=\"CLSID:8856F961-340A-11D0-A96B-00C04FD705A2\" WIDTH=0 HEIGHT=0 VIEWASTEXT></object>')");
		//tbContentElement.execScript("document.body.insertAdjacentHTML('beforeEnd', '<script language=javascript>function Test(){alert(234)}</script>'); Test();");
		//objWB.ExecWB(WB_SAVE,OLECMDEXECOPT_DODEFAULT);
		tbContentElement.execScript("ObjectWBHelper.ExecWB("+WB_SAVE+","+OLECMDEXECOPT_DODEFAULT+")","javascript");
		//tbContentElement.execScript("alert(ObjectWBHelper.id)","javascript");
		//tbContentElement.execScript("Test()","javascript");
		//alert("2");
		//GetDOM().designMode = "On";
		//alert("3 " + GetDOM().designMode);
		//lastModify = GetDOM().lastModified;
		//alert(lastModify);
		//
		URL_VALUE.value = tbContentElement.location.href;
<%Else%>
		if (tbContentElement.CurrentDocumentPath != "") {
		  var path;
		  path = tbContentElement.CurrentDocumentPath;
		  if (path.substring(0, 7) == "http://" || path.substring(0, 7) == "file://")
		    tbContentElement.SaveDocument("", true);
		  else
		    tbContentElement.SaveDocument(tbContentElement.CurrentDocumentPath, false);
		}
		else {
		  tbContentElement.SaveDocument("", true);
		}
		URL_VALUE.value = tbContentElement.CurrentDocumentPath;
<%End If%>
		tbContentElement.focus();
	}
	catch(e)
	{
		AlertMsg("Save",e,false);
	}
}

function MENU_FILE_PRINT_onclick() {
	try
	{
<%If bUseDHTMLSafe Then%>
		//var objWB = WBHelper();
		//alert(objWB);
		//GetDOM().navigator.ExecWB(WB_PRINTPREVIEW,OLECMDEXECOPT_DODEFAULT,null);	//,OLECMDEXECOPT_PROMPTUSER,PAGE_PRINT_TEMPLATE);
		//objWB.ExecWB(WB_PRINTPREVIEW,OLECMDEXECOPT_DODEFAULT);,PAGE_PRINT_TEMPLATE);	//,OLECMDEXECOPT_PROMPTUSER,PAGE_PRINT_TEMPLATE);
		tbContentElement.print();
<%Else%>
		tbContentElement.PrintDocument(true);
<%End If%>
	}
	catch(e)
	{
		AlertMsg("Print",e,false);
	}
}

function MENU_FILE_SAVEAS_onclick() {
	try
	{
<%If bUseDHTMLSafe Then%>
		var objWB = WBHelper();
		objWB.document.clear();
		objWB.document.write(GetDOM().all.toString());
		objWB.ExecWB(WB_SAVE,OLECMDEXECOPT_DODEFAULT);
<%Else%>
		tbContentElement.SaveDocument("", true);
<%End If%>
		tbContentElement.focus();
	}
	catch(e)
	{
		AlertMsg("SaveAs",e,false);
	}
}

function DECMD_VISIBLEBORDERS_onclick(bRefreshToolBarBtn) {
	tbContentElement.ShowBorders = !tbContentElement.ShowBorders;
	tbContentElement.focus();
	//
	if( bRefreshToolBarBtn )
	{
		if( tbContentElement.ShowBorders )
	  		TBSetState(document.body.all["DECMD_VISIBLEBORDERS"],"checked");
		else
	  		TBSetState(document.body.all["DECMD_VISIBLEBORDERS"],"unchecked");
	}
}

function DECMD_UNORDERLIST_onclick() {
  ExecCommand(DECMD_UNORDERLIST,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_UNDO_onclick() {
  ExecCommand(DECMD_UNDO,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_UNDERLINE_onclick() {
  ExecCommand(DECMD_UNDERLINE,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_SNAPTOGRID_onclick() {
  tbContentElement.SnapToGrid = !tbContentElement.SnapToGrid;
  tbContentElement.focus();
}

function DECMD_SHOWDETAILS_onclick(bRefreshToolBarBtn) 
{
	tbContentElement.ShowDetails = !tbContentElement.ShowDetails;
	tbContentElement.focus();
	//
	if( bRefreshToolBarBtn )
	{
		if( tbContentElement.ShowDetails )
	  		TBSetState(document.body.all["DECMD_SHOWDETAILS"],"checked");
		else
	  		TBSetState(document.body.all["DECMD_SHOWDETAILS"],"unchecked");
	}
}

function DECMD_SETFORECOLOR_onclick() {
  var arr = showModalDialog( "Inc/selcolor.htm",
                             "",
                             "font-family:Verdana; font-size:12; status:0; dialogWidth:30em; dialogHeight:34em" );

  if (arr != null) {
    ExecCommand(DECMD_SETFORECOLOR,OLECMDEXECOPT_DODEFAULT, arr);
  }
}

function DECMD_SETBACKCOLOR_onclick() {
  var arr = showModalDialog( "Inc/selcolor.htm",
                             "",
                             "font-family:Verdana; font-size:12; status:0; dialogWidth:30em; dialogHeight:34em" );

  if (arr != null) {
    ExecCommand(DECMD_SETBACKCOLOR,OLECMDEXECOPT_DODEFAULT, arr);
  }
  tbContentElement.focus();
}

function DECMD_SELECTALL_onclick() {
  ExecCommand(DECMD_SELECTALL,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_REDO_onclick() {
  ExecCommand(DECMD_REDO,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_PASTE_onclick() {
  ExecCommand(DECMD_PASTE,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_OUTDENT_onclick() {
  ExecCommand(DECMD_OUTDENT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_ORDERLIST_onclick() {
  ExecCommand(DECMD_ORDERLIST,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_MAKE_ABSOLUTE_onclick() {
  ExecCommand(DECMD_MAKE_ABSOLUTE,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_LOCK_ELEMENT_onclick() {
  ExecCommand(DECMD_LOCK_ELEMENT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_JUSTIFYRIGHT_onclick() {
  ExecCommand(DECMD_JUSTIFYRIGHT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_JUSTIFYLEFT_onclick() {
  ExecCommand(DECMD_JUSTIFYLEFT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_JUSTIFYCENTER_onclick() {
  ExecCommand(DECMD_JUSTIFYCENTER,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_ITALIC_onclick() {
  ExecCommand(DECMD_ITALIC,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_INDENT_onclick() {
  ExecCommand(DECMD_INDENT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_IMAGE_onclick() {
  ExecCommand(DECMD_IMAGE,OLECMDEXECOPT_PROMPTUSER);
  tbContentElement.focus();
}

function DECMD_HYPERLINK_onclick() {
  ExecCommand(DECMD_HYPERLINK,OLECMDEXECOPT_PROMPTUSER);
  tbContentElement.focus();
}

function DECMD_FINDTEXT_onclick() {

<%If bUseDHTMLSafe Then%>
	var rng = tbContentElement.document.body.createTextRange();
	<%If bUseItalian Then%>
		sLastFind = prompt("Ricerca testo", sLastFind);
	<%Else%>
		sLastFind = prompt("Enter text to search for", sLastFind);
	<%End If%>
	var found = rng.findText(sLastFind);
	if(found)
	    rng.select();
<%Else%>
	ExecCommand(DECMD_FINDTEXT,OLECMDEXECOPT_PROMPTUSER);
	tbContentElement.focus();
<%End If%>

}

function DECMD_DELETE_onclick() {
  ExecCommand(DECMD_DELETE,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_CUT_onclick() {
  ExecCommand(DECMD_CUT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function DECMD_COPY_onclick() {
  ExecCommand(DECMD_COPY,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

// CODE REVIEW: Fix syntax error.
// //function DECMD_BOLD_onclick() {
function DECMD_BOLD_onclick() {
  ExecCommand(DECMD_BOLD,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function HELP_ACCKEY_onclick() {
	OpenPopUpWindow( "<%=IIF(bUseItalian,"Help/DHTMLEd_KeyboardAcceleratorsIT.html","Help/DHTMLEd_KeyboardAccelerators.html")%>", "", 0, 0, true, true );
}

function HELP_GLYPH_DETAIL_onclick() {
	OpenPopUpWindow( "<%=IIF(bUseItalian,"Help/DHTMLEd_Glyph.html","Help/DHTMLEd_Glyph.html")%>", "", 0, 0, true, true );
}

function OnMenuShow(QueryStatusArray, menu) {
  var i, s;

  for (i=0; i<QueryStatusArray.length; i++) {
    s = QueryStatus(QueryStatusArray[i].command);
    if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
      TBSetState(QueryStatusArray[i].element, "gray");
    } else if (s == DECMDF_ENABLED  || s == DECMDF_NINCHED) {
       TBSetState(QueryStatusArray[i].element, "unchecked");
    } else { // DECMDF_LATCHED
       TBSetState(QueryStatusArray[i].element, "checked");
    }
  }

  // If the menu is the HTML menu, then
  // check if the selection type is "Control", if so,
  // set menu item state of the Intrinsics submenu and rebuild the menu.
  if (QueryStatusArray[0].command == DECMD_HYPERLINK) {
    for (i=0; i < HTML_INTRINSICS.all.length; i++) {
      if (HTML_INTRINSICS.all[i].className == "tbMenuItem") {
        if (GetDOM().selection.type == "Control") {
            TBSetState(HTML_INTRINSICS.all[i], "gray");
        } else {
            TBSetState(HTML_INTRINSICS.all[i], "unchecked");
        }
      }
    }
  }

  // rebuild the menu so that menu item states will be reflected
  TBRebuildMenu(menu, true);

  tbContentElement.focus();
}

// Aggiorna lo stato di alcune voci del 
// menù <View>
function OnMenuShow_View() {

	if( tbContentElement.ShowBorders )
		TBSetState(document.body.all["VIEW_VISIBLEBORDERS"], "checked");
	else		
		TBSetState(document.body.all["VIEW_VISIBLEBORDERS"], "unchecked");
	//
	if( tbContentElement.ShowDetails )
		TBSetState(document.body.all["VIEW_SHOWDETAILS"], "checked");
	else		
		TBSetState(document.body.all["VIEW_SHOWDETAILS"], "unchecked");

  // rebuild the menu so that menu item states will be reflected
  TBRebuildMenu(VIEW, true);
}


function pasteHTML(sHTML) {
  
	var selection;
	try
	{
<%If bUseDHTMLSafe Then%>
		if( rangeLast != undefined || GetDOM().selection.type != "none" )
		{
			if( rangeLast != undefined )
			{
				selection = rangeLast;
				selection.select();
			}
			else
				selection = GetDOM().selection.createRange();
			//
			/***		
			if( selection.text.length == 0 )
			{
				// Se non c'è selezione cerca di inserire all'inzio dell'elemento
				selection = selection.parentElement();
				alert(selection.tagName);
				if( selection.tagName.toUpperCase() == "BODY" )
					GetDOM().body.insertAdjacentHTML("afterBegin", sHTML);
				else
					selection.insertAdjacentHTML("afterBegin", sHTML);
			}
			else
			*****/
				selection.pasteHTML(sHTML);
		}
		else
			GetDOM().body.insertAdjacentHTML("afterBegin", sHTML);
		//alert(GetDOM().body.innerHTML);
		//alert(selection.htmlText);
<%Else%>
		selection = GetDOM().selection.createRange();
		selection.pasteHTML(sHTML);
<%End If%>
	}
	catch(e)
	{
		//AlertMsg("pasteHTML", e);
		alert("<%=IIF(bUseItalian,"Punto di inserimento non valido!","Invalid insert point!")%>");
	}
	//
	tbContentElement.focus();

}

function TABLE_DELETECELL_onclick() {
  ExecCommand(DECMD_DELETECELLS,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_DELETECOL_onclick() {
  ExecCommand(DECMD_DELETECOLS,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_DELETEROW_onclick() {
  ExecCommand(DECMD_DELETEROWS,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_INSERTCELL_onclick() {
  ExecCommand(DECMD_INSERTCELL,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_INSERTCOL_onclick() {
  ExecCommand(DECMD_INSERTCOL,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_INSERTROW_onclick() {
  ExecCommand(DECMD_INSERTROW,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_INSERTTABLE_onclick() {
  InsertTable();
  tbContentElement.focus();
}

function TABLE_MERGECELL_onclick() {
  ExecCommand(DECMD_MERGECELLS,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TABLE_SPLITCELL_onclick() {
  ExecCommand(DECMD_SPLITCELL,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function FORMAT_FONT_onclick() {
  ExecCommand(DECMD_FONT,OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function MENU_FILE_NEW_onclick() {

<%If bUseDHTMLSafe Then%>
	if( lastModify != GetDOM().lastModified ) {
<%Else%>
	if (tbContentElement.IsDirty) {
<%End If%>
	  if (!window.confirm("<%=IIF(bUseItalian,"Il documento è cambiato\n\nContinuare senza salvare ?","Document has changed!\n\nContinue without save ?")%>")) 
	  {
	    //MENU_FILE_SAVE_onclick();
	    return;
	  }
	}
	//	
	try
	{
<%If bUseDHTMLSafe Then%>
		GetDOM().body.innerHTML = "";
<%Else%>
		URL_VALUE.value = "http://";
		tbContentElement.NewDocument();
		//docComplete = false;
<%End If%>
		tbContentElement.focus();
	}
	catch(e)
	{
		AlertMsg("New",e,false);
	}
}

function URL_VALUE_onkeypress() {
  if (event.keyCode == 13) {
<%If bUseDHTMLSafe Then%>
	if( lastModify != GetDOM().lastModified ) {
<%Else%>
	if (tbContentElement.IsDirty) {
<%End If%>
	  if (!window.confirm("<%=IIF(bUseItalian,"Il documento è cambiato\n\nContinuare senza salvare ?","Document has changed!\n\nContinue without save ?")%>")) 
	  {
	    //MENU_FILE_SAVE_onclick();
	    URL_VALUE.value = "";
	    return;
	  }
	}
	
    docComplete = false;
    try
    {
<%If bUseDHTMLSafe Then%>
		GetDOM().designMode = "off";
	    tbContentElement.document.location = URL_VALUE.value;
<%Else%>
	    tbContentElement.LoadURL(URL_VALUE.value);
<%End If%>

		tbContentElement.focus();
	}
	catch(e)
	{
		//alert(e);
		AlertMsg("GoToURL",e,false);
	}
  }
}

function ZORDER_ABOVETEXT_onclick() {
  ExecCommand(DECMD_BRING_ABOVE_TEXT, OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function ZORDER_BELOWTEXT_onclick() {
  ExecCommand(DECMD_SEND_BELOW_TEXT, OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function ZORDER_BRINGFORWARD_onclick() {
  ExecCommand(DECMD_BRING_FORWARD, OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function ZORDER_BRINGFRONT_onclick() {
  ExecCommand(DECMD_BRING_TO_FRONT, OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function ZORDER_SENDBACK_onclick() {
  ExecCommand(DECMD_SEND_TO_BACK, OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function ZORDER_SENDBACKWARD_onclick() {
  ExecCommand(DECMD_SEND_BACKWARD, OLECMDEXECOPT_DODEFAULT);
  tbContentElement.focus();
}

function TOOLBARS_onclick(toolbar, menuItem) {
  if (toolbar.TBSTATE == "hidden") {
    if( toolbar == DOMToolbar )
		TBSetState(toolbar, "dockedBottom");
	else
		TBSetState(toolbar, "dockedTop");
    TBSetState(menuItem, "checked");
  } else {
    TBSetState(toolbar, "hidden");
    TBSetState(menuItem, "unchecked");
  }

  TBRebuildMenu(menuItem.parentElement, false);

  tbContentElement.focus();
}

function DOM_GETITEM_onclick()
{
	var itm = getElementUnderCaret();
	if( itm == null )
		document.body.all["DECMD_DOMITEM"].value = "";
	else	
		document.body.all["DECMD_DOMITEM"].value = itm.tagName;

	//getElementUnderCaret().insertAdjacentHTML("afterBegin","<DIV ID=TEST contentEditable=false>text object</DIV>");
}

// Se l'ID non viene specificato lo ricava mediante il progressivo del componente
function InsertOOComponent(sClass,sID,nHeight)
{
	// Identifica l'idice dell'ultimo eventualmente inserito
	var nID = 1, nVal, i, elem, sImg = "", doc = GetDOM();
	var sStyle = "style=\"width:200;height:" + nHeight + ";border: dotted 2px gray\"";
	if( sID == "" ) {
		//for( elem in doc.all ) {
		for( i=0; i<doc.all.length; i++ ) {
			elem = doc.all.item(i);
			if( elem.tagName.toUpperCase() == "DIV" && elem.className.substr(0,sClass.length).toUpperCase() == sClass.toUpperCase() ) {
				nVal = elem.id.substr(sClass.length).valueOf();
				if( typeOf(nVal) == "number" && nVal > nID )
					nID = nVal + 1;
			}
		}
		sID = sClass + nID;
	}	
	
	// Identifica il percorso che contiene le immagini dei componenti (Images/..)
	nVal = document.location.href.lastIndexOf("\\");
	if( nVal == -1 )
		nVal = document.location.href.lastIndexOf("/");
	if( nVal != -1 )
		sImg = document.location.href.substr(0,nVal+1);
	// Aggiunge il componente
	sImg = sImg + "Images/" + sClass + ".bmp";		// L'immagine che rappresenta il componente ha lo stesso nome della classe con estensione bmp
	pasteHTML("<div id=\"" + sID + "\" " + sStyle + " contentEditable=false CLASS=\"" + sClass + "\">" + 
			"<img id=\"" + sID + "_Image\" width=24 height=24 src=\"" + sImg + "\"></div>");
}

function ParagraphStyle_onchange() {
  ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, ParagraphStyle.options(ParagraphStyle.selectedIndex).value);
  tbContentElement.focus();
}

function FontName_onchange() {
  ExecCommand(DECMD_SETFONTNAME, OLECMDEXECOPT_DODEFAULT, FontName.options(FontName.selectedIndex).value);
  tbContentElement.focus();
}

function FontSize_onchange() {
  ExecCommand(DECMD_SETFONTSIZE, OLECMDEXECOPT_DODEFAULT, parseInt(FontSize.value));
  tbContentElement.focus();
}

function tbContentElement_DocumentComplete() {

<%If bUseDHTMLSafe Then%>
    if (initialDocComplete) {
      if (tbContentElement.location.href == "") {
        URL_VALUE.value = "http://";
    }
    else if( tbContentElement.location.href == "about:blank" )
		URL_VALUE.value = "http://";
	else
      URL_VALUE.value = tbContentElement.location.href;
  }
<%Else%>
    if (initialDocComplete) {
      if (tbContentElement.CurrentDocumentPath == "") {
        URL_VALUE.value = "http://";
    }
    else {
      URL_VALUE.value = tbContentElement.CurrentDocumentPath;
    }
  }
<%End If%>

  initialDocComplete = true;
  docComplete = true;
  //
  StartEditor();  
}

function DlgHelper() {
	var sObjDlgHelper = '<object ID=ObjectDlgHelper CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" WIDTH=0 HEIGHT=0 VIEWASTEXT></object>';
	var obj = document.all.item("ObjectDlgHelper");
	if( obj == null )
	{
		document.body.insertAdjacentHTML('beforeEnd', sObjDlgHelper);
		obj = document.all.item("ObjectDlgHelper");
	}
	return obj;
}

//getSystemFonts uses the dialog helper object to return an array of all of the fonts on the user's system, then populates a drop-down listbox in the toolbar with the array elements
function setSystemFonts()
{
	try
	{
		var i = 1, objHlp = DlgHelper();
		for (;i < objHlp.fonts.count;i++)
		{ 
			var oOption = document.createElement("OPTION");
			oOption.text = objHlp.fonts(i);
			oOption.value = oOption.text;
			window.FontName.add(oOption);	
		} 
	}
	catch(e)
	{
		AlertMsg("SetSystemFonts", e, false);
	}
}

function setParagraphStyle()
{
	try
	{
		var i = 1, objHlp = DlgHelper();
		for (;i < objHlp.blockFormats.count;i++)
		{ 
			var oOption = document.createElement("OPTION");
			oOption.text = objHlp.blockFormats(i);
			oOption.value = oOption.text;
			window.ParagraphStyle.add(oOption);	
		} 

	
		// Test With Associative Array...
		/*for(var key in _blockFormats)
		{
			//alert(key + "=" + _blockFormats[key]);
			var oOption = document.createElement("OPTION");
			oOption.text = _blockFormats[key];
			oOption.value = oOption.text;
			window.ParagraphStyle.add(oOption);	
		}*/
	}
	catch(e)
	{
		AlertMsg("SetParagraphStyle", e, false);
	}
}

// Returns the element directly under the insertion point
function getElementUnderCaret()		// IHTMLElement
{
    // Branch on the type of selection and
    // get the element under the caret or the site selected object
    // and return it
    var rg, ctlRg, itm;
    //
	itm = null;    
	//
	switch( GetDOM().selection.type )
	{
		case "None":
		case "Text":

		    rg = GetDOM().selection.createRange();

		    // Collapse the range so that the scope of the
		    // range of the selection is the the caret. That way the
		    // parentElement method will return the element directly
		    // under the caret. If you don't want to change the state of the
		    // selection, then duplicate the range and collapse it
		    if( rg != null )
		    {
		        rg.collapse();
		        itm = rg.parentElement();
		    }
		    break;

		case "Control":
		    
		    // An element is site selected
		    ctlRg = GetDOM().selection.createRange();
		    
		    // There can only be one site selected element at a time so the
		    // commonParentElement will return the site selected element
		    itm = ctlRg.commonParentElement();
		    //
		    break;
    }
    //
    return itm; 
}
