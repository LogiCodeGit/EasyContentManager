<%
' Controlla l'uscita dall'applicazione per chiudere la sessione
' corrente e distruggere tutte le transazioni rimaste attive
'
' Includere questa pagina in un frame invisibile.
%>
<html>
<head>
<title>Logout Frame</title>
<base target="LogoutFrame">
</head>
<body>
<i>end session control...</i>
</body>

<SCRIPT LANGUAGE="JavaScript">
<!--
// Funzione presente anche in srcClientScriptForm
function NewHttpRequest() {
    var xmlhttp = false;
    try {
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            xmlhttp = false;
        }
    }
    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
        try {
            xmlhttp = new XMLHttpRequest();
        } catch (e) {
            xmlhttp = false;
        }
    }
    if (!xmlhttp && window.createRequest) {
        try {
            xmlhttp = window.createRequest();
        } catch (e) {
            xmlhttp = false;
        }
    }
    //
    if (xmlhttp)
        return xmlhttp;
    else
        return undefined;
}

function EndSession()
{
	// Richiama la pagina che effettua la chiusura dell'applicazione
	// <frmAppEnd.asp>
    try {
        // Effettua prima un tentativo nella pagina corrente
         var req = NewHttpRequest();
//         req.open("GET", "frmAppEnd.aspx", true);
//         req.onreadystatechange = function() {
//             if (req.readyState == 4) {
//                 alert(req.responseText);
//             }
         //         }
         req.open("GET", "frmAppEnd.aspx", false);
         req.send(null);
         //window.location = "frmAppEnd.aspx";
    }
    catch (e) {
        // Richiama la pagina pop-up se la chiusura precedente non è riuscita
        try {
            window.open("frmAppEnd.aspx", "EndSession", "width=1,height=1,status=no,location=no,menubar=no,scrollbars=no");
        }
        catch (e) { }
    }
 }
window.onunload = EndSession;
//-->
</SCRIPT>
</html>

