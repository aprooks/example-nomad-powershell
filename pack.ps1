$artifacts_store = "d:\nomad\artifacts\my-job.zip"

Compress-Archive -LiteralPath .\my-job\ -DestinationPath $artifacts_store -Update