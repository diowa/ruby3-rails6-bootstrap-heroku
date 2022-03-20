# frozen_string_literal: true

class Movie < ApplicationRecord
  include ChronoModel::TimeMachine

  belongs_to :studio, class_name: 'Movies::Studio'

  def to_s
    name
  end
end
