-- This is a minimal recreation of the angelsinfiniteore addition of an infinite ore
-- It is cobbled together from this commit:
--     https://github.com/LenardHess/factorio_angelsmods/commit/51dfbe56dc430baa708416d4674aed4fb6633945

local resource_autoplace = require("resource-autoplace")

angelsmods = {
  ores = {
    yield = 20,     -- value originates from angelsinfiniteores/settings.lua -> angels-infinite-yield
    loweryield = 1, -- value originates from angelsinfiniteores/settings.lua -> angels-lower-infinite-yield
  }
}

local infinite_coal = {
  name = "infinite-coal",
  get = "coal",
  order = "b",
  sheet = 2,
  infinite = true,
  glow = true,
  var = 2,
  map_color = { r = 0, g = 0, b = 0 },
  tint = { r = 0.2, g = 0.2, b = 0.2 },
  mining_time = 1,
  type = "item",
  minimum = angelsmods.ores.yield,
  normal = 1500,
  maximum = 6000,
  acid_to_mine = "water",
  output_name = "coal",
  output_min = 1,
  output_max = 1,
  output_probability = angelsmods.ores.loweryield,

  workaround_fixup_rng_seed = true,
  autoplace = {
    starting_area = false,

    -- Ordering relative to vanilla coal, which has an odering value of "b"
    order = "a",    -- ordering before coal
    --order = "ba", -- ordering after coal

    -- The below values were played around with a bit, hence the mess of comments
    --resource_index = 0,
    base_density = 4,--5, -- Vanilla coal: 8
    regular_rq_factor_multiplier = 1.0,--0.3, -- Vanilla coal: 1.0
    --starting_rq_factor_multiplier = 1.1,

    random_spot_size_minimum = 0.25,       -- Default: 0.25
    random_spot_size_maximum = 2,          -- Default: 2
    --regular_blob_amplitude_multiplier = 1, -- Default: 1
  }
}

local input = infinite_coal

if input.name == "infinite-coal" then
  log("Making resource " .. input.name)
  log(serpent.block(input))
end
local ret_table = {
  type = "resource",
  flags = { "placeable-neutral" },
  tree_removal_probability = 0.8,
  tree_removal_max_distance = 32 * 32,
  infinite_depletion_amount = 10,
  resource_patch_search_radius = 12,
}
local autoplace_ret_table = {
  name = input.name,
  order = input.autoplace.order or input.order,
  base_density = input.autoplace.base_density,
  has_starting_area_placement = input.autoplace.starting_area,
  resource_index = input.autoplace.resource_index,
  regular_rq_factor_multiplier = input.autoplace.regular_rq_factor_multiplier,
  starting_rq_factor_multiplier = input.autoplace.starting_rq_factor_multiplier,
  base_spots_per_km2 = input.autoplace.base_spots_per_km2,
  random_probability = input.autoplace.random_probability,
  random_spot_size_minimum = input.autoplace.random_spot_size_minimum,
  random_spot_size_maximum = input.autoplace.random_spot_size_maximum,
  additional_richness = input.autoplace.additional_richness,
  richness_post_multiplier = input.autoplace.richness_post_multiplier or nil,
}

local function make_resautoplace(input)
  data:extend({
    {
      type = "autoplace-control",
      name = input.name,
      localised_name = { "", "[entity=" .. input.name .. "] ", { "entity-name." .. input.name } },
      richness = true,
      order = "b-" .. input.order,
      category = "resource",
    },
  })
end

local function make_particle(input)
  if not data.raw["optimized-particle"][input.name .. "-particle"] then
    data:extend({
      {
        type = "optimized-particle",
        name = input.name .. "-particle",
        --flags = {"not-on-map"},
        life_time = 180,
        pictures = {
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-1.png",
            priority = "extra-high",
            tint = input.tint,
            width = 5,
            height = 5,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-2.png",
            priority = "extra-high",
            tint = input.tint,
            width = 7,
            height = 5,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-3.png",
            priority = "extra-high",
            tint = input.tint,
            width = 6,
            height = 7,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-4.png",
            priority = "extra-high",
            tint = input.tint,
            width = 9,
            height = 8,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-5.png",
            priority = "extra-high",
            tint = input.tint,
            width = 5,
            height = 5,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-6.png",
            priority = "extra-high",
            tint = input.tint,
            width = 6,
            height = 4,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-7.png",
            priority = "extra-high",
            tint = input.tint,
            width = 7,
            height = 8,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-8.png",
            priority = "extra-high",
            tint = input.tint,
            width = 6,
            height = 5,
            frame_count = 1,
          },
        },
        shadows = {
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-1.png",
            priority = "extra-high",
            width = 5,
            height = 5,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-2.png",
            priority = "extra-high",
            width = 7,
            height = 5,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-3.png",
            priority = "extra-high",
            width = 6,
            height = 7,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-4.png",
            priority = "extra-high",
            width = 9,
            height = 8,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-5.png",
            priority = "extra-high",
            width = 5,
            height = 5,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-6.png",
            priority = "extra-high",
            width = 6,
            height = 4,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-7.png",
            priority = "extra-high",
            width = 7,
            height = 8,
            frame_count = 1,
          },
          {
            filename = "__noise-expression-repro__/graphics/entity/ores-particle/ore-particle-shadow-8.png",
            priority = "extra-high",
            width = 6,
            height = 5,
            frame_count = 1,
          },
        },
      },
    })
  end
