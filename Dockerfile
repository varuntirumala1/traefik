FROM alpine:3.13
RUN apk add --no-cache \
        openssl \
        curl \
        supervisor \
        ca-certificates \
        nano \
        libc6-compat \
        bash \
        wget \
    && curl -s -O https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.tgz \
    && tar zxf cloudflared-stable-linux-amd64.tgz \
    && mv cloudflared /bin \
    && rm cloudflared-stable-linux-amd64.tgz \
    && curl -s https://api.github.com/repos/traefik/traefik/releases/latest \
       | grep "browser_download_url.*traefik_[^extended].*_linux_amd64\.tar\.gz" \
       | cut -d ":" -f 2,3 \
       | tr -d \" \
       | wget -qi - \
   && tarball="$(find . -name "*linux_amd64.tar.gz")" \
   && tar -xzf $tarball \
   && chmod +x traefik \
   && mv traefik / \
   && rm $tarball

# Copy Supervisord config files
COPY supervisord.conf /etc/supervisord.conf
COPY argo-tunnel.sh /usr/share/argo-tunnel.sh
RUN chmod +x /usr/share/argo-tunnel.sh
COPY script/ca-certificates.crt /etc/ssl/certs/
COPY Argo ./data/
EXPOSE 80
VOLUME ["/tmp"]
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
ENTRYPOINT ["/usr/bin/supervisord -c /etc/supervisord.conf", "/traefik"]
