' =================================================
' LogiCode - EasyCommerce
' CONFIGURAZIONE DELLE AZIONI POSSIBILI PER
' L'APPLICAZIONE
'
' Definizione delle azioni modificabili in relazione 
' alla configurazione dell'applicazione, tutte le
' funzioni e le operazioni di elaborazione dati devono
' essere raggruppate in questo modulo.
'
' N.B.: Configurare opportunamente le costanti in:
'		<Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	06/04/2003
' =================================================
'
' Funzioni aggiuntive disponibili:
'	Public Function InitApplicationObjects( p_objPage, p_blnEnableStart, p_blnProgressMessages )
'	Function WriteClientDestinationActionEx( ... )
'	WriteFunctionKey_AppReturn
'	Sub WriteFunctionKey_Exit
'	Sub WriteFunctionKey_FormExit
'
' < Inclusione della librearia OODBMS Form che include a sua volta gli altri moduli >
'	- Parameters.xml			' NOTA: Contiene le costanti di definizione dell'applicazione
'	- mod_lib. Const.aspx
'	- modGlobal.aspx
'	- mod_lib. Lib.aspx

' N.B.: per ulteriori informazioni sulla proprietà 'ValidateRequest'
'		leggere il documento (How To: Protect From Injection Attacks in ASP.NET)
'		http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnpag2/html/paght000003.asp
'		In relatà l'impostazione a 'false' è necessaria solo per la pagina
'		'frmDataRow.aspx' che permette l'invio di campi (FORM) con
'		codice HTML
Imports OODBMSObjLib
Imports OOWebLib

Public Module modSiteFunctions

    ' N.B.: per inizializzare gli oggetti è necessario richiamare all'avvio di ogni pagina
    'Dim _site = Site(Page)
    'If Not InitApplicationObjects(Application, Session, Me, False, True) Then
    '    ' Termina l'applicazione
    '    _lib. EndApplication(True)
    'End If
    Public Function Site(application As System.Web.HttpApplicationState,
                         session As System.Web.SessionState.HttpSessionState) As EasyContentManager.clsSiteFunctions

        ' Inizializzazione dell'oggetto globale per la gestione del sito
        Site = Site(session)
        If Site Is Nothing Then
            Site = New EasyContentManager.clsSiteFunctions(application, session)
            session("g_SiteFunctions") = Site
        End If

    End Function
    '
    Public Function Site(page As System.Web.UI.Page) As EasyContentManager.clsSiteFunctions
        Return Site(page.Application, page.Session)
    End Function
    '
    Friend Function Site(session As System.Web.SessionState.HttpSessionState) As EasyContentManager.clsSiteFunctions   ' solo per uso interno (verificare se è Nothing)
        Return session("g_SiteFunctions")
    End Function


    ' Alcune funzioni globali di supporto
    Public Sub WriteHeadSessionObjFrameAccess(ByRef page As System.Web.UI.Page)
        clsWEBGlobal.WriteHeadSessionObjFrameAccess(page)
    End Sub
    Public Function DatLink(session As System.Web.SessionState.HttpSessionState) As clsDataLink
        Return Session("g_objDataLink")
    End Function
    Public Function Language(session As System.Web.SessionState.HttpSessionState) As OODBMS_LocaleLanguage
        Return session("g_LocaleLanguage")
    End Function

End Module

