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
    @store = OpenidMongodbStore::Store.new(test_database)
  end

  def teardown
    test_database.drop_collection 'openid_mongo_store_associations'
    test_database.drop_collection 'openid_mongo_store_nonces'
    puts 'bye'
  end

end
