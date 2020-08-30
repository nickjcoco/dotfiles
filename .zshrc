# TMUX Configuration

###################
# List of options #
###################

set -g @dracula-show-battery false
set -g @dracula-show-powerline true
set -g @dracula-military-time true
set -g @dracula-show-left-icon window
set -g @dracula-cpu-usage true
set -g @dracula-ram-usage true

####################
# Keymap overrides #
####################

# set Ctl-a as prefix
unbind C-b
set -g prefix C-a
bind-key C-a send-prefix

# remap directional splits
unbind %
bind | split-window -h # split vertically
unbind '"'
bind - split-window -v # split horizontally

# vim controls for resizing panes
bind -r H resize-pane -L 5  # 5 px bigger to the left
bind -r J resize-pane -D 5  # 5 px bigger down
bind -r K resize-pane -U 5  # 5 px bigger up
bind -r L resize-pane -R 5  # 5 px bigger to the right

#################
# Mouse support #
#################

set -g mouse on

##############################
# tmux-resurrect vim options #
##############################

# for vim
set -g @resurrect-strategy-vim 'session'

###################
# List of plugins #
###################

set -g @plugin 'dracula/tmux'
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-yank'
set -g @plugin 'tmux-plugins/tmux-resurrect'

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'
