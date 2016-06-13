Imports OO_DBMS_Web_Controls_Library
'
Module test

    Sub StartProcess(p_objSession As HttpSessionState, p_strFunctionID As String)

        p_objSession("ProgressObj_" & p_strFunctionID) = New SessionProgress(p_objSession, p_strFunctionID)

    End Sub

    Sub StopProcess(p_objSession As HttpSessionState, p_strFunctionID As String)

        Dim Pgrs As SessionProgress = p_objSession("ProgressObj_" & p_strFunctionID)
        If Not Pgrs Is Nothing Then
            Pgrs.Stop()
        End If

    End Sub

    Function ProcessExecuting(p_objSession As HttpSessionState, p_strFunctionID As String, _
                            Optional ByRef p_blnRetStopped As Boolean = False) As Boolean

        Dim Pgrs As SessionProgress = p_objSession("ProgressObj_" & p_strFunctionID)
        If Pgrs Is Nothing Then
            p_blnRetStopped = True
        Else
            p_blnRetStopped = Pgrs.Stopped
        End If
        '
        Return OODBMSObjLib.GetStrFlag(p_objSession("Executing_" & p_strFunctionID))

    End Function


    Public Sub funzioneconprogressione(p_objSession As HttpSessionState, _
                                       p_strFunctionID As String, _
                                       Optional p_Progress As OODBMSObjLib.itfProgress = Nothing)

        p_objSession("Executing_" & p_strFunctionID) = True
        Try

            If Not p_Progress Is Nothing Then p_Progress.OnStart(OODBMSObjLib.OODBMS_ActionEvents.odbeUpdateTable, 20)
            Do
                If Not p_Progress Is Nothing Then
                    If Not p_Progress.OnProgress(OODBMSObjLib.OODBMS_ActionEvents.odbeUpdateTable, 20, 1, Nothing, Nothing) Then
                        Throw New Exception("annullato")
                    End If
                End If


                '..codice

            Loop
            If Not p_Progress Is Nothing Then p_Progress.OnEnd(OODBMSObjLib.OODBMS_ActionEvents.odbeSetTableRow, 20)


        Finally
            p_objSession("Executing_" & p_strFunctionID) = False

        End Try

    End Sub



End Module

