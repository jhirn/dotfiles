#!/usr/bin/osascript

# Required parameters:
# @raycast.author Joe hirn
# @raycast.authorURL https://github.com/lcardito
# @raycast.schemaVersion 1
# @raycast.title Raise/Lower Hand
# @raycast.mode silent
# @raycast.packageName Zoom
# @raycast.description Raise/Lower Hand in Zoom chat

# Optional parameters:
# @raycast.icon images/zoom-logo.png

tell application "zoom.us"
	activate
	tell application "System Events"
		keystroke "y" using {option down}
		log "Toggle raise heand"
	end tell
end tell
