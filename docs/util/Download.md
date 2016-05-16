# Downloader
A download utility with caching support.




## Downloader:\_\_init(cache, opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/Download.lua#L15)

Constructor.

Arguments:

- `cache ` (`string`): cache directory. Optional, Default: `'/tmp/torchlib'`.

Options:

- `verbose`: prints out progress

## Downloader:get(to, url, opt)
[View source](http://github.com/vzhong/torchlib/blob/master/src//util/Download.lua#L33)

Retrieves a file from cache, downloading it from `url` if it doesn't exists.

Arguments:

- `to ` (`string`): location to download to, relative to the cache directory.
- `url ` (`string`): url to download from. Optional.
- `opt ` (`table[string:any]`): options. Optional.

Options:

- `force`: overwrite the file if one exists.

