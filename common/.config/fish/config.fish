set -gx EDITOR nvim

fish_add_path --append --global /usr/local/go/bin ~/go/bin ~/.local/bin

if status is-interactive
    set -g fish_greeting

    if not functions -q __git.init
        functions -q fisher; or curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher update
    end

    alias ls 'eza --icons auto'
    alias ll 'eza -l --icons auto --git'
    alias la 'eza -la --icons auto --git'

    command -q fzf; and fzf --fish | source
    command -q zoxide; and zoxide init fish --cmd cd | source
    command -q direnv; and direnv hook fish | source
    command -q fnm; and fnm env --use-on-cd --shell fish | source
    command -q starship; and starship init fish | source
end
