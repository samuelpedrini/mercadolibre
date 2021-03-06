module Mercadopago
  class Api
    attr_accessor :access_token

    def initialize(args={})
      @app_key = args[:app_key]
      @app_secret = args[:app_secret]
      @callback_url = args[:callback_url]
      @access_token = args[:access_token]
      @endpoint_url = 'https://api.mercadopago.com'
      @auth_url = 'https://auth.mercadopago.com.ar'
      @site = args[:site]
    end

    include Mercadopago::Core::Oauth
    include Mercadopago::Core::Payments

    def get_last_response
      @last_response
    end

    def get_last_result
      @last_result
    end

    def send_custom_request(http_method, action, params={}, headers={})
      if http_method.to_s.downcase == 'get'
        get_request(action, params, headers)
      elsif http_method.to_s.downcase == 'post'
        post_request(action, params, headers)
      elsif http_method.to_s.downcase == 'put'
        put_request(action, params, headers)
      elsif http_method.to_s.downcase == 'patch'
        patch_request(action, params, headers)
      elsif http_method.to_s.downcase == 'head'
        head_request(action, params, headers)
      elsif http_method.to_s.downcase == 'delete'
        delete_request(action, params, headers)
      else
        raise 'invalid http method!'
      end
    end

    private

    def get_request(action, params={}, headers={})
      begin
        api_response_kind = headers.delete('api_response_kind')
        api_response_kind = headers.delete(:api_response_kind) if api_response_kind.nil?
        api_response_kind = 'object' if api_response_kind.nil?

        parse_response(api_response_kind, RestClient.get("#{@endpoint_url}#{action}", {params: params}.merge(headers)))
      rescue => e
        parse_response('object', e.response)
      end
    end

    def post_request(action, params={}, headers={})
      begin
        api_response_kind = headers.delete('api_response_kind')
        api_response_kind = headers.delete(:api_response_kind) if api_response_kind.nil?
        api_response_kind = 'object' if api_response_kind.nil?

        parse_response(api_response_kind, RestClient.post("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response('object', e.response)
      end
    end

    def put_request(action, params={}, headers={})
      begin
        api_response_kind = headers.delete('api_response_kind')
        api_response_kind = headers.delete(:api_response_kind) if api_response_kind.nil?
        api_response_kind = 'object' if api_response_kind.nil?

        parse_response(api_response_kind, RestClient.put("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response('object', e.response)
      end
    end

    def patch_request(action, params={}, headers={})
      begin
        api_response_kind = headers.delete('api_response_kind')
        api_response_kind = headers.delete(:api_response_kind) if api_response_kind.nil?
        api_response_kind = 'object' if api_response_kind.nil?

        parse_response(api_response_kind, RestClient.patch("#{@endpoint_url}#{action}", params, headers))
      rescue => e
        parse_response('object', e.response)
      end
    end

    def head_request(action, params={}, headers={})
      begin
        api_response_kind = headers.delete('api_response_kind')
        api_response_kind = headers.delete(:api_response_kind) if api_response_kind.nil?
        api_response_kind = 'object' if api_response_kind.nil?

        parse_response(api_response_kind, RestClient.head("#{@endpoint_url}#{action}", params))
      rescue => e
        parse_response('object', e.response)
      end
    end

    def delete_request(action, params={}, headers={})
      begin
        api_response_kind = headers.delete('api_response_kind')
        api_response_kind = headers.delete(:api_response_kind) if api_response_kind.nil?
        api_response_kind = 'object' if api_response_kind.nil?

        parse_response(api_response_kind, RestClient.delete("#{@endpoint_url}#{action}", params))
      rescue => e
        parse_response('object', e.response)
      end
    end

    def parse_response(api_response_kind, response)
      @last_response = response

      result = OpenStruct.new
      result.status_code = response.code

      if api_response_kind == 'object'
        result.headers = (JSON.parse(response.headers.to_json, object_class: OpenStruct) rescue response.headers)
        result.body = (JSON.parse(response.body, object_class: OpenStruct) rescue response.body)
      elsif api_response_kind == 'hash'
        result.headers = response.headers
        result.body = (JSON.parse(response.body) rescue response.body)
      else
        result.headers = response.headers
        result.body = response.body
      end

      @last_result = result

      result
    end
  end
end
