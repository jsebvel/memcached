# Memchaed Serve
This project was implement with Ruby 3.0.1


## Development server
Get into server directory and run `ruby server.rb` for start the server at port 2000.
When you see the message 'Server start at port 2000' you need to open new command line. You can run this new command line from any directory
In this new command line, you can send the commands.
## Send commands
To send commands you need to install netcat or any tool with the same purpose
After you install the tool, you need to run according the tool you have installed. For example, to run netcat
you must execute `netcat localhost 2000`.
Other alternative is gnu-netcat. With this tool you must run `nc -v localhost 2000 `

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

##Help
If you need some help please type the command `help` after enter your name.
## Test
To run test, you need to install 'rspec' with `gem install rspec`. After installation you need to start the server and run in a new windows the command `bundle exec rspec`.
This command can run at project root directory.
