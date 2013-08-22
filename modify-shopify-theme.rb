# Proof-of-concept - modifying an Asset (404.liquid) from a Theme using a Shopify App

include ShopifyAPI

require 'awesome_print'

active_resource_logger = Logger.new('active_resource.log', 'daily'); 
active_resource_logger.level = Logger::DEBUG # or Logger::INFO
ActiveResource::Base.logger = active_resource_logger

themes = Theme.all
theme  = themes.find { |t| t.name == 'radiance' }

# ap themes
# ap theme

asset = Asset.find('templates/404.liquid', :params => {:theme_id => theme.id})

# ap asset

v1 = asset.value

v2 = v1 =~ /PAGE/ ? v1.downcase : v1.upcase

ap v1
ap v2

asset.value = v2

if ! asset.save
  ap asset.errors.count
  ap asset.errors
end

# Usage

# [ 2.0.0@my_shopify_app ] { ~/code/experimental/my_shopify_app }-> shopify list
#    fadel-davis1910
#  * test-1-257
# [ 2.0.0@my_shopify_app ] { ~/code/experimental/my_shopify_app }-> shopify console
# using test-1-257.myshopify.com
# irb(main):001:0> load 'modify-shopify-theme.rb'
# "<DIV ID=\"COL-MAIN\" CLASS=\"CONTENT\">\n  <H1 CLASS=\"HEADING\">PAGE NOT FOUND <SPAN CLASS=\"NOT_FOUND\">404</SPAN></H1>\n  <P>PERHAPS YOU WANT TO RETURN TO THE <A HREF=\"/\">HOME PAGE</A> OR <A HREF=\"/SEARCH\">TRY A SEARCH</A>.</P>\n</DIV>"
# "<div id=\"col-main\" class=\"content\">\n  <h1 class=\"heading\">page not found <span class=\"not_found\">404</span></h1>\n  <p>perhaps you want to return to the <a href=\"/\">home page</a> or <a href=\"/search\">try a search</a>.</p>\n</div>"
# => true
# irb(main):002:0> load 'modify-shopify-theme.rb'
# "<div id=\"col-main\" class=\"content\">\n  <h1 class=\"heading\">page not found <span class=\"not_found\">404</span></h1>\n  <p>perhaps you want to return to the <a href=\"/\">home page</a> or <a href=\"/search\">try a search</a>.</p>\n</div>"
# "<DIV ID=\"COL-MAIN\" CLASS=\"CONTENT\">\n  <H1 CLASS=\"HEADING\">PAGE NOT FOUND <SPAN CLASS=\"NOT_FOUND\">404</SPAN></H1>\n  <P>PERHAPS YOU WANT TO RETURN TO THE <A HREF=\"/\">HOME PAGE</A> OR <A HREF=\"/SEARCH\">TRY A SEARCH</A>.</P>\n</DIV>"
# => true
# irb(main):003:0>