require 'rubygems'
require 'rack'
require 'rack/openid'
require 'easy_rack_open_id'
require 'lib/openid_mongodb_store'
require 'ruby-debug'

class HelloWorld
  def call(env)
    [200, {"Content-Type" => "text/plain"}, ["Made it through!"]]
  end
end



use Rack::Session::Cookie
use Rack::OpenID, OpenidMongodbStore::Store.new(Mongo::Connection.new.db('testorama'))
use EasyRackOpenID, :allowed_identifiers => ['http://samsm.com/']

run HelloWorld.new
