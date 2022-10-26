<#
.SYNOPSIS
 Create a New Perfmon Data Collector Set from an XML input
.PARAMETER XMLFilePath
 Path of XML file to import
.PARAMETER DataCollectorName
 Name of new Data Collector. This should match the name in the XML file
.EXAMPLE
 New-DataCollectorSet -XMLFilePath C:\Scripts\Perfmontemplate.xml -DataCollectorName CPUIssue
#>
param (
 [parameter(Mandatory=$True,HelpMessage='Path of XML file to import')]
 $XMLFilePath
 ,
 [parameter(Mandatory=$True,HelpMessage='Name of new Data Collector')]
 $DataCollectorName
 )

# Test for existence of supplied XML file
if (Test-Path $XMLFilePath){
 }
else{
 Write-Host "Path to XML file is invalid, exiting script"
 Exit
 }


if (Test-Path "C:\temp\"){



 # Create a new DataCollectorSet COM object, read in the XML file,
 # use that to set the XML setting, create the DataCollectorSet,
 # start it.
 $datacollectorset = New-Object -COM Pla.DataCollectorSet
 $xml = Get-Content $XMLFilePath
 $datacollectorset.SetXml($xml)
 $datacollectorset.Commit("$DataCollectorName" , $null , 0x0003) | Out-Null
 $datacollectorset.start($True)

}
