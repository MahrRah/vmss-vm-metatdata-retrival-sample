$vmName = Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/compute/name?api-version=2021-02-01&format=text"
"VM_NAME=$vmName" | Out-File -FilePath C:\vm-metadata.env -Append
