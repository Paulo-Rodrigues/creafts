class Api::V1::UsersController < ApplicationController
  skip_before_action :authorize_request, only: [ :create ]

  def create
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.external_id)

      render json: { token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: {
      id: @current_user.external_id,
      email: @current_user.email
    }, status: :ok
  end

  def update
    if @current_user.update(update_user_params)
      render json: {
        id: @current_user.external_id,
        email: @current_user.email
      }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def change_password
    return render json: { errors: ["Current password can't be blank"] }, status: :unprocessable_entity unless params[:current_password].present?
    return render json: { errors: ["Password can't be blank"] }, status: :unprocessable_entity unless params[:new_password].present?

    unless @current_user.authenticate(params[:current_password])
      return render json: { errors: ["Current password is incorrect"] }, status: :unprocessable_entity
    end

    if @current_user.update(password: params[:new_password], password_confirmation: params[:new_password_confirmation])
      render json: { message: "Password changed successfully" }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:email)
  end
end
