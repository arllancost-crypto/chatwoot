require 'rails_helper'

RSpec.describe 'Platform account role isolation', type: :request do
  it 'cannot grant administrator in an account the platform app does not manage' do
    platform_app = create(:platform_app)
    account = create(:account)
    user = create(:user)

    expect do
      post "/platform/api/v1/accounts/#{account.id}/account_users",
           params: { user_id: user.id, role: 'administrator' },
           headers: { api_access_token: platform_app.access_token.token }, as: :json
    end.not_to change(account.account_users, :count)
    expect(response).to have_http_status(:unauthorized)
  end
end
