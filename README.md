# Data Import Preprocessor Debugger

This is a Power Shell script that allows to run Data Import preprocessors using commannd line console.

Often times when doing preprocessors in data import it can be difficult to associate the errors to what is happening in the code, that is the reason why we created this simple utility to run the preprocessor code on a file and step through the processing. 

## Instructions
1. Download the code: `git@github.com:Ed-Fi-Exchange-OSS/DataImportPreprocessorDebugger.git`
2. Open the file DataImportPreprocessorDebugger.ps1 and edit the config section with the correct information.
3. Run DataImportPreprocessorDebugger.ps1 by Power Shell console

###### Configuration Section
 * ` SourceBaseApiUrl       `The api url Examples: https://ods.example.com/api, https://ods.example.com
 * ` DataApi                `Examples: data/v3, or data/v3/2019
 * ` ApiVersion             `The Api version, Examples 5.3, 6.1
 * ` SourceKey              `The Key to get a token 
 * ` SourceSecret           `The Secret to get a token 
 * ` WorkingCsvFile         `The csv file to be processed
 * ` WorkingOutputCsvFile   `The result csv
 * ` PreprocessorFile       `The preprocessor to run (ps1 file)
 * ` RemoveOldLogs          `1 to remove old logs, 0 to keep old logs

 
###### PowerShell

```powershell 
#Change your directory
 $dataImportPreprocessorDebugger = "C:\DataImportPreprocessorDebugger\DataImportPreprocessorDebugger.ps1"
Write-host -ForegroundColor Cyan  $dataImportPreprocessorDebugger 
 &  $dataImportPreprocessorDebugger 
``` 

### Logs

By default, the application creates log files, to review them go to the root directory and find the Logs folder.
### Support


