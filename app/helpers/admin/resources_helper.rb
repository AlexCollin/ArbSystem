module Admin
  module ResourcesHelper
    # def resource_form_for(_resource, _params, _options = {}, &_block)
    #   url = if _resource.new_record?
    #           UrlBuilder.resources_path(_resource.class, _params)
    #         else
    #           UrlBuilder.resource_path(_resource.class, _params)
    #         end
    #
    #   method = _resource.new_record? ? :post : :put
    #
    #   options = { url: url, method: method, builder: ActiveAdmin::FormBuilder }
    #   options.merge!(_options)
    #
    #   semantic_form_for([:admin, _resource], options) do |f|
    #     _block.call(f)
    #   end
    # end
  end
end