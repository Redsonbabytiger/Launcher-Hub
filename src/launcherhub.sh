#!/bin/bash
# Launcher Hub v1.0
# Main script: GUI-based hub/launcher using YAD

CONFIG="$HOME/.launcherhub.conf"

# Ensure config exists
[ ! -f "$CONFIG" ] && cat > "$CONFIG" <<EOF
[Websites]
GitHub=xdg-open https://github.com
Docs=xdg-open https://docs.python.org

[Apps]
Terminal=gnome-terminal
Editor=code
EOF

# Load section into menu
load_section() {
    section=$1
    entries=$(awk -F= -v s="[$section]" '
        $0==s {found=1; next}
        /^\[/{found=0}
        found && NF==2 {print $1 "|" $2}' "$CONFIG")

    [ -z "$entries" ] && echo "No entries|"
    echo "$entries"
}

# Run selected entry
run_entry() {
    cmd=$(echo "$1" | cut -d'|' -f2-)
    eval "$cmd" &
}

# Main menu
main_menu() {
    yad --notebook --title="Launcher Hub" --width=700 --height=500 \
        --tab="Websites" --list --column="Name" --column="Command" \
            $(load_section "Websites") \
        --tab="Apps" --list --column="Name" --column="Command" \
            $(load_section "Apps") \
        --tab="Scripts" --list --column="Name" --column="Command" \
            $(load_section "Scripts") \
        --button="Run:0" --button="Edit:1" --button="Close:2"
}

while true; do
    choice=$(main_menu)
    case $? in
        0) run_entry "$choice" ;;
        1) xdg-open "$CONFIG" ;;
        2) exit 0 ;;
    esac
done