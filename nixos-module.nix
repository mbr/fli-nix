{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.fli-mcp-http;
in
{
  options.services.fli-mcp-http = {
    enable = lib.mkEnableOption "fli HTTP MCP server";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultText = lib.literalExpression "fli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default";
      description = "Package providing the fli-mcp-http executable.";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address on which the MCP server listens.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "TCP port on which the MCP server listens.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional environment variables for the MCP server.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the configured TCP port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.fli-mcp-http = {
      description = "fli HTTP MCP server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = cfg.environment // {
        HOST = cfg.listenAddress;
        PORT = toString cfg.port;
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe' cfg.package "fli-mcp-http";
        Restart = "on-failure";
        RestartSec = 5;
        DynamicUser = true;
        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
