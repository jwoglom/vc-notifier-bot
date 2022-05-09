job "vc-notifier-bot" {
    datacenters = ["dc1"]

    type = "service"

    group "default" {
        count = 1

        volume "data_volume" {
            type = "host"
            source = "data_volume"
        }

        task "default" {
            driver = "docker"

            config {
                image = "ghcr.io/jwoglom/vc-notifier-bot/vc-notifier-bot:latest"
                command = "/bin/bash"
                args = ["-c", <<EOF
                    pwd;
                    cd /usr/src/app;
                    node index.js
                EOF
                ]
            }

            volume_mount {
                volume = "data_volume"
                destination = "/data"
            }

            volume_mount {
                volume = "data_volume"
                destination = "/usr/src/app/data"
            }

            kill_timeout = "60s"

            env {
                NODE_CONFIG = "{\"botToken\": \"ENTER_DISCORD_BOT_TOKEN_HERE\"}"
            }

            resources {
                cpu = 500
                memory = 512
            }
        }
    }
}
