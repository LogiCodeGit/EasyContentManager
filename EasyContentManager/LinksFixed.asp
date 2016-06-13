<%
' Pagina di visualizzazione dei collegamenti fissi
'
' N.B.: Le definizione delle costanti si trovano in <Parameters.xml>
'
' Copyright:		LogiCode Srl
' Autore:			Daniele Magliacani
' Data creazione:	12/01/2004

' E' necessario impostare la var. di sessione PAGE_FRAME_INFO_FILTER
' prima di includere questa pagina per filtrare solo i collegamenti
' relativi al Frame specificato.
%>
<HTML>
<BODY>
<%

' Eventuale inizializzazione dell'applicazione 
If Not _site.InitApplicationObjects(Me,False,False) Then
	Response.Write( "Applicazione terminata o sessione scaduta.")
	Response.End	
End If

' Identifica le specifiche della tabella con le Notizie
' e tutti i dati relativi a notizie valide di tipo a 
' scorrimento
Dim strWhereFix = ""
'If Session("PAGE_FRAME_INFO_FILTER") > "" Then
'	strWhereFix = "CorniceDestinazione='" & Session("PAGE_FRAME_INFO_FILTER") & "'"
'End If
'	With _site.DatLink.Table("Collegamenti")
'		strWhereFix = strWhereFix & " AND Scorrimento"
'	End With
'
Dim objLinksFix As OODBMSObjLib.clsDataSource
If Not _site.Lib.GetDataSource(objLinksFix, "Collegamenti", False, strWhereFix, "", "", 0) Then
	_site.Frm.Break_FormConstruction()
End If

' Solo se presenti
If objLinksFix.RowCount > 0 Then
	%>

        <table cellSpacing="0" cellPadding="0" width="100%" border="0">
            <tr>
              <td bgColor="#999999">
                <table cellSpacing="1" cellPadding="1" width="100%" border="0">
<%	
	Dim sCaptionFix = ""
	If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian Then
		sCaptionFix = "Links"
	Else
		sCaptionFix = "Links"
	End If
	%>          
                    <tr>
                      <td bgColor="#f0f0f0"><font face="verdana, arial" color="#666666" size="1">
						<a title="Accedi ai Links" style="CURSOR: HAND" target=_self OnClick='if(window.document.all("trShowLinks").style.display=="none") window.document.all("trShowLinks").style.display=""; else window.document.all("trShowLinks").style.display="none";'>
						<img border="0" src="images/SignalNotFilled.gif" width="5" height="9">&nbsp;<b><%=sCaptionFix%></b></font><br>
						<!--</a>-->
                      </td>
                    </tr>
                    <tr style="display:none" id="trShowLinks">
                      <td bgColor="#F7F7F7">
                        <table>
<%	
	
	' Cliclo di elaborazione Links
	Dim nSwapColorFix = False
	While Not objLinksFix.Eof
		If nSwapColorFix Then
			%>
							<tr><td width="100%" style="FONT-SIZE: xx-small">
<%			
		Else
			%>
							<tr><td width="100%" style="FONT-SIZE: xx-small">
<%			
		End If
		'
		If objLinksFix.ColValueStr("Collegamento") <> "" Then
			
			Dim sTitleFix = objLinksFix.ColValueStr("Descrizione")
			If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollEnglish And objLinksFix.ColValueStr("DescrizioneInglese")<>"" Then
				sTitleFix = objLinksFix.ColValueStr("DescrizioneInglese")
			End If
			
			' Identifica l'URL del dispositivo
			Dim sUrl = "", sValue = Rtrim(objLinksFix.ColValueStr("Collegamento"))
            _site.Lib.GetEncodedURL(sValue, objLinksFix.ColField("Collegamento").DataType, sValue, sUrl)
			
			' Imposta la visualizzazione su frame dei contenuti
			' oppure su frame PopUp
			Dim sHref = ""
			If objLinksFix.ColValueStr("IntegraSito") Then
				' Visualizza nel frame dei contenuti
				sHref = sUrl
			Else
				' Visualizza nella finestra PopUp
				sHref = "javascript:OpenPopUpWindow( """ & sUrl & """, """", 0, 0, true, true )"
			End If
			%>
								<img src="images/SignalFilled.gif" width="6" height="9">&nbsp;
								<a href='<%=sHref%>' title="<%=sTitleFix%>">
<%			
		End If
		%>
								<font face="Arial">
								<b>
		<%
		    If _site.Language = OODBMSObjLib.OODBMS_LocaleLanguage.ollItalian _
		                          Or objLinksFix.ColValueStr("NomeInglese") = "" Then
		        Response.Write(objLinksFix.ColValueStr("Nome"))
		    Else
		        Response.Write(objLinksFix.ColValueStr("NomeInglese"))
		    End If
		%>
		</b></font>
<%		
		If objLinksFix.ColValueStr("Collegamento") <> "" Then
			%>			
								</a>
<%			
		End If
		%>
							</td></tr>
<%		
		'
		objLinksFix.RowNext()
		nSwapColorFix = Not nSwapColorFix
	End While
	%>
                        </table>
                      </td>
                    </tr>
                </table>
              </td>
            </tr>
        </table>
<br>
<%	
End If
%>
</BODY>
</HTML>
