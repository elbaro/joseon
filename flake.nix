{
  description = "Joseon theme for Helix, VSCode, Zed and the shell";

  inputs = {
  };

  outputs =
    { self }:
    {
      homeModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          cfg = config.programs.joseon-theme;

          # ── Palette ──────────────────────────────────────────
          # RGB triples for truecolor ANSI (38;2;R;G;B)
          p = {
            red = "174;25;50";
            text = "80;78;72";
            gray = "166;163;154";
            blue = "85;139;207";
            green = "104;151;100";
            orange = "209;111;21";
            pink = "234;87;123";
            white = "224;223;222";
          };

          # Hex values for FZF (which uses #rrggbb)
          hex = {
            red = "#ae1932";
            text = "#504e48";
            gray = "#a6a39a";
            blue = "#558bcf";
            green = "#689764";
            orange = "#d16f15";
            white = "#e0dfde";
          };

          # ── ANSI helpers ─────────────────────────────────────
          fg = c: "38;2;${c}";
          bg = c: "48;2;${c}";
          bold = s: "1;${s}";
          underline = s: "4;${s}";
          dim = s: "2;${s}";

          join = builtins.concatStringsSep ":";
          exts = val: list: map (e: "*.${e}=${val}") list;

          # ── File extension groups ────────────────────────────
          archives = [
            "tar" "tgz" "arc" "arj" "taz" "lha" "lz4" "lzh" "lzma"
            "tlz" "txz" "tzo" "t7z" "zip" "z" "dz" "gz" "lrz" "lz"
            "lzo" "xz" "zst" "bz2" "bz" "tbz" "tbz2" "tz" "rar"
            "ace" "zoo" "cpio" "7z" "rz" "cab" "jar" "war" "ear"
            "deb" "rpm" "apk" "squashfs"
          ];
          images = [
            "png" "jpg" "jpeg" "gif" "bmp" "svg" "svgz" "ico"
            "tif" "tiff" "webp" "avif" "heic" "heif" "jxl"
            "xcf" "xpm" "pbm" "pgm" "ppm"
          ];
          audio = [
            "mp3" "flac" "ogg" "oga" "opus" "wav" "aac" "wma"
            "m4a" "aiff" "ape" "mka" "ra"
          ];
          video = [
            "mp4" "mkv" "avi" "mov" "wmv" "flv" "webm" "m4v"
            "mpg" "mpeg" "ogv" "vob" "ts" "m2ts"
          ];
          backup = [
            "bak" "old" "orig" "rej" "swp" "swo" "tmp"
            "dpkg-old" "dpkg-new"
          ];

          # ── Computed env var strings ─────────────────────────

          lsColors = join (
            [
              "rs=0"
              "di=${bold (fg p.blue)}"
              "ln=${fg p.orange}"
              "mh=${underline (fg p.text)}"
              "pi=${fg p.orange}"
              "so=${fg p.orange}"
              "do=${fg p.orange}"
              "bd=${bold (fg p.orange)}"
              "cd=${bold (fg p.orange)}"
              "or=${dim (fg p.red)}"
              "mi=${dim (fg p.red)}"
              "su=${bold (fg p.white)};${bg p.red}"
              "sg=${fg p.white};${bg p.red}"
              "ca=${fg p.red}"
              "tw=${fg p.text};${bg p.blue}"
              "ow=${underline (fg p.blue)}"
              "st=${bold (fg p.blue)}"
              "ex=${fg p.red}"
            ]
            ++ exts (fg p.green) archives
            ++ exts (fg p.pink) images
            ++ exts (fg p.pink) audio
            ++ exts (bold (fg p.pink)) video
            ++ exts (fg p.gray) backup
            ++ [ "*~=${fg p.gray}" "*#=${fg p.gray}" ]
          );

          ezaColors = join [
            "da=${fg p.gray}"
            "sn=${fg p.text}"
            "sb=${fg p.gray}"
            "hd=${underline (fg p.text)}"
            "uu=${fg p.text}"
            "un=${fg p.gray}"
            "gu=${fg p.gray}"
            "gn=${fg p.gray}"
            "ur=${fg p.green}"
            "uw=${fg p.orange}"
            "ux=${fg p.red}"
            "ue=${fg p.red}"
            "gr=${fg p.green}"
            "gw=${fg p.orange}"
            "gx=${fg p.red}"
            "tr=${fg p.green}"
            "tw=${fg p.orange}"
            "tx=${fg p.red}"
            "lp=${fg p.orange}"
            "ga=${fg p.green}"
            "gm=${fg p.orange}"
            "gd=${fg p.red}"
            "gv=${fg p.blue}"
            "gt=${fg p.red}"
          ];

          grepColors = join [
            "ms=${bold (fg p.red)}"
            "mc=${fg p.red}"
            "fn=${fg p.blue}"
            "ln=${fg p.gray}"
            "bn=${fg p.gray}"
            "se=${fg p.gray}"
          ];

          gccColors = join [
            "error=${bold (fg p.red)}"
            "warning=${fg p.orange}"
            "note=${fg p.blue}"
            "caret=${bold (fg p.green)}"
            "locus=${fg p.gray}"
            "quote=${fg p.green}"
          ];

          jqColors = join [
            (fg p.gray) # null
            (fg p.red) # false
            (fg p.green) # true
            (fg p.orange) # number
            (fg p.green) # string
            (fg p.blue) # array
            (fg p.blue) # object
            (bold (fg p.red)) # object key
          ];

          # ESC byte for LESS_TERMCAP (shell-agnostic, raw byte)
          esc = builtins.fromJSON ''"\\u001b"'';
          termcap = code: "${esc}[${code}m";
        in
        {
          options.programs.joseon-theme = {
            enable = lib.mkEnableOption "Joseon theme";

            helix.enable = lib.mkEnableOption "Helix theme" // {
              default = cfg.enable;
            };
            vscode.enable = lib.mkEnableOption "VSCode theme" // {
              default = cfg.enable;
            };
            zed.enable = lib.mkEnableOption "Zed theme" // {
              default = cfg.enable;
            };
            shell.enable = lib.mkEnableOption "Shell environment colors (LS_COLORS, EZA_COLORS, GREP_COLORS, GCC_COLORS, FZF, JQ, less/man)" // {
              default = cfg.enable;
            };
          };

          config = lib.mkIf cfg.enable {
            programs.helix.themes = lib.mkIf cfg.helix.enable {
              joseon = builtins.fromTOML (builtins.readFile "${self}/helix.toml");
            };

            programs.vscode.profiles.default.extensions = lib.mkIf cfg.vscode.enable [
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

            home.file.".config/zed/themes/joseon.json" = lib.mkIf cfg.zed.enable {
              source = "${self}/zed/joseon.json";
            };

            # FZF — native Home Manager option
            programs.fzf.colors = lib.mkIf cfg.shell.enable {
              "fg" = hex.text;
              "bg" = "-1";
              "hl" = hex.red;
              "fg+" = hex.text;
              "bg+" = hex.gray;
              "hl+" = hex.red;
              "info" = hex.gray;
              "prompt" = hex.red;
              "pointer" = hex.red;
              "marker" = hex.green;
              "spinner" = hex.orange;
              "header" = hex.blue;
              "border" = hex.gray;
              "gutter" = "-1";
            };

            # Everything else — home.sessionVariables
            home.sessionVariables = lib.mkIf cfg.shell.enable {
              LS_COLORS = lsColors;
              EZA_COLORS = ezaColors;
              GREP_COLORS = grepColors;
              GCC_COLORS = gccColors;
              JQ_COLORS = jqColors;
              LESS_TERMCAP_mb = termcap (bold (fg p.pink));
              LESS_TERMCAP_md = termcap (bold (fg p.red));
              LESS_TERMCAP_me = termcap "0";
              LESS_TERMCAP_so = termcap "${fg p.white};${bg p.red}";
              LESS_TERMCAP_se = termcap "0";
              LESS_TERMCAP_us = termcap (underline (fg p.blue));
              LESS_TERMCAP_ue = termcap "0";
            };
          };
        };
    };
}
