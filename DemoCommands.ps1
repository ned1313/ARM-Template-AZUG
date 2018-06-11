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

Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile .\ParameterExamples.json -TemplateParameterObject $templateParameters

azd -Name "Parameter-Example" -ResourceGroupName $ResourceGroup -TemplateFile .\ParameterExamples.json `
    -TemplateParameterObject $templateParameters

$templateParameters = @{
    stringParam = "option 2"
    intParam = 3
    arrayParam = @(1,2,3,4)
}

azd -Name "Parameter-Example" -ResourceGroupName $ResourceGroup -TemplateFile .\ParameterExamples.json `
    -TemplateParameterObject $templateParameters

#Variables Demo
azd -Name "Variable-Example" -TemplateFile .\VariableExamples.json -ResourceGroupName $ResourceGroup

#Function Demo
azd -Name "Function-Example" -TemplateFile .\FunctionExample.json -ResourceGroupName $ResourceGroup

#Resources Demo
$vmCredential = Get-Credential -UserName "azugAdmin" -Message "Password for new VM"

$templateParameters = @{
    virtualMachineSize = "Standard_D2_v3"
    adminUsername = $vmCredential.UserName
    adminPassword = $vmCredential.Password
    storageAccountType = "Standard_LRS"
}

azd -Name "Basic-VM" -ResourceGroupName $ResourceGroup -TemplateFile .\101-1vm-2nics-2subnets-1vnet.json -TemplateParameterObject $templateParameters

#Nested Templates demo
azd -Name "NestedInline" -ResourceGroupName $ResourceGroup -TemplateFile .\NestedTemplateInline.json

cd NestedTemplateExample

$templateParameters = @{
    VMSize = "S"
    adminUsername = $vmCredential.UserName
    adminPassword = $vmCredential.Password
    dnsLabelPrefix = "azugexample"
}

Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroup -TemplateFile .\master.json -TemplateParameterObject $templateParameters

azd -Name "LinkedTemplate" -ResourceGroupName $ResourceGroup -TemplateFile .\master.json -TemplateParameterObject $templateParameters

$templateParameters.VMSize = "M"

azd -Name "LinkedTemplate" -ResourceGroupName $ResourceGroup -TemplateFile .\master.json -TemplateParameterObject $templateParameters -Mode Incremental
#Cleanup after yourself, don't be a SLOB
Remove-AzureRmResourceGroup -Name $ResourceGroup -Force:$true

