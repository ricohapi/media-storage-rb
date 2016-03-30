# Copyright (c) 2016 Ricoh Company, Ltd. All Rights Reserved.
# See LICENSE for more information

module RicohAPI
  module MStorage
    module Debugger
      class RequestFilter
        def filter_request(request)
          started = "======= [RicohAPI::MStorage] HTTP REQUEST STARTED ======="
          log started, request.dump
        end

        def filter_response(request, response)
          finished = "======= [RicohAPI::MStorage] HTTP REQUEST FINISHED ======="
          log '-' * 50, response.dump, finished
        end

        private

        def log(*outputs)
          outputs.each do |output|
            MStorage.logger.info output
          end
        end
      end
    end
  end
end