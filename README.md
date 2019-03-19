# docker-vsftpd

FTP server to serve files.

## Supported tags and Dockerfile links
- [`latest` (*Dockerfile*)](https://github.com/eddyhub/docker-vsftpd/blob/master/Dockerfile)

## How to use
a) Build the container with `docker build -t vsftpd .`
b) Start container with `docker run -d vsftpd`
c) Pass config options listed in here: [vsftpd.conf](https://security.appspot.com/vsftpd/vsftpd_conf.html) via environment variables and prefix these with `VSFTPD_`
d) Add volumes to save the uploaded files between container restarts etc.

## Testing
```bash
docker build -t vsftpd.

docker run --name vsftpd --rm \
	   -e FTP_USER=foo \
           -e FTP_PASSWORD=bar \
           -e FTP_USER_HOME=/home/bar \
           -e VSFTPD_anon_root=/home/bar \
           -e VSFTPD_pasv_min_port=21490 \
           -e VSFTPD_pasv_min_port=21500 \
           -e VSFTPD_local_enable=YES \
           -e VSFTPD_write_enable=YES \
           -e VSFTPD_local_umask=000 \
           -e VSFTPD_xferlog_enable=YES \
           -v /tmp/ftp:/home/bar \
           vsftpd

```
