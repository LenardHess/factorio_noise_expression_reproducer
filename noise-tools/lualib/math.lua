-- extends math
math.phi = (1 + math.sqrt(5)) / 2

math.log2 = function(v)
  return math.log(v) / math.log(2)
end

math.clamp = function(a, b, c)
  return math.max(b, math.min(a, c))
end

math.sign = function(a)
  return a > 0 and 1 or (a < 0 and -1 or 0)
end
