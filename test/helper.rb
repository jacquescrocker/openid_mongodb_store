require 'rubygems'
require 'test/unit'
require 'mocha'
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

  def store
    @store ||= OpenidMongodbStore::Store.new(test_database)
  end

  def store_association(opts = {})
    association = OpenID::Association.new(handle, secret, timestamp, lifetime, assoc_type)
    opts.each_pair {|k,v| association.send "#{k}=", v}
    store.store_association(server_url,association)
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
    @timestamp ||= Time.now - 10 # 10 seconds ago
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

  def teardown
    test_database.drop_collection 'openid_mongo_store_associations'
    test_database.drop_collection 'openid_mongo_store_nonces'
  end

end
