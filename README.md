RTFS
====

RTFS is a Ruby Client of [TFS](http://code.taobao.org/project/view/366/).

For TFS integration with CarrierWave, see
[carrierwave-tfs](http://github.com/huacnlee/carrierwave-tfs) for more
information.


Requirements
------------

* <del>Linux System (tfstool can only be built on Linux Systems).</del>
* <del>tfstool</del>

2013-03-14

These are no longer valid requirements. TFS now favors
[Web Service API](http://baike.corp.taobao.com/index.php/CS_RD/tfs/use_web_service),
which requires nothing but a decent REST client of the language you choose.

See the [official documentation](http://baike.corp.taobao.com/index.php/CS_RD/tfs)
for more information about APIs and service applications.


Install
-------

```bash
$ gem install rtfs
```

Configure
---------

or How to integrate into Rails app.

Create `tfs.yml` in your rails app's config directory. The content of it should
look like this:

```yaml
# config/tfs.yml
defaults: &defaults
  host: 'http://127.0.0.1:3900'
  appkey: "myprecious"

development:
  <<: *defaults

test:
  <<: *defaults

production:
  <<: *defaults
```

Create an initializer too. Call it `tfs.rb` or whatever filename you fancy:


```ruby
# config/initializers/tfs.rb
require 'rtfs'
tfs_config = YAML.load_file("#{Rails.root}/config/tfs.yml")[Rails.env]
$tfs = RTFS::Client.tfs(tfs_config.merge({:ns_addr => tfs_config['host']}))
```

Then `$tfs` will be available as a global object.


Simple Usage
------------

```ruby
# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def save
    @user = User.new
    ext = File.extname(params[:Filedata].original_filename)
    file_name = $tfs.put(params[:Filedata].tempfile.path, :ext => ext)
    @user.avatar_path = [file_name,ext].join("")
  end
end

# app/models/user.rb
class User < ActiveRecord::Base
  def avatar_url
    server_id = self.id % 4 + 1
    "http://img#{server_id}.tbcdn.com/#{self.avatar_path}"
  end
end
```

Put local file into TFS server:

```bash
$ bundle exec rails c
irb> $tfs.put("~/Downloads/a.jpg")
T1Ub1XXeFBXXb1upjX
RTFS
```


API
---

```ruby
# initialize client
tfs = RTFS::Client.new(:ns_addr => 'http://127.0.0.1:3800',
                       :appkey  => 'myprecious')

# simply put file
tfs.put('foo.jpg')          # ==> T1Ub1XXeFBXXb1upjX

# stat file
tfs.stat('T1Ub1XXeFBXXb1upjX')

# remove file
tfs.rm('T1Ub1XXeFBXXb1upjX')

# put named file, keep that name in TFS
tfs.save('foo.jpg')         # ==> 133/7463/foo.jpg

# remove named file
tfs.del('foo.jpg')          # ==> true
```


Executabes?
-----------

RTFS will be available as a executable binary soon. Stay tuned...