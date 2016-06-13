<%
' Pagina di inizializzazione dell'applicazione.
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	05/04/2003
'
' Parametri da specificare in entrata (Request):
'	
'	FORM_SYS_FIELD_APP_CONTEXT_NAME = "ooSYS_AppContextName"
'		Nome del contesto di elaborazione.
'		Questo parametro viene passato a <GetDestLocation()>
'		per richiedere la destinazione iniziale in relazione
'		al contesto indicato, il contenuto viene solitamente usato per 
'		impostare l'ambito di lavoro corrente (vedi _site.Lib.SetWorkSpace())
'		in modo da definire l'inizio di un'operazione o di un
'		percorso elaborativo. 
'	FORM_SYS_FIELD_RETURN_APP_URL = "ooSYS_ReturnAppURL"	 (opzionale)
'		Eventuale URL della pagina da richiamare all'uscita
'		dall'applicazione.
'		Impostare "_this_" per indicare di ritornare alla
'		pagina chiamante.
'	FORM_SYS_FIELD_RETURN_APP_FRAME = "ooSYS_ReturnAppFrame" (opzionale)
'		Eventuale Frame della pagina da richiamare all'uscita
'		dall'applicazione, se non specificato cerca di identificare
'		quello principale (Contents)
'   FORM_SYS_FIELD_REDIRECT_CONTENT_URL = "ooSYS_RedirectURL" (opzionale)
'       Eventuale URL della pagina di destinazione dopo le
'       varie inizializzazioni
'       Il parametro può essere impostato anche nella sessione (Session)
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	 (opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese
'  
'   N.B.: E' possibile gestire o attivare un'altra azienda direttamente dai parametri specificando il nome (COMPANY_NAME)
'         la descrizione (COMPANY_DESCRIPTION) e l'eventuale stringa di connessione dati (DATABASE_CONNECTION_STRING)
'         se differente dal tipo di DB predefinito.
'         [*** FUNZIONAMENTO GESTIONE AZIENDA ***]
'           N.B.: i parametri predefiniti relativi alle aziende sono memorizzati nel file 'Config\Parameters.xml'
'                 ma possono essere modificati mediante l'impostazione dei seguenti parametri nella richiesta
'                 della pagina di avvio (che richiama questa procedura):
'           "COMPANY_NAME"
'           "DATABASE_CONNECTION_STRING"
'           "COMPANY_DESCRIPTION"
'       NOTA: la variazione dei parametri sopra descritti avviene solo a livello di sessione, mentre
'             l'azienda predefinita rimane quella specificata nel file ('Config\Parameters.xml')
'             La funzione _site.Glb.GetParam (collegata a GetRequestField) viene quindi virtualizzata 
'             per questi parametri in modo da rendere trasparente all'applicazione i dati dell'azienda
'             correntemente selezionata (vedi anche relative funzioni di gestione dell'azienda in
'             modOODBMS_Lib)
'       L'impostazione di tali parametri comporta l'eventuale creazione dell'azienda (se non presente)
'       e la relativa generazione dell'archivio (se previsto) e l'aggiornamento della lista delle aziende
'       gestite e relativi parametri, vedere
'           "COMPANY_LIST"
'           "DATABASE_CONNECTION_STRING_[COMPANY_NAME]"
'           "COMPANY_DESCRIPTION_[COMPANY_NAME]"
'
' Azioni attivate da questa pagina (PAGE_NAME_APP_START):
'		- ACTION_FIRST_ACCESS, nome del contesto in FORM_SYS_FIELD_APP_CONTEXT_NAME
'			Applicazione avviata.

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Application Start"

' Imposta l'Header in modo da abilitare l'accesso
' degli oggetti di sessione anche se l'applicazione
' viene eseguita all'interno di un frame
WriteHeadSessionObjFrameAccess(Me)

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

<b><i>LOADING...</i></b>
<br><br>
<%
' Eventuale inizializzazione dell'applicazione 
If Not _site.InitApplicationObjects(Me) Then
	Response.Write( "Impossibile continuare.")
	Response.End	
End If

' Imposta eventuale URL della pagina di uscita
If _site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL) = "_this_" Then
	_site.Lib.SetReturnAppURL(_site.GetCurrentURL(Page))  'Request.ServerVariables.Item("HTTP_REFERER"))
Else
	_site.Lib.SetReturnAppURL(_site.URLParamDecode(_site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_URL)))
End If

' Imposta eventuale Frame della pagina di uscita
If _site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_FRAME) <> "" Then
	_site.Lib.SetReturnAppFrame(_site.Glb.RequestField(FORM_SYS_FIELD_RETURN_APP_FRAME))
End If

' Applicazione avviata.
' Identifica la destinazione dopo la partenza
If _site.Glb.RequestField(FORM_SYS_FIELD_REDIRECT_CONTENT_URL) <> "" Then
    ' Ridirige la destinazione all'indirizzo richiesto
    _site.WriteClientDestinationURL(Page, _site.URLParamDecode(_site.Glb.RequestField(FORM_SYS_FIELD_REDIRECT_CONTENT_URL)))
ElseIf Session(FORM_SYS_FIELD_REDIRECT_CONTENT_URL) <> "" Then
    ' Ridirige la destinazione all'indirizzo impostato nel parametro della sessione
    Dim sRedirect As String = Session(FORM_SYS_FIELD_REDIRECT_CONTENT_URL)
    Session(FORM_SYS_FIELD_REDIRECT_CONTENT_URL) = ""
    _site.WriteClientDestinationURL(Page, sRedirect)
ElseIf Not _site.WriteClientDestinationAction(Page, _site.Glb.GetParam("PAGE_NAME_APP_START"), ACTION_FIRST_ACCESS, Request(FORM_SYS_FIELD_APP_CONTEXT_NAME)) Then
	_site.Lib.EndApplication(True)
End If

' Imposta eventuale linguaggio di presentazione
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	_site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))
End If
%>
</BODY>
</HTML>

