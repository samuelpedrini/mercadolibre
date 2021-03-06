module Mercadolibre
  module Core
    module UsersAndApps
      def get_user(user_id)
        get_request("/users/#{user_id}", { access_token: @access_token }).body
      end

      def get_users(user_ids)
        get_request('/users', { ids: user_ids.join(',') }).body
      end

      def get_seller(nickname)
        filters = { nickname: nickname, limit: 0 }
        response = get_request("/sites/#{@site}/search", filters)[:body]
        get_user(response.seller.id)
      end

      def get_my_user
        get_request('/users/me', { access_token: @access_token }).body
      end

      def get_user_addresses(user_id)
        get_request("/users/#{user_id}/addresses", { access_token: @access_token }).body
      end

      def get_user_payment_methods(user_id)
        get_request("/users/#{user_id}/payment_methods", { access_token: @access_token }).body
      end

      def get_user_brands(user_id)
        get_request("/users/#{user_id}/brands", { access_token: @access_token }).body
      end

      def get_user_promotion_packs(user_id, listing_type=nil, category_id=nil)
        filters = { access_token: @access_token }

        if category_id.present?
          filters[:categoryId] = category_id
        end

        if listing_type.present?
          url = "/users/#{user_id}/classifieds_promotion_packs/#{listing_type}"
        else
          url = "/users/#{user_id}/classifieds_promotion_packs"
        end

        get_request(url, filters).body
      end

      def get_user_available_listing_types(user_id, category_id)
        filters = {
          access_token: @access_token,
          category_id: category_id
        }

        get_request("/users/#{user_id}/available_listing_types", filters).body
      end

      def get_user_listing_type_availability(listing_type, category_id)
        filters = {
          access_token: @access_token,
          category_id: category_id
        }

        get_request("/users/#{user_id}/available_listing_type/#{listing_type}", filters).body
      end

      def get_application_feeds
        get_request("/users/#{user_id}/applications/#{@app_key}", { access_token: @access_token }).body
      end

      def get_application_info
        get_request("/applications/#{@app_key}", { access_token: @access_token }).body
      end

      def get_user_accepted_payment_methods(user_id)
        get_request("/users/#{user_id}/accepted_payment_methods").body
      end
    end
  end
end
