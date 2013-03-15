require "rtfs"

RSpec.configure do |config|
  config.color = true
end

$tfs = RTFS::Client.tfs(:ns_addr => 'http://10.232.4.44:3800',
                        :appkey => '4f8fbb734d4d8')