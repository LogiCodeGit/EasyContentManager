<%
' N.B.: per ulteriori informazioni sulla proprietà 'ValidateRequest'
'		leggere il documento (How To: Protect From Injection Attacks in ASP.NET)
'		http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnpag2/html/paght000003.asp
'		In relatà l'impostazione a 'false' è necessaria solo per la pagina
'		'frmDataRow.aspx' che permette l'invio di campi (FORM) con
'		codice HTML
%>
<%@ Page ValidateRequest="false" %>
<!--
	Parametri necessari:
		FORM_SYS_FIELD_DATA_PATH = "Richieste"
		FORM_SYS_FIELD_REQUEST_ACTION = ACTION_ADD_NEW
-->
<%
' < Inclusione modulo di gestione delle azioni per l'applicazione >
%>
<!-- #INCLUDE FILE="Config/modSiteAction.aspx" -->

<html>
<head>
<title>Info & FAQ</title>
<%
' Se la richiesta non è valida rilancia l'intera operazione
Dim bEnd As Boolean = False
If _site.Glb.RequestField(FORM_SYS_FIELD_DATA_PATH) = "" Or _site.Glb.RequestField(FORM_SYS_FIELD_REQUEST_ACTION) = "" Then
    bEnd = True
%>
    <meta http-equiv="Refresh" content="0; url=frmAppStart.aspx?<%=FORM_SYS_FIELD_APP_CONTEXT_NAME%>=RequestAndInfo&<%=FORM_SYS_FIELD_RETURN_APP_URL%>=<%=_site.Lib.GetPageFileName(_site.Glb.GetParam("PAGE_NAME_CONTENT_START_FIRST"))%>" />
<%
End If
%>
</head>
<body>

<%
If Not bEnd Then
    IF Not Session("g_blnUserLogged") Then
%>
    <br>
    <hr><br><center>
    Per le tue richieste (FAQ) puoi scrivere una e-mail a <A href="mailto:<%=_site.Glb.GetParam("ADMIN_SUPPORT_EMAIL")%>"><%=_site.Glb.GetParam("ADMIN_SUPPORT_NAME")%></A> oppure più semplicemente compilare il modulo che segue.
    <!--
    <br />
    Per rendere la richiesta privata e interrogabile mediante il proprio profilo si consiglia di effettuare prima l'accesso 
        <a href="frmAppStart.aspx?<%=FORM_SYS_FIELD_APP_CONTEXT_NAME%>=<%=_site.Glb.GetParam("CONTEXT_NAME_CUSTOMER_AREA")%>&<%=FORM_SYS_FIELD_RETURN_APP_URL%>=_this_">
        CLIENTE
        </a>
    -->
    .
    </center><BR>
    <hr>
<%
    End If
%>
<%
    ' < Pagina di gestione del form 'Richieste Web'>
    Server.Execute("frmDataRow.aspx")
End If
%>

<!-- INCLUDE FILE="frmDataRow.aspx" -->

</body>
</html>
