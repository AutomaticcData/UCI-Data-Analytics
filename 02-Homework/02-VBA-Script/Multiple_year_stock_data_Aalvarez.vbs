Option Explicit


'////////Reference Sources ///////////////////////////////
'AALVAREZ 7/31/018
    'https://excel-macro.tutorialhorizon.com/vba-excel-get-the-names-of-all-worksheets-in-a-excel-workbook/
    '///reference https://www.techrepublic.com/blog/10-things/10-ways-to-reference-excel-workbooks-and-sheets-using-vba/
    '//sum an entire column    https://www.mrexcel.com/forum/excel-questions/451599-sum-entire-column.html
    '//https://www.ozgrid.com/forum/forum/help-forums/excel-general/40655-count-non-blank-cells-in-range-w-vb
    '//https://excel-macro.tutorialhorizon.com/vba-excel-get-the-names-of-all-worksheets-in-a-excel-workbook/
    '// numbers bigger than long, exception overflow errors. https://stackoverflow.com/questions/1840661/handling-numbers-larger-than-long-in-vba
    'change background colors  https://www.excel-easy.com/vba/examples/background-colors.html
    '//msgbox buttons https://www.exceltrick.com/formulas_macros/vba-msgbox/
'//////// End References /////////////////////////////////

Sub StockMarketModerate()
    'get the active workbook name and set it into an object
    Dim MainWorkBook As Workbook
    Set MainWorkBook = ActiveWorkbook
    
    'get the active worksheet name and set it to an object
    Dim MainWorkSheet As Worksheet
    Set MainWorkSheet = ActiveWorkbook.ActiveSheet
    
    '-----------------------------------------
    Dim i           As Double          'loop counter
    Dim wordCount   As Integer          'word count
    Dim ArrNames    As String           'tickervalues
    Dim c           As Integer
    c = 1                               'ticker name in column 1
    
    Dim colValue, colMatch As String    'values to set and compare
    colValue = ""
    colMatch = ""
    
    'Dim blnMatch As Boolean             'flag if match found, default to false
    'blnMatch = False
    
    Dim totalSum As Double                'sum of values
    'Ticker Column  16
    'Volume Column  17
    
    'get the range for the first column we are using
    Dim numRowRange As Double
    numRowRange = WorksheetFunction.CountA(MainWorkSheet.Range("A:A"))
    'Debug.Print numTickerRange
    
    Dim rowStart As Double             'row to start looking for values
    rowStart = 2
    
    Dim rowEnd As Double             'the last row to look for values
    rowEnd = numRowRange
    
    Dim currentTickerRow As Integer     'the row count for the current ticker name
        currentTickerRow = 0
    Dim openValue As String
        openValue = ""
    Dim closeValue As String
        closeValue = ""
        
    For i = rowStart To rowEnd
      currentTickerRow = currentTickerRow + 1
      colValue = MainWorkSheet.Cells(i, c).Value    'set the initial col value here
      
      
      If colMatch = "" Then 'checking our initial values
        'blnMatch = True     'assume first row and is a match
        colMatch = colValue 'assign the matching value assuming the above
        wordCount = 1
      End If

    '--------------------====
      If colValue = colMatch Then
        'blnMatch = True
        totalSum = totalSum + CLng(MainWorkSheet.Cells(i, 7).Value)
        closeValue = MainWorkSheet.Cells(i, 6).Value
        
        If currentTickerRow = 1 Then        'set value only if we are on the first record for current ticker
            openValue = MainWorkSheet.Cells(i, 3).Value
        End If
        
      ElseIf colValue <> colMatch Then
        
        ArrNames = ArrNames & colMatch & "," & totalSum & "," & openValue & "," & closeValue & "|"
        
        'blnMatch = False
        colMatch = MainWorkSheet.Cells(i, c).Value          'set new column value
        wordCount = wordCount + 1                           'track ticker counts
        totalSum = CLng(MainWorkSheet.Cells(i, 7).Value)    'sum of volume
        
        currentTickerRow = 0                                'reset ticker
      End If
    '--------------------====


'     Debug.Print "-----------------"
'     Debug.Print "Match: " & colMatch
'     Debug.Print "Total: " & totalSum
'     Debug.Print "Names: " & ArrNames
'     'Debug.Print "blnMatch: " & blnMatch
'     Debug.Print "currentTickerRow: " & currentTickerRow
'



Next
    
