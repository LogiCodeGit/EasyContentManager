<% 
' Pagina di visualizzazione dei Links.
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
'
' Parametri da specificare in entrata (Request):
'
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'
' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Links"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

' Evita di memorizzare questa pagina nella
' cache del browser
Response.Expires = -1

' Identifica il nome del form
Dim sFormName = "Links"

' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<%
' < Inclusione delle funzioni Form Java lato client >
%>
<!-- #INCLUDE FILE="srcClientScriptForm.js" -->

<html><head>
<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
<title>Links Page</title>
<base target="Contents">
</head>
<!--<body background="<%=_site.Glb.GetParam("HTML_LEFT_BACKGROUND_IMG")%>" style='background-color: #FCFCFD; background-image: <%=_site.Glb.GetParam("HTML_LEFT_BACKGROUND_IMG")%>; background-repeat: repeat-x; background-attachment: fixed;'>-->
<!--<body bgcolor="#EFF7E7">-->
<!--<body background="images/backgroundLine.gif" style='background-image: images/backgroundLine.gif; background-repeat: repeat; background-attachment: fixed; border-right-style: solid; border-right-width: 1px; border-right-color: #C0C0C0;'>-->
<body background="images/backgroundLine.gif" style='background-image: /images/backgroundLine.gif; background-repeat: repeat; background-attachment: fixed;'>
<center>
<img src="<%=_site.Glb.GetParam("APP_LOGO_IMG")%>"/>
</center>
<br />
<!-- GENERA LE FUNZIONI DI MENU' PER IL LATO SINISTRO DEL SITO -->
<%
If Session("DISABLE_MENU") = "" Then

	' Eventuale inizializzazione dell'applicazione 
	If Not _site.InitApplicationObjects(Me,True,False) Then
		Response.Write( "Applicazione terminata o sessione scaduta.")
		Response.End	
	End If
	'	
	Session("PAGE_FRAME_INFO_FILTER") = "Links"
%>
	<table cellSpacing="0" cellPadding="0" border="0" width="100%">
            <tr>
              <td vAlign="top" width="99%">

                  <table cellSpacing="0" cellPadding="0" width="100%" border="0">
                    
                      <tr>
                        <td bgColor="#999999">
                          <table cellSpacing="1" cellPadding="0" width="100%" border="0">
                            
                              <tr>
                                <td>
                                  <table cellSpacing="0" cellPadding="0" width="100%" border="0">
                                    
                                      <tr>
                                        <td width="13" bgColor="#999999" style="background-image: url('images/cell_head_bg.gif'); background-repeat: repeat-x">
                                        <img border="0" src="images/SignalTitled.gif" width="11" height="15">
                                        </td>
<%
Dim sCaption = "", sTitle = ""
Dim sName = "", sCaption1 = ""
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	'sCaption = "Benvenuto su " & UCase(_site.Glb.GetParam("COMPANY_NAME"))
	sCaption = UCase(_site.Glb.GetParam("APP_NAME"))  '"MENU' & STRUMENTI"
Else
	'sCaption = "Welcome in " & UCase(_site.Glb.GetParam("COMPANY_NAME"))
	sCaption = UCase(_site.Glb.GetParam("APP_NAME"))  '"MENU' & TOOLS"
End If
%>                                        <td bgColor="#999999" style="background-image: url('images/cell_head_bg.gif'); background-repeat: repeat-x">
                                            <font face="VERDANA, ARIAL" color="#808080" size="1"><b><%=sCaption%></b></font><br>
                                        </td>
                                      </tr>
                                    
                                  </table>
                                </td>
                              </tr>
                              <tr>
                                <td bgColor="#f0f0f0">
                                  <table>
                                    
                                      <tr>
                                        <td width="110" height="5" align="left">
                                          </td>
                                        </tr>
                                        <tr>
                                          <td>
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "HOME"
	sTitle = "Ritorna alla pagina principale"
