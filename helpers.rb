module Sinatra
  module SteamApp
    module Helpers
      def game_url(id)
        "http://store.steampowered.com/app/#{id}/"
      end

      def game_header_url(id)
        "https://steamcdn-a.akamaihd.net/steam/apps/#{id}/header.jpg"
      end

      def human_playtime(playtime)
        return '0 minutes' if playtime.zero?
        human_duration = ActiveSupport::Duration.build(playtime * 60)

        return human_duration.inspect
      end

      def human_title(name)
        name.titleize
      end
    end
  end
end

