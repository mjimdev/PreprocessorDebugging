
cls
$Config = @{
    SourceBaseApiUrl='' #the api url, Examples: https://ods.example.com/api, https://ods.example.com
    DataApi="/data/v3" #Examples: data/v3, or data/v3/2019
    ApiVersion='6.1'  # the Api version Examples 5.3, 6.1
    SourceKey=""  # the Key to get a token 
    SourceSecret=""  # the Secret to get a token 
    WorkingCsvFile=""  # The csv file to be processed
    WorkingOutputCsvFile=""  # The output csv file 
    PreprocessorFile=""  # The preprocessor to run (ps1 file)
    RemoveOldLogs="1" #  1= true,  0=false
	
}

$Preprocessor =  [System.IO.File]::ReadAllText($Config.PreprocessorFile)
$sPreprocessor= "Function PreprocessorDebugging {" + $Preprocessor + "}"
$MainScriptBlock = [Scriptblock]::Create($sPreprocessor)
New-Module -ScriptBlock $MainScriptBlock -name PreprocessorDebugging | Import-Module

Function Process-csv()
{  

    Import-Module "$PSScriptRoot\PreprocessorModule" -Force -Verbose #-Force


    InitConfiguration -jsonConfig $Config
    ## reading the csv file
     $CsvData = New-Object System.Collections.Generic.List[string]
     $rowsProcessed =0
     Import-Csv -path $Config.WorkingCsvFile | Foreach-Object { 
     $argumentlistH = ""
     $argumentlistR = ""

      foreach ($property in $_.PSObject.Properties)
        {
            $argumentlistHeader += ",{0}" -f $($property.Name)
            $argumentlistRrow += ",{0}" -f $($property.Value)
        } 
        $argumentlistHeader=$argumentlistHeader.TrimStart(",")
        $argumentlistRrow= $argumentlistRrow.TrimStart(",")
        # creating argument list
        if( $rowsProcessed -lt 1)
        {   $CsvData.Add( "{0}" -f $argumentlistHeader)
        }
      
           $CsvData.Add( "{0}" -f $argumentlistRrow)
           $rowsProcessed += 1
    }

    $orderedOutputValues= $CsvData  | PreprocessorDebugging

    #export to CSV
    $csvRecords = $orderedOutputValues -join "`r`n" | Out-String
    Write-Host " $csvRecords"

    $orderedOutputValues | Out-File  $Config.WorkingOutputCsvFile
}

Function Init()
{   
    # Enable Logging
    New-Item -ItemType Directory -Force -Path "Logs"
    $date = Get-Date -Format "MM-dd-yyyy-H-m-s"
    $logPath = "Logs\\DebuggingPreprocessor_$date.log"
    Start-Transcript -Path $logPath

    Write-Host "*** Initializing Ed-Fi >" -ForegroundColor Cyan

    Process-csv
     if ($Config.RemoveOldLogs -eq "1")
    {
         Write-Host "*** Removing old logs" -ForegroundColor Cyan
         Remove-Item  $PSScriptRoot\Logs\*.log* -exclude  *DebuggingPreprocessor_$date.log* -force
    }
    
   
    Stop-Transcript
}
# Execute\Init the task
Init