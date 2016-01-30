#!/usr/bin/ruby

require 'yaml'
require 'dropbox_sdk'

TOK_FILE = "access_token.yml"

# Get your app key and secret from the Dropbox developer website
APP_KEY = 'xxxxxxxxxxxxxx'
APP_SECRET = 'xxxxxxxxxxxxxx'

flow = DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
authorize_url = flow.start()

if (File.file?(TOK_FILE))
	#puts "access token exists !" # for debuging
	$access_token = YAML.load_file(TOK_FILE)
	#puts $access_token # for debuging
else
	# Have the user sign in and authorize this app
	puts '1. Go to: ' + authorize_url
	puts '2. Click "Allow" (you might have to log in first)'
	puts '3. Copy the authorization code'
	print 'Enter the authorization code here: '
	code = gets.strip

	# This will fail if the user gave us an invalid authorization code
	$access_token, user_id = flow.finish(code)

	File.open(TOK_FILE, 'w') { |file| 
					file.write($access_token.to_yaml)
					file.close()
				  }
end

client = DropboxClient.new($access_token)
#puts "linked account:", client.account_info().inspect

#file = open('working-draft.txt')
#response = client.put_file('/magnum-opus.txt', file)
#puts "uploaded:", response.inspect

root_metadata = client.metadata('/')
puts "\nmetadata:\n\n", root_metadata.inspect
puts "\n\n"
#contents, metadata = client.get_file_and_metadata('/magnum-opus.txt')
#open('magnum-opus.txt', 'w') {|f| f.puts contents }

files = client.delta()
puts files
sleep(1)
system('ls -l')
