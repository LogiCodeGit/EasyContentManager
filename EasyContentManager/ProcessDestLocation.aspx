<%
    ' Pagina di supporto per eseguire le operazioni di destinazione richieste,
    ' richiama la funzione che processa la destinazione:
    '       destination URL = GetDestLocation("ProcessDestLocation", DATA_PATH or APP_CONTEXT, ACTION, ...)
    '
    ' Parametri da specificare in entrata (Request):
    '   FORM_SYS_FIELD_DATA_PATH oppure FORM_SYS_FIELD_APP_CONTEXT_NAME
    '   FORM_SYS_FIELD_REQUEST_ACTION
    '	Questi ed eventuali ulteriori parametri vengono utilizzati dalla funzione
    '       GetDestLocation() di modSiteFunctions.vb
    '
    ' Copyright:		LogiCode Srl
    ' Autore:			Daniele Magliacani
    ' Data creazione:	19/05/2016

    ' Costanti di definizione della pagina
    Const PAGE_DESCRIPTION As String = "Process Dest. Location"

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
If Not _site.Lib.InitializeGlobalObjects(Me) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Definizione del tasto di uscita dalla sessione
Dim sTitle = "", sCaption = ""
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sTitle = "Fine della sessione utente"
	sCaption = "Fine sessione"
Else
	sTitle = "End of the user session"
	sCaption = "End Session"
End If
    'Dim sEndSessionKey = "<input " & _site.Glb.GetParam("HTML_FIXED_EXIT_BUTTON_STYLE") & " type=button value=""<    " & sCaption & " "" onclick='javascript:window.location=""" & _site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_LOGOUT")) & """;' title=""" & sTitle & """>"
    
    ' Controlli 
    ' - Devono essere stati inizializzati i dati dell'operatore/utente
    Dim bError = False
    Dim objDSUser As OODBMSObjLib.clsDataSource = Session("g_objDSLoggedUser")
    If objDSUser Is Nothing Then
        _site.Glb.RspErr("L'operatore non risulta validato")
        bError = True
    ElseIf objDSUser.RowInvalid Then
        _site.Glb.RspErr("I dati dell'operatore non sono più disponibili")
        bError = True
    End If

    ' In Caso di errore termina la pagina
    If bError Then Response.End()
%>

<table id="Menu_Operatore"  width=80%>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td width="2%"></td><td colspan="3" title="Menù <%=objDSUser.Table.PresentationName%>" style="border: 1 dashed #C6C3C6">
<font face="Arial" size=+2 color=silver><i><b>&nbsp;Menù <%=objDSUser.Table.PresentationName%><font face="Arial" size=+1 color=lightgrey> -  <%=objDSUser.ColValueStr("Nome")%></font></i></b></font></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td colspan="2"></td></tr>
<tr><td width="2%"></td><td width="3%" style="border-right-style: solid; border-right-width: 1">&nbsp;</td><td width="1%"></td>
<td>

<font face="Arial" size=+1>

<table width=100%>
<tr <%=_site.Glb.GetParam("HTML_FIXED_MAIN_FUNCTION_TR_TAGS")%>><td align=right>
<%
    If _site.ValidFunctionKey_Exit(Me) Then
        _site.WriteFunctionKey_Exit(Me)
    End If
%>
    <br>
</td></tr>
</table>
<br>
<%
    ' Esegue la richiesta per la destinazione
    Dim frm As String = ""
    Dim sLocation As String = _site.GetDestLocation(Me, _
                                 "ProcessDestLocation", _
                                 _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION), _
                                 If(_site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH) <> "", _
                                            _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH), _
                                            _site.Glb.RequestField(FORM_SYS_FIELD_APP_CONTEXT_NAME)), _
                                frm)
    'If sLocation <> "" Then
    '    ' Imposta la destinazione
    '    _site.WriteClientDestinationURL(Me, sLocation)
    'End If
    
 %>

</font>

</td></tr>
</table>

</BODY>
</HTML>

