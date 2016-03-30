# Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
# See LICENSE for more information

module RicohAPI
  module OAuth
    TOKEN_ENDPOINT = 'https://auth.beta2.ucs.ricoh.com/auth/token'
    DISCOVERY_ENDPOINT = 'https://auth.beta2.ucs.ricoh.com/auth/discovery'
    DISCOVERY_RELATED_SCOPES = [
      'https://ucs.ricoh.com/scope/api/auth',
      'https://ucs.ricoh.com/scope/api/discovery'
    ]
  end
end

require 'ricohapi/oauth/client'
require 'ricohapi/oauth/access_token'