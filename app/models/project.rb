# frozen_string_literal: true

class Project < ApplicationRecord
  include ChronoModel::TimeMachine

  belongs_to :user

  has_many :units

  def to_s
    name
  end
end
