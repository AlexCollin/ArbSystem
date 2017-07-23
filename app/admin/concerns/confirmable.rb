# module Confirmable
#   def self.extended(base)
#     base.instance_eval do
#       action_item :confirm do
#         link_to 'Confirm', url_for(action: :confirm)
#       end
#
#       # omitting other gory details for brevity
#     end
#   end
# end