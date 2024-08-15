local wezterm = require 'wezterm'

local config = wezterm.config_builder()
local color_scheme = 'nord'
local scheme = wezterm.get_builtin_color_schemes()[color_scheme]

local bg = wezterm.color.parse(scheme.background)

config = {
  automatically_reload_config = true,
  color_scheme = color_scheme,
  font_size = 18.0,
  window_background_opacity = 0.9,
  macos_window_background_blur = 30,
  window_decorations = 'RESIZE',
  colors = {
    tab_bar = {
        active_tab = {
            bg_color = scheme.background,
            fg_color = scheme.foreground
        }
    }
  },
  window_frame = {
      font_size = 18.0,
      font = wezterm.font({ family = 'Fira Code' }),
      active_titlebar_bg = scheme.background,
      inactive_titlebar_bg = bg:darken(0.4)
  },
}

local function segments_for_right_status(window)
    return {
        window:active_workspace(),
        wezterm.strftime('%a %b %-d %H-%M'),
        wezterm.hostname()
    }
end

wezterm.on('update-status', function(window)
    local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
    local segments = segments_for_right_status(window)

    local color_scheme = window:effective_config().resolved_palette
    local bg = wezterm.color.parse(color_scheme.background)
    local fg = color_scheme.foreground

    local gradient_to, gradient_from = bg
    gradient_from = gradient_to:lighten(0.2)

    local gradient = wezterm.color.gradient(
      {
        orientation = 'Horizontal',
        colors = { gradient_from, gradient_to },
      },
      #segments -- only gives us as many colours as we have segments.
    )

    local elements = {}

    for i, seg in ipairs(segments) do
      local is_first = i == 1

      if is_first then
        table.insert(elements, { Background = { Color = 'none' } })
      end
      table.insert(elements, { Foreground = { Color = gradient[i] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })

      table.insert(elements, { Foreground = { Color = fg } })
      table.insert(elements, { Background = { Color = gradient[i] } })
      table.insert(elements, { Text = ' ' .. seg .. ' ' })
    end

    window:set_right_status(wezterm.format(elements))
end)

return config
