class Course < ApplicationRecord
  belongs_to :course_modality
  belongs_to :course_format
  belongs_to :course_offer
  belongs_to :user

  validates :sigla, :name, :active, :carga_horaria, :course_modality_id, :course_format_id, :course_offer_id, presence:true

  def decorate
    @decorate ||= CourseDecorator.new self
  end
end
