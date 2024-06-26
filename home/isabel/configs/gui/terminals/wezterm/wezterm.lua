local wezterm = require("wezterm")
local utils = require("utils")

local c = {}
if wezterm.c_builder then
  c = wezterm.config_builder()
end

-- theme
require("catppuccin").apply_to_config(c)
require("bar").apply_to_config(c)

if utils.is_linux() then
  c.window_background_opacity = 0.90
elseif utils.is_darwin() then
  c.window_background_opacity = 0.95
  c.macos_window_background_blur = 15
elseif utils.is_windows() then
  c.window_background_image = "C:\\Users\\Isabel\\Pictures\\wallpapers\\GEpt2MeaAAANR2q.jpeg"
  c.window_background_image_hsb = {
    brightness = 0.05, -- make the bg darker so we can see what we are doing
  }
  c.win32_system_backdrop = "Tabbed"
end

-- load my keybinds
require("keybinds").apply(c)

-- default shell
if utils.is_linux() then
  c.default_prog = { "fish", "--login" }
elseif utils.is_darwin() then
  c.default_prog = { "/etc/profiles/per-user/isabel/bin/fish", "--login" }
elseif utils.is_windows() then
  c.launch_menu = {
    {
      label = "PowerShell",
      args = { "pwsh.exe" },
    },
    {
      label = "WSL",
      args = { "wsl.exe" },
    },
  }
end

-- window stuff
c.window_decorations = "RESIZE"
c.window_padding = { left = 10, right = 0, top = 0, bottom = 0 }
c.adjust_window_size_when_changing_font_size = false

-- fonts
c.font = wezterm.font_with_fallback({
  "CommitMono",
  "Symbols Nerd Font",
})
c.font_size = 13
c.adjust_window_size_when_changing_font_size = false
c.window_frame = {
  font = wezterm.font("CommitMono"),
  font_size = c.font_size,
}

if utils.is_windows() then
  c.line_height = 1
else
  c.line_height = 1.2
end

-- QOL
c.audible_bell = "Disabled"
c.default_cursor_style = "BlinkingBar"
c.front_end = "WebGpu"
c.window_close_confirmation = "NeverPrompt"
c.prefer_to_spawn_tabs = true

-- this is nix so lets not do it
-- enable this if i ever setup nix to statically link
-- c.automatically_reload_config = false
c.check_for_updates = false

-- TODO:
-- https://wezfurlong.org/wezterm/config/lua/config/tiling_desktop_environments.html

return c
