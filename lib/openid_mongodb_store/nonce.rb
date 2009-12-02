class OpenidMongodbStore::Nonce
  def self.collection
    @@collection ||= OpenidMongodbStore.database.collection('openid_mongo_store_nonce')
  end
end