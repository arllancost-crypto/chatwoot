require 'rails_helper'

RSpec.describe 'Platform agent bot account isolation', type: :request do
  let(:platform_app) { create(:platform_app) }
  let(:account) { create(:account) }
  let(:headers) { { api_access_token: platform_app.access_token.token } }

  it 'rejects creation in an account not managed by the platform app' do
    expect do
      post '/platform/api/v1/agent_bots', params: { name: 'Scoped bot', account_id: account.id }, headers: headers, as: :json
    end.not_to change(AgentBot, :count)
    expect(response).to have_http_status(:unauthorized)
  end

  it 'allows creation in a managed account' do
    create(:platform_app_permissible, platform_app: platform_app, permissible: account)
    post '/platform/api/v1/agent_bots', params: { name: 'Scoped bot', account_id: account.id }, headers: headers, as: :json
    expect(response).to have_http_status(:success)
    expect(AgentBot.find(response.parsed_body['id']).account_id).to eq(account.id)
  end

  it 'rejects reassignment to an unmanaged account' do
    bot = create(:agent_bot)
    create(:platform_app_permissible, platform_app: platform_app, permissible: bot)
    expect do
      patch "/platform/api/v1/agent_bots/#{bot.id}", params: { account_id: account.id }, headers: headers, as: :json
    end.not_to(change { bot.reload.account_id })
    expect(response).to have_http_status(:unauthorized)
  end

  it 'does not turn an account bot into a global bot' do
    bot = create(:agent_bot, account: account)
    create(:platform_app_permissible, platform_app: platform_app, permissible: bot)
    patch "/platform/api/v1/agent_bots/#{bot.id}", params: { account_id: nil }, headers: headers, as: :json
    expect(response).to have_http_status(:unauthorized)
    expect(bot.reload.account_id).to eq(account.id)
  end
end
