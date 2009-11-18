require File.dirname(__FILE__) + '/nonce'
require File.dirname(__FILE__) + '/association'

# Again, from the OpenID gem
require 'openid/store/interface'


class OpenidMongodbStore::Store < OpenID::Store::Interface
  include OpenidMongodbStore
  def store_association(server_url, association)
    remove_association(server_url, association.handle)
    Association.create(:server_url => server_url,
                       :handle     => association.handle,
                       :secret     => association.secret,
                       :issued     => association.issued,
                       :lifetime   => association.lifetime,
                       :assoc_type => association.assoc_type)
  end

  def get_association(server_url, handle=nil)
    assocs = if handle.blank?
      Association.all(:conditions => {:server_url => server_url})
    else
      Association.all(:conditions => {:server_url => server_url, :handle => handle})
    end

    assocs.reverse.each do |assoc|
      a = assoc.from_record
      if a.expires_in == 0
        assoc.destroy
      else
        return a
      end
    end if assocs.any? # <- may not be needed
    
    # Fail if there isn't an acceptable association
    return nil
  end
  
  def remove_association(server_url, handle)
    Association.delete_all(:server_url => server_url, :handle => handle)
  end
  
  def use_nonce(server_url, timestamp, salt)
    return false if Nonce.first(:conditions => {:server_url=>server_url,
                                                :timestamp => timestamp,
                                                :salt => salt})
    return false if (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
    Nonce.create(:server_url => server_url, :timestamp => timestamp, :salt => salt)
    return true
  end
  
  def cleanup_nonces
    now = Time.now.to_i
    Nonce.delete_all({:timestamp => {'$gt'=> (now + OpenID::Nonce.skew),
                                     '$lt'=> (now - OpenID::Nonce.skew)}})
  end

  def cleanup_associations
    now = Time.now.to_i
    Association.delete_all(:expire_at => {'$gt' => now})
  end
  
end