starship init fish | source

# Set up fzf key bindings
fzf --fish | source

if test "$FISH_MOO" = "1"
    ~/scripts/random_cow_fortune.sh
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
