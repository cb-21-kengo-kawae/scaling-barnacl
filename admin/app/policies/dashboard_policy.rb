# DashboardPolicy
DashboardPolicy = Struct.new(:user, :dashboard) do
  def index?
    %i[viewer editor director].include? user.role.to_sym
  end
end
