require 'json'
require 'net/http'
require 'open-uri'
# Reading Last track id from file
last_track_id = File.open('last_track.txt', 'r').readlines.first
# Parse all tracks
puts 'Getting All Tracks...'
all_tracks = open 'https://api.vk.com/method/audio.get?'\
  'access_token=f576b7c1441fc88564cb166f7d9e6b757039c549a3a71d2bfa258391a017c1f4b8d255b8967d14435ef6b&'\
  'owner_id=28151710'
puts 'Parsing data...'
all_tracks = JSON.parse(all_tracks.read)
# Delete first count object
all_tracks['response'].shift
puts 'Searching starting point'
track_index = 0
all_tracks['response'].each do |object|
  track_index = all_tracks['response'].index(object) if object['aid'] == last_track_id.to_i
end
# Get amout of tracks to display
tracks_to_download = all_tracks['response'][0..track_index].size
# Iterate trough all new tracks
all_tracks['response'][0..track_index].each_with_index do |track, index|
  # Getting track info from json data
  subdomain = track['url'].split('//').last.split('/').first
  track_url = track['url'].split('net').last
  track_name = "#{track['artist']} - #{track['title']}.mp3"
  # Displaying progress
  puts "Downloading #{track_name}, #{tracks_to_download - index} left"
  # Creating request
  Net::HTTP.start(subdomain) do |http|
    resp = http.get(track_url)
    open("../#{track_name}", 'wb') do |file|
      file.write(resp.body)
    end
  end
end
puts "Done."
# https://api.vk.com/method/audio.get?access_token=f576b7c1441fc88564cb166f7d9e6b757039c549a3a71d2bfa258391a017c1f4b8d255b8967d14435ef6b&owner_id=28151710
# Writing last track id to file
File.open('last_track.txt', 'w').puts all_tracks['response'][0]['aid']
