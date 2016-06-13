<!-- DHTML Editor - LogiCode Srl -  www.logicode.it -->
<!-- Copyright LogiCode. All rights reserved. -->
<%
    '<!-- 
    '	DHTML Editing Component Overview
    '		http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/dnaredcom/html/cncpt.asp	
    '	How to Create an HTML Editor Application
    '		http://msdn.microsoft.com/library/default.asp?url=/workshop/author/editing/tutorials/HTML_Editor.asp
    '	Using the DHTML Editing Component Document Object
    '		http://msdn.microsoft.com/archive/en-us/dnaredcom/html/cncpt.asp?frame=true#Using_the_DHTML_Editing_Component_Document_Object 
    '	DHTML Editing Control
    '		http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/samples/internet/browser/editcntrl/default.asp
    '   Scripting & COM Objects
    '       http://msdn.microsoft.com/en-us/library/ms810018.aspx
    '	Frequently Asked Questions About the Dynamic HTML Editing Component
    '		http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/dnaredcom/html/edcomfaq.asp
    '	The Script Center Script Repository
    '		http://www.microsoft.com/technet/scriptcenter/scripts/default.mspx
    '	Links
    '		http://www.lescasse.com/TDHTML5.asp
    '		
    '	Reference
    '		GetDOM() Object
    '			HTML and DHTML Reference
    '			http://msdn.microsoft.com/workshop/author/dhtml/reference/dhtml_reference_entry.asp?frame=true
    '			
    '	Evolution IE7 & Windows Vista
    '		Replacing the DHTML Editing Control in Windows Vista and Beyond
    '		http://msdn.microsoft.com/windowsvista/default.aspx?pull=/library/en-us/dnlong/html/htmleditinfuture.asp
    '       http://msdn.microsoft.com/en-us/library/aa663363.aspx
    '	
    '-->
    '<!--
    '	Parametri accettati/restituiti mediante campi del FORM nascosti oppure madiante
    '   una chiamata <showDialog()>:
    '		"HTMLContent"
    '			Contenuto HTML modificabile
    '		"TextOnly"
    '			Considera solo il testo effettivo ignorando
    '			eventuali elementi di formattazione.
    '		"BodyOnly"
    '			Considera solo il contenuto dell'elemento BODY, altrimenti
    '           riporta il documento HTML completo.
    '       "Language"
    '           "0" Italiano
    '           "1" Inglese
    '-->
%>
<%

    ' --------------------------------------------------------------------
	' Identifica il tipo di Browser per supportare
	' le funzioni di Editing anche in IE7 e MS Vista
	'
	' Vedi 'Replacing the DHTML Editing Control in Windows Vista and Beyond'
	' per ulteriori dettagli.
    ' --------------------------------------------------------------------
	Dim sUS As String, bIsVista As Boolean, bIsIE7 As Boolean
    Dim bUseDHTMLSafe As Boolean = False
	sUS = LCase(Request.ServerVariables("HTTP_USER_AGENT"))
	bIsVista = (InStr(sUS, "windows nt 6.") > 0)
	bIsIE7   =  (InStr(sUS, "msie 7.") > 0)
    If (bIsVista And bIsIE7) Or Request("DHTMLSafe") <> "" Then
        ' Imposta per usare MSHMTL editing (safe-for-scripting)
        '    Response.Redirect "Surrogate.htm"
        bUseDHTMLSafe = True
    Else
        '    Response.Redirect "DHTMLEd.htm"
    End If
    
    ' SOLO PER TEST, ABILITA LA MODALITA' MSHMTL editing (safe-for-scripting)
' PER IE7 e MS Vista
    bUseDHTMLSafe = True

    ' --------------------------------------------------------------------
    ' Imposta l'Header necessario per abilitare l'accesso
    ' degli oggetti di sessione anche se l'applicazione
    ' viene eseguita all'interno di un frame
    ' Vedi Articolo Microsoft Knowledge Base - 323752
    ' (PRB: Session Variables Are Lost If You Use FRAMESET in Internet Explorer 6.0)
    '
    ' N.B.: Richiamare all'inizio della pagina prima di qualsiasi
    '		altra istruzione
	Response.AddHeader("P3P", "CP=""CAO PSA OUR""")

	' Identifica il linguaggio da utilizzare secondo i parametri
	' di sessione (ODBMS Library) eventualmente inizializzati
    Dim bUseItalian = False
    If Request("Language") = "0" Then
        bUseItalian = True
    ElseIf Request("Language") > "0" Then
        bUseItalian = False
    ElseIf Session("g_LocaleLanguage") = "0" Then
        bUseItalian = True
    End If

    ' Identifica eventuale contenuto
    'Dim sContent As String
    'If Request("HTMLContent") <> "" OrElse Request("SaveContent") <> "" Then
    '    ' Legge il contenuto e lo salva nella sessione
    '    sContent = Request("HTMLContent")
    '    Session("HTMLContent") = sContent
    'ElseIf Session("HTMLContent") Then
    '    sContent = Session("HTMLContent")
    'End If
    'If Request("SaveContent") <> "" Then
    '    ' In caso di salvataggio del contenuto
    '    ' chiude la pagina
    '    ' N.B.: la pagina chiamante viene aggiornata
    '    '       in modo che possa leggere il contenuto
    '    '       aggiornato nella sessione richiamando
    '    '       SUBMIT del form principale
    '    Session("HTMLContentSaved") = "True"
    '    Response.Write("<script language=javascript>")
    '    Response.Write("if( typeof( window.opener ) != ""undefined"" && window.opener != null ) {")
    '    Response.Write("    window.opener.document.forms.item(0).action=doc.location.pathname;")
    '    Response.Write("    window.opener.document.forms.item(0).target = ""_self""")
    '    Response.Write("	window.top.close();")
    '    Response.Write("}")
    '    Response.Write("</script>")
    '    Response.End()
    'End If
    
%>
<html>
<head>
<META NAME="TITLE" CONTENT="LogiCode Srl - DHTML Editor">
<META NAME="DESCRIPTION" CONTENT="On Line DHTML Editor">
<META NAME="author" CONTENT="http://www.logicode.it">
<META NAME="copyright" CONTENT="2005, LogiCode Srl">
<title>LogiCode DHTML Editor</title>

<!-- Include Styles -->
<link REL="stylesheet" TYPE="text/css" HREF="Toolbars/toolbars.css">

<!-- Styles for Menù (safe-script) -->
<STYLE>
.menuItem {font-family:sans-serif;font-size:10pt;width:100;padding-left:20;
   background-Color:menu;color:black}
.highlightItem {font-family:sans-serif;font-size:10pt;width:100;padding-left:20;
   background-Color:highlight;color:white}
.clickableSpan {padding:4;width:500;background-Color:blue;color:white;border:5px gray solid}
</STYLE>

<!-- Script Functions and Event Handlers -->
<script LANGUAGE="JavaScript" SRC="Inc/dhtmled.js">
</script>