Else
	sCaption = "HOME"
	sTitle = "Return to Main Page"
End If
%>          
											<img border="0" src="images/SignalFilled.gif" width="6" height="9">&nbsp;
											<a href="frmAppStart.aspx" 
													title="<%=sTitle%>" target="Contents">
												<font face="Verdana, Arial" size=1><%=sCaption%></Font></a>
                                          </td>
                                        </tr>

    <!--  EVENTUALE SEZIONE PER I DATI IDENTIFICATIVI E PAGINA 'CHI SIAMO' -->

<%
Dim objNews As OODBMSObjLib.clsDataSource = Nothing, bEnableNews As Boolean = False
If bEnableNews AndAlso _site.Lib.GetDataSource(objNews, "NotizieWeb", , "", "") Then
	If Not objNews.EOF Then
%>
                                        <tr>
                                          <td>
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "NOTIZIE"
	sTitle = "Accedi alle ultime notizie"
Else
	sCaption = "NEWS"
	sTitle = "Access to latest news"
End If
%>          
											<img border="0" src="images/SignalFilled.gif" width="6" height="9">&nbsp;
											<a href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_PREVIEW_FRAME_NEWS"))%>?<%=FORM_SYS_FIELD_APP_CONTEXT_NAME%>=<%=_site.Glb.GetParam("PAGE_NAME_PREVIEW_FRAME_NEWS")%>&<%=FORM_SYS_FIELD_RETURN_APP_URL%>=<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))%>" 
													title="<%=sTitle%>" target="Contents">
												<font face="Verdana, Arial" size=1><%=sCaption%></Font></a>
                                          </td>
                                        </tr>
<%
    End If
End If
%>

<%
Dim objReqWeb As OODBMSObjLib.clsDataSource = Nothing, bEnableReqWeb As Boolean = False
If bEnableReqWeb AndAlso _site.Lib.GetDataSource(objReqWeb, "Richieste", , "", "") Then
	If Not objReqWeb.EOF Then
%>
                                        <tr>
                                          <td>
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "FAQ & SOLUZIONI"
	sTitle = "FAQ / Richeste & Soluzioni"
Else
	sCaption = "FAQ & SOLUTIONS"
	sTitle = "FAQ / Request & Solutions"
End If 
%>          
											<img border="0" src="images/SignalFilled.gif" width="6" height="9">&nbsp;
											<a href="<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_PREVIEW_FRAME_FAQ"))%>?<%=FORM_SYS_FIELD_APP_CONTEXT_NAME%>=<%=_site.Glb.GetParam("PAGE_NAME_PREVIEW_FRAME_ALBUM")%>&<%=FORM_SYS_FIELD_RETURN_APP_URL%>=<%_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))%>" 
													title="<%=sTitle%>" target="Contents">
												<font face="Verdana, Arial" size=1><%=sCaption%></Font></a>
                                          </td>
                                        </tr>
<%
    End If
End If
%>
                                        <tr>
                                          <td>
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "SUPPORTO"
	sTitle = "Invia una e-mail per contatti"
Else
	sCaption = "SUPPORT"
	sTitle = "Send e-mail for contact us"
End If
%>          
											<img border="0" src="images/SignalFilled.gif" width="6" height="9">&nbsp;
											<a href="mailto:<%=_site.Glb.GetParam("ADMIN_SUPPORT_EMAIL")%>" 
													title="<%=sTitle%>" target="Contents">
												<font face="Verdana, Arial" size=1><%=sCaption%></Font></a>
                                          </td>
                                        </tr>

<%
Dim bEnableRequest As Boolean = False
If bEnableRequest Then
%>

                                        <tr>

                                          <td>
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "RICHIESTE"
	sTitle = "Invia una richiesta di informazioni"
Else
	sCaption = "REQUEST"
	sTitle = "Send request for informations"
