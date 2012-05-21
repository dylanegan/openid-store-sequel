module OpenID
  module Store
    class Sequel
      class Association < ::Sequel::Model(:open_id_associations)
        def from_record
          OpenID::Association.new(handle, Base64.decode64(secret), Time.at(issued), lifetime, assoc_type)
        end
      end
    end
  end
end
