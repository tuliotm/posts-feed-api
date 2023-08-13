# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/users').to route_to('users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #login via POST' do
      expect(post: '/users/login').to route_to('users#login')
    end

    it 'routes to #logout via DELETE' do
      expect(delete: '/users/logout').to route_to('users#logout')
    end
  end
end
