# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorize, only: %i[update]
  before_action :set_user, only: %i[update]

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      token = encode_token({ user_id: @user.id })
      render json: { user: UserSerializer.new(@user), token: token }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if authorized_update_user
      if @user.update(user_params)
        render json: { user: UserSerializer.new(@user) }
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end


  # POST /login
  def login
    @user = User.find_by(email: user_params[:email])

    if @user&.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: UserSerializer.new(@user), token: token }, status: :ok
    else
      render json: { error: 'Usuário ou senha inválidos' }, status: :unprocessable_entity
    end
  end

  # DELETE /logout
  def logout
    head :no_content
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:email, :name, :password, :profile_photo)
  end
end
