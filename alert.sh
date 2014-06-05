# Add an "alert" alias for long running commands. Use like so:
#   sleep 10; alert
# requirement: terminal-notifier
alias alert='if [ $? = 0 ]; then terminal-notifier -title "$(history | tail -n1 | sed -E '"'"'s/^ *[0-9]+ *//;s/ *[;&|] *alert$//'"'"')" -message "Success"; else terminal-notifier -title "$(history | tail -n1 | sed -E '"'"'s/^ *[0-9]+ *//;s/ *[;&|] *alert$//'"'"')" -message "Failure"; fi'
