require 'helper'

class TestOpenidMongodbStore < Test::Unit::TestCase
  def test_store_and_retrieve_association
    # Make sure there isn't already an association in the database
    assert !get_association

    # Save an assocaition
    assert store_association

    # Retrieve the association
    assert store.get_association(server_url, handle)
  end

  def test_remove_association
    store_association

    # Ensure an assocaition exists
    assert get_association

    # Remove a specific association
    assert store.remove_association(server_url,handle)
    # Confirm that the association is gone.
    assert !get_association
  end

  def test_use_nonce
    # If a timestamp is too old, use_nonce should return false
    too_old_timestamp = timestamp - (OpenID::Nonce.skew * 1.5).to_i
    assert !store.use_nonce(server_url, too_old_timestamp, salt)

    # When no nonces exist, this should return true and create a nonce record
    assert store.use_nonce(server_url, timestamp, salt)

    # After a nonce is created with a given salt/timestamp, use_nonce should return false
    assert !store.use_nonce(server_url, timestamp, salt)
  end

  def test_cleanup_nonces
    too_old_timestamp = timestamp - (OpenID::Nonce.skew * 1.5).to_i
    store.nonces.insert({'server_url' => server_url, 'timestamp' => too_old_timestamp, 'salt' => salt})

    # Verify nonce is inserted
    assert store.nonces.find_one({'server_url'=> server_url, 'timestamp' => too_old_timestamp, 'salt' => salt})

    # Cleanup nonces
    assert store.cleanup_nonces

    # Verify nonce was cleaned up
    assert !store.nonces.find_one({'server_url'=> server_url, 'timestamp' => too_old_timestamp, 'salt' => salt})
  end

  def test_cleanup_associations
    too_old_timestamp = timestamp - (60*60*24*365) # year old
    # assert store.store_association(:timestamp => too_old_timestamp)
    store.associations.insert('server_url' => server_url,
                              'handle'     => handle,
                              'secret'     => BSON::Binary.new(secret),
                              'issued'     => too_old_timestamp,
                              'lifetime'   => lifetime,
                              'assoc_type' => assoc_type,
                              'expire_at'  => (too_old_timestamp + lifetime))


    # Ensure association was saved
    assert store.associations.find_one({'issued' => too_old_timestamp})

    # Cleanup associations
    assert store.cleanup_associations

    # Ensure association was removed
    assert !store.associations.find_one({'issued' => too_old_timestamp})

  end
end
