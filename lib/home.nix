{
  pkgs,
  hx-theme,
  ...
}: {
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
    nil
    manix
    # gitless
  ];
  programs.helix = {
    enable = true;
    settings = {
      theme = hx-theme;
      editor.true-color = true;
    };
    languages = {
      nix = {
        language-server.command = "nil";
      };
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    shellAbbrs = {
      # l = "exa --icons";
      ll = "exa --icons --long --header --git --no-user";
      lh = "exa --icons --long --header --git --all";
      lll = "exa --icons --tree --level=3 --header --git";
      llh = "exa --icons --tree --level=3 --header --git --all --long";
    };
    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      {
        name = "autopair-fish";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
    ];
  };
  home.stateVersion = "22.11";
}
