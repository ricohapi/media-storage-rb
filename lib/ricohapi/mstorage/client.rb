# Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
# See LICENSE for more information

module RicohAPI
  module MStorage
    class Client
      attr_accessor :token, :auth_client

      class Error < StandardError; end

      SEARCH_VERSION = '2016-07-08'
      USER_META_REGEX = /^user\.([A-Za-z0-9_\-]{1,256})$/
      MAX_USER_META_LENGTH = 1024
      MIN_USER_META_LENGTH = 1

      def initialize(token)
        if token.is_a? Auth::Client
          self.auth_client = token
          self.token = self.auth_client.api_token_for!
        else
          self.token = Auth::AccessToken.new token
        end
      end

      # GET /media, POST /media/search
      def list(params = {})
        params.reject! do |k, v|
          ![:after, :before, :limit, :filter].include? k.to_sym
          v.nil?
        end
        if params.include? :filter
          request_params = { search_veresion: SEARCH_VERSION, query: params[:filter] }
          params.delete :filter
          request_params[:paging] = params unless params.empty?

          handle_response do
            token.post endpoint_for('media/search'), request_params.to_json, {'Content-Type': 'application/json'}
          end
        else
          handle_response do
            token.get endpoint_for('media'), params
          end
        end
      end

      # GET /media/{id}
      def info(media_id)
        handle_response do
          token.get endpoint_for("media/#{media_id}")
        end
      end

      # GET /media/{id}/content
      def download(media_id)
        handle_response(:as_raw) do
          token.get endpoint_for("media/#{media_id}/content")
        end
      end

      # GET /media/{id}/meta, GET /media/{id}/meta/exif, GET /media/{id}/meta/gpano,
      # GET /media/{id}/meta/user, GET /media/{id}/meta/user/{key}
      def meta(media_id, field_name = nil)
        case field_name
        when nil
          handle_response do
            token.get endpoint_for("media/#{media_id}/meta")
          end
        when 'exif', 'gpano', 'user'
          handle_response do
            token.get endpoint_for("media/#{media_id}/meta/#{field_name}")
          end
        when USER_META_REGEX
          handle_response(:as_raw) do
            token.get endpoint_for("media/#{media_id}/meta/user/#{$1}")
          end
        else
          raise Error.new("Invalid field_name: #{field_name.inspect}")
        end
      end

      # POST /media (multipart)
      def upload(media)
        handle_response do
          token.post endpoint_for('media'), media
        end
      end

      # DELETE /media/{id}
      def delete(media_id)
        handle_response(:as_raw) do
          token.delete endpoint_for("media/#{media_id}")
        end
      end

      # PUT /media/{id}/meta/user/{key}
      def add_meta(media_id, user_meta)
        validate(user_meta)
        user_meta.each do |k, v|
          USER_META_REGEX =~ k
          handle_response(:as_raw) do
            token.put endpoint_for("media/#{media_id}/meta/user/#{$1}"), v, {'Content-Type': 'text/plain'}
          end
        end
      end

      # DELETE /media/{id}/meta/user, DELETE /media/{id}/meta/user/{key}
      def remove_meta(media_id, key)
        case key
        when 'user'
          handle_response(:as_raw) do
            token.delete endpoint_for("media/#{media_id}/meta/user")
          end
        when USER_META_REGEX
          handle_response(:as_raw) do
            token.delete endpoint_for("media/#{media_id}/meta/user/#{$1}")
          end
        else
          raise Error.new("Invalid key: #{key.inspect}")
        end
      end

      private

      def handle_response(as_raw = false, retrying = false)
        self.token = self.auth_client.api_token_for! if self.auth_client

        response = yield
        case response.status
        when 200...300
          if as_raw
            response.body
          else
            _response_ = MultiJson.load response.body
            _response_.with_indifferent_access if _response_.respond_to? :with_indifferent_access
          end
        else
          begin
            raise Error.new("Status code #{response.status}: #{JSON.parse(response.body)["reason"]}")
          rescue JSON::ParserError
            raise Error.new("Status code #{response.status}: Unexpected response: #{response.body}")
          end
        end
      end

      def endpoint_for(path)
        File.join BASE_URL, path
      end

      def validate(param)
        raise Error.new("Invalid parameter: #{param.inspect}: nothing to request.") unless param
        if param.is_a? Hash
          param.each do |k, v|
            raise Error.new("Invalid parameter: #{k.inspect} => #{v.inspect}") unless k && (MIN_USER_META_LENGTH..MAX_USER_META_LENGTH).include?(v.length)
          end
        end
      end
    end
  end
end
