# SPDX-License-Identifier: Apache-2.0
# Licensed to the Ed-Fi Alliance under one or more agreements.
# The Ed-Fi Alliance licenses this file to you under the Apache License, Version 2.0.
# See the LICENSE and NOTICES files in the project root for more information.

############################################################
# 0) Helper Functions
 $Config = @{}
 $global:Config =  @{} 
 $global:internalcache = @{}
 $global:DataImport = @{
    ApiVersion=0
 }
Function InitConfiguration
{  
    Param(
       $jsonConfig
    )
    $global:Config = $jsonConfig
    Write-Host "Api version $($jsonConfig.ApiVersion)" 
    $global:DataImport.ApiVersion=  $($jsonConfig.ApiVersion)
    Write-Host "InitConfiguration    $( $global:Config.SourceBaseApiUrl)   "
      
}
Function Get-AgentCacheItem
{
[Parameter(Mandatory=$true, Position=0)]$Key
 if(-not [string]::IsNullOrEmpty($($Key)))
    {   

        return $global:internalcache.$Key
    }
}

Function New-AgentCacheItem{
[Parameter(Mandatory=$true, Position=0)] $Key,
[Parameter(Mandatory=$true, Position=1)] $Value
    if(-not[string]::IsNullOrEmpty($($Key)))
    {
        if(-not [string]::IsNullOrEmpty($($Value)))
        {
             $caheItem = Get-AgentCacheItem -Key $($Key)        
            if (!$caheItem) {
                $global:internalcache.add($Key,$Value)     
            }
        }
    }
}
Function Invoke-OdsApiRequest
{  
    Param(
        [string]$RequestPath = ""
    )
    $AggregateListArray = [System.Collections.ArrayList]@()
    $Config=$global:Config
    Write-Host  "$RequestPath"
    Write-Host  "SourceBaseApiUrl ...  $( $global:Config.SourceBaseApiUrl)"

        $SourceBaseApiUrl= $($Config.SourceBaseApiUrl)
        $SourceOAuthUrl=  $($Config.SourceBaseApiUrl) + '/oauth/token'
        $SourceEdFiUrl= $($Config.DataApi)
        Write-Host " *** Getting Token ******** $SourceOAuthUrl "
        # * Get a token *
        $SourceFormData = @{
            Client_id = $($Config.SourceKey)
            Client_secret = $($Config.SourceSecret)
            Grant_type = 'client_credentials'
        }

        $OAuthResponse = Invoke-RestMethod -Uri "$SourceOAuthUrl" -Method Post -Body $SourceFormData
        $token = $OAuthResponse.access_token

        Write-Host " *** Getting Token ******** $token "

        $SourceHeaders = @{
		    "Accept" = "application/json"
            "Authorization" = "Bearer $token"
            "Content-Type" = "application/json"
        }
        $RequestPathTest=  $($Config.SourceBaseApiUrl) + $SourceEdFiUrl + $RequestPath
        $result =( Invoke-RestMethod -Uri "$RequestPathTest" -Headers $SourceHeaders)  | ConvertTo-Json
        return $result
  }

