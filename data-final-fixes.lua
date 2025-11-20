if settings.startup["repro-enable-noise-tools"].value then
  require("noise-tools/ore-debug")
  -- LAST
  noise_debug.apply_controls()
end