<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--

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
var bBodyOnly = false;

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
var elemLast = undefined;
var lastModify;
var bActiveObjects = false;
<%
If bUseItalian Then
%>
var bUseItalian = true;
<%
Else
%>
var bUseItalian = false;
<%
End If
%>


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
					
				case DECMD_INSERTTABLE:
					if( rangeLast != undefined )
						rangeLast.select();
					else if( elemLast != undefined )
					    elemLast.setActive();
				    TABLE_INSERTTABLE_onclick();
				    break;
				    
				default:
					if( rangeLast != undefined )
						rangeLast.select();
					else if( elemLast != undefined )
					    elemLast.setActive();
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
        //
		if( !tbContentElement.document.queryCommandEnabled(sID) )
		{
		    // Se si tratta di collegamento ed è presente una selezione
            // ne attiva comunque l'inserimento		    
            if( vCmdID == DECMD_HYPERLINK
                    && GetDOM().selection != undefined
                    && GetDOM().selection.type != "None"
                    && GetDOM().selection.type != "Control" )
			    return DECMDF_ENABLED;
            //			
			return DECMDF_DISABLED;
		}
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
					
				case "BodyOnly":
				
					// Imposta il flag per considerare solo il testo
					if( window.dialogArguments[elem].toString() != "" && window.dialogArguments[elem].toString().toUpperCase() != "FALSE" )
						bBodyOnly = true;
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
			//document.body.contentEditable = "true";
			try {
			    tbContentElement.document.body.contentEditable="true";
			} catch(e){/*alert(e.message);*/}
			try {
			    GetDOM().designMode = "on";
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
		    tbContentElement.document.body.contentEditable="true";
		} catch(e){/*alert(e.message);*/}
		try {
		    GetDOM().designMode = "on";
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

// Riporta il contenuto valido
function GetValidContent(bOnlyBody)
{
    // Riporta il contenuto	
    var sValidCnt = "";
	if( bTextOnly )
	{
		// Riporta solo il testo
		//try {
		//    sValidCnt = GetDOM().body.innerText;
		//}
		//catch(e) {
		    sValidCnt = GetDOM().documentElement.innerText; 
		//}
	}
	else
	{
		// Riporta il codice HTML
		var bWithHTML = false;
		if( bOnlyBody )
		{
		    try {
		        sValidCnt = GetDOM().body.innerHTML;
		    }
		    catch(e) {
		        sValidCnt = GetDOM().documentElement.innerHTML; 
		        bWithHTML = true;
		    }
		}
		else
		{
		    sValidCnt = GetDOM().documentElement.innerHTML; 
		    bWithHTML = true;
		}
		
		if( bWithHTML )
		{
		    // Elimina eventuale tag per il contenuto editabile
		    sValidCnt = sValidCnt.replace(" contentEditable=true","");
		    sValidCnt = sValidCnt.replace(" contentEditable=false","");
		}
	}
	//
    return sValidCnt;
}

// Riporta le modifiche alla finestra chiamante
function ReturnDialogChanges()
{
	var args = new Array();
	
	// Disattivazione contenuto IFRAME modificabile
	//document.body.contentEditable = "true";
	try {
	    GetDOM().designMode = "off";
	} catch(e){/*alert(e.message);*/}
	try {
	    tbContentElement.document.body.contentEditable="false";
	} catch(e){/*alert(e.message);*/}

    // Riporta il contenuto	
    /*
	if( bTextOnly )
		// Riporta solo il testo
		args["HTMLContent"] = GetDOM().documentElement.innerText; //GetDOM().body.innerText;
	else
		// Riporta HTML
		args["HTMLContent"] = GetDOM().documentElement.innerHTML;
	*/
	args["HTMLContent"] = GetValidContent(bBodyOnly);
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
	    arr = window.showModalDialog( "Inc/instable.htm",
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
        if (bUseItalian)
		    AlertMsg("InsertTable - Questa funzionalità richiede l'abilitazione anche temporanea dei pop-up...", e, false);
        else
		    AlertMsg("InsertTable - This functionality require to enable pop-up in your browser...", e, false);
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

    // Tenta di memorizzare il control attivo
    try {
        if (GetDOM().hasFocus())
            elemLast = GetDOM().activeElement();
    }
    catch(e) {elemLast=undefined;}
    /*
	try{
	    if( elemLast == undefined && GetDOM().hasFocus() )
	        elemLast = GetDOM().activeElement;
	}catch(e){elemLast=undefined;}
	*/

  // Aggiornamento dello stato
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
		//objWB.document.write(GetDOM().all.toString());
		objWB.document.write(GetValidContent(false));
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
  
	var selection = undefined;
	var elemActive = null;
	try
	{
<%If bUseDHTMLSafe Then%>
		if( rangeLast != undefined 
		    || elemLast != undefined 
		    || GetDOM().selection.type != "none" )
		{
			if( rangeLast != undefined )
				selection = rangeLast;
			else if( GetDOM().hasFocus() )
				selection = GetDOM().selection.createRange();
			//
			try{
			    elemActive = GetDOM().activeElement;
			}catch(e){}
			//
			if( selection == undefined 
			        || elemLast != undefined
			        || (selection.htmlText.length == 0 && elemActive != null) )
			{
				// Se non c'è selezione cerca di inserire all'inzio dell'elemento
				if( elemLast != undefined )
					elemLast.insertAdjacentHTML("afterBegin", sHTML);
                else
			        elemActive.insertAdjacentHTML("afterBegin", sHTML);
			    //selection.select();
				//selection.pasteHTML(sHTML);
			    /***		
				    selection = selection.parentElement();
				    alert(selection.tagName);
				    if( selection.tagName.toUpperCase() == "BODY" )
					    GetDOM().body.insertAdjacentHTML("afterBegin", sHTML);
				    else
					    selection.insertAdjacentHTML("afterBegin", sHTML);
			    *****/
			}
			else
			{
				selection.select();
				selection.pasteHTML(sHTML);
			}
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
	rangeLast = undefined;
	elemLast = undefined;
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
		//GetDOM().designMode = "off";
	    try {
	        GetDOM().designMode = "off";
	    } catch(e){/*alert(e.message);*/}
	    try {
	        tbContentElement.document.body.contentEditable="";
	    } catch(e){/*alert(e.message);*/}
        //
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

//-->
</script>

<%If bUseDHTMLSafe Then%>
	<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="onactivate">
	<!--
		// Chiude eventuale menù attivo
		try {
			if (tbMenuShowing != null) {
				tbMenuCancel = tbMenuShowing;
				TBHideMenuBodies();
				TBShowNormal(tbMenuCancel);
				tbMenuShowing = null;
				tbMenuCancel = null;
			}
		} catch(e) {}
	
		// Aggiorna periodicamente le proprietà dell'elemento corrente
		nTimeInterval = window.setInterval("tbContentElement_DisplayChanged()", 500);
		
		// Annulla eventuale selezione memorizzata in precedenza
		try
		{
			if( rangeLast != undefined )
			{
				rangeLast.select();
				rangeLast = undefined;
			}
			else if( elemLast != undefined )
			    elemLast.setActive();
			elemLast = undefined;
			
		} catch(e) {}
		
	//-->
	</script>
	<script language="javascript" for="tbContentElement" event="onbeforedeactivate">
	<!--
	
		// Memorizza eventuale selezione corrente da ripristinare
		// in caso di esecuzione comando dopo l'attivazione di 
		// altra finestra che causa la perdita di tali informazioni
		// nel frame
		//if( tbContentElement.document.selection.type != "None" && rangeLast == undefined )
		if( rangeLast == undefined )
			rangeLast = tbContentElement.document.selection.createRange();
		//
		/*
		if( elemLast == undefined && tbContentElement.document.hasFocus() )
			elemLast = tbContentElement.document.activeElement();
		*/
		/*
		try{
		    if( elemLast == undefined && GetDOM().hasFocus() )
		        elemLast = GetDOM().activeElement;
		}catch(e){elemLast=undefined;}
		*/	
		
		// Se esce dall'editor disabilita la funzione di aggiornamento 
		// proprietà dell'elemento corrente
		window.clearInterval(nTimeInterval);
	//-->
	</script>
<%Else%>
	<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="DisplayChanged">
	<!--
	return tbContentElement_DisplayChanged()
	//-->
	</script>
<%End If%>

<%If bUseDHTMLSafe Then%>
	<!-- L'evento (oncontextmenu) viene impostato quando il documento è completo 
		 vedi StartEditor() -->
	<script LANGUAGE="javascript" FOR="document" EVENT="oncontextmenu">
	<!--
	// Disabilita i menù contestuali non desiderati
	return false;
	//-->
	</script>
<%Else%>
	<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="ShowContextMenu">
	<!--
	return tbContentElement_ShowContextMenu()
	//-->
	</script>
<%End If%>

<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="ContextMenuAction(itemIndex)">
<!--
return tbContentElement_ContextMenuAction(itemIndex)
//-->
</script>

<%If bUseDHTMLSafe Then%>
	<SCRIPT LANGUAGE=javascript FOR=tbContentElement EVENT=onreadystatechange>
	<!--
	try
	{
		if( tbContentElement.document.readyState == "complete" )
			tbContentElement_DocumentComplete();
	} 
	catch(e)
	{
		AlertMsg("DocumentComplete", e, false);
	}
	//-->
	</SCRIPT>
<%Else%>
	<SCRIPT LANGUAGE=javascript FOR=tbContentElement EVENT=DocumentComplete>
	<!--
	 tbContentElement_DocumentComplete()
	//-->
	</SCRIPT>
<%End If%>

<!-- TEST VBScript - la stessa versione presente in JavaScript sopra -->
<!--SCRIPT LANGUAGE=vbscript-->
<!--
Function WBHelper() 
	sObjWBHelper = "<object ID=ObjectWBHelper CLASSID=""CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"" WIDTH=0 HEIGHT=0 VIEWASTEXT></object>"
	Set obj = GetDOM().all.item("ObjectWBHelper")
	If obj Is Nothing Then
		GetDOM().body.insertAdjacentHTML "beforeEnd", sObjWBHelper
		Set obj = GetDOM().all.item("ObjectWBHelper")
	End If
	Set WBHelper = obj
End Function

'Sub print
'	MENU_FILE_PRINT_onclick()
'End Sub

Function MENU_FILE_PRINT_onclick()
	On Error Resume Next
	Set objWB = WBHelper()
	objWB.ExecWB WB_PRINTPREVIEW, OLECMDEXECOPT_DODEFAULT, PAGE_PRINT_TEMPLATE
	If Err.Number <> 0 Then MsgBox Err.Description 'AlertMsg "Print", Err.Description, False
End Function
//-->
<!--/SCRIPT-->

</head>
<body LANGUAGE="javascript" onload="return window_onload()" 
							onunload="return window_unonload()">
<!--
<form id="DHTMLEditor">
<input type="hidden" name="HTMLContent" value="<=Server.HtmlEncode(sContent)>">
<input type="hidden" name="Language" value="<=bUseItalian>">
-->

<!--------------------->
<!--   Menù PopUp    -->
<!--  (safe-script)	 -->
<!--------------------->
<!-- Dynamic Menù Manager...
	<div id=puMenu onclick="clickMenu()" onmouseover="switchMenu()" onmouseout="switchMenu()" style="position:absolute;display:none;width:200;background-Color:menu; border: outset 3px gray">
	<div class="menuItem" id=[mnuID]>[MenùItemString]</div> 
	</div>
-->
 
<SCRIPT language=javascript>
//<!--
// Visualizza il menù PopUp in relazione alle voci impostate in ContextMenu[]
function displayMenu() {
	var i, puMenu;
	var doc = document;		// GetDOM()
	var evt = tbContentElement.event;	// N.B.: l'evento iniziale avviene nel frame di Editing
										//		 qelli successivi nella pagina corrente che contiene 
										//		 il <DIV> di gestione menù PopUp
	var sDivMenu = "<div id=puMenu contentEditable=false onclick=\"clickMenu()\" onmouseover=\"switchMenu()\" onmouseout=\"switchMenu()\" style=\"position:absolute;display:none;width:200;background-Color:menu; border: outset 3px gray\"></div>";

	// Chiude eventuale menù precedente
	rangeLast = undefined;
	elemLast = undefined;
	hideMenu();

	// Memorizza eventule selezione corrente 
	if( rangeLast == undefined )
	    rangeLast = tbContentElement.document.selection.createRange();
	/*
    if (elemLast == undefined && tbContentElement.document.hasFocus() )
        elemLast = tbContentElement.document.activeElement();
    */
    /*
	try {
	    if (elemLast == undefined && GetDOM().hasFocus())
	        elemLast = GetDOM().activeElement;
	} catch (e) { elemLast = undefined; }
    */
    
	// Identifica l'oggetto DIV che gestisce il menù PopUp
	puMenu = doc.all.item("puMenu");
	if( puMenu == null ) {
		// Aggiunge il codice HTML per la gestione del menù
		doc.body.insertAdjacentHTML('beforeEnd', sDivMenu);
		puMenu = doc.all.item("puMenu");
	}	

	// Compone il menuù PopUp per MSHTML Editing (safe) che simula 
	// quello di DHTML Editing Component (SetContextMenu)
	sDivMenu = "";
	for (i=0; i<ContextMenu.length; i++) {
		if( ContextMenu[i].cmdId == MENU_SEPARATOR )
			sDivMenu = sDivMenu + "<HR>";
		else {
			sDivMenu = sDivMenu + "<div class=\"menuItem\" id=\"puItem_" + i + "\">";
			sDivMenu = sDivMenu + ContextMenu[i].string + "</div>";
		}
	}
	// Imposta le voci nel menù (DIV)
	puMenu.innerHTML = sDivMenu;
	
	// Durante l'attivazione del menù (PopUp) disabilita la modifica
	//GetDOM().designMode = "Off";	
	
	// Attiva il menù
	puMenu.style.posLeft=evt.screenX-window.screenLeft;
	puMenu.style.posTop=evt.screenY-window.screenTop;
	puMenu.style.display="";
	if( puMenu.style.posLeft + puMenu.clientWidth > document.body.clientWidth )
		puMenu.style.posLeft -= ((puMenu.style.posLeft + puMenu.clientWidth) - document.body.clientWidth);
	if( puMenu.style.posTop + puMenu.clientHeight > document.body.clientHeight )
		puMenu.style.posTop -= ((puMenu.style.posTop + puMenu.clientHeight) - document.body.clientHeight);
	puMenu.setCapture();

}
function switchMenu() {   

   var el=event.srcElement;
   if (el.className=="menuItem") {
      el.className="highlightItem";
   } else if (el.className=="highlightItem") {
      el.className="menuItem";
   }
   
}
function hideMenu() {

	var doc = document;		// GetDOM()
	var puMenu = doc.all.item("puMenu");
	if( puMenu != null ) {
		if( puMenu.style.display.toUpperCase() != "NONE" ) {
			puMenu.releaseCapture();
			puMenu.style.display="none";
		}
		//puMenu.removeNode(true);

		// Riabilita la modifica (Editor)
		/*if( GetDOM().designMode.toUpperCase() != "ON" ) 
			GetDOM().designMode = "On";	*/

		// Ripristina eventule selezione 
		if( rangeLast != undefined )
			rangeLast.select();
        else if (elemLast != undefined)
            elemLast.setActive();

	}
}

function clickMenu() {

	var idMenu, el=event.srcElement;
	hideMenu();

	// Pop Up Menù Manager
	// Identifia l'ID della voce ricavandolo dall'ID dell'elemento 
	// che è nella seguente forma:
	// puItem_[idMenu]
	if( el.id.substr(0,7) == "puItem_" ) {
		idMenu = el.id.substr(7).valueOf();
		tbContentElement_ContextMenuAction(idMenu);
	}
   
   /***
   if (el.id=="[mnuID1]") {
      // Do action;
   } else if (el.id=="[mnuID]") {
      // Do action;
   }
   ***/

}
//-->
</SCRIPT>


<!--------------------->
<!-- Menù / Toolbars -->
<!--------------------->
<div class="tbToolbar" ID="MenuBar">
  <div class="tbMenu" ID="FILE">
    File
    <div class="tbMenuItem" ID="FILE_NEW" LANGUAGE="javascript" onclick="return MENU_FILE_NEW_onclick()">
      <%=IIF(bUseItalian,"Nuovo...","New...")%>
      <img class="tbIcon" src="images/newdoc.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FILE_OPEN" LANGUAGE="javascript" onclick="return MENU_FILE_OPEN_onclick()">
      <%=IIF(bUseItalian,"Apri File...","Open File...")%>
      <img class="tbIcon" src="images/open.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FILE_SAVE" LANGUAGE="javascript" onclick="return MENU_FILE_SAVE_onclick()">
      <%=IIF(bUseItalian,"Salva File","Save File")%>
      <img class="tbIcon" src="images/save.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FILE_SAVEAS" LANGUAGE="javascript" onclick="return MENU_FILE_SAVEAS_onclick()">
      <%=IIF(bUseItalian,"Salva con Nome...","Save File As...")%>
      <img class="tbIcon" src="images/saveas.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbSeparator"></div>
    <div class="tbMenuItem" ID="FILE_PRINT" LANGUAGE="javascript" onclick="return MENU_FILE_PRINT_onclick()">
      <%=IIF(bUseItalian,"Stampa...","Print...")%>
      <img class="tbIcon" src="images/print.gif" WIDTH="23" HEIGHT="22">
    </div>
  </div>

  <div class="tbMenu" ID="EDIT" LANGUAGE="javascript" tbOnMenuShow="return OnMenuShow(QueryStatusEditMenu, EDIT)">
    Edit
    <div class="tbMenuItem" ID="EDIT_UNDO" LANGUAGE="javascript" onclick="return DECMD_UNDO_onclick()">
      <%=IIF(bUseItalian,"Annulla","Undo")%>
      <img class="tbIcon" src="images/undo.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="EDIT_REDO" LANGUAGE="javascript" onclick="return DECMD_REDO_onclick()">
      <%=IIF(bUseItalian,"Ripeti","Redo")%>
      <img class="tbIcon" src="images/redo.gif" WIDTH="23" HEIGHT="22">
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="EDIT_CUT" LANGUAGE="javascript" onclick="return DECMD_CUT_onclick()">
      <%=IIF(bUseItalian,"Taglia","Cut")%>
      <img class="tbIcon" src="images/cut.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="EDIT_COPY" LANGUAGE="javascript" onclick="return DECMD_COPY_onclick()">
      <%=IIF(bUseItalian,"Copia","Copy")%>
      <img class="tbIcon" src="images/copy.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="EDIT_PASTE" LANGUAGE="javascript" onclick="return DECMD_PASTE_onclick()">
      <%=IIF(bUseItalian,"Incolla","Paste")%>
      <img class="tbIcon" src="images/paste.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="EDIT_DELETE" LANGUAGE="javascript" onclick="return DECMD_DELETE_onclick()">
      <%=IIF(bUseItalian,"Elimina","Delete")%>
      <img class="tbIcon" src="images/delete.gif" WIDTH="23" HEIGHT="22">
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="EDIT_SELECTALL" LANGUAGE="javascript" onclick="return DECMD_SELECTALL_onclick()">
      <%=IIF(bUseItalian,"Seleziona Tutto","Select All")%>
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="EDIT_FINDTEXT" TITLE="<%=IIF(bUseItalian,"Cerca","Find")%>" LANGUAGE="javascript" onclick="return DECMD_FINDTEXT_onclick()">
      <%=IIF(bUseItalian,"Cerca...","Find...")%>
      <img class="tbIcon" src="images/find.gif" WIDTH="23" HEIGHT="22">
    </div>
  </div>

  <div class="tbMenu" ID="VIEW" LANGUAGE="javascript" tbOnMenuShow="return OnMenuShow_View()">
    View
	<div class="tbMenuItem" ID="VIEW_VISIBLEBORDERS" TBTYPE="toggle" TITLE="<%=IIF(bUseItalian,"Bordi Visibili","Visible Borders")%>" LANGUAGE="javascript" onclick="return DECMD_VISIBLEBORDERS_onclick(true)">
	  <%=IIF(bUseItalian,"Bordi Visibili","Visible Borders")%>
	  <img class="tbIcon" src="images/borders.gif" WIDTH="23" HEIGHT="22">
	</div>
	<div class="tbMenuItem" ID="VIEW_SHOWDETAILS" TBTYPE="toggle" TITLE="<%=IIF(bUseItalian,"Visualizza Dettagli","Show Details")%>" LANGUAGE="javascript" onclick="return DECMD_SHOWDETAILS_onclick(true)">
	  <%=IIF(bUseItalian,"Visualizza Dettagli","Show Details")%>
	  <img class="tbIcon" src="images/details.gif" WIDTH="23" HEIGHT="22">
	</div>

    <div class="tbSeparator"></div>
    
    <div class="tbSubmenu" TBTYPE="toggle" ID="VIEW_TOOLBARS">
      <%=IIF(bUseItalian,"Barre degli Strumenti","Toolbars")%>
      <!--<div class="tbMenuItem" id="ToolbarMenuFile" TBTYPE="toggle" TBSTATE="unchecked" ID="TOOLBARS_FILE" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(FileToolbar, ToolbarMenuFile)">-->
      <div class="tbMenuItem" id="ToolbarMenuFile" TBTYPE="toggle" TBSTATE="checked" ID="TOOLBARS_FILE" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(FileToolbar, ToolbarMenuFile)">
        File
      </div>
      <div class="tbMenuItem" id="ToolbarMenuStd" TBTYPE="toggle" TBSTATE="checked" ID="TOOLBARS_STANDARD" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(StandardToolbar, ToolbarMenuStd)">
        <%=IIF(bUseItalian,"Predefinito","Standard")%>
      </div>
      <div class="tbMenuItem" id="ToolbarMenuFont" TBTYPE="toggle" TBSTATE="checked" ID="TOOLBARS_FONT" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(FontToolbar, ToolbarMenuFont)">
        <%=IIF(bUseItalian,"Carattere","Font")%>
      </div>
      <div class="tbMenuItem" id="ToolbarMenuFmt" TBTYPE="toggle" TBSTATE="checked" ID="TOOLBARS_FORMAT" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(FormatToolbar, ToolbarMenuFmt)">
        <%=IIF(bUseItalian,"Formattazione","Formatting")%>
      </div>
      <div class="tbMenuItem" id="ToolbarMenuAbs" TBTYPE="toggle" TBSTATE="checked" ID="TOOLBARS_ZORDER" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(AbsolutePositioningToolbar, ToolbarMenuAbs)">
        <%=IIF(bUseItalian,"Posizione Assoluta","Absolute Positioning")%>
      </div>
      <div class="tbMenuItem" id="ToolbarMenuTable" TBTYPE="toggle" TBSTATE="checked" ID="TOOLBARS_TABLE" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(TableToolbar, ToolbarMenuTable)">
        <%=IIF(bUseItalian,"Tabella","Table")%>
      </div>
      <div class="tbMenuItem" id="ToolbarMenuDOM" TBTYPE="toggle" TBSTATE="unchecked" ID="TOOLBARS_FILE" TBTYPE="toggle" LANGUAGE="javascript" onclick="return TOOLBARS_onclick(DOMToolbar, ToolbarMenuDOM)">
        <%=IIF(bUseItalian,"Dettagli DOM","DOM Detail")%>
      </div>
    </div>
  </div>

  <div class="tbMenu" ID="FORMAT" LANGUAGE="javascript" tbOnMenuShow="return OnMenuShow(QueryStatusFormatMenu, FORMAT)">
    <%=IIF(bUseItalian,"Formato","Format")%>
    <div class="tbMenuItem" ID="FORMAT_FONT" LANGUAGE="javascript" onclick="return FORMAT_FONT_onclick()">
      <%=IIF(bUseItalian,"Carattere...","Font...")%>
      <img class="tbIcon" src="images/font.gif" WIDTH="23" HEIGHT="22">
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="FORMAT_BOLD" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_BOLD_onclick()">
      <%=IIF(bUseItalian,"Grassetto","Bold")%>
      <img class="tbIcon" src="images/bold.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FORMAT_ITALIC" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_ITALIC_onclick()">
      <%=IIF(bUseItalian,"Italico","Italic")%>
      <img class="tbIcon" src="images/italic.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FORMAT_UNDERLINE" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_UNDERLINE_onclick()">
      <%=IIF(bUseItalian,"Sottolineato","Underline")%>
      <img class="tbIcon" src="images/under.gif" WIDTH="23" HEIGHT="22">
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="FORMAT_SETFORECOLOR" LANGUAGE="javascript" onclick="return DECMD_SETFORECOLOR_onclick()">
      <%=IIF(bUseItalian,"Imposta Colore di Primo Piano...","Set Foreground Color...")%>
      <img class="tbIcon" src="images/fgcolor.GIF" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FORMAT_SETBACKCOLOR" LANGUAGE="javascript" onclick="return DECMD_SETBACKCOLOR_onclick()">
      <%=IIF(bUseItalian,"Imposta Colore di Sfondo...","Set Background Color...")%>
      <img class="tbIcon" src="images/bgcolor.gif" WIDTH="23" HEIGHT="22">
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="FORMAT_JUSTIFYLEFT" TBTYPE="radio" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYLEFT_onclick()">
      <%=IIF(bUseItalian,"Allinea a Sinistra","Align Left")%>
      <img class="tbIcon" src="images/left.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FORMAT_JUSTIFYCENTER" TBTYPE="radio" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYCENTER_onclick()">
      <%=IIF(bUseItalian,"Allinea al Centro","Center")%>
      <img class="tbIcon" src="images/center.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="FORMAT_JUSTIFYRIGHT" TBTYPE="radio" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYRIGHT_onclick()">
      <%=IIF(bUseItalian,"Allinea a Destra","Align Right")%>
      <img class="tbIcon" src="images/right.gif" WIDTH="23" HEIGHT="22">
    </div>
  </div>

  <div class="tbMenu" ID="HTML" LANGUAGE="javascript" tbOnMenuShow="return OnMenuShow(QueryStatusHTMLMenu, HTML)">
    HTML
    <div class="tbMenuItem" ID="HTML_HYPERLINK" LANGUAGE="javascript" onclick="return DECMD_HYPERLINK_onclick()">
      <%=IIF(bUseItalian,"Collegamento...","Link...")%>
      <img class="tbIcon" src="images/link.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="HTML_IMAGE" LANGUAGE="javascript" onclick="return DECMD_IMAGE_onclick()">
      <%=IIF(bUseItalian,"Immagine...","Image...")%>
      <img class="tbIcon" src="images/image.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbMenuItem" ID="HTML_TABLE" LANGUAGE="javascript" onclick="return TABLE_INSERTTABLE_onclick()">
      <%=IIF(bUseItalian,"Tabella...","Table...")%>
      <img class="tbIcon" src="images/instable.gif" WIDTH="23" HEIGHT="22">
    </div>
    <div class="tbSeparator"></div>

    <div class="tbSubmenu" ID="HTML_INTRINSICS">
      <%=IIF(bUseItalian,"Controlli Integrati","Intrinsics")%>
      <div class="tbMenuItem" ID="INTRINSICS_TEXTBOX" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=text&gt;')">
        <%=IIF(bUseItalian,"Casella di Testo","Text Box")%>
        <img class="tbIcon" src="images/textbox.gif" WIDTH="23" HEIGHT="22">
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_PASSWRD" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=password&gt;')">
        Password
        <img class="tbIcon" src="images/textpassword.gif" WIDTH="23" HEIGHT="22">
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_FILE" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=file&gt;')">
        <%=IIF(bUseItalian,"Selezione File","File Field")%>
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_TEXTAREA" LANGUAGE="javascript" onclick="return pasteHTML('&lt;TEXTAREA rows=2 cols=20&gt;&lt;/TEXTAREA&gt;')">
        <%=IIF(bUseItalian,"Area di Testo","Text Area")%>
      </div>

      <div class="tbSeparator"></div>

      <div class="tbMenuItem" ID="INTRINSICS_CHECKBOX" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=checkbox&gt;')">
        <%=IIF(bUseItalian,"Casella di Spunta","Check Box")%>
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_RADIO" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=radio&gt;')">
        <%=IIF(bUseItalian,"Casella di Selezione","Radio Button")%>
      </div>

      <div class="tbSeparator"></div>

      <div class="tbMenuItem" ID="INTRINSICS_DROPDOWN" LANGUAGE="javascript" onclick="return pasteHTML('&lt;SELECT&gt;&lt;/SELECT&gt;')">
        <%=IIF(bUseItalian,"Selezione a Discesa","Drop Down")%>
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_LISTBOX" LANGUAGE="javascript" onclick="return pasteHTML('&lt;SELECT size=2&gt;&lt;/SELECT&gt;')">
        <%=IIF(bUseItalian,"Casella Lista","List Box")%>
      </div>

      <div class="tbSeparator"></div>

      <div class="tbMenuItem" ID="INTRINSICS_BUTTON" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=button value=Button&gt;')">
        <%=IIF(bUseItalian,"Tasto","Button")%>
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_SUBMIT" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=submit value=Submit&gt;')">
        <%=IIF(bUseItalian,"Tasto di Invio","Submit Button")%>
      </div>
      <div class="tbMenuItem" ID="INTRINSICS_RESET" LANGUAGE="javascript" onclick="return pasteHTML('&lt;INPUT type=reset value=Reset&gt;')">
        <%=IIF(bUseItalian,"Tasto di Reset","Reset Button")%>
      </div>
    </div>

  </div>

  <div class="tbMenu" ID="HELP">
	Help
    <div class="tbMenuItem" ID="HTML_HELP_ACCKEY" LANGUAGE="javascript" onclick="return HELP_ACCKEY_onclick()">
      <%=IIF(bUseItalian,"Tasti Rapidi","Keyboard Accelerators...")%>
    </div>

    <div class="tbMenuItem" ID="HTML_HELP_GLYPH" LANGUAGE="javascript" onclick="return HELP_GLYPH_DETAIL_onclick()">
      <%=IIF(bUseItalian,"Legenda Dettagli (Glyph)","Glyph Detail Legend...")%>
	  <img class="tbIcon" src="images/details.gif" WIDTH="23" HEIGHT="22">
    </div>
  </div>
</div>

<!--<div class="tbToolbar" ID="FileToolbar" TBSTATE="hidden">-->
<div class="tbToolbar" ID="FileToolbar">
  <div class="tbGeneral" ID="URL_LABEL" TITLE="<%=IIF(bUseItalian,"Digita l'URL","Enter URL")%>" style="top:6; width:27; FONT-FAMILY: ms sans serif; FONT-SIZE: 10px;">
    URL:
  </div>
  <input type="text" class="tbGeneral" ID="URL_VALUE" TITLE="<%=IIF(bUseItalian,"Digita l'URL","Enter URL")%>" value="http://" style="width:200" LANGUAGE="javascript" onkeypress="return URL_VALUE_onkeypress()">

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="MENU_FILE_NEW" TITLE="<%=IIF(bUseItalian,"Nuovo File","New File")%>" LANGUAGE="javascript" onclick="return MENU_FILE_NEW_onclick()">
    <img class="tbIcon" src="images/newdoc.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="MENU_FILE_OPEN" TITLE="<%=IIF(bUseItalian,"Apri File","Open File")%>" LANGUAGE="javascript" onclick="return MENU_FILE_OPEN_onclick()">
    <img class="tbIcon" src="images/open.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="MENU_FILE_SAVE" TITLE="<%=IIF(bUseItalian,"Salva File","Save File")%>" LANGUAGE="javascript" onclick="return MENU_FILE_SAVE_onclick()">
    <img class="tbIcon" src="images/save.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="FontToolbar">
  <select ID="ParagraphStyle" class="tbGeneral" style="width:150" TITLE="Paragraph Format" LANGUAGE="javascript" onchange="return ParagraphStyle_onchange()">
  </select>
  <select ID="FontName" class="tbGeneral" style="width:140" TITLE="<%=IIF(bUseItalian,"Nome Font","Font Name")%>" LANGUAGE="javascript" onchange="return FontName_onchange()">
  </select>
  <select ID="FontSize" class="tbGeneral" style="width:40" TITLE="<%=IIF(bUseItalian,"Dimensione Font","Font Size")%>" LANGUAGE="javascript" onchange="return FontSize_onchange()">
    <option value="1">1
    <option value="2">2
    <option value="3">3
    <option value="4">4
    <option value="5">5
    <option value="6">6
    <option value="7">7
  </select>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_BOLD" TITLE="<%=IIF(bUseItalian,"Grassetto","Bold")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_BOLD_onclick()">
    <img class="tbIcon" src="images/bold.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_ITALIC" TITLE="<%=IIF(bUseItalian,"Italico","Italic")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_ITALIC_onclick()">
    <img class="tbIcon" src="images/italic.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_UNDERLINE" TITLE="<%=IIF(bUseItalian,"Sottolineato","Underline")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_UNDERLINE_onclick()">
    <img class="tbIcon" src="images/under.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="FormatToolbar">

  <div class="tbButton" ID="DECMD_SETFORECOLOR" TITLE="<%=IIF(bUseItalian,"Colore di Primo Piano","Foreground Color")%>" LANGUAGE="javascript" onclick="return DECMD_SETFORECOLOR_onclick()">
    <img class="tbIcon" src="images/fgcolor.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_SETBACKCOLOR" TITLE="<%=IIF(bUseItalian,"Colore di Sfondo","Background Color")%>" LANGUAGE="javascript" onclick="return DECMD_SETBACKCOLOR_onclick()">
    <img class="tbIcon" src="images/bgcolor.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_JUSTIFYLEFT" TITLE="<%=IIF(bUseItalian,"Allinea a Sinistra","Align Left")%>" TBTYPE="toggle" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYLEFT_onclick()">
    <img class="tbIcon" src="images/left.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_JUSTIFYCENTER" TITLE="<%=IIF(bUseItalian,"Centra","Center")%>" TBTYPE="toggle" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYCENTER_onclick()">
    <img class="tbIcon" src="images/center.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_JUSTIFYRIGHT" TITLE="<%=IIF(bUseItalian,"Allinea a Destra","Align Right")%>" TBTYPE="toggle" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYRIGHT_onclick()">
    <img class="tbIcon" src="images/right.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_ORDERLIST" TITLE="<%=IIF(bUseItalian,"Elenco Numerato","Numbered List")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_ORDERLIST_onclick()">
    <img class="tbIcon" src="images/numlist.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_UNORDERLIST" TITLE="<%=IIF(bUseItalian,"Elenco Puntato","Bulletted List")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_UNORDERLIST_onclick()">
    <img class="tbIcon" src="images/bullist.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_OUTDENT" TITLE="<%=IIF(bUseItalian,"Diminuisce Rientro","Decrease Indent")%>" LANGUAGE="javascript" onclick="return DECMD_OUTDENT_onclick()">
    <img class="tbIcon" src="images/deindent.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_INDENT" TITLE="<%=IIF(bUseItalian,"Aumenta Rientro","Increase Indent")%>" LANGUAGE="javascript" onclick="return DECMD_INDENT_onclick()">
    <img class="tbIcon" src="images/inindent.GIF" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_HYPERLINK" TITLE="<%=IIF(bUseItalian,"Collegamento","Link")%>" LANGUAGE="javascript" onclick="return DECMD_HYPERLINK_onclick()">
    <img class="tbIcon" src="images/link.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_IMAGE" TITLE="<%=IIF(bUseItalian,"Inserisci Immagine","Insert Image")%>" LANGUAGE="javascript" onclick="return DECMD_IMAGE_onclick()">
    <img class="tbIcon" src="images/image.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="StandardToolbar">

  <div class="tbButton" ID="DECMD_CUT" TITLE="<%=IIF(bUseItalian,"Taglia","Cut")%>" LANGUAGE="javascript" onclick="return DECMD_CUT_onclick()">
    <img class="tbIcon" src="images/cut.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_COPY" TITLE="<%=IIF(bUseItalian,"Copia","Copy")%>" LANGUAGE="javascript" onclick="return DECMD_COPY_onclick()">
    <img class="tbIcon" src="images/copy.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_PASTE" TITLE="<%=IIF(bUseItalian,"Incolla","Paste")%>" LANGUAGE="javascript" onclick="return DECMD_PASTE_onclick()">
    <img class="tbIcon" src="images/paste.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_UNDO" TITLE="<%=IIF(bUseItalian,"Annulla","Undo")%>" LANGUAGE="javascript" onclick="return DECMD_UNDO_onclick()">
    <img class="tbIcon" src="images/undo.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_REDO" TITLE="<%=IIF(bUseItalian,"Ripeti","Redo")%>" LANGUAGE="javascript" onclick="return DECMD_REDO_onclick()">
    <img class="tbIcon" src="images/redo.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_FINDTEXT" TITLE="<%=IIF(bUseItalian,"Cerca","Find")%>" LANGUAGE="javascript" onclick="return DECMD_FINDTEXT_onclick()">
    <img class="tbIcon" src="images/find.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="MENU_FILE_PRINT" TITLE="<%=IIF(bUseItalian,"Stampa","Print")%>" LANGUAGE="javascript" onclick="return MENU_FILE_PRINT_onclick()">
    <img class="tbIcon" src="images/print.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="AbsolutePositioningToolbar">
  <div class="tbButton" ID="DECMD_VISIBLEBORDERS" TITLE="<%=IIF(bUseItalian,"Bordi Visibili","Visible Borders")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_VISIBLEBORDERS_onclick(false)">
    <img class="tbIcon" src="images/borders.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_SHOWDETAILS" TITLE="<%=IIF(bUseItalian,"Visualizza Dettagli","Show Details")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_SHOWDETAILS_onclick(false)">
    <img class="tbIcon" src="images/details.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_MAKE_ABSOLUTE" TBTYPE="toggle" LANGUAGE="javascript" TITLE="<%=IIF(bUseItalian,"Posizione Assuluta","Make Absolute")%>" onclick="return DECMD_MAKE_ABSOLUTE_onclick()">
    <img class="tbIcon" src="images/abspos.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_LOCK_ELEMENT" TBTYPE="toggle" LANGUAGE="javascript" TITLE="<%=IIF(bUseItalian,"Blocca","Lock")%>" onclick="return DECMD_LOCK_ELEMENT_onclick()">
    <img class="tbIcon" src="images/lock.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbMenu" ID="ZORDER" LANGUAGE="javascript" tbOnMenuShow="return OnMenuShow(QueryStatusZOrderMenu, ZORDER)">
  Z Order
    <div class="tbMenuItem" ID="ZORDER_BRINGFRONT" LANGUAGE="javascript" onclick="return ZORDER_BRINGFRONT_onclick()">
      <%=IIF(bUseItalian,"Porta in Primo Piano","Bring to Front")%>
    </div>
    <div class="tbMenuItem" ID="ZORDER_SENDBACK" LANGUAGE="javascript" onclick="return ZORDER_SENDBACK_onclick()">
      <%=IIF(bUseItalian,"Porta in Fondo","Send to Back")%>
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="ZORDER_BRINGFORWARD" LANGUAGE="javascript" onclick="return ZORDER_BRINGFORWARD_onclick()">
      <%=IIF(bUseItalian,"Porta Avanti","Bring Forward")%>
    </div>
    <div class="tbMenuItem" ID="ZORDER_SENDBACKWARD" LANGUAGE="javascript" onclick="return ZORDER_SENDBACKWARD_onclick()">
      <%=IIF(bUseItalian,"Porta Indietro","Send Backward")%>
    </div>

    <div class="tbSeparator"></div>

    <div class="tbMenuItem" ID="ZORDER_BELOWTEXT" LANGUAGE="javascript" onclick="return ZORDER_BELOWTEXT_onclick()">
      <%=IIF(bUseItalian,"Sotto il Testo","Below Text")%>
    </div>
    <div class="tbMenuItem" ID="ZORDER_ABOVETEXT" LANGUAGE="javascript" onclick="return ZORDER_ABOVETEXT_onclick()">
      <%=IIF(bUseItalian,"Sopra il Testo","Above Text")%>
    </div>
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_SNAPTOGRID" TITLE="<%=IIF(bUseItalian,"Allinea alla Griglia","Snap to Grid")%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_SNAPTOGRID_onclick()">
    <img class="tbIcon" src="images/snapgrid.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="TableToolbar">
  <div class="tbButton" ID="DECMD_INSERTTABLE" TITLE="<%=IIF(bUseItalian,"Inserisci Tabella","Insert Table")%>" LANGUAGE="javascript" onclick="return TABLE_INSERTTABLE_onclick()">
    <img class="tbIcon" src="images/instable.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_INSERTROW" TITLE="<%=IIF(bUseItalian,"Inserisci Riga","Insert Row")%>" LANGUAGE="javascript" onclick="return TABLE_INSERTROW_onclick()">
    <img class="tbIcon" src="images/insrow.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_DELETEROWS" TITLE="<%=IIF(bUseItalian,"Elimina Riga","Delete Rows")%>" LANGUAGE="javascript" onclick="return TABLE_DELETEROW_onclick()">
    <img class="tbIcon" src="images/delrow.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_INSERTCOL" TITLE="<%=IIF(bUseItalian,"Inserisci Colonna","Insert Column")%>" LANGUAGE="javascript" onclick="return TABLE_INSERTCOL_onclick()">
    <img class="tbIcon" src="images/inscol.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_DELETECOLS" TITLE="<%=IIF(bUseItalian,"Elimina Colonne","Delete Columns")%>" LANGUAGE="javascript" onclick="return TABLE_DELETECOL_onclick()">
    <img class="tbIcon" src="images/delcol.gif" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_INSERTCELL" TITLE="<%=IIF(bUseItalian,"Inserisci Cella","Insert Cell")%>" LANGUAGE="javascript" onclick="return TABLE_INSERTCELL_onclick()">
    <img class="tbIcon" src="images/inscell.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_DELETECELLS" TITLE="<%=IIF(bUseItalian,"Elimina Celle","Delete Cells")%>" LANGUAGE="javascript" onclick="return TABLE_DELETECELL_onclick()">
    <img class="tbIcon" src="images/delcell.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_MERGECELLS" TITLE="<%=IIF(bUseItalian,"Unisci Celle","Merge Cells")%>" LANGUAGE="javascript" onclick="return TABLE_MERGECELL_onclick()">
    <img class="tbIcon" src="images/mrgcell.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_SPLITCELL" TITLE="<%=IIF(bUseItalian,"Dividi Celle","Split Cells")%>" LANGUAGE="javascript" onclick="return TABLE_SPLITCELL_onclick()">
    <img class="tbIcon" src="images/spltcell.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<!-- Barra degli strumenti per i componenti in esecuzione lato Client -->
<div class="tbToolbar" ID="ClientComponentToolbar">
  <div class="tbButton" ID="DECMD_INSERT_DATAPANEL" TITLE="<%=IIF(bUseItalian,"Inserisci Pannello Dati","Insert Data Panel")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OODataPanel","",150)'>
    <img class="tbIcon" src="images/OODataPanel.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbButton" ID="DECMD_INSERT_DATAGRID" TITLE="<%=IIF(bUseItalian,"Inserisci Griglia Dati","Insert Data Grid")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OODataGrid","",150)'>
    <img class="tbIcon" src="images/OODataGrid.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbButton" ID="DECMD_INSERT_BIDIM_DATA" TITLE="<%=IIF(bUseItalian,"Inserisci Griglia Dati Bidimensionale","Insert Bidimensional Data Grid")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OOBidimData","",150)'>
    <img class="tbIcon" src="images/OOBidimData.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbButton" ID="DECMD_INSERT_DATASELECTION" TITLE="<%=IIF(bUseItalian,"Inserisci Selezione Dati","Insert Data Selection")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OODataSelection","",30)'>
    <img class="tbIcon" src="images/OODataSelection.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbButton" ID="DECMD_INSERT_REFSELECTION" TITLE="<%=IIF(bUseItalian,"Inserisci Selezione Dati Referenziati","Insert Data Reference Selection")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OODataReference","",30)'>
    <img class="tbIcon" src="images/OODataReference.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbButton" ID="DECMD_INSERT_DATAGRID" TITLE="<%=IIF(bUseItalian,"Inserisci Ricerca","Insert Short Search")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OOShortSearch","",30)'>
    <img class="tbIcon" src="images/OOShortSearch.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbButton" ID="DECMD_INSERT_DATATREE" TITLE="<%=IIF(bUseItalian,"Inserisci Albero Dati","Insert Data Tree")%>" LANGUAGE="javascript" onclick='return InsertOOComponent("OODBDataTree","",100)'>
    <img class="tbIcon" src="images/OODBDataTree.bmp" WIDTH="16" HEIGHT="16">
  </div>
  <div class="tbSeparator"></div>
  <div class="tbButton" TBTYPE="toggle" ID="DECMD_ACTIVATE_OBJECTS" TITLE="<%=IIF(bUseItalian,"Attiva Oggetti","Activate Objects")%>" LANGUAGE="javascript" onclick='return SwitchObjectsActivation()'>
    <img class="tbIcon" src="images/StartCOM.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="DOMToolbar" TBSTATE="hidden">
  <input type=text ID="DECMD_DOMITEM" class="tbGeneral" style="width:250" TITLE="DOM Item" LANGUAGE="javascript" readonly>
  <div class="tbButton" ID="DECMD_DOMGETITEM" TITLE="Get DOM Item" LANGUAGE="javascript" onclick="return DOM_GETITEM_onclick()" onmousemove="return DOM_GETITEM_onclick()">
    <img class="tbIcon" src="images/start.gif" WIDTH="23" HEIGHT="22">
  </div>
