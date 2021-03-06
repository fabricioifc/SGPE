class CourseDecorator < ApplicationDecorator
  delegate_all
  attr_reader :component

  def initialize(component)
    @component = component
  end

  def name
    component.name.capitalize
  end

  def active
    active_tag component.active?, 'fa-2'
  end


end
