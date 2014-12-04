module DDcloud
  module Exceptions
    CODES = {
      "REASON_10" => "Failure at network",
      "REASON_20" => "Unrecoverable failure cause by a timeout.",
      "REASON_250" => "Network does not exist for this organization.",
      "REASON_320" => "Invalid Input Data - SourceIP must be a valid IPv4 address."
    }

    class ApiError < StandardError; end
    class ConnectionError < StandardError; end
    class RequestError < StandardError; end
  end
end
