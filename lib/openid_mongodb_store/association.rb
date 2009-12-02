class OpenidMongodbStore::Association
  
  before_save :compute_expire_at
  
  key :expire_at, Integer
  
  ATTRIBUTES = [:handle, :secret, :issued, :lifetime, :assoc_type]
  ATTRIBUTES.each {|attr| attr_accessor(attr) }
  
  def self.collection
    @@collection ||= OpenidMongodbStore.database.collection('openid_mongo_store_association')
  end
  
  def initialize(attributes)
    attributes.each_pair do |k,v|
      send "#{k}=", v
    end
  end
  
  def save
    collection.insert(attributes)
  end
  
  def attributes
    ATTRIBUTES.inject({}) do |memo, attr|
      memo.merge attr, send(attr)
    end
  end
  
  def self.create(attributes)
    new(attributes)
  end
  
  
  def from_record
    OpenID::Association.new(handle, secret, issued, lifetime, assoc_type)
  end
  
  protected
    def compute_expire_at
      self.expire_at = issued + lifetime
    end
  
end