class RegistrationsController < Devise::RegistrationsController

    # PUT /resource
    # We need to use a copy of the resource because we don't want to change
    # the current user in place.
    def update
        self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
        prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
        
        # binding.pry
        if pode_remover_avatar?
            resource.avatar.purge_later
        end
      #   resource.avatar.purge_later
      #   resource.avatar.attach(account_update_params[:avatar])
      
  
        resource_updated = update_resource(resource, account_update_params)
        yield resource if block_given?
        if resource_updated
          set_flash_message_for_update(resource, prev_unconfirmed_email)
          bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
    
          respond_with resource, location: after_update_path_for(resource)
        else
          clean_up_passwords resource
          set_minimum_password_length
          respond_with resource
        end
    end

    private

    def pode_remover_avatar?
        return resource.avatar.attached? && (!account_update_params[:remove_avatar].nil? && account_update_params[:remove_avatar].eql?('1'))
    end

end