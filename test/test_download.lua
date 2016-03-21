local Downloader = require('torchlib').Downloader

local TestDownload = torch.TestSuite()
local tester = torch.Tester()

local T = torch.Tensor

function TestDownload.test_cache()
  local d = Downloader()
  tester:asserteq('/tmp/torchlib', d.cache)
  tester:asserteq(false, path.exists('./foo'))
  d = Downloader('/tmp/torchlib-foo')
  tester:assert(path.exists('/tmp/torchlib-foo') ~= nil)
  path.rmdir('/tmp/torchlib-foo')
end

function TestDownload.test_get()
  local d = Downloader()
  local ret = d:get('google.txt', 'http://www.google.com/robots.txt')
  tester:asserteq(ret, '/tmp/torchlib/google.txt')
  tester:assert(path.exists('/tmp/torchlib/google.txt') ~= nil)
end

tester:add(TestDownload)
tester:run()
