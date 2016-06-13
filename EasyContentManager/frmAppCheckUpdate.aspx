<%

' Pagina di controllo e aggioramento struttura dati dell'applicazione.
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	10/05/2003
'

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Application Update"

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

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
<META NAME="GENERATOR" Content="LogiCode Easy Content Manager">
<TITLE><%=PAGE_DESCRIPTION%> - <%=_site.Glb.GetParam("APP_NAME")%></TITLE>
</HEAD>
<BODY>

<%
' < Inclusione dell'intestazione >
%>
<!-- #INCLUDE FILE="CustomHeader.aspx" -->

<%
    ' Inizializzazione degli oggetti globali
    'If Not _site.Lib.InitializeGlobalObjects(Me) Then
    '	' Termina l'applicazione
    '	_site.Lib.EndApplication(True)
    'End If
    ' Inizializza il modulo globale
    _site.Lib.InitializeDirectories(_site.Glb.GetParam("APP_NAME")) ' Inizializza gli indirizzari
    _site.Glb.InitializeGlobal(Me)
    _site.Glb.bUseTextOnlyErrors = False                          ' Imposta eventuali errori in modalità HTML

    ' Controllo / aggiornamento struttura
    Dim objBusinessAspDBLib As New EasyContentManagerDB.DBAsp
    If Not _site.Lib.CheckUpdateStruct(True, objBusinessAspDBLib) Then
        ' Termina l'applicazione
        _site.Lib.EndApplication(True)
    Else
        ' Applicazione aggiornata.
        _site.Glb.RspMsg("")
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            _site.Glb.RspMsg("Verifiche e aggiornamenti completati.")
        Else
            _site.Glb.RspMsg("Verifications and adjournments completed.")
        End If
        _site.Glb.RspMsg("")
    End If
    '
    If _site.Lib.InitializeGlobalObjects(Me) Then
        _site.WriteFunctionKey_FormExit(Page)
    End If
%>
</BODY>
</HTML>

