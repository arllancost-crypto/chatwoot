require 'rails_helper'

RSpec.describe User do
  describe 'password policy after Rails upgrade' do
    %w[lowercase123! UPPERCASE123! NoNumbersHere! NoSpecial123].each do |password|
      it "rejects a password missing a required character category: #{password}" do
        user = build(:user, password: password, password_confirmation: password)
        user.valid?

        expect(user.errors[:password]).to be_present
      end
    end

    it 'retains password hashing and verification' do
      user = create(:user, password: 'Strong-Test-984!', password_confirmation: 'Strong-Test-984!')

      expect(user.reload.valid_password?('Strong-Test-984!')).to be(true)
      expect(user.valid_password?('Wrong-Test-984!')).to be(false)
    end
  end
end
