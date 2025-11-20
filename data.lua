log("### hello world ###")

require("add-resource")

if settings.startup["repro-enable-noise-tools"].value then
  require("noise-tools/lualib/math")
  noise_debug = require("noise-tools/noise-debug")
end
