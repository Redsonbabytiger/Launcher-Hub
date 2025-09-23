done

#!/bin/bash
# Launcher Hub - Main script: GUI-based hub/launcher using YAD
# Maintainer: Brigham Johns <brighamjohns@gmail.com>

VERSION="1.2"
CONFIG="$HOME/.launcherhub.conf"
REQUIRED_CMDS=(yad awk xdg-open)

# Check for required dependencies
for cmd in "${REQUIRED_CMDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' not found. Please install it." >&2
        exit 1
    fi
done

# Ensure config exists
if [ ! -f "$CONFIG" ]; then
    cat > "$CONFIG" <<EOF
[Websites]
GitHub=xdg-open https://github.com
Docs=xdg-open https://docs.python.org

[Apps]
Terminal=gnome-terminal
Editor=code
EOF
fi

# Load section entries for the menu
load_section() {
    section="$1"
    entries=$(awk -F= -v s="[$section]" '
        $0==s {found=1; next}
        /^\[/{found=0}
        found && NF==2 {print $1 "|" $2}' "$CONFIG")
    if [ -z "$entries" ]; then
        echo "(No entries)|"
    else
        echo "$entries"
    fi
}

# Run the selected entry's command
run_entry() {
    cmd=$(echo "$1" | cut -d'|' -f2-)
    if [ -z "$cmd" ] || [[ "$cmd" =~ ^\(No entries\) ]]; then
        yad --info --title="Launcher Hub" --text="No entry selected or nothing to run." --width=300 --timeout=2
        return 1
    fi
    eval "$cmd" &
}

# Show the main menu using YAD
main_menu() {
    yad --notebook --title="Launcher Hub v$VERSION" --width=700 --height=500 \
        --tab="Websites" --list --column="Name" --column="Command" \
            $(load_section "Websites") \
        --tab="Apps" --list --column="Name" --column="Command" \
            $(load_section "Apps") \
        --tab="Scripts" --list --column="Name" --column="Command" \
            $(load_section "Scripts") \
        --button="Run:0" --button="Edit:1" --button="Close:2"
}

# Main event loop
while true; do
    choice=$(main_menu)
    case $? in
        0) run_entry "$choice" ;;
        1) xdg-open "$CONFIG" ;;
        2) exit 0 ;;
        *) exit 1 ;;
    esac
done