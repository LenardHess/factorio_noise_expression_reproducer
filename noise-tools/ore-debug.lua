noise_debug.hide_map_cliffs()
noise_debug.remove_non_tile_autoplace()

--noise_debug.tiles_to_visualisation("visualisation", -25, 50, "3-band")
--noise_debug.tiles_to_visualisation("visualisation", -1, 2, "3-band")
--noise_debug.tiles_to_visualisation("visualisation", -1, 2, "custom")
--noise_debug.tiles_to_visualisation("visualisation", -1, 1, "greyscale")
noise_debug.tiles_to_visualisation("visualisation", 0, 1, "greyscale")
--noise_debug.tiles_to_visualisation("visualisation", -10, 10, "greyscale")


noise_debug.add_visualisation_target("normal-coal-patches", "var('default-coal-patches')", 1)
-- noise_debug.add_visualisation_target("normal-coal-probability", "(var('control:coal:size') > 0) * (clamp(var('default-coal-patches'), 0, 1))", 1)
-- noise_debug.add_visualisation_target("normal-coal-richness", "(var('control:coal:size') > 0) * (1*var('control:coal:richness')*(var('default-coal-patches'))*max((1000+distance)/2600,1))", 1)
noise_debug.add_visualisation_target("normal_positive", "if((var('default-coal-patches') > 0), 1, 0)", 1)

noise_debug.add_visualisation_target("infinite-coal-patches", "var('default-infinite-coal-patches')", 1)
-- noise_debug.add_visualisation_target("infinite-coal-probability", "(var('control:infinite-coal:size') > 0) * (clamp(var('default-infinite-coal-patches'), 0, 1))", 1)
-- noise_debug.add_visualisation_target("infinite-coal-richness", "(var('control:infinite-coal:size') > 0) * (1*var('control:infinite-coal:richness')*(var('default-infinite-coal-patches'))*max((1000+distance)/2600,1))", 1)
noise_debug.add_visualisation_target("infinite_positive", "if((var('default-infinite-coal-patches') > 0), 1, 0)", 1)

-- noise_debug.add_visualisation_target("prob_normal_gt_infinite", " if(((var('control:coal:size') > 0) * (clamp(var('default-coal-patches'), 0, 1))) > ((var('control:infinite-coal:size') > 0) * (clamp(var('default-infinite-coal-patches'), 0, 1))), 1, 0)", 1)

noise_debug.add_visualisation_target("normal_positive_and_gt_infinite",      "if(var('default-coal-patches') > 0, 0.25, 0) + if( var('default-coal-patches') > var('default-infinite-coal-patches'), 0.5, 0)", 1)
-- noise_debug.add_visualisation_target("WTF1_normal_positive_and_gt_infinite", "if(var('default-coal-patches') > 0, 0, 0) + if( var('default-coal-patches') > var('default-infinite-coal-patches'), 0.5, 0)", 1)
-- noise_debug.add_visualisation_target("WTF2_normal_positive_and_gt_infinite", "if(var('default-coal-patches') > 0, 0, 0) + if( var('default-coal-patches') > var('default-infinite-coal-patches'), 1, 0)", 1)
-- noise_debug.add_visualisation_target("WTF3_normal_positive_and_gt_infinite", "if( var('default-coal-patches') > var('default-infinite-coal-patches'), 1, 0) + if(var('default-coal-patches') > 0, 0, 0)", 1)
-- noise_debug.add_visualisation_target("WTF4_normal_positive_and_gt_infinite", "if( var('default-coal-patches') > var('default-infinite-coal-patches'), 1, 0) + 0", 1)
-- noise_debug.add_visualisation_target("WTF5_normal_positive_and_gt_infinite", "if( var('default-coal-patches') > var('default-infinite-coal-patches'), 1, 0) + (var('default-coal-patches')*0)", 1)
noise_debug.add_visualisation_target("normal_gt_infinite",                   "if( var('default-coal-patches') > var('default-infinite-coal-patches'), 1, 0)", 1)

-- set the default
data.raw["noise-expression"].visualisation.expression = "var('debug_normal-coal-patches')"
