# require File.dirname(__FILE__) + '/nonce'
# require File.dirname(__FILE__) + '/association'

# Again, from the OpenID gem
require 'openid/store/interface'


class OpenidMongodbStore::Store < OpenID::Store::Interface
  include OpenidMongodbStore
  
  def initialize(db = nil)
    OpenidMongodbStore.database = db
  end
  
  def associations
    @@associations ||= OpenidMongodbStore.database.collection('openid_mongo_store_associations')
  end
  
  def nonces
    @@nonces ||= OpenidMongodbStore.database.collection('openid_mongo_store_nonces')
  end
  
  def store_association(server_url, association)
    remove_association(server_url, association.handle)
    associations.insert(:server_url => server_url,
                        :handle     => association.handle,
                        :secret     => association.secret,
                        :issued     => association.issued,
                        :lifetime   => association.lifetime,
                        :assoc_type => association.assoc_type)
  end

  def get_association(server_url, handle=nil)
    assocs = if (handle.nil? or handle.empty?)
      associations.find({'server_url' => server_url})
    else
      associations.find({'server_url' => server_url, 'handle' => handle})
    end
    
    assoc_records = assocs.collect {|a| a }

    # TODO: Removed .reverse here, make sure that was reasonable.
    assoc_records.each do |a|
      openid_association = OpenID::Association.new(a['handle'],
                                                   a['secret'],
                                                   a['issued'],
                                                   a['lifetime'],
                                                   a['assoc_type'])
      if openid_association.expires_in == 0
        associations.remove({'_id' => a['_id']})
      else
        return openid_association
      end
    end if assoc_records.any? # <- may not be needed
    
    # Fail if there isn't an acceptable association
    return nil
  end
  
  def remove_association(server_url, handle)
    associations.remove({'server_url'=> server_url, 'handle' => handle})
  end
  
  def use_nonce(server_url, timestamp, salt)
    return false if nonces.find_one({'server_url'=> server_url,
                                     'timestamp' => timestamp,
                                     'salt'      => salt})
    return false if (timestamp - Time.now.to_i).abs > OpenID::Nonce.skew
    nonces.insert({'server_url' => server_url, 'timestamp' => timestamp, 'salt' => salt})
    return true
  end
  
  def cleanup_nonces
    now = Time.now.to_i
    nonces.remove({'timestamp' => {'$gt'=> (now + OpenID::Nonce.skew),
                                   '$lt'=> (now - OpenID::Nonce.skew)}})
  end

  def cleanup_associations
    now = Time.now.to_i
    # Association.delete_all(:expire_at => {'$gt' => now})
    associations.remove('expire_at' => {'$gt' => now})
  end
  
end