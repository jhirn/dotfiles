-- Pull in the wezterm API
local wezterm = require("wezterm")
local config = wezterm.config_builder()
local action = wezterm.action

require("config.launch").apply(config)
-- This will hold the configuration.

local opacity = 0.7

config.color_scheme = "Abernathy"

config.font = wezterm.font("Agave Nerd Font", { weight = "Bold" })
config.font_size = 14
config.line_height = 1.2
config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 0.9, -- default is 1.0
}

-- Cursor
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.cursor_blink_rate = 700
config.default_cursor_style = "BlinkingBlock"
config.force_reverse_video_cursor = false
config.hide_mouse_cursor_when_typing = true

config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"

config.default_cursor_style = "BlinkingBar"

config.window_padding = { left = "0.5cell", right = "0.5cell", top = "0.5cell", bottom = "0.5cell" }
config.window_decorations = "RESIZE"
config.window_background_opacity = opacity

config.keys = {
	{
		key = "d",
		mods = "CMD",
		action = action.SplitHorizontal,
	},
	{
		key = "d",
		mods = "SHIFT|CMD",
		action = wezterm.action.SplitVertical,
	},
	{
		key = "w",
		mods = "CMD",
		action = action({ CloseCurrentPane = { confirm = true } }),
	},
	{
		key = "Enter",
		mods = "CMD|SHIFT",
		action = action.TogglePaneZoomState,
	},
	{
		key = "[",
		mods = "CMD",
		action = action.ActivatePaneDirection("Prev"),
	},
	{
		key = "]",
		mods = "CMD",
		action = action.ActivatePaneDirection("Next"),
	},
	{
		key = "u",
		mods = "CMD",
		action = action.EmitEvent("toggle-opacity"),
	},
}

-- config.mouse_bindings = {
-- 	{
-- 		event = { Up = { streak = 1, button = "Left" } },
-- 		mods = "NONE",
-- 		action = action.DisableDefaultAssignment,
-- 	},
-- 	{
-- 		event = { Up = { streak = 1, button = "Left" } },
-- 		mods = "CMD",
-- 		action = wezterm.action.OpenLinkAtMouseCursor,
-- 	},
-- }

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		-- if no override is setup, override the default opacity value with 1.0
		overrides.window_background_opacity = 1.0
	else
		-- if there is an override, make it nil so the opacity goes back to the default
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

return config
