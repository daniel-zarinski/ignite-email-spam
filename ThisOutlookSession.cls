VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisOutlookSession"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True
Private Sub Application_NewMailEx(ByVal EntryIDCollection As String)
    Dim inbox As Outlook.Folder
    Dim spamFolder As Outlook.Folder
    Dim mailItem As Outlook.mailItem
    Dim http As Object
    Dim url As String
    Dim jsonData As String
    Dim response As String
    Dim errorMsg As String
    Dim prompt As String
    Dim emailBody As String
    
    ' Set the inbox and spam folders
    Set inbox = Application.Session.GetDefaultFolder(olFolderInbox)
    On Error Resume Next
    Set spamFolder = inbox.Folders("Spam")
    If spamFolder Is Nothing Then
        ' Create the Spam folder if it doesn't exist
        Set spamFolder = inbox.Folders.Add("Spam")
    End If
    On Error GoTo 0

    ' Get the new mail item by Entry ID
    Set mailItem = Application.Session.GetItemFromID(EntryIDCollection)

    If Not mailItem Is Nothing And mailItem.Class = olMail Then
        ' Extract plain text from email body
        emailBody = GetPlainTextFromMailItem(mailItem)
        
        ' Create the prompt from subject and body
        prompt = "Subject: " & mailItem.Subject & vbCrLf & "Body: " & emailBody
        'prompt = "Subject: " & mailItem.Subject & vbCrLf & "Body: " & mailItem.Body
        
        ' Escape special characters in the prompt
        prompt = Replace(prompt, "\", "\\")  ' Escape backslashes
        prompt = Replace(prompt, """", "\""") ' Escape double quotes
        prompt = Replace(prompt, vbCrLf, "\n") ' Replace carriage returns and line feeds with \n
        prompt = Replace(prompt, vbTab, "\t") ' Replace tabs with \t

        ' Create the JSON payload
        jsonData = "{""model"": ""email-spam-ollama3.1"", ""prompt"": """ & prompt & """, ""stream"": false}"

        ' Send POST request to API
        Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
        url = "http://localhost:11434/api/generate"
        http.Open "POST", url, False
        http.setRequestHeader "Content-Type", "application/json"
        
        On Error Resume Next
        http.Send jsonData
        
        ' Capture error message if the request fails
        If http.Status <> 200 Then
            errorMsg = "Error " & http.Status & ": " & http.statusText & vbCrLf & "Response: " & http.responseText
            MsgBox errorMsg, vbCritical, "API Request Error"
            Exit Sub
        End If
        On Error GoTo 0

        ' Get response from the server
        response = http.responseText
        
        ' Check if the response indicates spam
        If ContainsExactClassification(response) Then
            ' Move the email to the Spam folder
            mailItem.Move spamFolder
        Else
            MsgBox response, vbInformation, "Response NOT Spam"
        End If
    End If
End Sub

Private Function ContainsExactClassification(ByVal response As String) As Boolean
    ' The exact string to match
    Dim exactString As String
    exactString = "\u003cemail_classification\u003e\""spam\""\u003c/email_classification\u003e"
    
    ' Check if the response contains the exact string
    ContainsExactClassification = (InStr(response, exactString) > 0)
End Function

Private Function GetPlainTextFromMailItem(ByVal mailItem As Outlook.mailItem) As String
    Dim bodyFormat As Long
    Dim plainText As String
    Dim htmlDoc As New MSHTML.HTMLDocument

    bodyFormat = mailItem.bodyFormat

    Select Case bodyFormat
        Case olFormatPlain
            ' Plain text format
            plainText = mailItem.Body
        Case olFormatHTML
            ' HTML format - parse HTML to get plain text
            htmlDoc.Body.innerHTML = mailItem.HTMLBody
            plainText = htmlDoc.Body.innerText
        Case olFormatRichText, olFormatUnspecified
            ' Rich Text Format or unspecified - attempt to get plain text
            plainText = mailItem.Body
        Case Else
            ' Default to mailItem.Body
            plainText = mailItem.Body
    End Select

    ' Trim leading and trailing spaces
    plainText = Trim(plainText)
    
    ' Optionally, replace multiple spaces and line breaks
    plainText = Replace(plainText, vbCrLf & vbCrLf, vbCrLf)
    plainText = Replace(plainText, vbCr & vbCr, vbCr)
    plainText = Replace(plainText, vbLf & vbLf, vbLf)

    GetPlainTextFromMailItem = plainText
End Function
