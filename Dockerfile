# This Dockerfile and other setup files are modified from here:
# https://github.com/Devidian/docker-spaceengineers/blob/master/Dockerfile
FROM debian:bullseye-slim

# Set architecture, turn off all wine logging
ENV WINEARCH=win64
ENV WINEDEBUG=-all
# Set wine configuration directory
ENV WINEPREFIX=/root/server

# For the wine key
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

WORKDIR /root
COPY ["./Server Files", "/root/"]
RUN chmod +x "/root/Install-Prereqs.sh" && "/root/Install-Prereqs.sh"

COPY ["./start.ps1", "/root/start.ps1"]

SHELL [ "pwsh", "-Command" ]

CMD /root/start.ps1