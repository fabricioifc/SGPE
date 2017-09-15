class Grid < ApplicationRecord
  belongs_to :course
  belongs_to :user
  has_many :grid_disciplines, dependent: :destroy
  # has_many :disciplines, :through => :grid_disciplines

  validates :year, :active, :course_id, presence:true

  accepts_nested_attributes_for :grid_disciplines, :allow_destroy => true

  def decorate
    @decorate ||= GridDecorator.new self
  end
end
