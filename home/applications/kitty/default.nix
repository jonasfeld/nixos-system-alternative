{ pkgs, config, ... }:

let 
  scrollback_pager = pkgs.writeShellScript "scrollback_pager" ''
    set -eu
    
    if [ "$#" -eq 3 ]; then
        INPUT_LINE_NUMBER=''${1:-0}
        CURSOR_LINE=''${2:-1}
        CURSOR_COLUMN=''${3:-1}
        AUTOCMD_TERMCLOSE_CMD="call cursor(max([0,''${INPUT_LINE_NUMBER}-1])+''${CURSOR_LINE}, ''${CURSOR_COLUMN})"
    else
        AUTOCMD_TERMCLOSE_CMD="normal G"
    fi
    
    exec ${config.programs.neovim.finalPackage}/bin/nvim 63<&0 0</dev/null \
        -u NONE \
        -c "map <silent> q :qa!<CR>" \
        -c "set shell=bash scrollback=100000 termguicolors laststatus=0 clipboard+=unnamedplus" \
        -c "autocmd TermEnter * stopinsert" \
        -c "autocmd TermClose * ''${AUTOCMD_TERMCLOSE_CMD}" \
        -c 'terminal sed </dev/fd/63 -e "s/'$'\x1b''']8;;file:[^\]*[\]//g" && sleep 0.01 && printf "'$'\x1b''']2;"' 
  '';
in {
  imports = [ ./base16-colors.nix ];
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    settings = {
      background_opacity = "0.85";

      cursor_shape = "block";
      cursor_blink_interval = 0;
      disable_ligatures = "always";

      scrollback_pager = "${scrollback_pager} 'INPUT_LINE_NUMBER' 'CURSOR_LINE' 'CURSOR_COLUMN'";

      mouse_hide_wait = -1;
      
      enable_audio_bell = "no";
    };
    keybindings = {
      "ctrl+shift+t" = "new_tab_with_cwd";
      "ctrl+shift+n" = "new_os_window_with_cwd";
      "ctrl+shift+enter" = "new_window_with_cwd";
    };
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 10.5;
      package = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; });
    };
  };
}
