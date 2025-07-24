local wezterm = require 'wezterm'
local act = wezterm.action

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    -- unset the color_scheme i.e. use default colors
    return nil
  else
    -- use a light theme
    return 'Lunaria Light (Gogh)'
  end
end

return {
  color_scheme = scheme_for_appearance(get_appearance()),

  -- https://github.com/wez/wezterm/issues/4587
  underline_position = -2,

  -- TODO: temporary workaround for debian nvidia drivers on 2024-07-05
  -- https://github.com/wez/wezterm/issues/2011
  enable_wayland = true,
  front_end = 'WebGpu',

  -- https://github.com/wezterm/wezterm/issues/4962
  window_decorations = "INTEGRATED_BUTTONS | RESIZE",

  font = wezterm.font_with_fallback {
    {
      family = 'Monaspace Neon', -- probably most readable, but would like to integrate others somewhere
      -- family = 'Monaspace Argon',
      -- family = 'Monaspace Xenon',
      -- family = 'Monaspace Krypton',
      harfbuzz_features = {'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'},
    },
  },
  font_size = 18,
  keys = {
    { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
    { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
    { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
    { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
    { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
    { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
    { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
    { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
    { key = '9', mods = 'ALT', action = act.ActivateTab(-1) },
  },
}
