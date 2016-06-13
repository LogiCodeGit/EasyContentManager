Public Class TestWebForm1
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then

            UpdatePanel1.ContentTemplateContainer.Controls.Add(New CheckBox)

        End If

    End Sub

    Protected Sub Button1_Click(sender As Object, e As EventArgs) Handles Button2.Click

        Debug.Print(Panel2_DragAndResizeExtender.ChangedX & "," & Panel2_DragAndResizeExtender.ChangedY)

    End Sub
End Class