'    ArrNames = ArrNames & colMatch & "," & totalSum & "," & openValue & "," & closeValue
'    Debug.Print "Names: " & ArrNames & vbNewLine & "WordCount: " & wordCount
'    Debug.Print vbNewLine
    

    Call StockArrayValuesFromString(ArrNames, MainWorkSheet)

End Sub



Sub StockArrayValuesFromString(ArrNames As String, MainWorkSheet As Worksheet)
   Dim FirstCol As Integer   'Column used for TickerValue
   FirstCol = 9
   Dim SecondCol As Integer     'Column for Yearly Change
   SecondCol = 10
   Dim ThirdCol As Integer     'Column for Percent Change
   ThirdCol = 11
   Dim FourthCol As Integer  'Column used for Sum of Total
   FourthCol = 12
      
    Dim i As Integer, j As Integer
    
    'set the header values in case they are not set
    MainWorkSheet.Cells(1, FirstCol).Value = "Ticker"
    MainWorkSheet.Cells(1, SecondCol).Value = "Yearly Change"
    MainWorkSheet.Cells(1, ThirdCol).Value = "Percent Change"
    MainWorkSheet.Cells(1, FourthCol).Value = "Total Stock Volume"
    
    Dim MainRows() As String
    Dim MainCols() As String
    
    MainRows = Split(ArrNames, "|")
    
    Dim openValue, closeValue, yearlyChange As Long
    Dim Tickername As String
    Dim TotalStockVolume, percentChange As Double
    
    
    For i = 0 To UBound(MainRows)
        'oValue = Replace(myArr(i), ")", Empty)
        
        'Debug.Print "Raw Value: " & i & " = " & MainRows(i)
        
        MainCols = Split(MainRows(i), ",")
        
        For j = 0 To UBound(MainCols)
            'Debug.Print MainCols(j)
            
'            add +2 to the row because we dont want to start at 0 from the FOR LOOP,
'            but we do we want to begin at the second row --------------------------

            'change background colors base on values
            
            Tickername = MainCols(0)
            TotalStockVolume = CDbl(MainCols(1))
            openValue = CLng(MainCols(2))
            closeValue = CLng(MainCols(3))
            
            
            'not too sure about how to get the yearly change formula,
            ',but if it was correct, it would go here
            
            yearlyChange = openValue - closeValue
            
            'check for divide by 0 errors
            If openValue > 0 Then
                percentChange = (yearlyChange / openValue) / 100
                
                'add color based on value
                If percentChange > 0 Then
                    MainWorkSheet.Cells(i + 2, SecondCol).Interior.ColorIndex = 50
                Else
                    MainWorkSheet.Cells(i + 2, SecondCol).Interior.ColorIndex = 3
                End If
            Else
                percentChange = 0
            End If

            MainWorkSheet.Cells(i + 2, FirstCol).Value = Tickername
            MainWorkSheet.Cells(i + 2, SecondCol).Value = yearlyChange
            MainWorkSheet.Cells(i + 2, ThirdCol).Value = percentChange
            MainWorkSheet.Cells(i + 2, FourthCol).Value = TotalStockVolume
            
            
        Next
        
        'MainCols = Split
        
'        myValues = Split(oValue, "(")
'
'        Debug.Print "Raw Value: " & i & " = " & myArr(i)
'        Debug.Print UBound(myArr())
'
'        For col = 0 To UBound(myValues)
'            Debug.Print "Output value: " & col + 1 & " = " & myValues(col)
'        Next col
'


            'add +2 to the row because we dont want to start at 0 from the FOR LOOP,
            'but we do we want to begin at the second row --------------------------
'            MainWorkSheet.Cells(i + 2, FirstCol).Value = myValues(0)
'            MainWorkSheet.Cells(i + 2, SecondCol).Value = myValues(1)

        'Debug.Print vbNewLine
    Next i



End Sub


Sub ClearStockData()
    Dim retVal As Integer
    retVal = MsgBox("Are you sure you want to reset Stock Analysis?", vbOKCancel + vbCritical, "Error Encountered")
    'button 2 is cancel, button 0 is OK
    Debug.Print retVal

    If retVal = 1 Then
         'get the active workbook name and set it into an object
        Dim MainWorkBook As Workbook
        Set MainWorkBook = ActiveWorkbook
        
        'get the active worksheet name and set it to an object
        Dim MainWorkSheet As Worksheet
        Set MainWorkSheet = ActiveWorkbook.ActiveSheet
           
           
        MainWorkSheet.Range("H:L").Interior.ColorIndex = 0
        MainWorkSheet.Range("H:L").Clear
    End If

End Sub


