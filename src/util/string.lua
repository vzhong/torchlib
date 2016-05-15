--- @arg {string} s - larger string
-- @arg {string} substring - smaller string
-- @returns {boolean} whether the larger string starts with the smaller string
function string.startswith(s, substring)
  return string.sub(s, 1, string.len(substring)) == substring
end

--- @arg {string} s - larger string
-- @arg {string} substring - smaller string
-- @returns {boolean} whether the larger string ends with the smaller string
function string.endswith(s, substring)
  return string.sub(s, -string.len(substring)) == substring
end
