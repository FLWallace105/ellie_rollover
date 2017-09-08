#ellie_rollover.rb

require 'httparty'
require 'dotenv'
require 'shopify_api'

module EllieRollOver
    class CreateNewTheme

        def initialize
            Dotenv.load

            @shopname = ENV['SHOPNAME']
            @shopkey = ENV['SHOPIFY_KEY']
            @shoppass = ENV['SHOPIFY_PASSWORD']
            @theme_id = ENV['THEME_ID']
            @staging_product_id = ENV['STAGING_PRODUCT_ID']
            @target_product_id = ENV['TARGET_PRODUCT_ID']
            @staging_three_pack_id = ENV['STAGING_ELLIE_3PACK_ID']
            @target_three_pack_id = ENV['TARGET_ELLIE_3PACK_ID']

        end

        def publish_theme
            #puts @shopname, @shopapi, @shopkey
            puts "Theme ID = #{@theme_id}"
            shop_url = "https://#{@shopkey}:#{@shoppass}@#{@shopname}.myshopify.com/admin"
            ShopifyAPI::Base.site = shop_url
            my_theme = ShopifyAPI::Theme.find(@theme_id)
            #puts my_theme.inspect
            theme_name = my_theme.name
            my_theme.role = "main"
            my_theme.save
            puts "Done publishing theme #{theme_name}"
         
            staging_product = ShopifyAPI::Product.find(@staging_product_id)
            puts "Found staging product sleeping four seconds"
            sleep 4
            staging_three_pack = ShopifyAPI::Product.find(@staging_three_pack_id)
            target_three_pack = ShopifyAPI::Product.find(@target_three_pack_id)
            puts "Found staging and target three pack sleeping four seconds again"
            sleep 4
            #puts staging_product.inspect
            staging_description = staging_product.body_html
            puts staging_description

            staging_images = staging_product.images
            staging_three_pack_images = staging_three_pack.images
            puts "--------"
            puts staging_three_pack_images.inspect
            puts "**************"
            target_product = ShopifyAPI::Product.find(@target_product_id)
            target_product.body_html = staging_description
            target_product.images = staging_images
            target_product.save
            target_three_pack.images = staging_three_pack_images
            target_three_pack.save
            puts "Successfully copied Product Info from Staging to Target for Monthly Box and Ellie 3- Pack."
            puts "All done!"




        end

    end
end
