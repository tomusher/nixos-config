{
  traefikLabels = { appName, host ? "", port, scheme ? "http" }:
    if host != "" then [
      "-l traefik.enable=true"
      "-l traefik.http.routers.${appName}.rule=Host(`${host}`)"
      "-l traefik.http.services.${appName}.loadbalancer.server.port=${toString port}"
      "-l traefik.http.services.${appName}.loadbalancer.server.scheme=${scheme}"
    ] else [ ];
}
