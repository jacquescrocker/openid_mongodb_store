require 'rubygems'
require 'test/unit'
require 'ruby-debug'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'openid_mongodb_store'

def test_database
  Mongo::Connection.new('localhost').db('openid_store_test')
end

class Test::Unit::TestCase

  def setup
    timestamp(true)
  end

  ##
  ## Mongo-specific database test configuration here.
  ##
  def teardown
    test_database.drop_collection 'openid_mongo_store_associations'
    test_database.drop_collection 'openid_mongo_store_nonces'
  end

  def store
    @store ||= OpenidMongodbStore::Store.new(test_database)
  end

  def insert_old_association
    store.associations.insert('server_url' => server_url,
                              'handle'     => handle,
                              'secret'     => BSON::Binary.new(secret),
                              'issued'     => too_old_association_timestamp,
                              'lifetime'   => lifetime,
                              'assoc_type' => assoc_type,
                              'expire_at'  => (too_old_association_timestamp + lifetime))

  end

  def find_old_association
    store.associations.find_one({'issued' => too_old_association_timestamp})
  end

  def insert_old_nonce
    store.nonces.insert({'server_url' => server_url, 'timestamp' => too_old_nonce_timestamp, 'salt' => salt})
  end

  def find_old_nonce
    store.nonces.find_one({'server_url'=> server_url, 'timestamp' => too_old_nonce_timestamp, 'salt' => salt})
  end

  ##
  ## End of Mongo-specific test config
  ##

  def too_old_nonce_timestamp
    timestamp - (OpenID::Nonce.skew * 1.5).to_i
  end

  def too_old_association_timestamp
    timestamp - (60*60*24*365) # year old
  end

  def store_association(issued = timestamp)
    association = OpenID::Association.new(handle, secret, issued, lifetime, assoc_type)
    store.store_association(server_url,association)
  end

  def get_association(server_url = server_url, handle = handle)
    store.get_association(server_url,handle)
  end

  def server_url
    "http://localhost:98765/"
  end

  def handle
    "{HMAC-SHA1}{4ca0a54b}{5Sx5CQ==}"
  end

  def secret
    OpenID::Util.from_base64("5EoS1O4V+x7VkBNEekHsavgRjbk=")
  end

  def timestamp(refresh = false)
    @timestamp = nil if refresh
    @timestamp ||= (Time.now - 10).to_i # 10 seconds ago
  end

  def lifetime
    1209600 # two weeks in seconds
  end

  def assoc_type
    "HMAC-SHA1"
  end

  def salt
    "KuIaaq"
  end

end
