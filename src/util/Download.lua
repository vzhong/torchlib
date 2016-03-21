--[[ A download utility with caching support. ]]
local Downloader = torch.class('tl.Downloader')

--[[ Constructor.
  - `cache` (optional): cache directory, defaults to `/tmp/torchlib`

  Options:
  - `verbose`: prints out progress
]]
function Downloader:__init(cache, opt)
  opt = opt or {}
  self.cache = cache or '/tmp/torchlib'
  self.verbose = opt.verbose
  if not path.exists(self.cache) then
    if self.verbose then print('WARNING: Making cache directory at '..self.cache) end
    path.mkdir(self.cache)
  end
end

--[[ Retrieves a file from cache, downloading it from `url` if it doesn't exists
  - `to`: Location to download to, relative to the cache directory
  - `url` (optional): URL to download from.

  Options:
  - `force`: overwrite the file if one exists.
]]
function Downloader:get(to, url, opt)
  opt = opt or {}
  local to_path = path.join(self.cache, to)
  if path.exists(to_path) and not opt.force then
    -- exists already, just return the path
  else
    os.execute('wget -O '..to_path..' '..url)
    local f = assert(io.open(to_path, 'rb'))
    f:close()
  end
  return to_path
end

return Downloader
