{ pkgs, ... }: {
  # programs.neovim = {
  #   enable = true;
  #   plugins = [
  #     pkgs.vimPlugins.conjure
  #     pkgs.vimPlugins.rainbow
  #   ];
  # };
  home.packages = with pkgs; [
    fzf
    grc
  ];
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      { name = "hydro"; src = pkgs.fishPlugins.hydro.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
  };
  home.stateVersion = "22.11";
}
