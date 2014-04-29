package = "examplepackage"
version = "scm-1"

source = {
   url = "git://github.com/soumith/examplepackage.torch",
   tag = "master"
}

description = {
   summary = "A hello-world for torch packages",
   detailed = [[
   	    A hello-world for torch packages
   ]],
   homepage = "https://github.com/soumith/examplepackage.torch"
}

dependencies = {
   "torch >= 7.0"
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
