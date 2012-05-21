# openid-store-sequel

Storing your OpenIDs in your Sequels.

## Usage

```ruby
require 'openid/store/sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || "postgres://localhost/openid_store_sequel")

DB.create_table! :open_id_associations do
  primary_key :id
  File        :server_url, :null => false
  String      :handle, :null => false
  File        :secret, :null => false
  Integer     :issued, :null => false
  Integer     :lifetime, :null => false
  String      :assoc_type, :null => false
end

DB.create_table! :open_id_nonces do
  primary_key :id
  String      :server_url, :null => false
  DateTime    :timestamp, :null => false
  String      :salt, :null => false
end

server = OpenID::Server::Server.new(OpenID::Store::Sequel.new, ...)
```

## License (MIT)

Copyright © 2012 [Merman](http://dylanegan.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
