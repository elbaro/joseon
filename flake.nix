{
  description = "Joseon theme for Helix and VSCode";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    {
      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.joseon-theme;
        in {
          options.programs.joseon-theme = {
            enable = lib.mkEnableOption "Joseon theme";
            
            helix.enable = lib.mkEnableOption "Helix theme" // { default = cfg.enable; };
            vscode.enable = lib.mkEnableOption "VSCode theme" // { default = cfg.enable; };
          };

          config = lib.mkIf cfg.enable {
            xdg.configFile = lib.mkIf cfg.helix.enable {
              "helix/themes/joseon.toml".source = "${self}/helix.toml";
            };

            programs.vscode.extensions = lib.mkIf cfg.vscode.enable [
              (pkgs.vscode-utils.buildVscodeExtension {
                name = "joseon-theme";
                pname = "joseon-theme";
                version = "1.0.0";
                src = "${self}/vscode";

                vscodeExtPublisher = "your-publisher-name";
                vscodeExtName = "joseon-theme";
                vscodeExtUniqueId = "your-publisher-name.joseon-theme";

                sourceRoot = null;
              })
            ];
          };
        };
    };
}