require 'test_helper'

class SharingTest < ActiveSupport::TestCase
  fixtures :user_identifiers
  fixtures :events

  setup do
    Sharing.delete_all
    UserSharing.delete_all
  end

  test "for add_sharing, decide_by_user, basic" do
    #add_sharing
    hashs = []
    user_identifiers(:em_one, :em_two, :email_one, :email_two, :mo_one, :mo_two).each do |uid|
      hashs << {:login_value => uid.login_value, :login_type => uid.login_type}
    end
    ret = events(:one_instance).add_sharing(1, "extra", hashs)
    #pp ret
    assert ret
    #pp events(:one_instance).sharings
    ret = events(:one_instance).sharings.to_a[0].user_sharings.to_a
    #pp ret.size
    assert ret.size == 2
    assert ret[0].user_id == 1
    assert ret[1].user_id == 2

    #decide_by_user, accept
    assert_nil ret[1].accept?
    assert events(:one_instance).decide_by_user(2, true)
    assert ret[1].accept?
    assert events(:one_instance).decide_by_user(2, false)
    assert !ret[1].accept?
  end
  
end