Public Class clsSiteFunctions

    ' Gestione degli oggetti di supporto relativi alla libreria WEB globale (vedere OOWebLib)
    Private _session As System.Web.SessionState.HttpSessionState
    Private _application As System.Web.HttpApplicationState
    Private _glb As clsWEBGlobal
    Private _db As clsWEBDatabase
    Private _lib As clsWebLib
    Private _frm As clsWebForm
    'Private _cust As clsCustomModule
    'Private _bus As clsModBusManager
    '
    Public Sub New(application As System.Web.HttpApplicationState,
                        session As System.Web.SessionState.HttpSessionState)
        _application = application
        _session = session
        _glb = New clsWEBGlobal
        _lib = New clsWebLib(_glb)
        _db = New clsWEBDatabase(_glb)
        _frm = New clsWebForm(_lib)
        '
        '_cust = New clsCustomModule(_lib, _application, _session)
        '_bus = New clsModBusManager(_lib, _application, _session)
    End Sub
    Public ReadOnly Property Glb As clsWEBGlobal
        Get
            Return _lib.Glb
        End Get
    End Property
    Public ReadOnly Property [Lib] As clsWebLib
        Get
            Return _lib
        End Get
    End Property
    Public ReadOnly Property DB As clsWEBDatabase
        Get
            Return _db
        End Get
    End Property
    Public ReadOnly Property Frm As clsWebForm
        Get
            Return _frm
        End Get
    End Property
    Public ReadOnly Property App As System.Web.HttpApplicationState
        Get
            Return _application
        End Get
    End Property
    Public ReadOnly Property Session As System.Web.SessionState.HttpSessionState
        Get
            Return _session
        End Get
    End Property
    Public ReadOnly Property Server As System.Web.HttpServerUtility
        Get
            Return System.Web.HttpContext.Current.Server
        End Get
    End Property
    Public ReadOnly Property DatLink() As clsDataLink
        Get
            Return modSiteFunctions.DatLink(Session)
        End Get
    End Property
    Public ReadOnly Property Language() As OODBMS_LocaleLanguage
        Get
            Return modSiteFunctions.Language(Session)
        End Get
    End Property

    ' =================================================
    ' Riporta il link della pagina da richiamare in relazione
    ' al nome della pagina sorgente (p_strSourceName), alla 
    ' tabella di contesto e all'azione effettuata (p_strAction)
    ' Se si verifica un errore oppure se l'azione non è
    ' supportata riporta un link vuoto ("").
    '
    ' Per eseguire una destinazione mediane link usare la pagina:
    '       ProcessDestLocation.aspx
    '
    ' N.B.: Questa funzione non deve essere direttamente 
    '		impostata come link di destinazione perchè
    '		potrebbe riportare errori nella pagina corrente,
    '		quindi è necessario leggere prima il link
    '		di destinazione controllando se è vuoto ("")
    '
    ' Parametri:
    '	<p_strSourceName>
    '		Nome della pagina sorgente che fa la richiesta
    '		del Link di destinazione.
    '		Le costanti relative ai nomi delle pagine (PAGE_NAME_)
    '		sono definite in <Parameters.xml)
    '	<p_strAction>
    '		Nome dell'azione processata nella pagina sorgente
    '		Le costanti relative ai nomi delle azioni (ACTION_)
    '		sono definite in <mod_lib. Const.aspx>
    '	<p_strContextName>
    '		Nome identificativo del contesto o dell'azione
    '		richiesta per la destinazione, può corrispondere
    '		al nome della tabella o Reference che definisce il 
    '		contesto di azione della pagina sorgente.
    '		I nomi delle tabelle/Reference si riferiscono a quelli
    '		definiti nel database dell'applicazione, per le
    '		Reference il nome deve essere completo di prefisso
    '		tabella ([TableName].[ReferenceName])
    '		Questo parametro può essere vuoto ("") se la destinazione
    '		richiesta ignora il contesto di azione.
    '		Il contenuto di questo parametro può essere impostato
    '		nell'ambito di lavoro corrente (vedi _lib. SetWorkSpace())
    '		in modo da definire l'inizio di un'operazione o di un
    '		percorso elaborativo. 
    '	<p_strReturnFrame>	
    '		Eventuale frame di destinazione (se diverso da quello predefinito)
    '		riportato dalla funzione.
    '		
    ' Se l'applicazione prevede più ambiti di elaborazione è
    ' necessario controllare o impostare anche il valore corrente
    ' (_session("g_strAppWorkSpace"))
    Public Function GetDestLocation(p_page As System.Web.UI.Page, _
                                ByVal p_strSourceName As String, _
                                ByVal p_strAction As String, _
                                ByVal p_strContextName As String, _
                                Optional ByRef p_strReturnFrame As String = "", _
                                Optional ByRef p_strReturnError As String = "", _
                                Optional ByVal p_strDefaultLocation As String = "") As String

        ' Inizializzazione
        GetDestLocation = p_strDefaultLocation

        ' Identifica la destinazione in relazione
        ' al nome della pagina di origine
        Dim objDataSource As OODBMSObjLib.clsDataSource
        Dim objAllarmi As OODBMSObjLib.clsDataSource
        Dim objPagamento As OODBMSObjLib.clsDataSource = Nothing
        Dim sSubject As String, sMsg As String
        Select Case p_strSourceName

            ' Se il nome sorgente è vuoto avvia l'applicazione
            Case ""

                ' Avvia l'applicazione
                GetDestLocation = GetCompleteURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_APP_START")), _
                    FORM_SYS_FIELD_REQUEST_ACTION & "=" & p_strAction & _
                    "&" & FORM_SYS_FIELD_APP_CONTEXT_NAME & "=" & p_strContextName)

                ' Azioni richieste dalla pagina di avvio dell'applicazione
            Case _glb.GetParam("PAGE_NAME_APP_START")

                ' Se l'utente risulta loggato richiama la pagina di uscita
                ' (solo se si tratta di area riservata operatori dalla quale
                '  si esce oppure nella quale si entra)
                If Not _session("g_objDSLoggedUser") Is Nothing And (_session("g_strAppWorkSpace") = _glb.GetParam("CONTEXT_NAME_RESERVED_AREA") Or p_strContextName = _glb.GetParam("CONTEXT_NAME_RESERVED_AREA")) Then

                    ' Attiva l'uscita dell'utente
                    GetDestLocation = GetCompleteURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_LOGOUT")), _
                                            FORM_SYS_FIELD_RETURN_APP_URL & "=" & URLParamEncode(_session("g_strContentMenuURL")))
                    GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_LOGOUT"))
                    _session("g_strSuccessURL") = GetInitialDestLocation(p_strContextName)     ' Destinazione di conferma

                Else

                    ' Inizializza la sessione anonima
                    Dim bContinue As Boolean = False
                    If Not _session("g_objDSLoggedUser") Is Nothing Then
                        ' Continua con il cliente loggato
                        bContinue = True
                    ElseIf InitializeGuestSession(p_strContextName) Then
                        ' Continua con una nuova sessione
                        bContinue = True
                    End If
                    '
                    If bContinue Then

                        ' Identifica l'operazione iniziale in relazione
                        ' al contesto
                        GetDestLocation = GetInitialDestLocation(p_strContextName)

                    End If

                End If

                ' Azioni richieste dalla pagina uscita utente
            Case _glb.GetParam("PAGE_NAME_LOGOUT")

                ' Ritorna all'URL iniziale
                'GetDestLocation = _session("g_strReturnAppURL")
                'p_strReturnFrame = _session("g_strReturnAppFrame")
                'If GetDestLocation = "" Then GetDestLocation = URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL)) 
                'GetDestLocation = URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL)) 
                GetDestLocation = _session("g_strSuccessURL")
                If GetDestLocation = "" Then GetDestLocation = URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL))
                If GetDestLocation = "" Then
                    ' Riparte con l'applicazione
                    GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))
                    'GetDestLocation(PAGE_NAME_APP_START, 					'								ACTION_FIRST_ACCESS, 					'								_session("g_strAppWorkSpace"))
                End If

                ' Azioni richieste dalla pagina accesso utente / cliente
                ' <p_strContextName>
                '		Deve contenere il nome della tabella (Clienti,Operatori, etc.)
            Case _glb.GetParam("PAGE_NAME_LOGIN")

                ' Eventuale registrazione dell'utente
                If p_strAction = ACTION_ADD_NEW Then

                    ' Attiva l'inserimento dell'operatore / cliente
                    GetDestLocation = _frm.ComposeFormRequestActionLink(p_strContextName, ACTION_ADD_NEW, "")

                    ' Effettua l'accesso in relazione al Namespace
                ElseIf p_strAction = ACTION_LOGIN Then

                    ' Attiva il menù Operatori			
                    If p_strContextName = "Operatori" Then

                        'If _session("g_strAppWorkSpace") = _glb.GetParam("CONTEXT_NAME_RESERVED_AREA") Then

                        If _session("g_strSuccessURL") <> "" Then

                            ' Destinazione in caso di successo
                            GetDestLocation = _session("g_strSuccessURL")

                            ' Imposta il menù Operatori come default
                            _lib.SetContentMenuURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_OPERATORE")))

                        Else
                            ' Richiama il menù Operatori
                            GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_OPERATORE"))

                            ' Imposta il menù Operatori come default
                            _lib.SetContentMenuURL(GetDestLocation)
                        End If

                        ' Imposta il contesto per l'area riservata
                        _lib.SetWorkSpace(_glb.GetParam("CONTEXT_NAME_RESERVED_AREA"))

                        'End If

                    Else

                        If p_strContextName = "Clienti" Then

                            ' Attiva l'accesso al menù
                            GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_CLIENTE"))

                            ' Imposta il menù del cliente come default (menù)
                            _lib.SetContentMenuURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_CLIENTE")))

                        End If

                    End If

                End If

                ' Azioni richieste dalla pagina di password dimenticata
            Case _glb.GetParam("PAGE_NAME_FORGOTTEN_PASSWORD")

                ' E' stata richiesta la password dimenticata
                If p_strAction = ACTION_QUERY Then

                    ' Continua con le funzionalità della pagina
                    GetDestLocation = LOCATION_CONTINUE

                    ' Annulla eventuale pagina di ritorno precedente
                    _lib.SetContentMenuURL("")

                End If

                ' Azioni richieste dalla pagina Visualizzazione/Modifica/Inserimento dati
                'Case _glb.GetParam("PAGE_NAME_DATA_ROW"), _
                '                    "ProcessDestLocation", _
                '                    "CustomRequest", _
                '                    "Contattaci"
            Case _glb.GetParam("PAGE_NAME_DATA_ROW"), "ProcessDestLocation"

                ' Contollo inserimento richieste 
                If p_strContextName = "Richieste" Then

                    If p_strAction = ACTION_INSERT Then

                        ' Ritorna alla pagina iniziale
                        GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))

                        ' Se si tratta di inserimento invia la notifica all'amministratore
                        If Not _frm.GetFormDataSource(objDataSource, _glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL)) Then
                            _glb.RspErr("Il DataSource della richiesta inserita non è più disponibile")
                        Else

                            ' Compone il messaggio di avvenuta registrazione
                            If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                sSubject = _glb.GetParam("APP_NAME") & " - Richiesta & Info"
                                sMsg = "RICHIESTA:" & vbCrLf & objDataSource.ColValueStr("Richiesta") & _
                                 vbCrLf & vbCrLf & "DATA: " & objDataSource.FormattedColValue("DataInserimento") & _
                                 IIf(Not objDataSource.ReferenceEmpty("Cliente"), vbCrLf & "CLIENTE: " & objDataSource.ColValueStr("Cliente"), "") & _
                                 IIf(Not objDataSource.ReferenceEmpty("Argomento"), vbCrLf & "ARGOMENTO: " & objDataSource.ColValueStr("Argomento"), "") & _
                                 IIf(Not objDataSource.ReferenceEmpty("Dispositivo"), vbCrLf & "PRODOTTO: " & objDataSource.ColValueStr("Dispositivo"), "") & _
                                 vbCrLf & "RIF.RICHIESTA: " & objDataSource.RowOID & _
                                 vbCrLf & "NOME: " & objDataSource.ColValueStr("Nome") & _
                                 vbCrLf & "E-MAIL: " & objDataSource.ColValueStr("EMail") & _
                                 vbCrLf & "TELEFONO: " & objDataSource.ColValueStr("Telefono")
                            Else
                                sSubject = _glb.GetParam("APP_NAME") & " - Request & Info"
                                sMsg = "REQUEST:" & vbCrLf & objDataSource.ColValueStr("Richiesta") & _
                                 vbCrLf & vbCrLf & "DATE: " & objDataSource.FormattedColValue("DataInserimento") & _
                                 IIf(Not objDataSource.ReferenceEmpty("Cliente"), vbCrLf & "CUSTOMER: " & objDataSource.ColValueStr("Cliente"), "") & _
                                 IIf(Not objDataSource.ReferenceEmpty("Argomento"), vbCrLf & "ARGOMENTO: " & objDataSource.ColValueStr("Argomento"), "") & _
                                 IIf(Not objDataSource.ReferenceEmpty("Dispositivo"), vbCrLf & "PRODUCT: " & objDataSource.ColValueStr("Dispositivo"), "") & _
                                 vbCrLf & "REQUEST REF.: " & objDataSource.RowOID & _
                                 vbCrLf & "NAME: " & objDataSource.ColValueStr("Nome") & _
                                 vbCrLf & "E-MAIL: " & objDataSource.ColValueStr("EMail") & _
                                 vbCrLf & "TELEPHON: " & objDataSource.ColValueStr("Telefono")
                            End If
                            sMsg = sMsg & vbCrLf & vbCrLf & _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME") & vbCrLf & "Supporto: " & _glb.GetParam("ADMIN_SUPPORT_EMAIL")

                            ' Invia l'e-mail all'amministratore
                            Dim bOk As Boolean = False
                            If _glb.MailSend(_glb.GetParam("ADMIN_SUPPORT_EMAIL"), sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then
                                ' Invia l'e-mail al richiedente
                                If RTrim(objDataSource.ColValueStr("EMail")) = "" _
                                        OrElse _glb.MailSend(objDataSource.ColValueStr("EMail"), sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then

                                    ' Invia eventuale indrizzo di supporto secondario
                                    If _glb.GetParam("ADMIN_SUPPORT_EMAIL_2ND") <> "" Then
                                        If _glb.MailSend(_glb.GetParam("ADMIN_SUPPORT_EMAIL_2ND"), sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then
                                            ' Inviato....
                                        End If
                                    End If

                                    ' Invia ulteriore e-mail all'eventuale supporto aggiuntivo legato
                                    ' all'argomento
                                    Dim sSupArg As String = ""
                                    If Not objDataSource.ReferenceEmpty("Argomento") Then
                                        sSupArg = RTrim(objDataSource.ColValueStr("Argomento.Supporto"))
                                        If sSupArg <> "" AndAlso InStr(_glb.GetParam("ADMIN_SUPPORT_EMAIL_2ND"), sSupArg, CompareMethod.Text) = 0 Then
                                            If _glb.MailSend(sSupArg, sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then
                                                ' Inviato....
                                            End If
                                        End If
                                    End If
                                    ' Invia ulteriore e-mail all'eventuale supporto aggiuntivo legato
                                    ' al dispositivo
                                    Dim sSupPrd As String = ""
                                    If Not objDataSource.ReferenceEmpty("Dispositivo") Then
                                        sSupPrd = RTrim(objDataSource.ColValueStr("Dispositivo.Supporto"))
                                        If sSupPrd <> "" AndAlso UCase(sSupPrd) <> UCase(sSupArg) AndAlso InStr(_glb.GetParam("ADMIN_SUPPORT_EMAIL_2ND"), sSupArg, CompareMethod.Text) = 0 Then
                                            If _glb.MailSend(sSupPrd, sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then
                                                ' Inviato....
                                            End If
                                        End If
                                    End If
                                    '
                                    bOk = True

                                End If
                            End If
                            If bOk Then
                                If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                    p_page.Response.Write("<" & "script language=javascript" & ">alert(""La richiesta è stata inviata..."");<" & "/script" & ">")
                                Else
                                    p_page.Response.Write("<" & "script language=javascript" & ">alert(""The request has been sent..."");<" & "/script" & ">")
                                End If
                            Else
                                If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                    p_page.Response.Write("<" & "script language=javascript" & ">alert(""La richiesta non è stata inviata correttamente a causa di errori..."");<" & "/script" & ">")
                                Else
                                    p_page.Response.Write("<" & "script language=javascript" & ">alert(""The request has not been sended successfully due to errors..."");<" & "/script" & ">")
                                End If

                            End If
                        End If
                    End If

                    ' Controllo gestione operatori
                ElseIf _session("g_strAppWorkSpace") = _glb.GetParam("CONTEXT_NAME_RESERVED_AREA") And p_strContextName = "Operatori" Then

                    If p_strAction = ACTION_INSERT Then

                        ' Prosegue con la pagina di completamento della registrazione			
                        GetDestLocation = GetCompleteURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_REGISTRATION_COMPLETE")), _
                               FORM_SYS_FIELD_FORM_PUPUP_LEVEL & "=" & _glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL))

                    Else

                        ' Dopo la modifica di un utente ritorna
                        ' al menù Operatore
                        GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_OPERATORE"))

                    End If

                    ' Controllo gestione clienti
                ElseIf p_strContextName = "Clienti" Then

                    If p_strAction = ACTION_INSERT Then

                        ' Prosegue con la pagina di completamento della registrazione			
                        'GetDestLocation = GetCompleteURL( _lib. GetPageFileName(_glb.GetParam("PAGE_NAME_REGISTRATION_COMPLETE")), _
                        '									FORM_SYS_FIELD_FORM_PUPUP_LEVEL & "=" & _glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL) )
                        GetDestLocation = LOCATION_CONTINUE

                        ' Se si tratta di inserimento di un Cliente invia la notifica al cliente e all'amministratore
                        If Not _frm.GetFormDataSource(objDataSource, _glb.RequestField(FORM_SYS_FIELD_FORM_PUPUP_LEVEL)) Then
                            _glb.RspErr("Il DataSource del cliente inserito non è più disponibile")
                        Else

                            ' Messaggio di registrazione completata
                            _glb.RspMsg("")
                            If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                _glb.RspMsg("Registrazione completata.")
                            Else
                                _glb.RspMsg("Registration completed.")
                            End If

                            ' Compone il messaggio di avvenuta registrazione
                            If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                sSubject = _glb.GetParam("APP_NAME") & " - Registrazione Cliente"
                                sMsg = "Dati di accesso per il nuovo Cliente (" & objDataSource.ColValueStr("Descrizione") & ")  " & vbCrLf & vbCrLf & "NOME: " & objDataSource.ColValueStr("Nome") & vbCrLf & "PASSWORD: " & objDataSource.ColValueStr("Password")
                            Else
                                sSubject = _glb.GetParam("APP_NAME") & " - Customer Registration"
                                sMsg = "Access data for the new Customer (" & objDataSource.ColValueStr("Descrizione") & ")  " & vbCrLf & vbCrLf & "NAME: " & objDataSource.ColValueStr("Nome") & vbCrLf & "PASSWORD: " & objDataSource.ColValueStr("Password")
                            End If
                            sMsg = sMsg & vbCrLf & _glb.GetParam("START_APP_PATH")
                            sMsg = sMsg & vbCrLf & vbCrLf & _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME") & vbCrLf & "Supporto: " & _glb.GetParam("ADMIN_SUPPORT_EMAIL")

                            ' Invia l'e-mail all'amministratore
                            If _glb.MailSend(_glb.GetParam("ADMIN_SUPPORT_EMAIL"), sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then

                                ' Invia l'e-mail al cliente
                                If _glb.MailSend(objDataSource.ColValueStr("EMail"), sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then

                                    ' Email inviate
                                    If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                        _glb.RspMsg("Email iniviata.")
                                    Else
                                        _glb.RspMsg("Email sended.")
                                    End If

                                    ' Invia eventuale indrizzo di supporto secondario
                                    If _glb.GetParam("ADMIN_SUPPORT_EMAIL_2ND") <> "" Then
                                        If _glb.MailSend(_glb.GetParam("ADMIN_SUPPORT_EMAIL_2ND"), sSubject, sMsg, _glb.GetParam("ADMIN_SUPPORT_EMAIL"), _glb.GetParam("APP_NAME") & " - " & _glb.GetParam("COMPANY_NAME"), _glb.GetParam("ADMIN_SUPPORT_EMAIL_SMTP"), , _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_USER"), _glb.GetParam("ADMIN_SUPPORT_SMTP_AUTH_PWD")) Then
                                            ' Inviato....
                                        End If
                                    End If

                                    ' Attiva il cliente nella sessione corrente	
                                    Dim sUserID As String = _lib.ComposeUserID(objDataSource.ColValueStr("Nome"), objDataSource.Table.ObjectName)
                                    If _lib.UserLogin(sUserID, OODBMS_UserAccessLevel.odulUserGuest, objDataSource, True) Then

                                        ' Accesso effettuato
                                        If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                            _glb.RspMsg("Accesso effettuato.")
                                        Else
                                            _glb.RspMsg("Login completed.")
                                        End If

                                        ' Completamenteo dell'accesso
                                        'GetDestLocation = GetDestLocation(page, _glb.GetParam("PAGE_NAME_LOGIN"), ACTION_LOGIN, objDataSource.Table.ObjectName,p_strReturnFrame)

                                        ' Imposta il tasto di uscita
                                        _frm.WriteFunctionKey_AppExit(True)

                                        ' Imposta il menù del cliente come default (menù)
                                        _frm.WriteFunctionKey_Menu()

                                        ' Aggiorna il frame dei links
                                        p_page.Response.Write("<script language=""javascript"">ReloadFrame(""Links"");<" & "/script>")

                                    End If
                                End If
                            End If
                        End If

                    Else

                        ' Dopo la modifica di un cliente ritorna al menù
                        GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_CLIENTE"))

                    End If

                ElseIf p_strContextName = "TabellePersonali" Then

                    If p_strAction = ACTION_INSERT _
                                OrElse p_strAction = ACTION_UPDATE _
                                OrElse p_strAction = "CheckUpdateStruct" Then

                        ' Aggiorna la struttura della/e tabella/e
                        Dim bCurrent As Boolean = True, objMyTbls As OODBMSObjLib.clsDataSource = Nothing
                        If p_strAction = "CheckUpdateStruct" OrElse Not _frm.GetFormDataSource(objMyTbls) OrElse objMyTbls.RowInvalid Then
                            ' Identifica tutte le tabelle da aggiornare
                            bCurrent = False
                            If Not _lib.GetDataSource(objMyTbls, "TabellePersonali") OrElse objMyTbls.RowCount = 0 Then
                                objMyTbls = Nothing
                            End If
                        End If
                        '
                        If objMyTbls Is Nothing Then
                            If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                _glb.RspMsg("Tabelle personalizzate non configurate")
                            Else
                                _glb.RspMsg("Custom data table is missing")
                            End If
                        Else
                            If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                _glb.RspMsg("Analisi delle tabelle personalizzate da aggiornare...")
                            Else
                                _glb.RspMsg("Analysis of custom tables to be updated...")
                            End If
                            _glb.RspMsg("")
                            Try
                                Dim sTbls As String = "", nUpdt As Integer = 0
                                While Not objMyTbls.EOF
                                    If EasyContentManagerDB.MyTable_CheckUpdate(objMyTbls) Then
                                        sTbls &= If(sTbls <> "", ",", "") & objMyTbls.ColValueStr("Descrizione")
                                        nUpdt += 1
                                    End If
                                    If bCurrent Then Exit While
                                    objMyTbls.RowNext()
                                End While
                                '
                                If sTbls <> "" Then
                                    If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                        _glb.RspMsg("Struttura tabella/e aggiornata: " & sTbls)
                                    Else
                                        _glb.RspMsg("Table/s structure updated: " & sTbls)
                                    End If
                                Else
                                    If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                                        _glb.RspMsg("Nessuna struttura da aggiornare.")
                                    Else
                                        _glb.RspMsg("No structure to be updated.")
                                    End If
                                End If
                            Catch ex As Exception
                                _glb.RspErr(ex.Message)
                                p_strReturnError = ex.Message
                            End Try
                        End If

                    End If
                    '
                    If p_strAction = "CheckUpdateStruct" Then
                        ' Dopo la modifica ritorna al menù Operatore
                        GetDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_MENU_OPERATORE"))
                    End If

                End If

                ' Azioni dalla griglia dati
            Case _glb.GetParam("PAGE_NAME_DATA_GRID")

                '' Se si tratta di selezione elementi durante la gestione
                '' del carrello aggiunge l'porta selezionato nella
                '' allarmi corrente
                'If p_strAction = ACTION_SELECT And p_strContextName = "Elementi" Then


                '    If _session("g_blnUserLogged") OrElse _glb.GetBoolean(_glb.GetParam("BUY_WITHOUT_VALIDATION")) Then
                '        GetDestLocation = GetCompleteURL(_lib. GetPageFileName(_glb.GetParam("PAGE_NAME_PREVIEW")), _
                '             "OID=" & _glb.RequestField(FORM_SYS_FIELD_OID) & _
                '             "&" & FORM_SYS_FIELD_RETURN_APP_URL & "=" & URLParamEncode(GetCurrentURL()))    ' Request.ServerVariables.Item("URL") ) 
                '    Else
                '        GetDestLocation = GetCompleteURL(_lib. GetPageFileName(_glb.GetParam("PAGE_NAME_LOGIN")), _
                '           LOGIN_TABLE_NAME & "=Clienti" & _
                '           "&" & LOGIN_FIELD_NAME_USER & "=NomeUtente" & _
                '           "&" & LOGIN_FIELD_NAME_PASSWORD & "=Password" & _
                '           "&" & LOGIN_FIELD_NAME_EMAIL & "=EMail" & _
                '                    "&" & LOGIN_FIELD_NAME_PIVA & "=PartitaIVA" & _
                '                    "&" & LOGIN_FIELD_NAME_CFISC & "=CodiceFiscale" & _
                '           "&" & LOGIN_FIELD_NAME_INHERIT_SESSION & "=True" & _
                '           "&" & FORM_SYS_FIELD_RETURN_APP_URL & "=" & URLParamEncode(GetCurrentURL())) 'Request.ServerVariables.Item("URL"))
                '    End If
                'End If

                ' Azioni dalla pagina di anteprima porta
            Case _glb.GetParam("PAGE_NAME_PREVIEW")

                ' Identifica l'oggetto temporaneo relativo alla allarmi
                ' corrente
                objAllarmi = _lib.TemporaryDataTypeSearch("Allarmi")
                If IsNothing(objAllarmi) Then
                    If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                        _glb.RspErr("Oggetto della allarmi non disponibile")
                    Else
                        _glb.RspErr("Object of the sale not available")
                    End If
                Else
                    ' Imposta per continuare con la gestione della griglia
                    'GetDestLocation = LOCATION_CONTINUE
                    'GetDestLocation = GetCompleteURL(_lib. GetPageFileName("PromotionFrame"), "")
                    GetDestLocation = "Pages/ViewPortElements.aspx"
                End If


        End Select

        ' Controllo esito
        If GetDestLocation = "" Then

            ' Prevedere la pagina predefiniti o precedente
            ' ....
            If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
                _glb.RspErr("Azione di destinazione non prevista o non correttamente configurata:" & "\nSorgente: " & p_strSourceName & "\nAzione: " & p_strAction & "\nContesto: " & p_strContextName & "\nAmbito: " & _session("g_strAppWorkSpace"))
            Else
                _glb.RspErr("Action of destination not scheduled or not correctly configured:" & "\nSource: " & p_strSourceName & "\nAction: " & p_strAction & "\nContext: " & p_strContextName & "\nWorkSpace: " & _session("g_strAppWorkSpace"))
            End If

            ' Non permette la prosecuzione
            p_page.Response.End()

        ElseIf GetDestLocation = LOCATION_CONTINUE Then

            ' Verifica se è presente un URL di ritorno
            ' richiesto dalla pagina chiamante
            Dim sReturnURL = _session("g_strSuccessURL")   '_session("g_strReturnAppURL")
            If Len(sReturnURL) = 0 Then sReturnURL = URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL))
            If Len(sReturnURL) > 0 Then
                GetDestLocation = sReturnURL    'LOCATION_CONTINUE
            End If

        End If

        ' Azzera la destinazione in caso di successo per evitare di considerarla in
        ' operazioni successive
        If GetDestLocation = _session("g_strSuccessURL") Then
            _session("g_strSuccessURL") = ""
        End If

    End Function

    ' Identifica l'operazione iniziale (destinazione) in relazione al contesto
    Public Function GetInitialDestLocation(ByVal p_strContextName As String) As String

        ' Identifica l'operazione iniziale in relazione
        ' al contesto
        Select Case p_strContextName

            Case _glb.GetParam("CONTEXT_NAME_RESERVED_AREA")

                ' Attiva l'accesso dell'operatore

                GetInitialDestLocation = GetCompleteURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_LOGIN")), _
                      LOGIN_TABLE_NAME & "=Operatori" & _
                      "&" & LOGIN_FIELD_NAME_USER & "=NomeUtente" & _
                      "&" & LOGIN_FIELD_NAME_PASSWORD & "=Password" & _
                      "&" & LOGIN_FIELD_NAME_EMAIL & "=EMail" & _
                                              "&" & LOGIN_FIELD_NAME_PIVA & "=PartitaIVA" & _
                                              "&" & LOGIN_FIELD_NAME_CFISC & "=CodiceFiscale" & _
                      "&" & LOGIN_FIELD_NAME_ACCESS_LEVEL & "=LivelloAccesso")

            Case _glb.GetParam("CONTEXT_NAME_CUSTOMER_AREA")

                ' Attiva l'accesso dell'operatore
                GetInitialDestLocation = GetCompleteURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_LOGIN")), _
                      LOGIN_TABLE_NAME & "=Clienti" & _
                      "&" & LOGIN_FIELD_NAME_USER & "=NomeUtente" & _
                      "&" & LOGIN_FIELD_NAME_PASSWORD & "=Password" & _
                      "&" & LOGIN_FIELD_NAME_EMAIL & "=EMail" & _
                                              "&" & LOGIN_FIELD_NAME_PIVA & "=PartitaIVA" & _
                                              "&" & LOGIN_FIELD_NAME_CFISC & "=CodiceFiscale")

            Case "RequestAndInfo"

                ' Identifica eventuale Cliente loggato
                Dim strSetDefault As String = ""
                If Not _session("g_objDSLoggedUser") Is Nothing Then
                    strSetDefault = "Cliente|OID:" & CStr(DirectCast(_session("g_objDSLoggedUser"), clsDataSource).RowOID)
                    ' La chiamata può contenere il parametro 'UserID' con il codice del cliente
                ElseIf _glb.RequestField("UserID") <> "" Then
                    strSetDefault = "Cliente|Code:" & _glb.RequestField("UserID")
                End If
                ' La chiamata può contenere il parametro 'Product' con il codice del dispositivo
                If _glb.RequestField("UserID") <> "" Then
                    If strSetDefault <> "" Then strSetDefault &= "|"
                    strSetDefault &= "Dispositivo|" & _glb.RequestField("Product")
                End If
                '
                If strSetDefault <> "" Then
                    ' Imposta il parametro
                    ' Vedi frmDataRow per dettagli
                    strSetDefault = "&" & FORM_SYS_FIELD_DEFAULT_FIELDS_VALUES & "=" & strSetDefault
                End If

                ' Richieste e informazioni
                'GetInitialDestLocation = GetCompleteURL( _lib. GetPageFileName(_glb.GetParam("PAGE_NAME_DATA_ROW")), _
                '						FORM_SYS_FIELD_DATA_PATH & "=Richieste" & _
                '							"&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_ADD_NEW )
                GetInitialDestLocation = GetCompleteURL("CustomRequest.aspx", _
                    FORM_SYS_FIELD_DATA_PATH & "=Richieste" & _
                     "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_ADD_NEW & _
                     strSetDefault)

            Case Else
                ' Attiva l'accesso alla pagina iniziale
                GetInitialDestLocation = _lib.GetPageFileName(_glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))

        End Select


    End Function

    ''-------------------------------------------------------------------------------------
    '' FUNZIONI PER LA GESTIONE DEL CARRELLO
    ''-------------------------------------------------------------------------------------
    'Function AddBasket_Porta(ByRef objAllarmi As Object, _
    '   ByRef vntOID_Porta As String, _
    '   ByRef sRiferimento As String, _
    '   Optional ByVal nQnt As Integer = 1) As Boolean

    '    ' Inizializza esito
    '    AddBasket_Porta = False

    '    ' Identifica gli elementi presenti nel carrello
    '    Dim objElementi As OODBMSObjLib.clsDataSource
    '    If _lib. GetReference(objAllarmi, _
    '        "Elementi", "", _
    '        objElementi, "", "", 0) Then

    '        ' Aggiunge l'porta nel carrello, se l'porta
    '        ' esiste già incrementa la quantità
    '        Dim bAdd = False
    '        On Error Resume Next
    '        If objElementi.FindRow(objElementi.Table.ParentOIDColumnName & "=" & vntOID_Porta) Then

    '            ' Se specificato il riferimento controlla se separare
    '            ' da eventuale altro precedentemente impostato
    '            If objElementi.ColValueStr("Riferimento") <> sRiferimento Then
    '                bAdd = True
    '            End If
    '        Else
    '            bAdd = True
    '        End If
    '        '
    '        If bAdd Then
    '            ' Aggiunge l'porta nel carrello
    '            objElementi.AddRow(objElementi.Table.ParentOIDColumnName, CLng(vntOID_Porta), _
    '                "Riferimento", sRiferimento, _
    '                "Quantità", nQnt)
    '        Else
    '            ' Incrementa la quantità
    '            objElementi.ColValueAdd("Quantità") = nQnt
    '            If Err.Number = 0 And sRiferimento <> "" Then objElementi.ColValue("Riferimento") = sRiferimento
    '            If Err.Number = 0 Then objElementi.UpdateRow()
    '        End If
    '        '
    '        If Not _lib. CatchError("") Then

    '            ' Operazione completata correttamente
    '            AddBasket_Porta = True

    '        End If

    '    End If

    'End Function

    '' Riporta il valore di un campo relativo ad un porta
    'Function GetColValue_Porta(ByVal p_strCodice As String, _
    '                       Optional ByVal p_strFieldName As String = "Descrizione", _
    '                       Optional ByVal p_strFormatted As Boolean = True) As Object
    '    'Function GetColValue_Porta(ByRef p_objPage As System.Web.UI.Page, _
    '    '    ByVal p_strCodice As String, _
    '    '   Optional ByVal p_strFieldName As String = "Descrizione", _
    '    '   Optional ByVal p_strFormatted As Boolean = True) As Object

    '    ' Eventuale Inizializzazione della sessione
    '    ' N.B.: Verifica eventuale richiesti di cambio azienda nei parametri correnti
    '    If Not _lib. ApplicationStarted() _
    '                OrElse IsSessionRequestCompanyChange() Then
    '        'If Not InitApplicationObjects(p_objPage, True, False) Then
    '        If Not InitApplicationObjects(True, False) Then
    '            GetColValue_Porta = ""   ' Non inizializzato
    '            Exit Function
    '        End If

    '    End If

    '    ' Accesso all'porta
    '    Dim objArt As OODBMSObjLib.clsDataSource = _session("objGetValues_Elementi")
    '    If objArt Is Nothing Then objArt = _session("g_objDataLink").GetDataSource("Elementi", OODBMSObjLib._lib. QueryOptions.oqoSimple)
    '    With objArt
    '        .RefreshIfNeeded()
    '        If .FindRow(.ColQueryString("Codice", False, p_strCodice), False) Then
    '            If p_strFormatted Then
    '                GetColValue_Porta = .FormattedColValue(p_strFieldName)
    '            Else
    '                GetColValue_Porta = .ColValue(p_strFieldName)
    '            End If
    '            _session("objGetValues_Elementi") = objArt
    '        Else
    '            If _session("g_LocaleLanguage") = OODBMSObjLib._lib. LocaleLanguage.ollItalian Then
    '                GetColValue_Porta = "#NON TROVATO#"
    '            Else
    '                GetColValue_Porta = "#NOT FOUND#"
    '            End If
    '        End If
    '    End With

    'End Function


    ' Identifica un cliente in relazione ai parametri, riporta Nothing se non identificato
    ' La pagina prevede la possibilità di specificare l'ID del cliente oppure l'e-mail
    ' Parametri supportati:
    '       UserID = Nome, ID Utente o E-Mail
    '       EMail = Indirizzo e-mail
    ' (vedi specifiche nella pagina)
    Function GetRequested_Cliente() As OODBMSObjLib.clsDataSource

        Dim objCust As OODBMSObjLib.clsDataSource = Nothing
        GetRequested_Cliente = Nothing
        If _lib.GetDataSource(objCust, "Clienti") Then

            ' Cerca per ID o EMail
            If _glb.RequestField("UserID") <> "" Then
                If objCust.FindQuery(objCust.ColQueryString("Nome", , _glb.RequestField("UserID"))) > 0 Then
                    GetRequested_Cliente = objCust
                ElseIf InStr(_glb.RequestField("UserID"), "@") > 0 Then
                    ' Tenta anche per email specificato nell'UserID
                    If objCust.FindQuery(objCust.ColQueryString("EMail", , _glb.RequestField("UserID"))) > 0 Then
                        GetRequested_Cliente = objCust
                    End If
                End If
            ElseIf _glb.RequestField("EMail") <> "" Then
                If objCust.FindQuery(objCust.ColQueryString("EMail", , _glb.RequestField("EMail"))) > 0 Then
                    GetRequested_Cliente = objCust
                End If
            End If

        End If

    End Function

    ' Identifica un porta in relazione ai parametri, riporta Nothing se non identificato
    ' La pagina prevede la possibilità di specificare l'OID dell'porta oppure il codice, e il
    ' riferimento di attivazione (se previsto dall'porta)
    ' Parametri supportati:
    '       OID = OID del dispositivo
    '       Code,Codice = Codice del dispositivo (verifica anche eventuale codice aggiuntivo)
    '       Product = Codice del dispositivo (verifica anche eventuale codice aggiuntivo)
    ' (vedi specifiche nella pagina)
    Function GetRequested_Porta(Optional ByRef p_sRetCode As String = "") As OODBMSObjLib.clsDataSource

        ' Dichiarazioni
        Dim vntOID = _glb.RequestField("OID")
        Dim sCode As String = RTrim(_glb.RequestField("Codice"))
        If sCode = "" Then sCode = RTrim(_glb.RequestField("Code"))
        If sCode = "" Then sCode = RTrim(_glb.RequestField("Product"))
        If UCase(Left(sCode, 5)) = "CODE:" Then sCode = Mid(sCode, 6)
        GetRequested_Porta = Nothing

        ' Accede agli elementi
        Dim objDataSource As OODBMSObjLib.clsDataSource = Nothing
        If _lib.GetDataSource(objDataSource, "Elementi", _
            OODBMS_QueryOptions.oqoSimple) Then

            If vntOID = "" Then

                ' Identifica l'porta mediante il codice
                If objDataSource.FindQuery(objDataSource.ColQueryString("Codice", , sCode) & _
                                        " OR " & objDataSource.ColQueryString("CodiceAggiuntivo", , sCode)) > 0 Then
                    GetRequested_Porta = objDataSource

                    ' Tenta la ricerca senza spazi
                ElseIf objDataSource.FindQuery(objDataSource.ColQueryString("Codice", , Replace(sCode, " ", "")) & _
                                        " OR " & objDataSource.ColQueryString("CodiceAggiuntivo", , Replace(sCode, " ", ""))) > 0 Then
                    GetRequested_Porta = objDataSource

                    ' Tenta la ricerca per descrizione
                ElseIf objDataSource.FindQuery(objDataSource.ColQueryString("Codice", , sCode, OODBMS_MatchCriteria.omcStrMatchInternal)) > 0 Then
                    GetRequested_Porta = objDataSource
                End If

            ElseIf objDataSource.FindRowOID(vntOID, True) Then
                GetRequested_Porta = objDataSource
            End If
        End If
        '
        p_sRetCode = sCode

    End Function

    ' Identifica la lista degli elementi appartenenti ad un dispositive/rete
    ' posizionandosi sul primo, riporta il numero degli elementi trovati.
    ' Per ottenere i dati di un porta usare il DataSource globale
    ' (objListSearch_Elementi) memorizzato nella sessione corrente
    ' oppure le funzioni List..._Elementi() di seguito definite.
    Function ListSearchItems_Elementi(ByRef p_objPage As System.Web.UI.Page, _
                                     ByVal p_strCodiceDispositivo As String) As Integer
        ' Eventuale Inizializzazione della sessione
        Dim _site = Site(p_objPage)
        If Not InitApplicationObjects(True, False) Then
            ListSearchItems_Elementi = 0    ' Non inizializzato
            Exit Function
        End If
        ' Accesso all'porta
        Dim objArt As OODBMSObjLib.clsDataSource = _session("objListSearchItems_Elementi")
        If objArt Is Nothing Then objArt = DirectCast(_session("g_objDataLink"), clsDataSource).GetDataSource("Elementi", OODBMSObjLib.OODBMS_QueryOptions.oqoSimple)
        Dim sWhere As String = "Dispositivi.Codice=" & _db.StrForQuery(p_strCodiceDispositivo)
        If objArt.SelWhere <> sWhere Then objArt.SelWhere = sWhere
        objArt.Refresh()
        '
        ListSearchItems_Elementi = objArt.RowCount
        If ListSearchItems_Elementi > 0 Then
            _session("objListSearchItems_Elementi") = objArt
        Else
            _session("objListSearchItems_Elementi") = Nothing
        End If
    End Function
    ' Si posiziona sull'porta successivo 
    Function ListNextItem_Elementi() As Boolean
        Dim objArt As OODBMSObjLib.clsDataSource = _session("objListSearchItems_Elementi")
        objArt.RowNext()
        '
        ListNextItem_Elementi = Not objArt.EOF
        If Not ListNextItem_Elementi Then
            objArt.CloseData()
            _session("objListSearchItems_Elementi") = Nothing
        End If
    End Function
    ' Riporta il valore del campo richiesto presente nell'porta
    ' corrente della lista 
    Function ListColValue_Elementi(ByVal p_strFieldName As String, _
                    Optional ByVal p_strFormatted As Boolean = True) As Object
        Dim objArt As OODBMSObjLib.clsDataSource = _session("objListSearchItems_Elementi")
        If p_strFormatted Then
            ListColValue_Elementi = objArt.FormattedColValue(p_strFieldName)
        Else
            ListColValue_Elementi = objArt.ColValue(p_strFieldName)
        End If
    End Function
    Function ListItem_Elementi() As OODBMSObjLib.clsDataSource
        ListItem_Elementi = _session("objListSearchItems_Elementi")
    End Function

    ' Riporta l'oggetto <clsDataSource> contenente i dati della allarmi 
    ' in corso, se non esiste inizializza una nuova allarmi.
    '
    ' N.B.: L'oggetto viene impostato nella sessione corrente con
    '       il nome di "OperazioneCorrente" e nei dati temporanei
    '		acc_lib. AccessType._lib. UserAccessLevel.oduli per l'elminazione con il nome di "Allarmi",
    '		per confermare la allarmi e evitarne l'eliminazione
    '		durante la chiusura della sessione usare <_lib. TemporaryDataDetach>
    '		(vedi funzioni _lib. TemporaryData...)
    Function GetDataObject_Allarmi() As Object

        ' Se è in corso l'inizializzazione mediante un'altra pagina
        ' presente all'interno di frames eventualmente gestiti
        ' attende alcuni secondi per evitare collisioni
        If CStr(_session("g_tmGetDataObject_Allarmi")) <> "" Then
            While System.Math.Abs(Microsoft.VisualBasic.Timer() - CSng("0" & _session("g_tmGetDataObject_Allarmi"))) < CSng(_lib.FUNC_EXEC_TIMEOUT)
                'DoEvents
            End While
        End If
        _session("g_tmGetDataObject_Allarmi") = Microsoft.VisualBasic.Timer()

        ' Cerca una allarmi già avviata nei dati di sessione
        GetDataObject_Allarmi = _lib.GetSessionObject("OperazioneCorrente")

        ' Se non è presente nessuna allarmi la crea
        If Not IsNothing(GetDataObject_Allarmi) Then
            If GetDataObject_Allarmi.RowInvalid Then
                'UPGRADE_NOTE: Object GetDataObject_Allarmi may not be destroyed until it is garbage collected. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1029"'
                GetDataObject_Allarmi = Nothing
            End If
        End If
        '
        If IsNothing(GetDataObject_Allarmi) Then
            'rspmsg "new"	

            If Not _lib.GetNewRowDS(GetDataObject_Allarmi, "Allarmi", "") Then
                ' Termina l'applicazione
                _lib.EndApplication(True)

                ' Imposta la allarmi nei dati temporanei per l'eventuale
                ' eliminazione in caso di mancata conferma
            ElseIf Not _lib.TemporaryDataAdd(GetDataObject_Allarmi) Then
                ' Termina l'applicazione
                _lib.EndApplication(True)
            Else

                ' Memorizza la allarmi nella sessione corrente
                _lib.SetSessionObject("OperazioneCorrente", GetDataObject_Allarmi)

                ' Imposta il cliente generico
                On Error Resume Next
                Dim bUseLogged_Cliente = False
                If Not _session("g_objDSLoggedUser") Is Nothing Then
                    ' Deve essere un Cliente
                    If DirectCast(_session("g_objDSLoggedUser"), clsDataSource).Table.ObjectName = "Clienti" Then
                        bUseLogged_Cliente = True
                    End If
                End If
                If bUseLogged_Cliente Then
                    ' Imposta il cliente corrente
                    GetDataObject_Allarmi.SetValues("Cliente", DirectCast(_session("g_objDSLoggedUser"), clsDataSource).RowOID)
                Else
                    ' Imposta il cliente generico
                    GetDataObject_Allarmi.SetValues("Cliente", _glb.GetParam("DEFAULT_BUY_CUSTOMER_DESCRIPTION"))
                End If
                If _lib.CatchError("Impostazione cliente") Then
                    ' Termina l'applicazione
                    _lib.EndApplication(True)

                    ' Aggiorna la allarmi in archivio in modo da
                    ' ottenere il numero di ordine
                ElseIf Not _lib.UpdateRow(GetDataObject_Allarmi) Then
                    ' Termina l'applicazione
                    _lib.EndApplication(True)
                End If
                On Error GoTo 0

            End If

        End If

        ' Annulla il timer di controllo conflitti di inizializzazione
        _session("g_tmGetDataObject_Allarmi") = ""

    End Function

    ' Riporta il numero di allarmi attivi
    Function GetDataObject_NumeroAllarmi() As Long

        ' Cerca una allarmi già avviata nei dati di sessione
        Dim objAllarmi = _lib.GetSessionObject("OperazioneCorrente")

        ' Se non è presente nessuna allarmi riporta 0
        If IsNothing(objAllarmi) Then
            GetDataObject_NumeroAllarmi = 0
        Else
            GetDataObject_NumeroAllarmi = objAllarmi.GetReference("Elementi").CalculateColValueNum("Quantità", OODBMS_QueryCalcFunction.odbcSum)
        End If
        '
        objAllarmi = Nothing

    End Function

    ' Riporta il link per la ricerca	
    Function GetLinkSearchAll() As Object

        ' Identifica l'immagine utilizzata per la selezione
        ' degli elementi nel carrello
        Dim sSelImage = _glb.GetParam("IMAGE_SUBDIR") & "/" & _glb.GetParam("BASKET_SELECTION_IMAGE_RED")

        ' Identifica l'immagine utilizzata per la selezione
        ' dei links
        Dim sLinksImage = _glb.GetParam("IMAGE_SUBDIR") & "/" & _glb.GetParam("BASKET_DEFAULT_LINKS_IMAGE")

        ' Genera il link per la pagina degli elementi
        Dim sFields = ""
        If _session("g_blnUserLogged") OrElse _glb.GetBoolean(_glb.GetParam("VIEW_PRICES_WITHOUT_VALIDATION")) Then
            sFields = "Dispositivo,Descrizione,Immagine,Dettagli,Codice,PrezzoAllarmi"
        Else
            sFields = "Dispositivo,Descrizione,Immagine,Dettagli,Codice"
        End If
        GetLinkSearchAll = GetCompleteURL(_lib.GetPageFileName(_glb.GetParam("PAGE_NAME_DATA_GRID")), _
              FORM_SYS_FIELD_DATA_PATH & "=Elementi" & _
              "&" & FORM_SYS_FIELD_REQUEST_ACTION & "=" & ACTION_VIEW & _
              "&" & FORM_SYS_FIELD_ENABLE_SELECT & "=True" & _
              "&" & FORM_SYS_FIELD_ROW_SELECTION_IMAGE & "=" & sSelImage & _
              "&" & FORM_SYS_FIELD_READ_ONLY & "=True" & _
              "&" & FORM_SYS_FIELD_HIDE_TITLE_FUNCTIONS & "=True" & _
              "&" & FORM_SYS_FIELD_PRESENTATION_FIELDS & "=" & sFields & _
              "&" & FORM_SYS_FIELD_PREVIEW_FIELDS & "=Immagine:ImmagineAnteprima" & _
              "&" & FORM_SYS_FIELD_DEFAULT_LINKS_IMAGE & "=" & sLinksImage & _
              "&" & FORM_SYS_FIELD_SEARCH_SEQUENCE & "=Dispositivo,Descrizione,Produttore" & _
              "&" & FORM_SYS_FIELD_ORDER_FIELDS & "=Dispositivo,Descrizione")

    End Function


    ' Effettua le operazioni di inizializzazione della 
    ' sessione di lavoro impostando l'utente anonimo
    Function InitializeGuestSession(ByVal p_strContextName As String) As Boolean

        ' Inizializzazioni
        InitializeGuestSession = False

        ' Memorizza il contesto nell'ambito di lavoro
        _lib.SetWorkSpace(p_strContextName)

        ' Azzera il menù di un eventuale ambito precedente
        _lib.SetContentMenuURL("")

        ' Imposta un utente fittizio per le operazioni
        ' di accesso
        If Not _lib.UserLogin(_lib.ComposeUserID("", ""), OODBMS_UserAccessLevel.odulUserGuest, Nothing, False) Then
            ' Error in impostazione dell'utente
            Exit Function
        End If
        '
        InitializeGuestSession = True

    End Function

    ' -------------------------------------------------
    ' Scrive il codice lato Client per l'impostazione
    ' della destinazione in relazione ai parametri
    ' specificati e alla relativa azione configurata
    ' in <modSiteAction.aspx>.
    ' La chiamata avviene impostando anche il parametro
    ' aggiuntivo <FORM_SYS_FIELD_CLIENT_ACTION_FRAME>
    ' contenente il nome del frame sorgente.
    '
    ' N.B.: La destinazione può essere impostata
    '		con le seguenti costanti:
    '		<LOCATION_CONTINUE>
    '			Permette di proseguire con le funzionalità
    '			della pagina corrente, in questo caso
    '			non è prevista la chiamata ad altro 
    '			indirizzo (URL).
    '			(utilizzata per le operazioni di 'Refresh'
    '			 oppure per funzioni contestuali che
    '			 inviano richieste al server)
    '		<LOCATION_COMPLETED>
    '			Indica di terminare la pagina perchè
    '			la funzione richiesta è stata completata
    '			permettendone l'uscita, in questo caso
    '			non è prevista la chiamata ad altro 
    '			indirizzo (URL).
    '			(utilizzata per il completamento di
    '			 fasi elaborative)
    '
    ' Parametri:
    '	<p_strSourceName>
    '		Nome della pagina sorgente che fa la richiesta
    '		del Link di destinazione.
    '		Le costanti relative ai nomi delle pagine (PAGE_NAME_)
    '		sono definite in <Parameters.xml)
    '	<p_strAction>
    '		Nome dell'azione processata nella pagina sorgente
    '		Le costanti relative ai nomi delle azioni (ACTION_)
    '		sono definite in <mod_lib. Const.aspx>
    '	<p_strContextTableName>
    '		Nome della tabella che definisce il contesto 
    '		di azione della pagina sorgente.
    '		I nomi delle tabelle si riferiscono a quelli
    '		definiti nel database dell'applicazione
    '		Questo parametro è vuoto ("") se l'azione
    '		non ha effettuato operazioni sui dati 
    '	<p_bUseMainAppFrame>
    '		Impostare True per attivare la pagina nel
    '		frame principale dell'applicazione.
    '
    ' Riporta False se la destinazione non è stata definita, 
    ' altrimenti imposta la destinazione per il Client interrompendo
    ' la costruzione della pagina corrente.
    Function WriteClientDestinationActionEx(page As System.Web.UI.Page, _
                                            ByVal p_strSourceName As String, _
                                           ByVal p_strAction As String, _
                                           ByVal p_strContextTableName As String, _
                                           ByRef p_bUseMainAppFrame As Boolean) As Boolean

        ' Inizializza esito
        WriteClientDestinationActionEx = False

        ' Identifica la destinazione
        Dim sFrame As String = "", sError As String = ""
        Dim sLocation = GetDestLocation(page, p_strSourceName, p_strAction, p_strContextTableName, sFrame, sError)
        If sLocation = "" Then Exit Function

        ' Se non è stato specificato di continuare richiama
        ' la destinazione nella pagina lato Client
        If sLocation = LOCATION_COMPLETED Then

            ' Indica che la pagina è stata già completata
            page.Response.Write("<br><br>" & vbCrLf)
            _frm.WriteFunctionKey_AppExit()

            ' Interrompe la costruzione della pagina corrente
            _frm.Break_FormConstruction()
            'p_page.Response.End()

        ElseIf sLocation <> LOCATION_CONTINUE Then

            ' Imposta per aggiungere il parametro per il 
            ' frame sorgente
            WriteClientDestinationURL(page, sLocation, sFrame, p_bUseMainAppFrame)

        End If
        '
        WriteClientDestinationActionEx = True

    End Function
    '
    Sub WriteClientDestinationURL(page As System.Web.UI.Page, ByVal sLocation As String, _
                            Optional ByVal sFrame As String = "", _
                            Optional ByVal p_bUseMainAppFrame As Boolean = False)

        ' Aggiunge eventuale parametro per frame di destinazione
        sLocation = GetCompleteURL(sLocation, FORM_SYS_FIELD_CLIENT_ACTION_FRAME & "=")

        ' Imposta lo script lato Client
        'page.Response.Write("<script language=javascript FOR=window EVENT=onload>" & vbCrLf)
        page.Response.Write("<script>" & vbCrLf)

        ' Identifica il frame dell'applicazione corrente
        page.Response.Write("var sFrame = """", wnd = window.window;" & vbCrLf)
        If _session("g_strMainFrameName") <> "" Then
            ' Se il frame era già stato impostato verifica
            ' che esista nell'applicazione corrente
            ' altrimenti notifica il nuovo frame identificato
            page.Response.Write("if(!ExistFrame(""" & _session("g_strMainFrameName") & """)) {" & vbCrLf)
        End If

        ' Identifica il frame
        page.Response.Write("	if(wnd.parent.frames.length>0) {" & vbCrLf)
        If sFrame <> "" Then
            page.Response.Write("	if(!ExistFrame(""" & sFrame & """))" & vbCrLf)
            page.Response.Write("		sFrame = """ & sFrame & """;" & vbCrLf)
            page.Response.Write("	else" & vbCrLf)
        End If
        page.Response.Write("			sFrame = wnd.name;" & vbCrLf)
        page.Response.Write("	}" & vbCrLf)
        '
        If _session("g_strMainFrameName") <> "" Then
            page.Response.Write("}" & vbCrLf)
        End If

        ' Identifica il fame di destinazione
        If p_bUseMainAppFrame Then
            If _session("g_strMainFrameName") = "" Then
                page.Response.Write("if(wnd.parent.frames.length==0)" & vbCrLf)
                page.Response.Write("	wnd = GetApplicationFrame(); " & vbCrLf)
            Else
                page.Response.Write("wnd = GetApplicationFrame(); " & vbCrLf)
            End If
        End If
        If sFrame <> "" Then
            page.Response.Write("if(ExistFrame(""" & sFrame & """))" & vbCrLf)
            page.Response.Write("	wnd = GetFrame(""" & sFrame & """); " & vbCrLf)
        End If
        Dim sCompleteURL = _glb.GetCompletePageURL(sLocation, False)
        page.Response.Write("wnd.location = """ & sCompleteURL & """ + sFrame;" & vbCrLf)
        page.Response.Write(" </" & "Script>" & vbCrLf)

        ' Interrompe la costruzione della pagina corrente
        _frm.Break_FormConstruction()
        'page.Response.End()

    End Sub
    '
    Function WriteClientDestinationAction(page As System.Web.UI.Page, _
                                          ByVal p_strSourceName As String, _
                                            ByVal p_strAction As String, _
                                            ByVal p_strContextTableName As String) As Boolean

        Return WriteClientDestinationActionEx(page, p_strSourceName, p_strAction, p_strContextTableName, False)

    End Function

    ' -------------------------------------------------
    ' Imposta il tasto di ritorno all'inizio applicazione
    ' -------------------------------------------------
    Sub WriteFunctionKey_AppReturn(page As System.Web.UI.Page)

        ' Identifica la destinazione
        Dim sFrame As String = "", sError As String = ""
        Dim sLocation = GetDestLocation(page, _glb.GetParam("PAGE_NAME_APP_START"), ACTION_SELECT, _session("g_strAppWorkSpace"), sFrame, sError)
        If sLocation = "" Then Exit Sub

        ' Identifica il frame di destinazione
        If sFrame = "" Then
            If _session("g_strMainFrameName") <> "" Then
                sFrame = _session("g_strMainFrameName")
            Else
                sFrame = FRAME_CONTENT_PAGES
            End If
        End If

        ' Scrive lo script di ricerca della pagina
        ' principale per ritornare all'inizio
        ' dell'applicazione
        _frm.WriteLn("<script language=javascript>")
        _frm.WriteLn("function GoToAppStart() {")
        _frm.WriteLn("var wnd = window.window;")
        _frm.WriteLn("while( typeof( wnd.opener ) != ""undefined"" && wnd.opener != null )")
        _frm.WriteLn("	wnd = wnd.opener.window;")
        _frm.WriteLn("if( wnd != """ & sFrame & """ ) {")
        _frm.WriteLn("	try { wnd = wnd.top.frames[""" & sFrame & """].window; }")
        _frm.WriteLn("	catch(e) { if( wnd.parent.frames.length >0 ) wnd = wnd.parent.window; else wnd = wnd.top.window;}}")
        '_frm.WriteLn("wnd.location=""" & Server.HtmlEncode(sLocation) & """;")
        _frm.WriteLn("wnd.location=""" & sLocation & """;")
        _frm.WriteLn("}</" & "Script>")

        ' Imposra il link per ritornare all'applicazione
        If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
            _frm.WriteLn("<INPUT TYPE=BUTTON OnClick=""javascript:GoToAppStart()""" & " VALUE="" Riavvia "" TITLE=""Riavvia l'applicazione"">")
        Else
            _frm.WriteLn("<INPUT TYPE=BUTTON OnClick=""javascript:GoToAppStart()""" & " VALUE="" Restart "" TITLE=""Restart application"">")
        End If

    End Sub

    ' -------------------------------------------------
    ' Imposta il tasto di uscita dal form corrente
    ' Ritorna al menù se definito, altrimenti riparte
    ' dall'inizio applicazione.
    ' Vedi anche _lib. SetContentMenuURL()
    '
    ' N.B.: Lo script lato Client implementato per 
    '		l'uscita tenta di identificare il frame
    '		principale per i contenuti <FRAME_CONTENT_PAGES>
    '		oppure quello memorizzato in <g_strMainFrameName>
    '		se tale frame non è stato impostato effettua
    '		l'operazione nel frame principale.
    ' -------------------------------------------------
    Function ValidFunctionKey_Exit(page As System.Web.UI.Page) As Boolean     ' Riporta True se esiste un link valido per il ritorno alla funzione precedente
        If _session("g_strContentMenuURL") <> "" _
                OrElse (_session("g_strReturnAppURL") <> "" _
                     AndAlso InStr(_session("g_strReturnAppURL"), page.Request.ServerVariables.Item("URL"), vbTextCompare) = 0) _
                OrElse (_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) <> "" _
                     AndAlso InStr(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL), page.Request.ServerVariables.Item("URL"), vbTextCompare) = 0) Then
            Return True
        End If
        Return False
    End Function
    Sub WriteFunctionKey_Exit(page As System.Web.UI.Page)
        WriteFunctionKey_FormExit(page)
    End Sub
    Sub WriteFunctionKey_FormExit(Page As System.Web.UI.Page, _
                                  Optional ByVal p_strAction As String = "", _
                                  Optional ByVal p_strContextWorkSpace As String = "")

        ' Identifica la destinazione
        ' - Se definito il menù vi ritorna
        ' - Altrimenti riparte dall'inizio applicazione
        Dim sCaption As String, sTip As String
        Dim sLocation As String, sFrame As String = ""
        Dim sError As String = ""

        If _session("g_LocaleLanguage") = OODBMS_LocaleLanguage.ollItalian Then
            sCaption = "<  Indietro " ' Esci / Indietro / Ritorna
            sTip = "Esce dall'operazione corrente"
        Else
            sCaption = "<  Back " ' Esci / Indietro / Ritorna
            sTip = "Exit current operation"
        End If
        '
        If _glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) <> "" _
                    AndAlso InStr(URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL)), Page.Request.ServerVariables.Item("URL"), vbTextCompare) = 0 Then
            sLocation = URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL))
        ElseIf _session("g_strReturnAppURL") <> "" _
                    AndAlso InStr(_session("g_strReturnAppURL"), Page.Request.ServerVariables.Item("URL"), vbTextCompare) = 0 Then
            sLocation = _session("g_strReturnAppURL")
            sFrame = _session("g_strReturnAppFrame")
            'ElseIf _session("g_strContentMenuURL") <> "" Then
            '    sLocation = _session("g_strContentMenuURL")
        Else
            Dim sPage As String = _lib.GetCurrentPageName(Page)
            sLocation = GetDestLocation(Page, _
                                        If(sPage <> "", sPage, _glb.GetParam("PAGE_NAME_APP_START")), _
                                        If(p_strAction <> "", p_strAction, ACTION_SELECT), _
                                        If(p_strContextWorkSpace <> "", p_strContextWorkSpace, _session("g_strAppWorkSpace")), _
                                        sFrame, sError, LOCATION_CONTINUE)
            If sLocation = "" OrElse sLocation = LOCATION_CONTINUE Then
                sLocation = _session("g_strContentMenuURL")
            End If
        End If

        ' Identifica il frame di destinazione
        If sFrame = "" Then
            If _session("g_strMainFrameName") <> "" Then
                sFrame = _session("g_strMainFrameName")
            Else
                sFrame = FRAME_CONTENT_PAGES
            End If
        End If

        ' Scrive lo script di uscita dalla pagina
        ' corrente, se si tratta di form principale
        ' ritorna all'inizio applicazione
        _frm.WriteLn("<script language=javascript>")
        ' Eventuale messaggio di errore
        If sError <> "" Then
            _frm.WriteLn("alert(""" & Replace(sError, vbCr, "\n") & """);")
        End If
        _frm.WriteLn("function FormExit() {")
        '	_frm.WriteLn "if( typeof( window.top.opener ) != ""undefined"" )"
        _frm.WriteLn("if( typeof( window.opener ) != ""undefined"" && window.opener != null )")
        _frm.WriteLn("	window.top.close();")
        _frm.WriteLn("else")
        _frm.WriteLn("{")
        _frm.WriteLn("	var wnd = window.window;")
        _frm.WriteLn("	if( wnd.name != """ & sFrame & """ ) {")
        _frm.WriteLn("		try { wnd = window.top.frames[""" & sFrame & """].window; }")
        _frm.WriteLn("		catch(e) { if( window.parent.frames.length >0 ) wnd = window.parent.window; else wnd = window.top.window;}}")
        '_frm.WriteLn("	wnd.location=""" & Server.HtmlEncode(sLocation) & """;")
        _frm.WriteLn("	wnd.location=""" & sLocation & """;")
        _frm.WriteLn("}")
        _frm.WriteLn("}</" & "Script>")

        ' Imposra il link per uscire dal form
        _frm.WriteLn("<INPUT TYPE=BUTTON OnClick=""javascript:FormExit()"" " & _glb.GetParam("HTML_FIXED_EXIT_BUTTON_STYLE") & " VALUE=""" & sCaption & """ TITLE=""" & sTip & """>")

    End Sub

    ' -------------------------------------------------
    ' Inizializza gli oggetti per l'applicazione corrente 
    ' e riporta True se è possibile.
    '   <p_objPage>
    '       Istanza della pagina corrente
    '   <p_blnEnableStart>
    '		Impostare True se si tratta di una pagina
    '		di avvio, in questo caso viene effettuata
    '		l'inizializzazione dell'applicazione se
    '		si tratta di primo accesso
    '	<p_blnProgressMessages>
    '		Impostare a False per inibire la visualizzazione
    '		dei messaggi durante l'inizializzazione
    '
    ' Richiamare all'inizio di ogni pagina prima
    ' di accedere al codice nel seguente modo
    '
    '   Dim _site = Site(Page)
    '
    '	' Eventuale inizializzazione dell'applicazione 
    '	If Not InitApplicationObjects(Me) Then
    '		p_page.Response.End	
    '	End If
    '	....	' OPPURE
    '	If Not InitApplicationObjects(Me,True,False) Then
    '		p_page.Response.Write( "Impossibile continuare.")
    '		p_page.Response.End	
    '	End If
    '	....
    '	....	' OPPURE
    '	If Not InitApplicationObjects(Me,False,False) Then
    '		p_page.Response.Write( "Applicazione terminata o sessione scaduta.")
    '		p_page.Response.End	
    '	End If
    '	....
    '	....	' OPPURE
    '	If Not InitApplicationObjects(Me,False,True) Then
    '		' Termina l'applicazione
    '		_lib. EndApplication(True)
    '	End If
    '
    ' -------------------------------------------------
    Public Function InitApplicationObjects( _
               ByRef p_objPage As System.Web.UI.Page, _
               Optional ByVal p_blnEnableStart As Boolean = True, _
               Optional ByVal p_blnProgressMessages As Boolean = True) As Boolean       ' Solo per compatibilità con versioni precedenti
        Return InitApplicationObjects(p_blnEnableStart, p_blnProgressMessages)
    End Function
    '
    Public Function InitApplicationObjects( _
               Optional ByVal p_blnEnableStart As Boolean = True, _
               Optional ByVal p_blnProgressMessages As Boolean = True) As Boolean

        ' Inizializza il modulo globale
        'InitializeGlobal(p_objPage)
        _glb.InitializeGlobal()

        ' Eventuale inizializzazione dell'applicazione 
        InitApplicationObjects = False
        If _lib.IsSessionRequestCompanyChange() Then

            ' [*** FUNZIONAMENTO GESTIONE AZIENDA ***]
            ' Validazione dei dati relativi all'azienda
            ' N.B.: i parametri predefiniti relativi alle aziende sono memorizzati nel file 'Config\Parameters.xml'
            '       ma possono essere modificati mediante l'impostazione dei seguenti parametri nella richiesta
            '       della pagina di avvio (che richiama questa procedura):
            '           "COMPANY_NAME"
            '           "DATABASE_CONNECTION_STRING"
            '           "COMPANY_DESCRIPTION"
            '       NOTA: la variazione dei parametri sopra descritti avviene solo a livello di sessione, mentre
            '             l'azienda predefinita rimane quella specificata nel file ('Config\Parameters.xml')
            '             La funzione _glb.GetParam (collegata a GetRequestField) viene quindi virtualizzata 
            '             per questi parametri in modo da rendere trasparente all'applicazione i dati dell'azienda
            '             correntemente selezionata (vedi anche relative funzioni di gestione dell'azienda in
            '             mod_lib. Lib)
            '       L'impostazione di tali parametri comporta l'eventuale creazione dell'azienda (se non presente)
            '       e la relativa generazione dell'archivio (se previsto) e l'aggiornamento della lista delle aziende
            '       gestite e relativi parametri, vedere
            '           "COMPANY_LIST"
            '           "DATABASE_CONNECTION_STRING_[COMPANY_NAME]"
            '           "COMPANY_DESCRIPTION_[COMPANY_NAME]"
            If Not _lib.IsCompanyConfigured(_glb.RequestField("COMPANY_NAME")) Then
                ' Salva i parametri dell'azienda se differente da quella predefinita
                If Not _lib.IsSessionDefaultCompany() Then
                    SaveCompanyParameters(_glb.RequestField("COMPANY_NAME"), _glb.RequestField("DATABASE_CONNECTION_STRING"), _glb.RequestField("COMPANY_DESCRIPTION"))
                End If
            End If
            _lib.ValidateSessionCompanyParameters()

            ' Termina l'applicazione per l'azienda precedente
            _lib.EndApplication(False)

        End If
        If _lib.ApplicationStarted() Then
            '_glb.RspMsg("Started")
            '            _glb.RspMsg(VarType(_session("g_objLib")) & " / " & (_session("g_objLib") Is Nothing) & " - " & InvalidSessionObject("g_objLib"))
            '            _glb.RspMsg(VarType(_session("g_objDBAsp")) & " / " & (_session("g_objDBAsp") Is Nothing) & " - " & InvalidSessionObject("g_objDBAsp"))
            '            _glb.RspMsg(VarType(_session("g_objDataLink")) & " / " & (_session("g_objDataLink") Is Nothing) & " - " & InvalidSessionObject("g_objDataLink"))
            '_glb.RspMsg("Test-Started")

            'If Not _lib. InitializeGlobalObjects(p_objPage) Then
            If Not _lib.InitializeGlobalObjects() Then
                ' Applicazione non valida
                Exit Function
            End If

            ' Applicazione già avviata
            InitApplicationObjects = True

            ' Avvia l'applicazione se possibile		
        ElseIf p_blnEnableStart Then

            '_glb.RspMsg("Start")
            ' Instanzia le Business Class dell'applicazione
            ' mediante l'oggetto di interfaccia Asp / Asp.Net
            Dim objBusinessAspDBLib As New EasyContentManagerDB.DBAsp

            ' Eventuale disabilitazione del pagamento con carta di credito
            objBusinessAspDBLib.CreditCardDisabled = _glb.GetBoolean(_glb.GetParam("CREDIT_CARD_DISABLED"))

            ' Eventuale disabilitazione dei pagamenti mediante circuiti postali (CONTRASSEGNO,BOLLETTINO,POSTE PAY, ecc)
            objBusinessAspDBLib.PostePayDisabled = _glb.GetBoolean(_glb.GetParam("POSTE_PAY_DISABLED"))

            ' Avvia l'applicazione
            Dim bCheckUpdateStruct As Boolean = True
            Dim bIgnoreUserLogin As Boolean = False
            '
            If Not _lib.StartApplication(objBusinessAspDBLib, _glb.GetParam("APP_NAME"), _glb.GetParam("DATABASE_TYPE"), _
                                            bCheckUpdateStruct, p_blnProgressMessages, _
                                            bIgnoreUserLogin) Then
                'If Not _lib. StartApplication(p_objPage, objBusinessAspDBLib, _glb.GetParam("APP_NAME"), _glb.GetParam("DATABASE_TYPE"), _
                '                                bCheckUpdateStruct, p_blnProgressMessages) Then
                ' Termina l'applicazione
                _lib.EndApplication(False)
                '
                Exit Function
            End If

            ' Inizializzazione dell'indirizzario interno per la gestione dei documenti/immagini condivise
            Dim sDocPath As String = Server.MapPath(_glb.GetParam("DOCUMENT_SUBDIR"))
            If sDocPath <> "" Then
                ' Imposta l'indirizzario di base per tutte le operazioni di identificazione del percorso assoluto (mediante le apposite funzioni della connessione)
                _lib.GetDataLink().Connection.RelativeBaseFilePath(_lib.GetDataLink().Database.AppName) = sDocPath
                ' N.B.: La libreria (OOWebLib) può utilizzare le funzioni globali di identificazione indirizzari assoluti senza passare dalla connessione (vedi GetAbsoluteFilePath)
                _lib.GetDataLink().Database.RelativeBaseFilePath(_lib.GetDataLink().Database.AppName) = sDocPath
                ' *** Impostate solo per compatibilità con versioni precedenti
                _lib.GetDataLink().Database.RelativeBaseFilePath("") = sDocPath
            End If

            ' Carica eventuali tabelle personalizzate
            Dim objMyTbls As OODBMSObjLib.clsDataSource = Nothing
            If _lib.GetDataSource(objMyTbls, "TabellePersonali") Then
                While Not objMyTbls.EOF
                    If EasyContentManagerDB.MyTable_CheckUpdate(objMyTbls) Then
                    End If
                    objMyTbls.RowNext()
                End While
            End If

            ' **** Disabilita i bloccaggi in multiutenza per velocizzare gli accessi
            With _lib.GetDataLink().Connection
                .MultiUserDataLock = OODBMS_LockMode.oloLockNone
                .CacheDisable()
            End With

            '_glb.RspMsg("End-Start")
            ' Imposta eventuale linguaggio di presentazione
            _lib.SelLocaleLanguage(_glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))

            ' Imposta il livello di accesso ospite (guest)
            ' N.B.: con livelli di accesso superiore è
            '       necessaria la validazione dell'utente
            _lib.SetUserAccessLevel(OODBMS_UserAccessLevel.odulUserGuest)

            ' Applicazione avviata
            InitApplicationObjects = True

            End If
            '
            If Not InitApplicationObjects And p_blnProgressMessages Then
                _glb.RspErr("Applicazione non avviata.")

                ' Imposta eventuale URL della pagina di uscita
                'Else
                '
                '    If _glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) <> "" Then
                '        If _glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) = "_this_" Then
                '	        _lib. SetReturnAppURL(GetCurrentURL())  'Request.ServerVariables.Item("HTTP_REFERER"))
                '        Else
                '	        _lib. SetReturnAppURL(URLParamDecode(_glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL)))
                '        End If
                '    End If

            End If

    End Function

    ' Accoda i parametri specificati all'URL 
    Function GetCompleteURL(ByVal p_strURL As String, _
           ByVal p_strAddParams As String) As String

        If InStr(p_strURL, "?") > 0 Then
            GetCompleteURL = p_strURL & "&" & p_strAddParams
        Else
            GetCompleteURL = p_strURL & "?" & p_strAddParams
        End If

    End Function

    ' Riporta l'URL corrente compreso i parametri della pagina
    Function GetCurrentURL(ByRef page As System.Web.UI.Page) As String
        Dim sParams As String = page.Request.ServerVariables.Item("QUERY_STRING")
        If sParams = "" Then
            ' Se non sono presenti i campi nell'URL allora tenta di recuperare quelli del form
            sParams = _glb.GetURLQuerySysFields()
        End If
        GetCurrentURL = page.Request.ServerVariables.Item("URL")
        If sParams <> "" Then
            GetCurrentURL &= "?" & sParams
        End If
    End Function

    ' Codifica / Decodifica dell'URL per evitarne l'interpretazione all'interno di un altro URL
    Function URLParamEncode(ByVal p_strURL As String) As String
        URLParamEncode = Replace(p_strURL, "?", "||")
        URLParamEncode = Replace(URLParamEncode, "=", "|_")
        URLParamEncode = Replace(URLParamEncode, "&", "__")
    End Function
    Function URLParamDecode(ByVal p_strURL As String) As String
        URLParamDecode = Replace(p_strURL, "||", "?")
        URLParamDecode = Replace(URLParamDecode, "|_", "=")
        URLParamDecode = Replace(URLParamDecode, "__", "&")
    End Function

    ' Aggiorna i parametri di configurazione dell'azienda nel file in modo permanente
    Public Sub SaveCompanyParameters(p_sCompanyName As String, _
                                Optional p_sConnectionString As String = "", _
                                Optional p_sCompanyDescription As String = "")

        Dim sCompanyList As String = _glb.GetParam("COMPANY_LIST")
        Dim sInsAfter As String = "COMPANY_DESCRIPTION"
        If InStr("|" & sCompanyList & "|", "|" & p_sCompanyName & "|", CompareMethod.Text) = 0 Then
            ' Salva nuova azienda
            sCompanyList &= "|" & p_sCompanyName
            SaveParam("COMPANY_LIST", sCompanyList, sInsAfter)
        End If
        sInsAfter = "COMPANY_LIST"

        ' Salva la relativa stringa di connessione
        If p_sConnectionString <> "" Then
            SaveParam("DATABASE_CONNECTION_STRING_" & p_sCompanyName, p_sConnectionString, sInsAfter)
            sInsAfter = "DATABASE_CONNECTION_STRING_" & p_sCompanyName
        End If
        ' Salva eventuale descrizione
        If p_sCompanyDescription <> "" Then
            SaveParam("COMPANY_DESCRIPTION_" & p_sCompanyName, p_sCompanyDescription, sInsAfter)
        End If

    End Sub
    ' Salva il parametro nel file di configurazione
    Public Sub SaveParam(ByVal p_sName As String, _
                                ByVal p_strValue As String, _
                                Optional ByVal p_strAfterName As String = "")
        ' Aggiorna il file
        Dim sFile As String = Server.MapPath("~\Config\Parameters.xml")
        Dim xml As New System.Xml.XmlDocument
        xml.InnerXml = _glb.ReadFile(sFile)
        With xml.ChildNodes(1)
            Dim e As System.Xml.XmlElement = Nothing
            Dim aft As System.Xml.XmlElement = Nothing
            For Each find As System.Xml.XmlNode In .ChildNodes
                If UCase(find.Name) = "ADD" Then
                    With find.Attributes.ItemOf("key")
                        If UCase(.Value) = UCase(p_sName) Then
                            e = find
                            Exit For
                        End If
                        If UCase(.Value) = UCase(p_strAfterName) Then aft = find
                    End With
                End If
            Next
            If e Is Nothing Then
                ' Aggiunge l'elemento
                Dim a As System.Xml.XmlAttribute
                e = xml.CreateElement("add")
                ' Crea gli attributi Key e Value
                a = xml.CreateAttribute("key")
                a.Value = p_sName
                e.Attributes.Append(a)
                a = xml.CreateAttribute("value")
                a.Value = p_strValue
                e.Attributes.Append(a)
                '
                If p_strAfterName <> "" Then
                    If aft Is Nothing Then
                        .AppendChild(e)
                    Else
                        .InsertAfter(e, aft)
                    End If
                Else
                    .AppendChild(e)
                End If
            Else
                e.Attributes.ItemOf("value").Value = p_strValue
            End If
        End With
        xml.Save(sFile)

        'With System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~\Config\Parameters.xml")
        '    Dim bFound As Boolean = False
        '    For Each k As String In .AppSettings.Settings.AllKeys
        '        If UCase(k) = UCase(p_sName) Then
        '            bFound = True
        '            Exit For
        '        End If
        '    Next
        '    If bFound Then
        '        .AppSettings.Settings.Item(p_sName).Value = p_strValue
        '    Else
        '        .AppSettings.Settings.Add(p_sName, p_strValue)
        '    End If
        '    .SaveAs(Server.MapPath("~\Config\Parameters.xml"), ConfigurationSaveMode.Full)
        '    '.Save(ConfigurationSaveMode.Modified)
        'End With

        ' Aggiorna anche la sessione
        _glb.SetParam(p_sName, p_strValue)
    End Sub

End Class
