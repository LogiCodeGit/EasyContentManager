Imports System.Web.SessionState

Public Class Global_asax
    Inherits System.Web.HttpApplication

    Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato quando l'applicazione viene avviata
    End Sub

    Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato quando la sessione viene avviata
    End Sub

    Sub Application_BeginRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato all'inizio di ogni richiesta
    End Sub

    Sub Application_AuthenticateRequest(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato al tentativo di autenticare l'utilizzo
    End Sub

    Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato quando si verifica un errore

        ' SOLO PER FUNZIONI \OOLib
        ' Chiude eventuale connessione attiva 
        Try
            Dim site As clsSiteFunctions = If(Session Is Nothing, Nothing, modSiteFunctions.Site(Session))
            If Not site Is Nothing Then
                site.DB.EndConnection()
            End If
        Catch ex As Exception
        End Try
    End Sub

    Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato al termine della sessione
        ' Codice eseguito al termine di una sessione. 
        ' Nota: l\'evento Session_End viene generato solo quando la modalità sessionstate
        ' è impostata su InProc nel file Web.config. Se la modalità è impostata su StateServer 
        ' o SQLServer, l\'evento non viene generato.


        ' SOLO PER FUNZIONI Easy...
        ' Rilascia eventuali risorse in sospeso
        ' E' necessario impostare il contesto globale 
        ' perchè non è più referenziabile (inspiegabilmente)
        ' mediante <Web.HttpContext.Current> negli
        ' altri moduli durante questo evento
        Dim site As clsSiteFunctions = If(Session Is Nothing, Nothing, modSiteFunctions.Site(Session))
        If Not site Is Nothing Then
            Try
                site.Glb.SetGlobalHttpContext(Application, Session, Server)
            Catch ex As Exception
                ' verificare eventuale errore...
            End Try
            Try
                site.Lib.EndApplication(False)
            Catch ex As Exception
                ' verificare eventuale errore...
            End Try
            Try
                site.Glb.SetGlobalHttpContext(Nothing, Nothing, Nothing)
            Catch ex As Exception
                ' verificare eventuale errore...
            End Try
        End If
    End Sub

    Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
        ' Generato al termine dell'applicazione
        ' SOLO PER FUNZIONI \OOLib
        ' Chiude eventuale connessione attiva 
        Try
            Dim site As clsSiteFunctions = If(Session Is Nothing, Nothing, modSiteFunctions.Site(Session))
            If Not site Is Nothing Then
                site.DB.EndConnection()
            End If
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub Application_PostRequestHandlerExecute(ByVal sender As Object, ByVal e As System.EventArgs)

        ' SOLO PER FUNZIONI \OOLib
        ' Chiude eventuale connessione attiva non esplicitamente
        ' salvata con DB_SaveConnection
        Try
            Dim site As clsSiteFunctions = If(Session Is Nothing, Nothing, modSiteFunctions.Site(Session))
            If Not site Is Nothing Then
                site.DB.EndConnection(True)
            End If
        Catch ex As Exception
            ' verificare eventuale errore...
        End Try
    End Sub

    Protected Sub Application_AcquireRequestState(ByVal sender As Object, ByVal e As System.EventArgs)

        ' Inizializza gli oggetti di sessione
        'mod....InitSessionObjects()

        ' Verifica per eventuale inizializzazione necessaria per la pagina con Frames
        ' N.B.: L'oggetto Session è disponibile solo quando vengono processate le pagine ASP/ASPX
        If System.Web.HttpContext.Current.Session IsNot Nothing _
                AndAlso System.Web.HttpContext.Current.Session("ooSYS_FramesStarted") <> "TRUE" _
                AndAlso System.Web.HttpContext.Current IsNot Nothing _
                AndAlso System.Web.HttpContext.Current.Request IsNot Nothing _
                AndAlso InStr(System.Web.HttpContext.Current.Request.Url.AbsolutePath, "/Test", CompareMethod.Text) = 0 _
                AndAlso InStr(System.Web.HttpContext.Current.Request.Url.AbsolutePath, "/srcClientScriptForm.aspx", CompareMethod.Text) = 0 _
                AndAlso InStr(System.Web.HttpContext.Current.Request.Url.AbsolutePath, "/Custom", CompareMethod.Text) = 0 _
                AndAlso InStr(System.Web.HttpContext.Current.Request.Url.AbsolutePath, "/Default.aspx", CompareMethod.Text) = 0 _
                AndAlso InStr(System.Web.HttpContext.Current.Request.Url.AbsolutePath, "/Index.htm", CompareMethod.Text) = 0 _
                AndAlso InStr(System.Web.HttpContext.Current.Request.Url.AbsolutePath, "/CustomMain.aspx", CompareMethod.Text) = 0 _
                    Then

            ' Inizializza la sessione per segnalare che 
            ' la gestione dei Frames è stata avviata
            Session("ooSYS_FramesStarted") = "TRUE"

            ' Memorizza la richiesta e riparte dalla pagina predefinita
            ' all'interno di frmAppStart.aspx
            Session("ooSYS_RedirectURL") = System.Web.HttpContext.Current.Request.Url.OriginalString
            Response.Redirect("~/Default.aspx", True)

        End If

    End Sub

End Class