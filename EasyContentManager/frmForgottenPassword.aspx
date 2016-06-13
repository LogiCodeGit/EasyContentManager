<%
' Pagina di notifica della password dimenticata.
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	26/01/2004
'
' Parametri in entrata:
'	LOGIN_TABLE_NAME = "LoginTableName"					
'		Nome della tabella che contiene i dati di accesso
'	LOGIN_FIELD_NAME_USER = "LoginUserName"				
'		Nome del campo che contiene l'UserID
'	LOGIN_FIELD_NAME_PASSWORD = "LoginPassword"			
'		Nome del campo che contiene la Password
'	LOGIN_FIELD_NAME_EMAIL = "LoginEMail"			
'		Eventuale nome del campo che contiene l'e-mail
'
'	"USERID"													(opzionale)	
'		Eventuale nome dell'utente predefinito in entrata.	
'       Può essere specificata anche l'e-mail
'
' Azioni attivate da questa pagina (PAGE_NAME_FORGOTTEN_PASSWORD):
'		- ACTION_QUERY, nome della tabella di contesto LOGIN_TABLE_NAME
'			Richiesta di password, l'identificativo viene passato
'			nella variabile del form "USERID".
'		
' N.B.: Le azioni vengono usate per richiedere l'indirizzo 
'		di destinazione mediante la funzione configurabile
'		<GetDestLocation()> definita in <modSiteAction.asp>

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Forgotten Password"

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

' Controlla i parametri 
If _site.Glb.RequestField(LOGIN_TABLE_NAME) = "" Or _site.Glb.RequestField(LOGIN_FIELD_NAME_USER) = "" Then
	_site.Glb.RspErr("Operazione non valida")
End If

' Effettua la validazione dei dati
Dim bConfirmRequest = False, sAlreadyConnected = False
    Dim bLogged = False, objUserDS As OODBMSObjLib.clsDataSource
If _site.Glb.RequestField("QUERY") <> "" Then
	
	If _site.Glb.RequestField("UserID") = "" Then
		
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
			_site.Glb.RspErr("Nome non impostato")
		Else
			_site.Glb.RspErr("Missing name")
		End If
		
		' Identifica i dati dell'utente
	ElseIf _site.Lib.GetUserData(_site.Glb.RequestField("UserID"), _
	                    _site.Glb.RequestField(LOGIN_TABLE_NAME), _
	                    _site.Glb.RequestField(LOGIN_FIELD_NAME_USER), _
	                    _site.Glb.RequestField(LOGIN_FIELD_NAME_PASSWORD), _
	                    objUserDS, _
	                    _site.Glb.RequestField(LOGIN_FIELD_NAME_EMAIL)) Then 
		
		' Invia un'e-mail all'utente per notificare la password
		Dim sMsg = ""
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
			sMsg = "Notifica della password" & vbCrLf & vbCrLf & "Password: " & objUserDS.ColValueStr("Password") & vbCrLf & "Utente: " & objUserDS.ColValueStr("Nome") & vbCrLf & vbCrLf & _site.Glb.GetParam("APP_NAME") & " - " & _site.Glb.GetParam("COMPANY_NAME") & vbCrLf & "Supporto: " & _site.Glb.GetParam("ADMIN_SUPPORT_EMAIL")
		Else
			sMsg = "Password notify" & vbCrLf & vbCrLf & "Password: " & objUserDS.ColValueStr("Password") & vbCrLf & "User: " & objUserDS.ColValueStr("Nome") & vbCrLf & vbCrLf & _site.Glb.GetParam("APP_NAME") & " - " & _site.Glb.GetParam("COMPANY_NAME") & vbCrLf & "Support: " & _site.Glb.GetParam("ADMIN_SUPPORT_EMAIL")
		End If
		
		' Invia l'e-mail all'amministratore
		If _site.Glb.MailSend(objUserDS.ColValueStr("EMail"), _site.Glb.GetParam("APP_NAME") & " - Password", sMsg, _site.Glb.GetParam("ADMIN_SUPPORT_EMAIL"), _site.Glb.GetParam("APP_NAME") & " - " & _site.Glb.GetParam("COMPANY_NAME"), _site.Glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"),,_site.Glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"),_site.Glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then
			
			_site.Glb.RspMsg("")
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				_site.Glb.RspMsg("Inviato e-mail con le informazioni sulla password...")
			Else
				_site.Glb.RspMsg("Send e-mail with password information succeded...")
			End If
			_site.Glb.RspMsg("E-Mail: " & objUserDS.ColValueStr("EMail"))
			_site.Glb.RspMsg("")
			
			' Richiesta di invio password, attiva la pagina successiva
			If Not _site.WriteClientDestinationAction(Page, _site.Lib.GetCurrentPageName(Me), ACTION_QUERY, _site.Glb.RequestField(LOGIN_TABLE_NAME)) Then
				_site.Lib.EndApplication(True)
				
			Else
				_site.WriteFunctionKey_Exit(Page)
			End If
			
		End If
		
		' Termina la pagina
		Response.End()
		
	'Else
		
	'	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	'		_site.Glb.RspErr("Nome non valido")
	'	Else
	'		_site.Glb.RspErr("Invalid name")
	'	End If
		
	End If
	
