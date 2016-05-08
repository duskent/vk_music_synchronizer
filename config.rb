require 'json'

class Config
  attr_accessor :access_token, :last_track, :download_path

  def initialize
    config = JSON.parse(File.open('config.txt').read)
    @access_token = config['config']['access-token']
    @last_track = config['config']['last-track']
    @download_path = config['config']['download-path']
  end

  def save
    config =
      {
        'config' => {
          'access-token' => @access_token,
          'last-track' => @last_track,
          'download-path' => @download_path
        }
      }.to_json
    File.open('config.txt', 'w').puts config
  end
end
