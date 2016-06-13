<%
' Pagina di notifica della registrazione completata.
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	13/04/2010
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Registration Completed"

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">

<TITLE><%=PAGE_DESCRIPTION%> - <%=_site.Glb.GetParam("APP_NAME")%></TITLE>
</HEAD>
<BODY>

<%
' < Inclusione dell'intestazione >
%>
<!-- #INCLUDE FILE="CustomHeader.aspx" -->

<%

' Inizializzazione degli oggetti globali
    If Not _site.Lib.InitializeGlobalObjects(Me) Then
        ' Termina l'applicazione
        _site.Lib.EndApplication(True)
    End If

%>

<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id="<%=_site.Lib.GetCurrentPageName(Me)%>" name=<%=_site.Lib.GetCurrentPageName(Me)%>>
<%

' Registrazione completata 
    _site.Glb.RspMsg("")
    If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
        _site.Glb.RspMsg("Registrazione completata.")
    Else
        _site.Glb.RspMsg("Registration completed.")
    End If
    _site.Glb.RspMsg("")

' Imposta il tasto di uscita
    _site.Frm.WriteFunctionKey_AppExit(True)

' Imposta il menù del cliente come default (menù)
    _site.Frm.WriteFunctionKey_Menu()

%>
</form>

</BODY>
</HTML>

