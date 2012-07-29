# OpenID Store Sequel

![](https://github.com/dylanegan/openid-store-sequel/raw/master/cat-attack.gif)

Storing your OpenIDs in your Sequels.

[![Build Status](https://secure.travis-ci.org/dylanegan/openid-store-sequel.png?branch=master)](http://travis-ci.org/dylanegan/openid-store-sequel)

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

## File/bytea type field compatability issue

There is an issue with File/bytea type fields when using an older version of the postgres client with a new postgres database. If you are having trouble getting things to work properly you can try reverting the bytea_output behavior to 'escape'.
   
```ruby
if DB.adapter_scheme == :postgres
  begin
    DB.run("ALTER ROLE #{DB['select current_user'].first[:current_user]} SET bytea_output TO 'escape'")
    puts "Success, bytea_output set to 'escape'. Re-establish your database connections to use the new encoding format."
  rescue Sequel::DatabaseError => e
    if e.message =~ /unrecognized configuration parameter "bytea_output"/
      puts "It looks like you are connected to a legacy postgres server that uses 'escape' output by default. Bytea fields should work as expected."
    else
      raise e
    end
  end
end
```

## License (MIT)

Copyright © 2012 [Merman](http://dylanegan.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
