# frozen_string_literal: true

class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, 'secret')
  end

  def decode_token
    auth_header = request.headers['Authorization']
    if auth_header
      token = auth_header.split(' ').last
      begin
        JWT.decode(token, 'secret', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorized_user
    decode_token = decode_token()
    if decode_token
      user_id = decode_token[0]['user_id']
      return nil unless user_id == params[:id].to_i  # Verifica se o ID do token é igual ao ID passado na rota
      @user = User.find_by(id: user_id)
    end
  end
  

  def authorize
    render json: {message: 'Você precisa estar logado'}, status: :unauthorized unless authorized_user
  end
end
