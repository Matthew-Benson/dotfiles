local wezterm = require 'wezterm'
local config = {}

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
  font = wezterm.font_with_fallback {
    {
      family = 'Monaspace Neon', -- probably most readable, but would like to integrate others somewhere
      -- family = 'Monaspace Argon',
      -- family = 'Monaspace Xenon',
      -- family = 'Monaspace Krypton',
      harfbuzz_features = {'calt', 'liga', 'ss01', 'ss02', 'ss03', 'ss04', 'ss05', 'ss06', 'ss07', 'ss08', 'ss09'},
    },
  },
  -- https://github.com/wez/wezterm/issues/4587
  underline_position = -2,
}
