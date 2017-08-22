alias nixi="nix-env -i"
alias nixu="nix-env -e"
alias nixc="nix-env --delete-generations 5d && nix-store --gc"
alias nixcf="nix-env --delete-generations old && nix-store --gc"
