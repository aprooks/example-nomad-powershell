$nomad_addr = "http://localhost:4646"
$nomad_artifacts = "d:/nomad/artifacts/"

# Step 1: copy to a file-share
if(!(test-path $nomad_artifacts)) 
{
    New-Item -ItemType Directory -Path $nomad_artifacts
}

Copy-Item ./artifacts/my-job.zip $nomad_artifacts/my-job.zip -Force

# Step 2: get json definition of a job

$JSON  = @{
    "JobHCL" = Get-Content -Path ./job.nomad | Out-String
} | ConvertTo-Json

# ask nomad to convert HCL defnition into Json
$result = Invoke-WebRequest -Method Post -Uri "$nomad_addr/v1/jobs/parse" `
                            -ContentType 'application/json' `
                            -Body $JSON 

$content = $result.Content

# Step 4: send received json content as Job definition
$JSON  = "{""JOB"": $content }"

Invoke-WebRequest -Method Post -Uri "$nomad_addr/v1/jobs" `
                            -ContentType 'application/json' `
                            -Body $JSON
