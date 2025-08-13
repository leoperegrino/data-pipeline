# $ nix develop path:.
{
  description = "dev shell for this repository";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "terraform" ];
      };
    };

  in {

    devShells."${system}" = {
      default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          terraform
          terraform-ls
          awscli2

          pre-commit
          jq
          checkov
          infracost
          terraform-docs
          tflint
          trivy
          sqls
        ];

        shellHook = ''
          export SHELL=zsh
          export TF_PLUGIN_CACHE_DIR="$XDG_CACHE_HOME/terraform/"
        '';

      };

      zsh = self.devShells."${system}".default.overrideAttrs (prev: {
        shellHook = prev.shellHook + ''
          exec zsh
        '';
      });

      tmux = self.devShells."${system}".default.overrideAttrs (prev: {
        shellHook = prev.shellHook + ''
          exec tmux new nvim \; new-window -n ranger ranger \; next-window
        '';
      });

    };
  };
}
