{
  description = "Tools, scripts for rescuing an old 1st-gen kindle fire";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils"; # TODO: pin

  };

  outputs = { flake-utils, self, nixpkgs }: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) { inherit system; };
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            android-tools
          ];
        };
      }
    );
}
