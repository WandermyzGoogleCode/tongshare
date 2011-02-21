require 'test_helper'

class ThuauthHelperTest < ActionView::TestCase
  test "encrypt-decrypte" do
    e = encrypt("Topsecret", ThuauthController::SECRET)
    pp e
    d = decrypt(e, ThuauthController::SECRET)
    assert d == "Topsecret"
  end

end
