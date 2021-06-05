# Memchaed Server
This project was implemented with Ruby 3.0.1


## Development Server
Get into server directory and run `ruby server.rb` to start the server at port 2000.
When you see the message 'Server start at port 2000' you need to open a new command line. You can run this new command line from any directory.
In this new command line, you can send the commands.

## Send commands
To send commands you need to install netcat, gnu-netcat or any similar tool. After you install the tool, you need to run it according the steps of the tool you have installed. For example, to run netcat you must execute `netcat localhost 2000`. Other alternative is gnu-netcat. With this tool you must run `nc -v localhost 2000`.
You can have  one or more clients at same time.

## GNU-NETCAT for arch
https://archlinux.org/packages/extra/x86_64/gnu-netcat/

## Command list
Next you can find list with accepted commands
* set
* add
* replace
* append
* prepend
* cas
* get
* gets

## Help
If you need some help please type the command `help` after enter your name.
## Test
To run test, you need to install bundle with `gem install bundler`, after this, you need to install 'rspec' with bundle, execute at root folder `bundle install --binstubs`. After installation you need to start the server and run in a new command line, the command `bundle exec rspec`.
This command should be run at project root directory.
If you get error like "WARNING: You don't have <a directory> in your PATH, gem executables will not run", you need to add at your path: 

  export GEM_HOME="$(ruby -e 'puts Gem.user_dir')"
  
  export PATH="$PATH:$GEM_HOME/bin"
This for linux.
