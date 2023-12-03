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
    eza
    firefox-wayland
    ungoogled-chromium
    epiphany
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
      # l = "eza --icons";
      ll = "eza --icons --long --header --git --no-user";
      lh = "eza --icons --long --header --git --all";
      lll = "eza --icons --tree --level=3 --header --git";
      llh = "eza --icons --tree --level=3 --header --git --all --long";
    };
    plugins = [
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
      # {
      #   name = "tide";
      #   src = pkgs.fishPlugins.tide.src;
      # }
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

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    NIXOS_OZONE_WL = 1;
  };
  home.stateVersion = "22.11";
}
