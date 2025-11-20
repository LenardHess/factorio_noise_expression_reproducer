local noise_debug = {}

if not (data.raw["noise-expression"] and data.raw["noise-expression"].visualisation) then
  data:extend({
    {
      type = "noise-expression",
      name = "visualisation",
      intended_property = "visualisation",
      expression = "elevation",
      localised_name = "Vis"
    }
  })
end

-- hide cliffs from visualisations
function noise_debug.hide_map_cliffs()
  for _, cliff in pairs(data.raw.cliff) do
    cliff.map_color = {0,0,0,0}
  end
end

function noise_debug.remove_non_tile_autoplace(exclusions_map)
  exclusions_map = exclusions_map or {}
  for type, protos in pairs(data.raw) do
    for _, proto in pairs(protos) do
      if not exclusions_map[proto.name] then
        if proto.autoplace then
          proto.autoplace = nil
          for _, planet in pairs(data.raw.planet) do
            if planet.map_gen_settings and planet.map_gen_settings.autoplace_settings then
              for _, thing in pairs(planet.map_gen_settings.autoplace_settings) do
                if thing.settings then
                  thing.settings[proto.name] = nil
                end
              end
            end
          end
        end
      end
    end
  end
end

-- added a temporary control if there is not one of that name, and return the string for the specified channel
-- output is not linear (see slider_to_linear).
-- e.g. visualisation = visualisation .."+50*".. noise_debug.temp_control("visualisation_shift", "size")
function noise_debug.temp_control(name, channel, category)
  temp_controls = temp_controls or {} -- global
  if not (data.raw["autoplace-control"] and data.raw["autoplace-control"]["debug_"..name]) then
    table.insert(temp_controls, "debug_"..name)
    data:extend(
      {
        {
          type = "autoplace-control",
          name = "debug_"..name,
          localised_name = {"", "Debug_"..name},
          --richness = false,
          order = "z",
          category = category or "terrain"
        }
      }
    )
    noise_debug.register_control("debug_"..name)
  end
  if channel == "size" or channel == "coverage" then
    return "var(\"control:debug_"..name..":size\")"
  elseif channel == "richness" then
    return "var(\"control:debug_"..name..":richness\")"
  elseif channel == "scale" then
    return "1/var(\"control:debug_"..name..":frequency\")"
  elseif channel == "frequency" then
    return "var(\"control:debug_"..name..":frequency\")"
  end
end

function noise_debug.double_linear_slider(name, from, to, category)
  local d = to - from
  local substeps = 12
  local substep = d / substeps
  local size_endpoint = to - substep
  return "(slider_to_linear(" .. noise_debug.temp_control(name, "scale", category) .. ", 0, " .. substep .. ")\z
        + slider_to_linear(" .. noise_debug.temp_control(name, "size", category) .. ", " .. from .. ", " .. size_endpoint .. "))"
end

function noise_debug.register_control(name)
  if noise_debug_controls_applied then
    return noise_debug.apply_control(name)
  end
  -- delayed until end of data-final-fixes
  noise_debug_unassigned_controls = noise_debug_unassigned_controls or {}
  table.insert(noise_debug_unassigned_controls, name)
end

function noise_debug.apply_controls()
  noise_debug_controls_applied = true
  if noise_debug_unassigned_controls then
    for _, name in pairs(noise_debug_unassigned_controls) do
      noise_debug.register_control(name)
    end
  end
end

function noise_debug.apply_control(name)
  for _, planet in pairs(data.raw.planet) do
    planet.map_gen_settings.autoplace_controls[name] = {}
  end
end

