module PermissaosHelper

  def get_models
  	@models ||= []
      ActiveRecord::Base.connection.tables.each do |v|
      	@models << v.singularize.camelize
      end
    @models.sort
  end

end
