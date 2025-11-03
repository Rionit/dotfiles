starship init fish | source

# Set up fzf key bindings
fzf --fish | source

if test "$FISH_MOO" = "1"
    ~/scripts/random_cow_fortune.sh
    set FISH_MOO 0 # otherwise fzf mooin
end

function gifetch
    bash $HOME/scripts/random_fastfetch.sh
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function palette
    # Check that a file path is provided
    if test (count $argv) -eq 0
        echo "Usage: palette path/to/colors.json"
        return 1
    end

    set file $argv[1]

    # Check that the file exists
    if not test -f $file
        echo "File not found: $file"
        return 1
    end

    # Extract hex colors from JSON using jq
    set colors (jq -r '.bg, .fg, .primary, .secondary, .accent' $file | tr -d '#')

    # Use pastel to display the palette with names
    pastel color $colors | pastel format name
end

# Fuzzy search multiple files with colored preview
# and open them in nvim
function envim
    nvim $(fzf --preview='bat --color=always {}')
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
