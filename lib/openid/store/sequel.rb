require "base64"
require "sequel"

require 'openid/util'
require 'openid/store/nonce'
require 'openid/association'

module OpenID
  module Store
    class Sequel
      autoload :Association, "openid/store/sequel/association"
      autoload :Nonce, "openid/store/sequel/nonce"

      def store_association(server_url, assoc)
        remove_association(server_url, assoc.handle)
        OpenID::Store::Sequel::Association.create(
                           server_url: server_url,
                           handle: assoc.handle,
                           secret: Base64.encode64(assoc.secret),
                           issued: assoc.issued,
                           lifetime: assoc.lifetime,
                           assoc_type: assoc.assoc_type
        )
      end

      def get_association(server_url, handle=nil)
        assocs = if handle.nil? || handle.empty?
            OpenID::Store::Sequel::Association.where(server_url: server_url)
          else
            OpenID::Store::Sequel::Association.where(server_url: server_url, handle: handle)
          end

        assocs.to_a.reverse.each do |assoc|
          a = assoc.from_record
          if a.expires_in == 0
            assoc.destroy
          else
            return a
          end
        end if assocs.any?

        return nil
      end

      def remove_association(server_url, handle)
        OpenID::Store::Sequel::Association.dataset.filter(server_url: server_url, handle: handle).delete > 0 ? true : false
      end

      def use_nonce(server_url, timestamp, salt)
        return false if OpenID::Store::Sequel::Nonce.first(server_url: server_url, timestamp: Time.at(timestamp), salt: salt) || (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
        OpenID::Store::Sequel::Nonce.create(server_url: server_url, timestamp: Time.at(timestamp), salt: salt)
        return true
      end

      def cleanup_nonces
        now = Time.now.to_i
        count = 0
        OpenID::Store::Sequel::Nonce.where("timestamp > '#{Time.at(now + OpenID::Nonce.skew)}' OR timestamp < '#{Time.at(now - OpenID::Nonce.skew)}'").each do |nonce|
          nonce.destroy
          count += 1
        end
        count
      end

      def cleanup_associations
        count = 0
        OpenID::Store::Sequel::Association.where('issued > 0').each do |association|
          if association.lifetime + association.issued > Time.now.to_i
            association.destroy
            count += 1
          end
        end
        count
      end
    end
  end
end
