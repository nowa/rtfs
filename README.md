RTFS
====

RTFS is a Ruby Client for TFS.

[About TFS](http://code.taobao.org/project/view/366/)

This is basicly library for TFS access, you can use [carrierwave-tfs](http://github.com/huacnlee/carrierwave-tfs) for Carrierwave.

Requirements
------------

* Linux System (TFS only success build in Linux system.)
* TFS

INSTALL
-------

```bash
$ gem install rtfs
```

Configure
---------

create this files before using.

config/tfs.yml

```yaml
defaults: &defaults
  host: '127.0.0.1:3100'
  # or use WebService
  host: 'http://127.0.0.1:3900'
  appkey: "......."

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

config/initialize/tfs.rb

```ruby
require 'rtfs'
tfs_config = YAML.load_file("#{Rails.root}/config/tfs.yml")[Rails.env]
$tfs = RTFS::Client.tfs(tfs_config.merge({:ns_addr => tfs_config['host']}))
```

:ns_addr include http:// tfs used webservice


Usage
-----

```ruby
class UsersController < ApplicationController
  def save
    @user = User.new
    ext = File.extname(params[:Filedata].original_filename)
    file_name = $tfs.put(params[:Filedata].tempfile.path, :ext => ext)
    @user.avatar_path = [file_name,ext].join("")
  end
end


class User < ActiveRecord::Base
  def avatar_url
    server_id = self.id % 4 + 1
    "http://img#{server_id}.tbcdn.com/#{self.avatar_path}"
  end
end
```

Put local file to TFS

```bash
irb> $tfs.put("~/Downloads/a.jpg")
T1Ub1XXeFBXXb1upjX
RTFS