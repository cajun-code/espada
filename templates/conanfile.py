from conans import ConanFile, CMake

class {{name}}Conan(ConanFile):
   settings = "os", "compiler", "build_type", "arch"
   requires = [
        
   ] # comma-separated list of requirements
   generators = "cmake", "gcc", "txt"
   #default_options = {"poco:shared": True, "openssl:shared": True}

   def imports(self):
      self.copy("*.dll", dst="bin", src="bin") # From bin to bin
      self.copy("*.dylib*", dst="bin", src="lib") # From lib to bin

   def build(self):
      cmake = CMake(self)
      cmake.configure()
      cmake.build()