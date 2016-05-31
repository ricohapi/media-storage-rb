# Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
# See LICENSE for more information

require 'ricohapi/auth'
require 'ricohapi/mstorage/version'

module RicohAPI
  module MStorage
    BASE_URL = 'https://mss.ricohapi.com/v1'
    SCOPE = 'https://ucs.ricoh.com/scope/api/udc2'
  end
end

require 'ricohapi/mstorage/client'