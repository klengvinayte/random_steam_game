require 'steam-api'
require 'active_support/all'
require 'pattern_string_generator'
require 'sinatra/base'
require 'dotenv'

require 'byebug'

require_relative 'helpers.rb'

Dotenv.load

class SteamApp < Sinatra::Base
  set root: File.dirname(__FILE__)

  helpers Sinatra::SteamApp::Helpers

  get '/' do
    erb :index
  end

  get '/suggest_game' do
    vanityurl = params['name']

    Steam.apikey = ENV['STEAM_API_KEY']

    begin
      steam_id = Steam::User.vanity_to_steamid(vanityurl)

      games = Steam::Player.owned_games(steam_id, params: { include_appinfo: 1 })

      if games['games'].nil? || games['games'].empty?
        @error = "No games found for the specified Steam ID."
        return erb :error
      end

      random_game = games['games'].sample

      @game_id = random_game['appid']
      @game_playtime = random_game['playtime_forever']
      @game_name = random_game['name']

      erb :suggest_game
    rescue Steam::Error => e
      @error = "An error occurred: #{e.message}"
      erb :error
    end
  end
end
