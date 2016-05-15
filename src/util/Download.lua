local torch = require 'torch'
local path = require 'pl.path'

--- @module Downloader
-- A download utility with caching support.
local Downloader = torch.class('tl.Downloader')

--- Constructor.
--
--  @arg {string='/tmp/torchlib'} cache - cache directory
--
--  Options:
--
--  - `verbose`: prints out progress
function Downloader:__init(cache, opt)
  opt = opt or {}
  self.cache = cache or '/tmp/torchlib'
  self.verbose = opt.verbose
  if not path.exists(self.cache) then
    if self.verbose then print('WARNING: Making cache directory at '..self.cache) end
    path.mkdir(self.cache)
  end
end

--- Retrieves a file from cache, downloading it from `url` if it doesn't exists.
--  @arg {string} to - location to download to, relative to the cache directory
--  @arg {string=} url - url to download from
--  @arg {table[string:any]=} opt - options
--
--  Options:
--
--  - `force`: overwrite the file if one exists.
function Downloader:get(to, url, opt)
  opt = opt or {}
  local to_path = path.join(self.cache, to)
  if (not path.exists(to_path)) or opt.force then
    os.execute('wget -O '..to_path..' '..url)
    local f = assert(io.open(to_path, 'rb'))
    f:close()
  end
  return to_path
end

return Downloader
