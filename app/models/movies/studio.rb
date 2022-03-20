# frozen_string_literal: true

module Movies
  class Studio < ApplicationRecord
    has_many :movies, inverse_of: :studio
  end
end
