<%
' Pagina iniziale dei contenuti.
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	05/04/2003
'
' Parametri da specificare in entrata (Request):
'	
'	FORM_SYS_FIELD_LOCALE_LANGUAGE = "ooSYS_LocaleLanguage"	(opzionale)
'		Eventuale linguaggio di presentazione, supportati:
'			0, Italian		Imposta l'italiano (predefinito)
'			1, English		Imposta l'inglese

' Costanti di definizione della pagina
Const PAGE_DESCRIPTION As String = "Content Entry Page"

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

<html>
	<head>
		<title>Content Entry Page</title>
		<LINK REL=stylesheet HREF="<%=_site.Glb.GetParam("MODULE_STYLE_SHEET")%>" type="text/css">
	</head>
	<!--<body style="BACKGROUND-REPEAT: no-repeat"><IMG src="Immagini/SfondoMagneto.JPG" width=100% height=100% border="0">-->
	<!--<body MS_POSITIONING="GridLayout" background="Immagini/SfondoMagneto.JPG" style="BACKGROUND-REPEAT: no-repeat"><IMG style="Z-INDEX: 101; LEFT: 8px; POSITION: absolute; TOP: 8px" alt="" src="Immagini/UnderCostruction.gif" align="middle" border="0">-->

<%

' Eventuale inizializzazione dell'applicazione 
If Not _site.InitApplicationObjects(Me,True,False) Then
	Response.End	
End If

' Imposta eventuale linguaggio di presentazione
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
	_site.Lib.SelLocaleLanguage(_site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE))
End If
%>

<%
If _site.Glb.RequestField(FORM_SYS_FIELD_LOCALE_LANGUAGE) <> "" Then
%>
<script language="javascript">

    // Aggiorna i frames per eventuale situazione carrello e lingua
    //ReloadFrame("Title");
    ReloadFrame("Links");
    //ReloadFrame("RightLinks");

</script>
<%
End If
%>

<script language="javascript">
    window.location = 'CustomHelloDefault.aspx';
</script>
<body>

<%
' < Inclusione dell'intestazione >
%>
<!-- #INCLUDE FILE="CustomHeader.aspx" -->

</body>
</html>
