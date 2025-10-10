# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
#
# Load theme from Oh My Zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
#
# Load theme from AUR package
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions)

# Set ZSH Autosuggestions highlight color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#acb0be'

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Alias
alias cl="clear"
alias cdf="cd ~/Projects/Freelance/"
alias cdp="cd ~/Projects/Personal/"
alias coffee="killall -9 CoffeeTalk.exe"
alias cpugovernor="cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
alias dev="npm run dev"
alias download_album="yt-dlp -x --audio-format mp3 --audio-quality 0 --embed-metadata --embed-thumbnail --write-info-json --write-thumbnail"
alias download_vid="yt-dlp -f 'bestvideo[height=720]+bestaudio' --merge-output-format mp4"
alias ff="fastfetch"
alias ffarch="fastfetch --config ~/.config/fastfetch/arch.jsonc"
alias ff-full="fastfetch --config ~/.config/fastfetch/groups.jsonc"
alias ffmin="fastfetch --config ~/.config/fastfetch/minimal.jsonc"
alias ffmini="fastfetch --config ~/.config/fastfetch/mini.jsonc"
alias ffos="fastfetch --config ~/.config/fastfetch/os.jsonc"
alias icat="kitten icat --scale-up"
alias icatgif="kitty +kitten icat --transfer-mode file ~/Pictures/Frieren/Frieren.gif"
alias lg="lazygit"
alias nc="ncmpcpp"
alias nv="nvim"
alias setwal="feh --bg-fill"
alias syu="paru -Syu"
alias syy="paru -Syy"
alias test="npm test"
alias tm="tmux"
alias tmks="tmux kill-server"
alias tmls="tmux ls"
alias x="exit"

# Using Neovim as the default text editor
export EDITOR=nvim

# Node.js (node and npm)
export NVM_DIR="$HOME/.nvm"

# Loads NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Loads bash completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Custom commands
# Add album cover to songs
embed_cover() {
    cover=$(ls *.jpg | head -n 1)
    if [ -z "$cover" ]; then
        echo "Cover.jpg not found!"
        return 1
    fi

    for file in *.mp3; do
        new_file="new_$file"

        ffmpeg -i "$file" -i "$cover" -map 0:a -map 1:v -c:v mjpeg \
            -metadata:s:v title="Album Art" -metadata:s:v comment="Cover (front)" \
            -c:a copy "$new_file"

        if [ $? -eq 0 ]; then
            rm "$file"
            mv "$new_file" "$file"
            echo "Successfully added cover to: $file"
        else
            echo "Failed to process: $file"
        fi
    done

    echo "Done! Now all songs got cover album."
}

# Check CPU usage
cpu_usage() {
  awk -v PREV_IDLE=0 -v PREV_TOTAL=0 '
    BEGIN {
      while (1) {
        getline < "/proc/stat"
        split($0, cpu, " ")
        idle = cpu[5]
        total = 0
        for (i = 2; i <= NF; i++) total += cpu[i]

        diff_idle = idle - PREV_IDLE
        diff_total = total - PREV_TOTAL
        usage = (1 - diff_idle / diff_total) * 100

        if (PREV_TOTAL != 0) printf "CPU Usage: %.2f%%\n", usage

        PREV_IDLE = idle
        PREV_TOTAL = total
        close("/proc/stat")
        system("sleep 1")
      }
    }'
}

# Make and change directory
mkc() {
  mkdir $1
  cd $1
}

# Open directory then open Neovim
cdnv() {
  cd $1
  nvim
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
