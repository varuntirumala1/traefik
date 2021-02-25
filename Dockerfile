FROM varuntirumala1/alpine:latest
COPY /etc/services.d/ /etc/services.d/
RUN  curl -s https://api.github.com/repos/traefik/traefik/releases/latest \
       | grep "browser_download_url.*traefik_[^extended].*_linux_amd64\.tar\.gz" \
       | cut -d ":" -f 2,3 \
       | tr -d \" \
       | wget -qi - \
   && tarball="$(find . -name "*linux_amd64.tar.gz")" \
   && tar -xzf $tarball \
   && chmod +x traefik \
   && mv traefik / \
   && rm $tarball

COPY script/ca-certificates.crt /etc/ssl/certs/
RUN chmod +x /etc/services.d/cloudflared/run

EXPOSE 80

VOLUME ["/tmp"]

ENTRYPOINT ["/traefik"]
