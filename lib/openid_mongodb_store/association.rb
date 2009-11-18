class OpenidMongodbStore::Association
  include MongoMapper::Document
  
  before_save :compute_expire_at
  
  key :expire_at, Integer
  
  def from_record
    OpenID::Association.new(handle, secret, issued, lifetime, assoc_type)
  end
  
  protected
    def compute_expire_at
      self.expire_at = issued + lifetime
    end
  
end