require 'test/unit'
require 'openid/store/sequel'

DB = Sequel.connect(ENV['DATABASE_URL'] || "postgres://localhost/openid_store_sequel_test")
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
