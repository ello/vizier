require 'rails/railtie'

module Vizier
  class Railtie < Rails::Railtie

    analyzer = Vizier::Analyzer.new(write_key: ENV["SEGMENT_WRITE_KEY"])
    initializer 'vizier.initialize' do |app|

      ActiveSupport::Notifications.subscribe 'process_action.action_controller' do |*args|

        event = ActiveSupport::Notifications::Event.new(*args)
        analyzer.track(event)

      end
    end
  end
end
