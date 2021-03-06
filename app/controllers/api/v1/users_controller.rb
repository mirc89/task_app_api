class Api::V1::UsersController < Api::V1::ApplicationController
  skip_before_action :authenticate!, only: [:create, :create_via_facebook]

  def index
    users = User.all
    render json: users, status: 200
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: {
        user: user
      }, status: 201
    else
      render json: {errors: ["User not created"]}, status: 400
    end
  end

  def show
    begin
      user = User.find(params[:id])
      render json: user, status: 200
    rescue
      render_404_not_found
    end
  end

  def find
    begin
      user = User.find_by!(email: params[:search])
      render json: user, status: 200
    rescue
      render_404_not_found
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end