-- Visualise an expression (defaults to visualisation) using tile map_color. min and max are the expected range of the expression.
function noise_debug.tiles_to_visualisation(visualise_expression, min, max, display)
  min = min or -50
  max = max or 100
  visualise_expression = visualise_expression or "visualisation"

  local tile_settings = {}
  if data.raw.planet and data.raw.planet.nauvis then
    for _, planet in pairs(data.raw.planet) do
      planet.map_gen_settings.autoplace_settings.tile.settings = tile_settings
    end
  end

  local adjust_magnitude = (max - min) / 2
  data:extend({
    {
      type = "noise-function",
      name = "visualise_function",
      parameters = {"input"},
      expression = "input * vis_scale + "..adjust_magnitude.." * (vis_shift_scale_linear + vis_shift_size_linear)",
      local_expressions =
      {
        vis_scale = "vis_scale_scale * slider_to_linear{slider_value=vis_scale_size, min=0.7, max=1.3}",
        vis_scale_scale = noise_debug.temp_control("vis_scale", "scale"),
        vis_scale_size = noise_debug.temp_control("vis_scale", "size"),
        vis_shift_scale = noise_debug.temp_control("vis_shift", "scale"),
        vis_shift_scale_linear = "slider_to_linear{slider_value=vis_shift_scale, min=-2, max=2}",
        vis_shift_size = noise_debug.temp_control("vis_shift", "size"),
        vis_shift_size_linear = "slider_to_linear{slider_value=vis_shift_size, min=-0.3, max=0.3}"
      }
    },
    {
      type = "noise-expression",
      name = "visualise_expression",
      expression = "visualise_function{input=" .. visualise_expression .. "}"
    },
  })

  local ordered_tiles = {}
  for _, tile in pairs(data.raw.tile) do
    if tile.name ~= "out-of-map"
    and tile.name ~= "water-wube"
    and tile.name ~= "cliff-test"
    and tile.name ~= "tile-unknown"
    and tile.name ~= "tutorial-grid"
    then
      table.insert(ordered_tiles, tile)
      tile_settings[tile.name] = {}
    end
  end

  table.sort(ordered_tiles, function(a, b) return a.layer < b.layer end)

  local expression_step = (max - min) / (#ordered_tiles - 1)
  local colour_step = 255 / (#ordered_tiles - 1)
  local divisions = 3
  local dividers = math.floor(#ordered_tiles / divisions)

  local tile_i = 0
  for _, tile in pairs(ordered_tiles) do
    local point = min + expression_step * tile_i
    tile.autoplace = {
      probability_expression = "1 + simple_peak{value = visualise_expression, target=" .. point .. "} / 10"
    }
    if display == "greyscale" then
      tile.map_color = {
        math.clamp(tile_i * colour_step, 0, 255),
        math.clamp(tile_i * colour_step, 0, 255),
        math.clamp(tile_i * colour_step, 0, 255),
      }
    elseif display == "custom" then
      tile.map_color = {
        -- Red
        tile_i <= dividers and 0
          or 255
          ,
        -- Green
        tile_i <= 2*dividers and 0
          or 255
          ,
        -- Blue
          math.clamp(tile_i % dividers * divisions * colour_step, 0, 255)
      }
    else -- "3-band"
      tile.map_color = {
        tile_i <= dividers and 0
          or ( tile_i <= (dividers * 2) and math.clamp(tile_i % dividers * 6 * colour_step, 0, 255)
            or math.clamp(tile_i % dividers * 6 * colour_step - 255, 0, 255)
          ),
        tile_i <= dividers and dividers and math.clamp(tile_i % dividers * 6 * colour_step - 255, 0, 255)
          or ( tile_i <= (dividers * 2) and math.clamp(tile_i % dividers * 6 * colour_step - 255, 0, 255)
            or math.clamp(tile_i % dividers * 6 * colour_step, 0, 255)
          ),
        tile_i <= dividers and math.clamp(tile_i % dividers * 6 * colour_step, 0, 255)
          or ( tile_i <= (dividers * 2) and 0
            or math.clamp(tile_i % dividers * 6 * colour_step - 255, 0, 255)
          )
      }
    end
    tile_i = tile_i + 1
  end
end

-- adds a control to adjust the visualisation
function noise_debug.visualisation_adjust(visualisation)
  return visualisation .. " * "..noise_debug.temp_control("visualisation", "scale")
    .. "+ 50 * slider_to_linear{slider_value = "..noise_debug.temp_control("visualisation", "size")..", min=-1, max=1}"
end

-- adds an expression as an option for visualisation for previewing. Often used with a multiplier to fall into the expected visualisation range.
-- e.g. noise_debug.add_visualisation_target("moisture", data.raw["noise-expression"].moisture.expression, 50)
-- e.g. noise_debug.add_visualisation_target("vulcanus_mountains_blob", "vulcanus_mountains_blob", 25)
function noise_debug.add_visualisation_target(name, expression, multiplier)
  if not expression then expression = name end
  if multiplier then
    expression = "("..expression .. ") * (" .. multiplier .. ")"
  end
  local debug_expression = {
    type = "noise-expression",
    name = "debug_"..name,
    intended_property = "visualisation",
    expression = expression
  }
  data:extend({debug_expression})
end

-- adds an expression as an option for visualisation for previewing. Often used with a multiplier to fall into the expected visualisation range.
-- e.g. noise_debug.add_visualisation_target("moisture", data.raw["noise-expression"].moisture.expression, 50)
-- e.g. noise_debug.add_visualisation_target("vulcanus_mountains_blob", "vulcanus_mountains_blob", 25)
function noise_debug.add_visualisation_target_from_local_expression(name, expression_name, local_expression_name, multiplier)
  local expression = table.deepcopy(data.raw["noise-expression"][expression_name])
  expression.expression = local_expression_name
  expression.intended_property = "visualisation"
  expression.name = "debug_" .. (name or (expression_name .. "_" .. local_expression_name))
  if multiplier then
    expression.expression = "(" .. expression.expression .. " ) * (" .. multiplier .. ")"
  end
  data:extend({expression})
end

-- allows scaling of multiple noise expressions with a debug control, useful for debugging multiple wobble levels.
function noise_debug.apply_debug_scalar_to_expression_names(scalar_name, expression_names)
  local multiplier = "slider_to_linear{slider_value="..noise_debug.temp_control(scalar_name, "scale")..", min=0, max=2}\z
                    * slider_to_linear{slider_value="..noise_debug.temp_control(scalar_name, "size")..",  min=0.8, max=1.2}"
  for _, expression_name in pairs(expression_names) do
    if data.raw["noise-expression"][expression_name] then
      data.raw["noise-expression"][expression_name].expression = "(" .. data.raw["noise-expression"][expression_name].expression .. ") * "..multiplier
    end
  end
end

if not data.raw["noise-function"]["simple-peak"] then
  data:extend({
    {
      type = "noise-function",
      name = "simple_peak",
      parameters = {"value", "target"},
      expression = "-abs(value - target)"
    }
  })
end

return noise_debug
