<%
    ' Pagina iniziale

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<html>
<HEAD>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
</HEAD>
<!--<body background="images/page_head_bg.gif" style='background-image: images/page_head_bg.gif; background-repeat: repeat-x; background-attachment: fixed'>-->
<body>
<b><i>Loading...</i></b>
<img src="/images/ajax-loader.gif" alt="Caricamento in corso..." />
<%
    ' Cerca la prima mappa (primaria) da visualizzare
    If Not _site.InitApplicationObjects(Me, True, False) Then
        Response.Write("Applicazione terminata o sessione scaduta.")
        Response.End()
    End If

    ' Identifica il link di destinazione
    Dim sDestLnk As String = ""

    ' Accede alle Mappe (solo quelle primarie)
    'Dim objMappe As OODBMSObjLib.clsDataSource = Nothing
    'If Not _site.Lib.GetDataSource(objMappe, "Mappe", , "Primaria", "Nome") Then
    '    Response.End()
    'End If
    'If Not objMappe.DataEmpty() Then

    '    ' Visualizza la prima mappa primaria identificata
    '    sDestLnk = "/Pages/ViewMapElement.aspx?OID=" & objMappe.RowOID 

    'Else
    '    ' Accede alla ricerca delle mappe
    '    sDestLnk = "/Pages/ViewMaps.aspx"
    ''Else
    ''_site.Glb.RspMsg("Nessuna Mappa identificata...")
    'End If

    ' PER ACCEDERE A QUALUNQUE FUNZIONE E' NECESSARIO PRIMA LOGGARSI
    If Session("g_objDSLoggedUser") Is Nothing Then
        
        ' In caso di successo va alla pagina di ingresso
        Session("g_strSuccessURL") = sDestLnk      
        'Session("g_strSuccessURL") = "/CustomHelloDefault.aspx"
        
        ' Imposta il contesto per l'area riservata
        _site.Lib.SetWorkSpace(_site.Glb.GetParam("CONTEXT_NAME_RESERVED_AREA"))

        ' Attiva il login
        sDestLnk = _site.GetInitialDestLocation(_site.Glb.GetParam("CONTEXT_NAME_RESERVED_AREA"))

        ' Imposta il menù Operatori come default
        _site.Lib.SetContentMenuURL(sDestLnk)

    End If
    
%>
    <script type="text/javascript" language="javascript">
    <!--
        window.location = "<%=sDestLnk%>";
    -->
    </script>

</body>
</html>
