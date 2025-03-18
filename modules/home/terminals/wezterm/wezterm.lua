-- wezterm config file

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Config here

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("Iosevka SolemnAttic", { weight = "Medium" })
config.font_size = 16.0

-- and finally, return the configuration to wezterm
return config
