require 'openid'
require 'mongo'

module OpenidMongodbStore
  
  def self.database=(db)
    @@database = db
  end
  
  def database
    @@database
  end
  
end

require File.dirname(__FILE__) + '/openid_mongodb_store/store'