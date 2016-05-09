--[[ Returns whether string `s` starts with `substring`. ]]
function string.startswith(s, substring)
  return string.sub(s, 1, string.len(substring)) == substring
end

--[[ Returns whether string `s` ends with `substring`. ]]
function string.endswith(s, substring)
  return string.sub(s, -string.len(substring)) == substring
end
