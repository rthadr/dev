#!/bin/sh

# First, detect which shell is executing this script
ppid=$(ps -p $$ -o ppid= | tr -d ' ')
shell=$(ps -p $ppid -o comm= | sed 's/^-//; s/.*\///')

# Execute the appropriate initialization script based on detected shell
case "$shell" in
  fish)
    fish_init="$DEVBOX_GLOBAL_ROOT/fish/config.fish"
    if [ -f "$fish_init" ]; then      
      # Update devbox.json in the script directory
      devbox_json="$DEVBOX_GLOBAL_ROOT/devbox.json"
      if [ -f "$devbox_json" ]; then
        echo "Updating devbox.json to use fish config directly"
        
        # Use jq to update the init_hook section
        jq '.shell.init_hook = [". $DEVBOX_GLOBAL_ROOT/fish/config.fish"]' "$devbox_json" > "$devbox_json.tmp"
        if [ $? -eq 0 ]; then
          mv "$devbox_json.tmp" "$devbox_json"
          echo "Updated devbox.json init_hook section to use fish config."
          echo "\n!!!RUN THE FOLLOWING COMMAND NOW!!!\n\nrefresh-global && exit\n\nYOU CAN SAFELY IGNORE THE FOLLOWING SYNTAX ERRORS:"
        else
          echo "Failed to update devbox.json"
          rm -f "$devbox_json.tmp"
        fi
      else
        echo "devbox.json not found at: $devbox_json"
      fi
      
      # Still execute the fish config for this session
      . "$fish_init"
    else
      echo "Fish initialization script not found: $fish_init"
    fi
    ;;
  bash)
    bash_init="$DEVBOX_GLOBAL_ROOT/initbash.sh"
    if [ -f "$bash_init" ]; then
      echo "Detected bash shell, executing: $bash_init"
      bash "$bash_init"
    else
      echo "Bash initialization script not found: $bash_init"
    fi
    ;;
  zsh)
    zsh_init="$DEVBOX_GLOBAL_ROOT/initzsh.sh"
    if [ -f "$zsh_init" ]; then
      echo "Detected zsh shell, executing: $zsh_init"
      zsh "$zsh_init"
    else
      echo "Zsh initialization script not found: $zsh_init"
    fi
    ;;
  *)
    echo "Unknown shell: $shell"
    echo "No specific initialization script available."
    ;;
esac
