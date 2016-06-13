<%
' Pagina di accesso utente.
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	05/04/2003
'
' Parametri in entrata:
'	LOGIN_TABLE_NAME = "LoginTableName"					
'		Nome della tabella che contiene i dati di accesso
'	LOGIN_FIELD_NAME_USER = "LoginUserName"				
'		Nome del campo che contiene l'UserID
'	LOGIN_FIELD_NAME_PASSWORD = "LoginPassword"			
'		Nome del campo che contiene la Password
'	LOGIN_FIELD_NAME_EMAIL = "LoginEMail"			
'	LOGIN_FIELD_NAME_PIVA = "LoginPIva"			
'	LOGIN_FIELD_NAME_CFISC = "LoginCFisc"			
'		Eventuali nomi dei campi opzionali per tentativi di
'       identificazione profilo tramite e-mail, partita iva
'       o codice fiscale
'	LOGIN_FIELD_NAME_ACCESS_LEVEL = "LoginAccessLevel"			(opzionale)
'		Nome del campo che contiene il livello di accesso
'		Se non specificato usa sempre il livello di 
'		acceso Guest.
'	LOGIN_FIELD_NAME_INHERIT_SESSION = "InheritSession"			(opzionale)
'		Impostare ("Yes") per mantenere gli oggetti e i dati di sessione
'		eventualmente impostati dall'utente precedente.
'		Se non specificato tutti gli oggetti globali relativi 
'		all'utente precedente vengono annullati.
'	FORM_SYS_FIELD_RETURN_APP_URL = "ooSYS_ReturnAppURL"	(opzionale)
'		Eventuale URL della pagina da richiamare all'uscita
'		dal form.
'
'  Il tentativo di accesso può essere effettuato mediante i seguenti
'  elementi che vengono verificati per proporre il primo trovato
'  nel DB:
'	"USERID"													(opzionale)	
'		Eventuale nome di accesso dell'utente predefinito in entrata.	
'	"EMAIL"													    (opzionale)	
'		Eventuale indirizzo e-mail dell'utente predefinito in entrata.	
'
' Azioni attivate da questa pagina (PAGE_NAME_LOGIN):
'		- ACTION_LOGIN, nome della tabella di contesto LOGIN_TABLE_NAME
'			Login effetuato, l'identificativo viene memorizzato
'			nella variabile globale di sessione	<g_strUserID>
'			e il DataSource contente tutti i dati dell'utente
'			nell'oggetto globale <g_objDSLoggedUser>
'		- ACTION_ADD_NEW, nome della tabella di contesto LOGIN_TABLE_NAME
'			Nuovo utente inserito.
'		
' N.B.: Le azioni vengono usate per richiedere l'indirizzo 
'		di destinazione mediante la funzione configurabile
'		<GetDestLocation()> definita in <modSiteAction.asp>

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Access"

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<%
' < Inclusione dell'intestazione >
%>
<!-- #INCLUDE FILE="CustomHeader.aspx" -->

<HTML>
<HEAD>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">

<TITLE><%=PAGE_DESCRIPTION%> - <%=_site.Glb.GetParam("APP_NAME")%></TITLE>
</HEAD>
<BODY>
<%

' Inizializzazione degli oggetti globali
If Not _site.InitApplicationObjects(Me,True,True) Then
	' Termina l'applicazione
	_site.Lib.EndApplication(True)
End If

' Controlla i parametri 
If _site.Glb.RequestField(LOGIN_TABLE_NAME) = "" _
        Or _site.Glb.RequestField(LOGIN_FIELD_NAME_USER) = "" _
        Or _site.Glb.RequestField(LOGIN_FIELD_NAME_PASSWORD) = "" Then
	_site.Glb.RspErr("Operazione non valida")
End If

