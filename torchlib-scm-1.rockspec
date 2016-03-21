package = "torchlib"
version = "scm-1"

source = {
   url = "git://github.com/vzhong/torchlib",
   tag = "master"
}

description = {
   summary = "libraries for torch",
   detailed = [[
      libraries for torch
   ]],
   homepage = "https://github.com/vzhong/torchlib"
}

dependencies = {
}

build = {
   type = "command",
   build_command = [[
cmake -E make_directory build;
cd build;
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)"; 
$(MAKE)
   ]],
   install_command = "cd build && $(MAKE) install"
}