end

local function generate_presets(resource)
  local presets = {
    ["rich-resources"] = { richness = "very-good" },
    ["rail-world"] = {
      frequency = 0.33333333333,
      size = 3,
    },
    ["ribbon-world"] = {
      frequency = 3,
      size = 0.5,
      richness = 2,
    },
  }
  -- if set and set.basic_settings and set.basic_settings.autoplace_controls then
  --   set.basic_settings.autoplace_controls = util.merge({set.basic_settings.autoplace_controls, resources})
  -- end
  for preset, conf in pairs(presets) do
    local set = data.raw["map-gen-presets"]["default"][preset]
    if
      set
      and set.basic_settings
      and set.basic_settings.autoplace_controls
      and not set.basic_settings.autoplace_controls[resource]
    then
      set.basic_settings.autoplace_controls[resource] = conf
    end
  end
end

--Create resource gfx sheet
local function make_resgfx(input)
  if input.type == "item" then
    if input.infinite == true then
      input.frame_count = 16
      input.variation_count = 4
    else
      input.frame_count = 8
      input.variation_count = 8
    end
    if input.get then
      local stages_copy = table.deepcopy(data.raw.resource[input.get].stages)
      --log(serpent.block(stages_copy))
      return stages_copy
    end
  end

end

--Create Glowmask for resources
local function make_resglow(input)
  if input.glow == true then
    if input.type == "item" then
      if input.get and data.raw.resource[input.get] then
        local stages_input = data.raw.resource[input.get].stages
        input.frame_count = stages_input.sheet.frame_count
        input.variation_count = stages_input.sheet.variation_count
      end
      if input.sheet == 2 then
        input.gfx_ani_per = 5
        input.gfx_ani_dev = 0.75
        input.gfx_dark_mul = 3
        input.gfx_alpha_min = 0.1
        input.gfx_alpha_max = 0.4
        return {
          sheet = {
            filename = "__noise-expression-repro__/graphics/entity/ores/ore-12-hr-glow.png",
            priority = "extra-high",
            tint = input.tint,
            width = 128,
            height = 128,
            line_length = 8,
            frame_count = input.frame_count,
            variation_count = input.variation_count,
            scale = 0.5,
            blend_mode = "additive",
            flags = { "light" },
          },
        }
      end
    end
  end
end


