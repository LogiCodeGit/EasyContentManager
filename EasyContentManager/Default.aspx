<%
' Pagina di avvio dell'applicazione.
' Verifica anche la ripartenza dal frame principale..

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Attiva la possibilità di visualizzare i messaggi
' in progressione per elaborazioni in fasi successive
' che impiegano un po di tempo
Response.Buffer = True

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->
<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->
<%  
    ' Inizializza la sessione per segnalare che 
    ' la gestione dei Frames è stata avviata
    Session("ooSYS_FramesStarted") = "TRUE"
    
    ' Rimanda alla pagina inziale personalizzata
    'Response.Redirect("CustomMain.aspx")
%>
<html>
	<head>
        <meta http-equiv="Refresh" content="5; url=CustomMain.aspx" />
	</head>
<body>
<script type="text/javascript" language="javascript">
<!--
    // Effettua la ripartenza dal frame principale
    try {
        GetTopFrame(false).location = "CustomMain.aspx";
    }
	catch(e) {
	}
-->
</script>
</body>
</html>