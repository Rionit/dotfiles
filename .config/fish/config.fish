starship init fish | source

# Set up fzf key bindings
fzf --fish | source

if test "$FISH_MOO" = "1"
    ~/scripts/random_cow_fortune.sh
    set FISH_MOO 0 # otherwise fzf mooin
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

# Fuzzy search multiple files with colored preview
# and open them in nvim
function envim
    nvim $(fzf --preview='bat --color=always {}')
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