if not data.raw.resource[input.name] then
  --Setup autoplace (base game)
  resource_autoplace.initialize_patch_set(input.name, input.autoplace.starting_area)

  --Create Autopace for the resource
  make_resautoplace(input)
  generate_presets(input.name)
  for _, planet_name in pairs(input.planets or { "nauvis" }) do
    data.raw.planet[planet_name].map_gen_settings.autoplace_controls[input.name] = {}
    data.raw.planet[planet_name].map_gen_settings.autoplace_settings.entity.settings[input.name] = {}
  end
  --Create Particle if resource yields items
  if input.type == "item" then
    if input.get and data.raw.particle and data.raw.particle[input.get .. "-particle"] then
      input.particle = input.get .. "-particle"
      log("Using existing particle " .. input.particle)
    else
      make_particle(input)
      input.particle = input.name .. "-particle"
      log("Created new particle " .. input.particle)
    end
  else
    input.particle = nil
  end
  --Set infinite yields according to mod options or default
  if angelsmods.ores and angelsmods.ores.yield then
    input.minimum = angelsmods.ores.yield * 15
    input.output_probability = angelsmods.ores.loweryield
  else
    input.minimum = 300
    input.output_probability = 1
  end
  --Set defaults for infinite resources normal and maximum
  if input.infinite then
    input.normal = 1500
    --input.maximum = 6000
  end
  --[[Set mining hardness
  if input.hardness == nil then
    input.hardness = 0.9
  end]]
  --Set stages count according to resource type
  local stages_count
  if input.type == "item" then
    if input.infinite == true then
      stages_count = { 1 }
    else
      stages_count = { 15000, 8000, 4000, 2000, 1000, 500, 200, 80 }
    end
  else
    stages_count = { 0 }
  end
  --Set if map grid will show
  if input.type == "item" then
    input.map_grid = true
  else
    input.map_grid = false
  end

  --Set Boxes according to presets
  if input.type == "fluid" then
    input.order = "d-" .. input.order
    input.highlight = true
    if input.sheet == 1 then
      input.collision_box = { { -4.4, -4.4 }, { 4.4, 4.4 } }
      input.selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } }
    end
    if input.sheet == 2 or input.sheet == 3 then
      input.collision_box = { { -1.4, -1.4 }, { 1.4, 1.4 } }
      input.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
    end
  else
    --Unset resource category if resource yields fluids
    input.category = nil
    input.order = "a-" .. input.order
    input.highlight = false
    input.collision_box = { { -0.1, -0.1 }, { 0.1, 0.1 } }
    input.selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } }
  end
  --Add fluidrequirements according to mod options
  if
    input.acid_to_mine and angelsmods.ores and angelsmods.ores.enablefluidreq
    or (input.name == "uranium-ore" or input.name == "infinite-uranium-ore")
      and settings.startup["angels-keepuranacid"].value
  then
    input.acid_amount = 10
  end
  --Get map_color and icon from the regular resource
  if input.get then
    input.map_color = data.raw.resource[input.get].map_color
    -- TMP: Turn the infinite coal to pink on the map
    if input.get == "coal" then
      input.map_color = {
        r = 1.0,
        g = 0.2,
        b = 1.0
      }
    end
    --autoplace_ret_table.autoplace_control_name=input.get

    -- Having the same as the vanilla patch causes collisions on name expressions here!
    -- It seems we must set the same as the vanilla resource to get noise expressions to overlap though!
    autoplace_ret_table.patch_set_name = input.name

    -- WORKAROUND: Fix up the indices to get identical spot noise generation
    -- See https://github.com/Arch666Angel/mods/issues/1046 for more
    if input.workaround_fixup_rng_seed then
      autoplace_sets.default.regular.patch_set_indexes[input.name] = autoplace_sets.default.regular.patch_set_indexes[input.get]
    end

    if data.raw.resource[input.get] then
      if data.raw.resource[input.get].icon_size then
        input.icon_size = data.raw.resource[input.get].icon_size
      else
        input.icon_size = 32
      end
      if data.raw.resource[input.get].icon then
        ret_table.icon = data.raw.resource[input.get].icon
      end
      if data.raw.resource[input.get].icons then
        ret_table.icons = data.raw.resource[input.get].icons
      end
    end
  elseif not input.icon_size then
    input.icon_size = 32
  end

  if input.icon then
    if not input.icon_size then
      input.icon_size = 32
    end
    ret_table.icons = { { icon = input.icon, icon_size = input.icon_size } }
  end
  ret_table.name = input.name
  ret_table.subgroup = input.subgroup
  ret_table.icon_size = input.icon_size
  ret_table.category = input.category
  ret_table.order = input.order
  ret_table.highlight = input.highlight
  ret_table.infinite = input.infinite
  ret_table.minimum = input.minimum
  ret_table.normal = input.normal
  --ret_table.maximum = input.maximum
  ret_table.minable = {
    --hardness = input.hardness,
    mining_particle = input.particle,
    mining_time = input.mining_time,
    fluid_amount = input.acid_amount,
    results = {
      {
        type = input.type,
        name = input.output_name,
        amount_min = input.output_min,
        amount_max = input.output_max,
        probability = input.output_probability,
        temperature = input.temperature,
      },
    },
  }
  ret_table.collision_box = input.collision_box
  ret_table.selection_box = input.selection_box
  ret_table.stage_counts = stages_count
  ret_table.stages = make_resgfx(input)
  ret_table.stages_effect = make_resglow(input)
  ret_table.effect_animation_period = input.gfx_ani_per
  ret_table.effect_animation_period_deviation = input.gfx_ani_dev
  ret_table.effect_darkness_multiplier = input.gfx_dark_mul
  ret_table.min_effect_alpha = input.gfx_alpha_min
  ret_table.max_effect_alpha = input.gfx_alpha_max
  ret_table.map_color = input.map_color
  ret_table.map_grid = input.map_grid
  ret_table.autoplace = resource_autoplace.resource_autoplace_settings(autoplace_ret_table)
  data:extend({ ret_table })
end

-- Fixup slider orders
for k, v in pairs(data.raw["autoplace-control"]) do
  v.order = "b"
end
data.raw["autoplace-control"]["coal"].order = "aaa"
data.raw["autoplace-control"]["infinite-coal"].order = "aab"

if settings.startup["repro-remove-blob-noise"].value then
  log("Disabling blob noise!!!")
  -- Fixup: Remove blob noise from regular patches
  data.raw["noise-function"]["resource_autoplace_all_patches"].local_functions.regular_blob_amplitude_at.expression="0"
end

if settings.startup["repro-remove-probability-upper-clamp"].value then
  log("Disabling probability clamping!!!")
  local prob = data.raw["resource"]["infinite-coal"].autoplace.probability_expression
  prob = prob:gsub("clamp(var('default-infinite-coal-patches'), 0, 1)", "max(var('default-infinite-coal-patches'), 0)")
  data.raw["resource"]["infinite-coal"].autoplace.probability_expression = prob

  local prob = data.raw["resource"]["coal"].autoplace.probability_expression
  prob = prob:gsub("clamp(var('default-coal-patches'), 0, 1)", "max(var('default-coal-patches'), 0)")
  data.raw["resource"]["coal"].autoplace.probability_expression = prob

end
