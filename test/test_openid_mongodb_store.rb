require 'helper'

class TestOpenidMongodbStore < Test::Unit::TestCase
  def test_store_and_retrieve_association
    # Make sure there isn't already an association in the database
    assert !store.get_association(server_url, handle)

    # Save an assocaition
    assert store_association

    # Retrieve the association
    assert store.get_association(server_url, handle)
  end

  def test_remove_association
  end

  def test_use_nonce # three ways to test (fail a, fail b, success/create)

  end
end
