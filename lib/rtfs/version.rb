# Version for RTFS
# by nowa<nowazhu@gmail.com> 2011-07-23

module RTFS::Version
  MAJOR = 0
  MINOR = 0
  REVISION = 3
  
  class << self
    # Returns X.Y.Z formatted version string
    def to_version
      "#{MAJOR}.#{MINOR}.#{REVISION}"
    end

    # Returns X-Y-Z formatted version name
    def to_name
      "#{MAJOR}_#{MINOR}_#{REVISION}"
    end
  end
end