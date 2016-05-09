function string.startswith(s, substring)
  return string.sub(s, 1, string.len(substring)) == substring
end

function string.endswith(s, substring)
  return string.sub(s, -string.len(substring)) == substring
end
