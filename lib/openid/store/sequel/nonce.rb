module OpenID
  module Store
    class Sequel
      class Nonce < ::Sequel::Model(:open_id_nonces)
      end
    end
  end
end
