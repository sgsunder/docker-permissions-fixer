Docker permissions fixer
======

When using a named Docker volume on a paticular service, the ownership of the root directory of the volume will always be `root:root` when created. This can cause problems in containers that do not operate as the root user.

Unfortunately, Docker doesn't seem to have a good native way of fixing this issue. This ultra-lightweight (~500 kB) container image can be called on as a dependant service that will fix the permissions as you specified, then sleep indefinitely. 

Example usage for Prometheus:

```yaml
volumes:
  metrics:
service:
  fixperms:
    image: ghcr.io/sgsunder/docker-permissions-fixer
    restart: always
    volumes:
      # Mount the volumes into both this container and the actual service you want to use to fix it
    - metrics:/metrics
    - another-example-volume:/another-example-volume
    command:
      # Reference each mounted volume here to fix the permissions
      # Syntax is "<mounted volume name>:<desired UID>:<desired GID>"
    - metrics:65534:65534
    - another-example-volume:1000:1000
     
   prometheus:
    image: prom/prometheus:v2.42.0
    depends_on:
      # This is to ensure that "fixperms" will always be started first
    - fixperms
    volumes:
    - ./prometheus.yaml:/etc/prometheus/prometheus.yml:ro
      # Mount the "fixed" volume as usual
    - metrics:/prometheus:rw
```