' Effettua la validazione dei dati
Dim bLogged = False
Dim bConfirmLogin = False
If _site.Glb.RequestField("LOGIN") <> "" Then
	
        Dim objUserDS As OODBMSObjLib.clsDataSource
	If RTrim(_site.Glb.RequestField("UserID")) = "" Then
		If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
			_site.Glb.RspErr("Devi specificare il nome...")
		Else
			_site.Glb.RspErr("The name is required...")
		End If
	ElseIf _site.Lib.ValidateUserLogin(_site.Glb.RequestField("UserID"), _site.Glb.RequestField("Password"), _
	                        _site.Glb.RequestField(LOGIN_TABLE_NAME), _site.Glb.RequestField(LOGIN_FIELD_NAME_USER), _
	                        _site.Glb.RequestField(LOGIN_FIELD_NAME_PASSWORD), objUserDS, _
	                        _site.Glb.RequestField(LOGIN_FIELD_NAME_EMAIL), _
	                        _site.Glb.RequestField(LOGIN_FIELD_NAME_PIVA), _
	                        _site.Glb.RequestField(LOGIN_FIELD_NAME_CFISC)) Then
		
		' Identifica l'identificativo dell'utente
            Dim sUserID As String = _site.Lib.ComposeUserID(objUserDS.ColValue(_site.Glb.RequestField(LOGIN_FIELD_NAME_USER)), objUserDS.Table.ObjectName)
		
		' Se l'utente risulta già validato chiede conferma
		' di entrata
		If _site.Lib.UserLogged(sUserID) Then
			
			' Se già confermato effettua la sconnessione
			If _site.Glb.RequestField("CONFIRM_LOGIN") <> "" Then
				
				' Sconnette la precedente sessione
				' per riconnettere la nuova
				If Not _site.Lib.UserLogout(sUserID, False) Then
					' Errore di logout
				End If
				
			Else
				
				' Imposta flag per la conferma
				bConfirmLogin = True
				
			End If
			
		End If
		
		If Not bConfirmLogin Then
			
			' Identifica se mantenere gli oggetti di sessione
			' eventualmente impostati dall'utente precedente
			Dim bInheritSession = False
			If _site.Glb.RequestField(LOGIN_FIELD_NAME_INHERIT_SESSION) <> "" Then
				bInheritSession = True
			End If
			
			' Imposta i dati dell'utente validato
			Dim bValidated As Boolean
			If _site.Glb.RequestField(LOGIN_FIELD_NAME_ACCESS_LEVEL) = "" Then
				' Validazione con livello Guest
				bValidated = _site.Lib.UserLogin(sUserID, OODBMS_UserAccessLevel.odulUserGuest, objUserDS, bInheritSession)
			Else
				' Validazione con livello di accesso
				bValidated = _site.Lib.UserLogin(sUserID, objUserDS.ColValue(_site.Glb.RequestField(LOGIN_FIELD_NAME_ACCESS_LEVEL)), objUserDS, bInheritSession)
			End If
			'
			If bValidated Then
				
				' Aggiorna il frame dei links
				Response.Write("<script language=""javascript"">ReloadFrame(""Links"");</script>")
				
				' Dati autenticati, attiva la pagina successiva
				If Not _site.WriteClientDestinationAction(Page, _site.Lib.GetCurrentPageName(Me), ACTION_LOGIN, _site.Glb.RequestField(LOGIN_TABLE_NAME)) Then
					_site.Lib.EndApplication(True)
				End If
				
			End If
			
			' Termina la pagina
			_site.Frm.Break_PageConstruction()
			
		End If
		
	End If

ElseIf _site.Glb.RequestField("CHANGE_COMPANY") <> "" Then

        ' Imposta l'azienda selezionata
        _site.Lib.SetSessionCompanyParameters(_site.Glb.RequestField("CHANGE_COMPANY"))
        If Not _site.InitApplicationObjects(Me,True,False) Then
	        Response.Write( "Impossibile continuare.")
	        Response.End	
        End If
	
End If

' Imposta il nome della tabella con i dati di accesso
Dim sTableName = UCase(_site.DatLink.Database.Tables.Item(_site.Glb.RequestField(LOGIN_TABLE_NAME)).PresentationName)
Dim sCompanyName = UCase(_site.Glb.GetParam("COMPANY_NAME"))
Dim sCaptionName = "", sCaptionCompany = "", nCo As Integer
For nCo = 1 To Len(sTableName)
	sCaptionName = sCaptionName & Mid(sTableName, nCo, 1) & " "
