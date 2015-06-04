require 'segment/analytics'
module Vizier
  class Analyzer

    def initialize(opts={})
      @opts = opts
      @analyzer = Segment::Analytics.new({
                                           write_key: opts[:write_key].nil? ? "ABC123" : opts[:write_key],
                                           on_error: Proc.new { |status, msg| Rails.logger.warn(msg) }
                                         })

    end

    def track(message)
      payload = massage_payload(message)
      @analyzer.track(payload)
    end

    private

    def massage_payload(message)
      {
        event: message.payload[:controller],
        context: {
          ip: message.payload[:ip],
          userAgent: message.payload[:ua]
        },
        properties: {
          parameters: message.payload[:params],
          status: message.payload[:status],

        },
        timestamp: DateTime.now(),
      }
    end
  end
end
