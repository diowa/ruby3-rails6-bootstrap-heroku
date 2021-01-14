# frozen_string_literal: true

class User < ApplicationRecord
  include ChronoModel::TimeMachine

  has_many :projects
  has_many :units, through: :projects

  def to_s
    name
  end
end
