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

#Cleanup after yourself, don't be a SLOB
Remove-AzureRmResourceGroup -Name $ResourceGroup -Force:$true

