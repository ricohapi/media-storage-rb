# Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
# See LICENSE for more information

require 'ricohapi/auth'
require 'ricohapi/mstorage/version'

module RicohAPI
  module MStorage
    BASE_URL = 'https://mss.ricohapi.com/v1'
    SCOPE = 'https://ucs.ricoh.com/scope/api/udc2'

    def self.logger
      @@logger
    end
    def self.logger=(logger)
      @@logger = logger
    end
    self.logger = ::Logger.new(STDOUT)
    self.logger.progname = 'RicohAPI::MStorage'

    def self.debugging?
      @@debugging
    end
    def self.debugging=(boolean)
      @@debugging = boolean
    end
    def self.debug!
      self.debugging = true
    end
    def self.debug(&block)
      original = self.debugging?
      self.debugging = true
      yield
    ensure
      self.debugging = original
    end
    self.debugging = false

    def self.http_client(agent_name = "RicohAPI::MStorage (#{VERSION})", &local_http_config)
      _http_client_ = HTTPClient.new(
        agent_name: agent_name
      )
      http_config.try(:call, _http_client_)
      local_http_config.try(:call, _http_client_) unless local_http_config.nil?
      _http_client_.request_filter << Debugger::RequestFilter.new if debugging?
      _http_client_
    end

    def self.http_config(&block)
      @@http_config ||= block
    end

    def self.reset_http_config!
      @@http_config = nil
    end
  end
end

require 'ricohapi/mstorage/client'
require 'ricohapi/mstorage/debugger/request_filter'