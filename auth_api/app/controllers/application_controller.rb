class ApplicationController < ActionController::API
  rate_limit to: 10, within: 1.minute

  before_action :authorize_request

  private

  def authorize_request
    header = request.headers["Authorization"]
    header = header.split(" ").last if header

    return render json: { errors: "Missing token" }, status: :unauthorized unless header

    begin
      @decoded = JsonWebToken.decode(header)
      return render json: { errors: "Invalid token" }, status: :unauthorized unless @decoded

      @current_user = User.find_by!(external_id: @decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end
