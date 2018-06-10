#Get Logged into Azure
Add-AzureRmAccount

#Create the resource group
$ResourceGroup = "AZUG"
$Location = "eastus"

New-AzureRmResourceGroup -Name $ResourceGroup -Location $Location

#Create an alias since YOU are LAZY
New-Alias -Name azd -Value New-AzureRmResourceGroupDeployment

#Hello World Demo
azd -Name "Hello-World" -ResourceGroupName $ResourceGroup -TemplateFile .\HelloWorld.json

#Parameter Demo
azd -Name "Parameter-Example" -ResourceGroupName $ResourceGroup -TemplateFile .\ParameterExamples.json

#Create a Parameter Object
$templateParameters = @{
    stringParam = "My string"
    intParam = 4
    arrayParam = @(1,2,3,4)
}

azd -Name "Parameter-Example" -ResourceGroupName $ResourceGroup -TemplateFile .\ParameterExamples.json `
    -TemplateParameterObject $templateParameters

$templateParameters = @{
    stringParam = "option 2"
    intParam = 3
    arrayParam = @(1,2,3,4)
}

azd -Name "Parameter-Example" -ResourceGroupName $ResourceGroup -TemplateFile .\ParameterExamples.json `
    -TemplateParameterObject $templateParameters


#Cleanup after yourself, don't be a SLOB
Remove-AzureRmResourceGroup -Name $ResourceGroup -Force:$true