</div>

<%  
    If bUseDHTMLSafe Then
%>
	<iframe ID="tbContentElement" CLASS="tbContentElement" scrolling="yes">
	</iframe>
<%
Else
%>
	<!-- DHTML Editing control Object. This will be the body object for the toolbars. -->
	<!-- http://msdn.microsoft.com/archive/en-us/dnaredcom/html/cncpt.asp?frame=true#Using_the_DHTML_Editing_Component_Document_Object -->
	<object ID="tbContentElement" CLASS="tbContentElement" CLASSID="clsid:2D360200-FFF5-11D1-8D03-00A0C959BC0A" VIEWASTEXT>
	  <param name=Scrollbars value=true>
	</object>
<%
End If
%>

<!-- DEInsertTableParam Object -->
<!-- Inserito dinamicamente dalla funzione ObjTableInfo() quando necessario
	<object ID="ObjTableInfo" CLASSID="clsid:47B0DFC7-B7A3-11D1-ADC5-006008A5848C" VIEWASTEXT>
	</object>
-->

<!-- DEGetBlockFmtNamesParam Object -->
<!-- Inserito dinamicamente dalla funzione ObjBlockFormatInfo() quando necessario
	<object ID="ObjBlockFormatInfo" CLASSID="clsid:8D91090E-B955-11D1-ADC5-006008A5848C" VIEWASTEXT>
	</object>