End If

' Imposta il nome della tabella con i dati di accesso
Dim sTableName = UCase(_site.DatLink.Database.Tables.Item(_site.Glb.RequestField(LOGIN_TABLE_NAME)).PresentationName)
Dim sCaptionName = sTableName
%>

<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id="<%=_site.Lib.GetCurrentPageName(Me)%>" name=<%=_site.Lib.GetCurrentPageName(Me)%>>

<%
' Campi nascosti per i parametri gestiti dal Login
_site.Frm.WriteInheritHiddenField(LOGIN_TABLE_NAME)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_USER)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_EMAIL)

' Diciture in relazione alla lingua
Dim sAccess = "", sRequestCmd = "", sName = ""
Dim sNameTip = "", sMessage = "", sClick = ""
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sAccess = "INVIO PASSWORD"
	sRequestCmd = "RICHIEDI"
	sName = "NOME o E-Mail"
	sNameTip = "Inserisci il nome identificativo per l'accesso"
	sMessage = "La password viene inviata al proprio indirizzo e-mail"
	sClick = "clicca qui"
Else
	sAccess = "SEND PASSWORD"
	sRequestCmd = "REQUEST"
	sName = "NAME or E-Mail"
	sNameTip = "Insert identification name for access"
	sMessage = "Send password to owner e-mail address"
	sClick = "click here"
End If
%>

<table border="0" width="100%" height="100%" cellpadding=20>
  <tr>
    <td>&nbsp;</td>
    <td height="10%"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="25%">&nbsp;</td>
    <td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_COLOR_PANEL")%>" style="border: 1 dashed #C6C3C6">
      <table border="0" width="100%">
        <tr>
        <td colspan="2" style="border-style: solid; border-width: 1" bordercolor="blue">
          <p align="center"><b><font color=#006699 face="Comic Sans MS"><%=sAccess%>&nbsp;-&nbsp;<%=sCaptionName%></font></b></p>
        </td>
        </tr>
        <tr><td colspan="2">&nbsp;</td></tr>
<%
If bConfirmRequest Then
	%>
        <tr><td colspan="2" align=center><FONT SIZE=+1 COLOR=red><%=_site.Glb.RequestField("USERID")%>&nbsp;<%=sAlreadyConnected%></FONT></td></tr>
        <tr><td colspan="2">&nbsp;</td></tr>
<%	
Else
	%>
        <tr>
          <td>
            <p align="right"><b><font face="Comic Sans MS" color=Navy><%=sName%></font>
                <font color="#CCCCFF">:</font></b></p>
          </td>
          <td>
              <p align="center"><input type="text" name="USERID" title="<%=sNameTip%>" value="<%=_site.Glb.RequestField("USERID")%>" size="25" onfocus="javascript:SetStatus(this)" style="background-color: #FFFFE7"></p>
          </td>
        </tr>
<%	
End If
%>        
        <tr>
          <td>
            <p align="right">
          </td>
          <td>
            <p align="center">
            <input type="submit" value=" <%=sRequestCmd%> " <%=_site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE")%>  name="QUERY">&nbsp;&nbsp;&nbsp;
            <%
' Se è presente un menù imposta il tasto di ritorno
If Session("g_strContentMenuURL") <> "" Then
	_site.WriteFunctionKey_Exit(Page)
Else
	_site.Frm.WriteFunctionKey_AppExit(False)
End If
%>
            </p>
          </td>
        </tr>
        <tr>
          <td colspan="2">&nbsp;
          </td>
        </tr>
        <tr>
          <td colspan="2" bordercolor="#FFFFFF" style="border-style: solid; border-width: 1" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF">
	          <p align="center"><%=sMessage%></p>
          </td>
        </tr>
      </table>
    </td>
    <td width="25%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td height="40%">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<script language="javascript">
function SetStatus(objControl)
{
	status = " < " + objControl.title + " >";
}
function StartForm()
{
	document.forms.item(0).USERID.focus();
}
</script>
</form>

</BODY>
</HTML>

