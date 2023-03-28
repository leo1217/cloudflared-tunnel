FROM alpine:latest as BUILDERE
WORKDIR /home
RUN apk add --no-cache curl
RUN apk add --no-cache libc6-compat
RUN url=$(curl -s https://api.github.com/repos/cloudflare/cloudflared/releases/latest | grep -w "browser_download_url.*cloudflared-linux-amd64" | head -1 | cut -d : -f 2,3 | tr -d \") \
    && curl -L --output "cloudflared" $url

FROM alpine:latest
ENV token=""
COPY --from=BUILDERE /home/cloudflared /usr/bin/cloudflared
RUN chmod +x /usr/bin/cloudflared
ENTRYPOINT cloudflared tunnel run --token $token