Next 
For nCo = 1 To Len(sCompanyName)
	sCaptionCompany = sCaptionCompany & Mid(sCompanyName, nCo, 1) & " "
Next 
%>

<form method="POST" ACTION="<%=Request.ServerVariables.Item("URL")%>" id="<%=_site.Lib.GetCurrentPageName(Me)%>" name=<%=_site.Lib.GetCurrentPageName(Me)%>>

<%
' Campi nascosti per i parametri gestiti dal Login
_site.Frm.WriteInheritHiddenField(LOGIN_TABLE_NAME)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_USER)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_PASSWORD)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_EMAIL)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_PIVA)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_CFISC)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_ACCESS_LEVEL)
_site.Frm.WriteInheritHiddenField(LOGIN_FIELD_NAME_INHERIT_SESSION)
_site.Frm.WriteInheritHiddenField(FORM_SYS_FIELD_RETURN_APP_URL)

If bConfirmLogin Then
	' Imposta i parametri nascosti con i dati
	' da confermare
	_site.Frm.WriteInheritHiddenField("USERID")
	_site.Frm.WriteInheritHiddenField("PASSWORD")
	_site.Frm.WriteHiddenField("CONFIRM_LOGIN", "True")
End If

' Diciture in relazione alla lingua
Dim sAccess = "", sAccessCmd = "", sNameCaption = ""
Dim sNameTip = "", sPasswordTip = "", sRegister = ""
Dim sClick = "", sAlreadyConnected = "", sRemember = ""
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sAccess = "A C C E S S O"
	sAccessCmd = "ACCEDI"
	sNameCaption = "NOME o E-Mail"
	sNameTip = "Inserisci il nome identificativo per l'accesso"
	sPasswordTip = "Inserisci la password"
	sRegister = "- se non sei ancora registrato"
	sRemember = "- se non ricordi la password"
	sClick = "clicca qui"
	sAlreadyConnected = "risulta già connesso, confermare l'accesso se la sessione precedente non è terminata correttamente oppure se non è più valida."
Else
	sAccess = "A C C E S S"
	sAccessCmd = "ACCESS"
	sNameCaption = "NAME or E-Mail"
	sNameTip = "Insert identification name for access"
	sPasswordTip = "Insert the password"
	sRegister = "- for new subscription"
	sRemember = "- for remember password"
	sClick = "click here"
	sAlreadyConnected = "already result connected, confirm the access if the preceding session has not finished correctly or if it is not more valid."
End If

%>

<table border="0" width="100%" height="100%" cellpadding=20>
  <tr>
    <td>&nbsp;</td>
    <td height="10%"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="30%">&nbsp;</td>
    <td bgcolor="<%=_site.Glb.GetParam("HTML_FIXED_COLOR_PANEL")%>" style="border: 1 dashed #C6C3C6">
      <table border="0" width="100%" id=LoginPanel>
        <tr>
        <td colspan="2" style="border-style: solid; border-width: 1" bordercolor="blue">
          <p align="center"><b><font color=#006699><%=sAccess%>&nbsp;&nbsp;<%=sCaptionName%>
                    <br/><%=sCaptionCompany%></font></b></p>
        </td>
        </tr>
        <tr><td colspan="2">&nbsp;</td></tr>
<%
If bConfirmLogin Then
	%>
        <tr><td colspan="2" align=center><FONT SIZE=+1 COLOR=red><%=_site.Glb.RequestField("USERID")%>&nbsp;<%=sAlreadyConnected%></FONT></td></tr>
        <tr><td colspan="2">&nbsp;</td></tr>
<%	
Else
	%>
        <tr>
          <td>
            <p align="right"><font color=Navy><%=sNameCaption%>:</font></p>
          </td>
          <td>
              <p align="center"><input type="text" name="USERID" title="<%=sNameTip%>" value="<%=_site.Glb.RequestField("USERID")%>" size="25" onfocus="javascript:SetStatus(this)" style="background-color: #FFFFE7"></p>
          </td>
        </tr>
        <tr>
          <td>
            <p align="right" style="color: navy">PASSWORD:</p>
          </td>
          <td>
            <p align="center"><input type="password" name="PASSWORD" title="<%=sPasswordTip%>" size="25" onfocus="javascript:SetStatus(this)" style="background-color: #FFFFE7"></p>
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
            <input type="submit" value=" <%=sAccessCmd%> " <%=_site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE")%> name="LOGIN">&nbsp;&nbsp;&nbsp;
            <%
