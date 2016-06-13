<%
' Pagina di visualizzazione News e Informazioni di tipo a scorrimento
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	12/01/2004

' E' necessario impostare la var. di sessione PAGE_FRAME_INFO_FILTER
' prima di includere questa pagina per filtrare solo le informazioni
' relative al Frame specificato.

%>

<HTML>
<BODY>
<%

' Eventuale inizializzazione dell'applicazione 
If Not _site.InitApplicationObjects(Me,True,False) Then
	Response.Write( "Applicazione terminata o sessione scaduta.")
	Response.End	
End If

' Identifica le specifiche della tabella con le Notizie
' e tutti i dati relativi a notizie valide di tipo a 
' scorrimento
Dim strWhereScr = ""
With _site.DatLink.Table("NotizieWeb")
	'UPGRADE_WARNING: Date was upgraded to Today and has a new behavior. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1041"'
	strWhereScr = .GetFieldQueryCriteria("DataInizioValidità", CDate(ToDay), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchLessOrEqual)
	'UPGRADE_WARNING: Use of Null/IsNull() detected. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1049"'
	'UPGRADE_WARNING: Date was upgraded to Today and has a new behavior. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1041"'
	strWhereScr = strWhereScr & " AND (" & .GetFieldQueryCriteria("DataFineValidità", CDate(ToDay), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchGreaterOrEqual) & " OR " & .GetFieldQueryCriteria("DataFineValidità", System.DBNull.Value) & ")"
	strWhereScr = strWhereScr & " AND Scorrimento"
End With
'If Session("PAGE_FRAME_INFO_FILTER") > "" Then
'	strWhereScr = strWhereScr & " AND CorniceDestinazione='" & Session("PAGE_FRAME_INFO_FILTER") & "'"
'End If
'
Dim objNewsScr As OODBMSObjLib.clsDataSource
If Not _site.Lib.GetDataSource(objNewsScr, "NotizieWeb", False, strWhereScr, "DataInizioValidità", "", 0) Then
	_site.Frm.Break_FormConstruction()
End If

' Solo se presenti
If Not objNewsScr.DataEmpty Then
	
	' Imposta l'oggetto di sessione da passare
	' al frame
	Session("g_objNewsScroll") = objNewsScr
	%>
<table cellSpacing="0" cellPadding="0" width="100%" border="0">
	<tbody>
		<tr><td bgColor="#999999">

			<table cellSpacing="1" cellPadding="1" width="100%" border="0">
			  <tbody>
			<%	
	Dim sCaptionScr = ""
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sCaptionScr = "Novità e Informazioni"
	Else
		sCaptionScr = "News and Informations"
	End If
	%>          
				<tr>
				  <td bgColor="#f0f0f0"><font face="verdana, arial" color="#666666" size="1"><img border="0" src="images/SignalNotFilled.gif" width="5" height="9">&nbsp;<b><%=sCaptionScr%></b></font><br>
				  </td>
				</tr>
				<tr>
			    <td bgColor="#f0f0f0">
		
					<iframe SRC="frmFrameNewsScroll.aspx" width="100%" height="150" title="Novità e Informazioni" 
						SCROLLING="yes" frameborder=0 framespacing=0 marginheight=1 marginwidth=1>
					</iframe>

			    </td>
			   </tr>
			  </tbody>
			</table>
		</td></tr>
	</tbody>
</table>
<br>
<%	
End If
%>
</BODY>
</HTML>
