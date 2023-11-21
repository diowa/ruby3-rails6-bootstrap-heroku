# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it 'creates users with factory' do
    expect do
      create(:user, :active)
    end.not_to raise_error
  end
end
