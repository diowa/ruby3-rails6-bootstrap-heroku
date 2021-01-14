# frozen_string_literal: true

class Unit < ApplicationRecord
  include ChronoModel::TimeMachine

  belongs_to :project

  has_one :user, through: :project

  def to_s
    name
  end
end
