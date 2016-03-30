# Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
# See LICENSE for more information

module RicohAPI
  module OAuth
    class Client < Rack::OAuth2::Client
      def initialize(client_id, client_secret)
        super(
          identifier: client_id,
          secret: client_secret,
          token_endpoint: TOKEN_ENDPOINT
        )
      end

      def api_token_for!(scope)
        idp_token = access_token!(
          scope: DISCOVERY_RELATED_SCOPES + Array(scope)
        )
        idp_token.api_token_for! scope
      end

      def access_token!(*args)
        token = super
        AccessToken.new token.access_token, refresh_token: token.refresh_token
      end
    end
  end
end