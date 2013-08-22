# run the following command:
# shopify console

# ... you get an irb session authenticated to the current shop
# Now, load this file as follows:

# load './tst1.rb'

require 'shopify_app'
require 'awesome_print'

include ShopifyAPI

a = Asset.all

a.each do |asset|
  ap asset.attributes
end

ap a[0].attributes