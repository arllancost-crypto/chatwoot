class Platform::Api::V1::AgentBotsController < PlatformController
  before_action :set_resource, except: [:index, :create]
  before_action :validate_platform_app_permissible, except: [:index, :create]
  before_action :validate_target_account, only: [:create, :update]

  def index
    @resources = @platform_app.platform_app_permissibles.where(permissible_type: 'AgentBot').includes(:permissible)
  end

  def show; end

  def create
    @resource = AgentBot.new(agent_bot_params.except(:avatar_url))
    @resource.account = @target_account if params.key?(:account_id)
    @resource.save!
    process_avatar_from_url
    @platform_app.platform_app_permissibles.find_or_create_by(permissible: @resource)
  end

  def update
    @resource.account = @target_account if params.key?(:account_id)
    @resource.update!(agent_bot_params.except(:avatar_url))
    process_avatar_from_url
  end

  def destroy
    @resource.destroy!
    head :ok
  end

  def avatar
    @resource.avatar.purge if @resource.avatar.attached?
    @resource
  end

  private

  def set_resource
    @resource = AgentBot.find(params[:id])
  end

  def agent_bot_params
    params.permit(:name, :description, :outgoing_url, :avatar, :avatar_url)
  end

  def validate_target_account
    return unless params.key?(:account_id)
    return if params[:account_id].blank? && (@resource.nil? || @resource.account_id.nil?)

    @target_account = Account.find_by(id: params[:account_id])
    return if @target_account && @platform_app.platform_app_permissibles.exists?(permissible: @target_account)

    render json: { error: 'Non permissible account' }, status: :unauthorized
  end

  def process_avatar_from_url
    ::Avatar::AvatarFromUrlJob.perform_later(@resource, params[:avatar_url]) if params[:avatar_url].present?
  end
end
