<html>
	<head>
        <title>EasyContentManager</title>
        <link rel="shortcut icon" href="http://www.logicode.it/images/logicode_icon.ico" />
        <meta name="title" content="EasyContentManager - Home" />
        <meta name="description" content="EasyContentManater - Gestione Contenuti" />
        <meta name="keywords" content="Content Manager Dynamic LogiCode Gestione Contenuti Siti Web Dinamici" />
        <meta name="author" content="http://www.logicode.it" />
        <meta name="copyright" content="2014, LogiCode Srl" />
        <meta name="revisit-after" content="7 days" />
        <meta name="robot" content="All" />
	</head>
<%
' Pagina principale di avvio e costruzione frames.
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	12/01/2004

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
' N.B.: Senza questo accorgimento le eventuali inizializzazioni
'		mediante i frames successivi potrebbero fare collisione
'		durante l'inizializzazione degli stessi oggetti generando
'		errori.

' Eventuale inizializzazione dell'applicazione 
WriteHeadSessionObjFrameAccess(Me)

%>
	
	<%
' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
	<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->


	<%
' < Inclusione delle funzioni Form Java lato client >
%>
	<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

	<%

	    Try
	        _site.Glb.InitializeGlobal()
	    Catch ex As Exception
	        Response.Write("Impossibile continuare, errore: " & ex.Message)
	        Response.End()
	    End Try
	    ''If Not _site.InitApplicationObjects(Me, True, False) Then
	    'If Not _site.Lib.InitializeGlobalObjects() Then
	    '    Response.Write("Impossibile continuare.")
	    '    Response.End()
	    'End If

	    ' Inizializza la sessione per segnalare che 
	    ' la gestione dei Frames è stata avviata
	    Session("ooSYS_FramesStarted") = "TRUE"

	    ' Imposta la pagina di ritorno al contenuto in caso di uscita
	    _site.Lib.SetReturnAppURL(_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_START_FIRST")))

	    ' Imposta eventuale linguaggio di presentazione
	    If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	        _site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))
	    End If

%>

	<link rel=stylesheet href="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css" />
 
	<frameset border="0" cols="0,300,*" frameborder="0">
		<frame border="0" name="LogoutFrame" scrolling="no" noresize target="LogoutFrame" src="LogoutFrame.aspx" marginwidth="0" marginheight="0" frameborder="0" framespacing="0">
		<frame border="0" name="Links" target="Contents" marginwidth="10" marginheight="0" scrolling="auto" noresize src="CustomLinks.aspx">
		<frame border=0 name="<%=FRAME_CONTENT_PAGES%>" marginwidth="10" marginheight="0" scrolling="auto" src="frmAppStart.aspx" target="_self" >
		<noframes>
			<body>
				<p>La pagina corrente utilizza i frame. Questa caratteristica non è
					supportata dal browser in uso.</p>
			</body>
		</noframes>
	</frameset>
	
<!--	
	<frameset border="0" rows="0,118,*" frameborder="0" frameSpacing="0">
		<frame border="0" name="LogoutFrame" scrolling="no" noresize target="LogoutFrame" src="LogoutFrame.aspx" marginwidth="0" marginheight="0" frameborder="0" framespacing="0">
		<frame border="0" name="Title" scrolling="no" noresize target="Contents" src="CustomTitle.aspx" marginwidth="0" marginheight="0" frameborder="0" framespacing="0">
		<frameset border="0" cols="230,*" frameborder="0">
			<frame border="0" name="Links" target="Contents" marginwidth="20" marginheight="0" scrolling="auto" noresize src="CustomLinks.aspx" style="BORDER-RIGHT: gainsboro thin solid">
			<frame border=0 name="<%=FRAME_CONTENT_PAGES%>" marginwidth="10" marginheight="0" scrolling="auto" src="frmAppStart.aspx" target="_self" >
		</frameset>
		<noframes>
			<body>
				<p>La pagina corrente utilizza i frame. Questa caratteristica non è
					supportata dal browser in uso.</p>
			</body>
		</noframes>
	</frameset>
-->	
</html>
