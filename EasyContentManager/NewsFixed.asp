<%
' Pagina di visualizzazione News e Informazioni di tipo fisso (non a scorrimento)
'
' N.B.: Le definizione de	lle costanti si trovano in <Parameters.xml>
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
    If Not _site.InitApplicationObjects(Me, False, False) Then
        Response.Write("Applicazione terminata o sessione scaduta.")
        Response.End()
    End If

' Identifica le specifiche della tabella con le Notizie
' e tutti i dati relativi a notizie valide che non 
' sono di tipo a scorrimento
Dim strWhere = ""
With _site.DatLink.Table("NotizieWeb")
	'UPGRADE_WARNING: Date was upgraded to Today and has a new behavior. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1041"'
	strWhere = .GetFieldQueryCriteria("DataInizioValidità", CDate(ToDay), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchLessOrEqual)
	'UPGRADE_WARNING: Use of Null/IsNull() detected. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1049"'
	'UPGRADE_WARNING: Date was upgraded to Today and has a new behavior. Copy this link in your browser for more: 'ms-help://MS.VSCC.2003/commoner/redir/redirect.htm?keyword="vbup1041"'
	strWhere = strWhere & " AND (" & .GetFieldQueryCriteria("DataFineValidità", CDate(ToDay), True, OODBMSObjLib.OODBMS_MatchCriteria.omcMatchGreaterOrEqual) & " OR " & .GetFieldQueryCriteria("DataFineValidità", System.DBNull.Value) & ")"
	strWhere = strWhere & " AND Not Scorrimento"
End With
'If Session("PAGE_FRAME_INFO_FILTER") > "" Then
'	strWhere = strWhere & " AND CorniceDestinazione='" & Session("PAGE_FRAME_INFO_FILTER") & "'"
'End If
'
Dim objNews As OODBMSObjLib.clsDataSource
If Not _site.Lib.GetDataSource(objNews, "NotizieWeb", False, strWhere, "DataInizioValidità", "", 0) Then
	_site.WriteFunctionKey_FormExit(Page)
	_site.Frm.Break_FormConstruction()
End If

' Solo se presenti
If Not objNews.DataEmpty Then
	
	' Cliclo di elaborazione notizie
	Dim nSwapColor = False
	While Not objNews.Eof
		If nSwapColor Then
			%>
<%			
		Else
			%>
<%			
		End If
		%>

        <table cellSpacing="0" cellPadding="0" width="98%" border="0">
          <tbody>
            <tr>
              <td bgColor="#999999">
                <table cellSpacing="1" cellPadding="1" width="100%" border="0">
                  <tbody>
                    <tr bgColor="#f0f0f0">
                      <td><font face="verdana, arial" color="#666666" size="1">
                      <img border="0" src="images/SignalNotFilled.gif" width="5" height="9">&nbsp;
<%		
		'
		If objNews.ColValueStr("Collegamento") <> "" Then
		
			Dim sTitleFix = ""
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
				sTitleFix = "Clicca per dettagli"
			Else
				sTitleFix = "Click for details"
			End If
			
			' Identifica l'URL del dispositivo
			Dim sUrl = "", sValue = objNews.ColValueStr("Collegamento")
			_site.Lib.GetEncodedURL(sValue, objNews.ColField("Collegamento").DataType, sValue, sUrl)
			%>
			<a href='javascript:OpenPopUpWindow( "<%=sUrl%>", "", 0, 0, true, true )' title="<%=sTitleFix%>">
<%			
		End If
		%>
                      
                      <%=objNews.ColValueStr("Titolo")%></font><br>
<%		
		If objNews.ColValueStr("Collegamento") <> "" Then
			%>			
			</a>
<%			
		End If
		%>
                      </td>
                    </tr>
                    <tr>
                      <td bgColor="#F7F7F7">
                        <table>
                          <tbody>
                            <tr>
                              <td><font face="Verdana, Arial" size="1" color="#00309C">
                              <font color=gray size=1><%=objNews.FormattedColValue("DataInizioValidità")%></font>
                              <br><%=objNews.ColValueStr("TestoNotizia")%>
                              </font>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </td>
            </tr>
          </tbody>
        </table>
        <br>
<%		
		'
		objNews.RowNext()
		nSwapColor = Not nSwapColor
	End While
	
End If
%>
</BODY>
</HTML>
