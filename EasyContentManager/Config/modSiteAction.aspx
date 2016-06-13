<!-- Codice predefinito da includere in ogni pagina -->
<!--
<@ Assembly Src="~/Config/modSiteFunctions.vb"%>
<@ Assembly Src="~/Config/modModBusManager.vb"%>
-->
<%@ Import Namespace="EasyContentManager" %>
<%@ Import namespace="OODBMSObjLib" %>
<%@ Import namespace="OODBMSObjLib.clsOODBMS" %>
<%@ Import namespace="OOWebLib" %>
<!-- ' Aggiunge il supporto ad Ajax Control Toolkit per le pagine che lo uilizzano
     ' E' necessario il riferimento nel progetto per la libreria (bin) 
     '      AjaxControlToolkit.dll      (ver. 3.5 oppure 4)
-->
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>
<% 
    ' N.B.: E' possibile verificare se è attivo il support ad Ajax Control Toolkit
    '       nel codice della pagina mediante la seguente variabile
    Dim _bAjaxEnabled As Boolean = True

    ' Inizializzazione degli oggetti globali
    Dim _site As EasyContentManager.clsSiteFunctions = modSiteFunctions.Site(Page)
    'Dim _cust = modSiteFunctions.Cust(_site)
    'Dim _bus = modSiteFunctions.Bus(_site)

%>
