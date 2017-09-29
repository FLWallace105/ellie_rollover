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
            @staging_3months_id = ENV['STAGING_3MONTHS_ID']
            @target_3months_id = ENV['TARGET_3MONTHS_ID']
            @new_month_collection_id = ENV['NEW_MONTH_COLLECTION']

        end

        def publish_theme
            #puts @shopname, @shopapi, @shopkey
            puts "Theme ID = #{@theme_id}"
            shop_url = "https://#{@shopkey}:#{@shoppass}@#{@shopname}.myshopify.com/admin"
            ShopifyAPI::Base.site = shop_url
            # publish collection
            new_collection = ShopifyAPI::CustomCollection.find(@new_month_collection_id)
            new_collection.published = true
            puts new_collection.inspect
            new_collection.save!
            puts "New Collection published"
            puts "-----------------------"


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
            puts "Sleeping four seconds"
            sleep 4
            puts "Doing Product Three Months"
            puts "_____________________________"
            staging_three_months = ShopifyAPI::Product.find(@staging_3months_id)
            target_three_months = ShopifyAPI::Product.find(@target_3months_id)
            staging_three_months_desc = staging_three_months.body_html
            staging_three_months_images = staging_three_months.images
            target_three_months.body_html = staging_three_months_desc
            target_three_months.images = staging_three_months_images
            puts staging_three_months_desc.inspect
            puts staging_three_months_images.inspect
            target_three_months.save
            puts "***********************************"
            puts "Successfully copied Product Info from Staging to Target for Monthly Box and Ellie 3- Pack and 3 Months product."
            puts "All done!"


            

        end

    end
end
