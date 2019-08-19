job "my-job-sleeper" {
  datacenters = ["dc1"]
  type = "batch"

  periodic {
    cron             = "*/5 * * * * *" // run every 5 minutes
    prohibit_overlap = true
  }

  group "my-job" {
    task "sleep" {
      driver = "raw_exec"

      // local http server. Can be any file host
      artifact {
        source = "http://127.0.0.1:8080/my-job.zip"
      }

      config {
        command = "powershell.exe"
        args = [
          "${NOMAD_TASK_DIR}\\my-job\\job.ps1" 
        ]
      }

      env {
          MYJOB_ENVIRONMENT = "production"
          MYJOB_ID = "${node.unique.name}-${node.unique.id}"
      }
    }
  }
}