-->

<!--Create the Dialog Helper Object-->
<!-- Inserito dinamicamente dalla funzione DlgHelper() quando necessario
	<object ID=dlgHelper CLASSID="clsid:3050f819-98b5-11cf-bb82-00aa00bdce0b" VIEWASTEXT>
	</object>
-->

<!-- Toolbar Code File. Note: This must always be the last thing on the page -->
<script LANGUAGE="Javascript" SRC="Toolbars/toolbars.js">
</script>

<script LANGUAGE="Javascript">
  tbScriptletDefinitionFile = "Toolbars/menubody.htm";
</script>
<!-- Script Functions for Menù -->
<script LANGUAGE="JavaScript" SRC="Toolbars/tbmenus.js">
</script>

<!-- Script Utilities (LogiCode) -->
<script LANGUAGE="JavaScript" SRC="Modules/DHTMLUtils.js">
</script>

<!--   
Aggiunto per problemi in alcune situazioni, veniva precedentemente aggiunto da tbmenus.js
vedi anche [*** INSERT SCRIPTLET EVENTS ***]
-->
<!--
<script type="text/javascript" language="javascript" for=TBSCRIPTLET event="onreadystatechange"> TBScriptletReadyState(this); </script>
<script type="text/javascript" language="javascript" for=TBSCRIPTLET event="onscriptletevent(eventName, eventObject)"> TBScriptletEvent(this, eventName, eventObject); </script>
-->
<!--
</form>
-->
</body>
</html>
