// Copyright LogiCode Srl.  All rights reserved.
//
// Verifica la versione del browser per
// poter attivare DHTML Editing Control
//
// Estratto da:
//	http://msdn.microsoft.com/archive/default.asp?url=/archive/en-us/dnaredcom/html/cncpt.asp
//
// Riporta False se la versione non è valida
function ValidateBrowserVersion()
{
	var bValid = false;
	//
	if (navigator.userAgent.indexOf("MSIE") == -1)
	{
		// Non-IE browser, navigate to a different page
	}
	else
	{
		// IE browser, now test for version 5 or better
		var browserVersionInfo = Array();
		browserVersionInfo = navigator.userAgent.split(";");
		IEVersion = browserVersionInfo[1].substring(6,7);
		if(IEVersion < "5")
		{ 
			// Navigate to a different page
			//alert("This page requires Internet Explorer	5!");
		} 
		else
			// Ok. Valid Browser...
			bValid = true;
	}
	//
	return bValid;
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
		if( typeof( objPopUpWindow ) != "undefined" )
		{
			if( !objPopUpWindow.closed )
				objPopUpWindow.close();
		}
	}
	catch( e )
	{
		// nessun errore
	}
}

// Gestisce una finestra PopUp
function OpenPopUpWindow( sPage, sParams, nXDim, nYDim, bScroll, bSizable )
{
	// Identifica le dimensioni, se non specificate (0) imposta
	// quelle predefinite rispetto alla dimensione dello schermo
	var nWidth = nXDim, nHeight = nYDim;
	if( nWidth == 0 )
		nWidth = window.screen.width * 0.5;

	if( nHeight == 0 )
		nHeight = window.screen.height * 0.5;

	// Impostazione proprietà
	var sSizable = "no", sScroll = "no";
	if( bScroll )
		sScroll = "yes";
	if( bSizable )
		sSizable = "yes";

	// Identifica la posizione di PopUp rispetto alla finestra precedente
	// Per ogni livello sposta la finestra in basso a destra
	var nLeft = (window.screen.width-nWidth-10);
	var nTop = 50;  //(window.screen.height/50);

	// Chiude eventuale finestra PopUp attiva
	ClosePopUpWindow();

	// Apre la finestra per il calcolo del codice fiscale
	objPopUpWindow = window.open( sPage + "?" + sParams, 
		"DHTMLPopUp", "status=yes,location=no,menubar=no,scrollbars=" + sScroll + "," +
					"width=" + nWidth + ",height=" + nHeight + "," + 
					"left=" + nLeft + ",top=" + nTop + ",resizable=" + sSizable );
	//
	return objPopUpWindow;
}
