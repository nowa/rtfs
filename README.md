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
# initialize client.
tfs = RTFS::Client.new(:ns_addr => 'http://127.0.0.1:3800',
                       :appkey  => 'myprecious',
                       :basedir => Rails.root.join('public'))

# simply put file.
tfs.put('foo.jpg')          # ==> T1Ub1XXeFBXXb1upjX

# stat file.
tfs.stat('T1Ub1XXeFBXXb1upjX')

# remove file.
tfs.rm('T1Ub1XXeFBXXb1upjX')

# put named file, keep that name in TFS.
tfs.save('foo.jpg')         # ==> 133/7463/foo.jpg

# remove named file.
tfs.del('foo.jpg')          # ==> true
```


Custom Path
-----------

自定义文件名的完整路径处理逻辑如下：

```ruby
tfs = RTFS::Client.new(:ns_addr => 'http://127.0.0.1:3800',
                       :appkey  => 'myprecious',
                       :basedir => Rails.root.join('public'))
tfs.save('foo/ham.jpg')
```

将会做如下步骤：

 1. 判断你的 TFS 中是否已有这个文件，
 2. 如果有，先删掉，
 3. 创建这个文件，相当于 UNIX 中的 `touch` 命令，不写入实际内容，文件内容为空，
 4. 尝试打开 `basedir` 与传入的 `foo/ham.jpg` 拼起来的路径，在此例中，即：
    `Rails.root.join('public', 'foo/ham.jpg')`
 5. 将改文件数据写入 TFS

在这中间，有个概念需要说明，自定义路径中，有一层叫做 uid（User ID），目的是分散文件位置，
避免数据读写过度集中。如果希望把 TFS 当 CDN 用，则需要固定这个 uid，可以在实例化 `RTFS::Client`
时传入，也可以实例化之后赋值：

```ruby
tfs = RTFS::Client.new(:uid => 10001,
                       # other options...
                       )

tfs.uid = 10001
```

这里选择 10001 是有原因的。在 `RTFS::Client` 的实现中，如果用户没有指定 uid，
则它会根据传入的文件名自动计算，算该名称的哈希，然后取余，范围是 10000 之内。
而 10000 本身，则为 RTFS 的测试所用，所以，自定义的 uid，从 10001 开始，比较妥。


Executabes?
-----------

RTFS will be available as a executable binary soon. Stay tuned...
