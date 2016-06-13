<%
    ' Pagina iniziale di supporto per ottenere lo script lato client processato dal server
    ' e supportare le funzioni delle versioni precedenti (asp like)
    ' Usare l'istruzione:
    '   Server.Execute("~/srcClientScriptForm.aspx")
    ' Per inserire il contenuto all'interno di un'altra pagina 

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->
