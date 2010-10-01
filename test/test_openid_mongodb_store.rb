require 'helper'

class TestOpenidMongodbStore < Test::Unit::TestCase
  def test_store_and_retrieve_association
    # Make sure there isn't already an association in the database
    assert !get_association

    # Save an assocaition
    assert store_association

    # Retrieve the association
    assert assoc = store.get_association(server_url, handle)

    # Check status of secret
    assert assoc.secret == secret
  end

  def test_text_date_association
    store_association(Time.now.to_s)

    assert assoc = get_association
  end

  def test_time_object_association
    store_association(Time.now)

    assert get_association
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
    assert !store.use_nonce(server_url, too_old_nonce_timestamp, salt)

    # When no nonces exist, this should return true and create a nonce record
    assert store.use_nonce(server_url, timestamp, salt)

    # After a nonce is created with a given salt/timestamp, use_nonce should return false
    assert !store.use_nonce(server_url, timestamp, salt)
  end

  def test_cleanup_nonces
    insert_old_nonce

    # Verify nonce is inserted
    assert find_old_nonce

    # Cleanup nonces
    assert store.cleanup_nonces

    # Verify nonce was cleaned up
    assert !find_old_nonce
  end

  def test_cleanup_associations
    insert_old_association

    # Ensure association was saved
    assert find_old_association

    # Cleanup associations
    assert store.cleanup_associations

    # Ensure association was removed
    assert !find_old_association

  end
end