' Se è presente un menù imposta il tasto di ritorno
If _site.ValidFunctionKey_Exit(Page)  Then
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
<%

    If Not bConfirmLogin AndAlso Not _site.Glb.GetBoolean(_site.Glb.GetParam("LOGIN_DISABLE_REG_AND_RECOVERY")) Then
	%>
        <tr>
          <td colspan="2" bordercolor="#FFFFFF" style="border-style: solid; border-width: 1" bordercolorlight="#FFFFFF" bordercolordark="#FFFFFF">
          <p align="center">
          <font color=red><%=sRegister%> <a href="<%=Server.HtmlEncode(_site.GetDestLocation(Page, _site.Lib.GetCurrentPageName(Me), ACTION_ADD_NEW, _site.Glb.RequestField(LOGIN_TABLE_NAME),sFrame))%>" target="<%iif(sFrame<>"",sFrame,"_self")%>"><%=sClick%></a>
          <br /><font color=red><%=sRemember%> <a href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_FORGOTTEN_PASSWORD"))%>?<%=LOGIN_TABLE_NAME%>=<%=_site.Glb.RequestField(LOGIN_TABLE_NAME)%>&<%=LOGIN_FIELD_NAME_USER%>=<%=_site.Glb.RequestField(LOGIN_FIELD_NAME_USER)%>&<%=LOGIN_FIELD_NAME_EMAIL%>=EMail" target="<%iif(sFrame<>"",sFrame,"_self")%>"><%=sClick%></a>
          </p>
          </font>
          </td>
        </tr>
<%	
End If
%>        
      </table>
    </td>
    <td width="30%">
    &nbsp;
      </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td height="40%">
<%
    Dim sCompanyList As String = RTrim(Replace(_site.Glb.GetParam("COMPANY_LIST"),"|" & _site.Glb.GetParam("COMPANY_NAME"),"",,,CompareMethod.Text))
    Dim arrCmp() As String = Split(sCompanyList,"|")
    If (sCompanyList<>"" OrElse Not _site.Lib.IsSessionDefaultCompany()) _
                 AndAlso Not GetStrFlag(_site.Glb.GetParam("DISABLE_COMPANY_CHANGE")) THEN

 %>
    <center style="color: navy">CAMBIO AZIENDA:</center>
    <ul>
<%
        Dim sCmpName As String
        For Each c As String In arrCmp
            If RTrim(c) = "" Then
                sCmpName = _site.Lib.GetDefaultCompanyName()
            Else
                sCmpName = c
            End If
            If UCase(sCmpName) <> UCase(_site.Glb.GetParam("COMPANY_NAME")) Then
                'Response.Write("<input type=""submit"" value="""  & sCmpName & """ " & _site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE") & " name=""COMPANY_NAME""><br>")
                Response.Write("<input type=""submit"" value="""  & sCmpName & """ " & _site.Glb.GetParam("HTML_FIXED_OTHER_BUTTON_STYLE") & " name=""CHANGE_COMPANY""><br>")
            End If
        Next
%>
    </ul>
<%
    Else
        Response.Write("&nbsp;")
    End If
%>
    </td>
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
	// N.B.: il primo control disponibile per l'INPUT viene
	//		 attivato automaticamente dal modulo srcClientScriptForm...
	//document.forms.item(0).USERID.focus();
}

<%
If _site.Glb.RequestField("CHANGE_COMPANY") <> "" Then
%>
    // Aggiorna i frames per eventuale cambio azienda
    //ReloadFrame("Title");
    ReloadFrame("Links");
    //ReloadFrame("RightLinks");
<%
End If
%>
</script>

</form>

<%
'Response.Write("<!--" & Session("g_strReturnAppURL") & "-->")
%>

</BODY>
</HTML>

