require 'openid'
require 'mongo'

module OpenidMongodbStore
  @@database = nil
  def self.database=(db)
    @@database = db
  end
  
  def self.database
    @@database
  end
  
end

require File.dirname(__FILE__) + '/openid_mongodb_store/store'