End If
%>          
											<img border="0" src="images/SignalFilled.gif" width="6" height="9">&nbsp;

											<a href="frmAppStart.aspx?<%=FORM_SYS_FIELD_APP_CONTEXT_NAME%>=RequestAndInfo&<%=FORM_SYS_FIELD_RETURN_APP_URL%>=<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))%>"
													title="<%=sTitle%>" target="Contents">
												<font face="Verdana, Arial" size=1><%=sCaption%></Font></a>
                                          </td>
                                        </tr>
<%
End If
%>
                                        <tr>
                                          <td>
<%
If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
	sCaption = "Accesso Operatori"
	sTitle = "Accedi all'area riservata Fornitori / Operatori"
Else
	sCaption = "Operators Access"
	sTitle = "Log in to Operators reserved area"
End If
%>          
											<img border="0" src="images/SignalFilled.gif" width="6" height="9">&nbsp;
											<a href="frmAppStart.aspx?<%=FORM_SYS_FIELD_APP_CONTEXT_NAME%>=<%=_site.Glb.GetParam("CONTEXT_NAME_RESERVED_AREA")%>&amp;<%=FORM_SYS_FIELD_RETURN_APP_URL%>=<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))%>" 
													title="<%=sTitle%>" target="Contents">
												<font face="Verdana, Arial" size=1><%=UCase(sCaption)%></Font></a>
                                          </td>
                                        </tr>

    <!--  EVENTUALE ALTRO TIPO DI ACCESSO (es. cliente) -->

                                        <tr>
                                          <td>
<%	
' Visualizza i dati dell'utente corrente
    ' e l'eventuale funzione di uscita
    Dim objDSLoggedUser As OODBMSObjLib.clsDataSource = Session("g_objDSLoggedUser")
    If Not objDSLoggedUser Is Nothing Then

	
        If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
            If objDSLoggedUser.Table.ObjectName = "Clienti" Then
                sCaption = "CLIENTE"
                sName = objDSLoggedUser.ColValueStr("Descrizione")
            Else
                sCaption = "OPERATORE"
                sName = objDSLoggedUser.ColValueStr("Denominazione")
            End If
        Else
            Response.Write("<br>")
            If objDSLoggedUser.Table.ObjectName = "Clienti" Then
                sCaption = "CUSTOMER"
                sName = objDSLoggedUser.ColValueStr("Descrizione")
            Else
                sCaption = "OPERATOR"
                sName = objDSLoggedUser.ColValueStr("Denominazione")
            End If
        End If
	%>          
	                                        <hr />
											<FONT face="Verdana, Arial" size=1 color=blue><b><%=sCaption%>:</b>
											<br><i><%=sName%></i>
											</FONT>
<%	
End If
%>
                                          </td>
                                        </tr>

                                        <tr>
                                          <td width="110">
                                          </td>
                                        </tr>
<%
' Se l'utente non è loggato imposta le relative funzioni
If Not Session("g_objDSLoggedUser") Is Nothing Then
%>                                        
                                        <tr>
                                          <td width="110">
<%	
	' Imposta il tasto di uscita
	_site.Frm.WriteFunctionKey_AppExit(True)
	
	' Imposta il menù del cliente come default (menù)
	_site.Frm.WriteFunctionKey_Menu()
	%>
                                          </td>
                                        </tr>
<%	
End If
%>                                        


                                      
                                    </table>
                                  </td>
                                </tr>
                              
                            </table>
                          </td>
                        </tr>
                      
                    </table>

<%
    ' ------------------------------------------------------
    ' Se l'utente non è loggato nasconde tutte le voci
    ' ------------------------------------------------------
    If Not Session("g_objDSLoggedUser") Is Nothing Then
%>

					<br />

					<!--                                   -->
					<!-- #INCLUDE FILE="LinksFixed.asp"    -->
					<!--                                   -->
                    
                    <!----- posizione di inserimento altre sezioni --->

<%
    End If          ' Fine controllo per utente non loggato
%>

              </td>
              
              </tr>
              
	  </table>

<%
End If

%>
</body>
</html>


