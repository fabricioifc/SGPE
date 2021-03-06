class Perfil < ApplicationRecord
  has_and_belongs_to_many :role, :join_table => :perfil_roles

  validates :name, presence:true, uniqueness:true

  def decorate
    @decorate ||= PerfilDecorator.new self
  end
end
