# Memchaed Serve
This project was implement with Ruby 3.0.1


## Install packages
Before run this project, run `npm install`.


## Development server
Get into server directory and run `ruby server.rb` for start the server at port 2000.

## Send commands
To send commands you need to install netcat or any tool with the same purpose
After you install the tool, you need to run according the tool you have installed. For example, to run netcat
you must execute `netcat localhost 2000`.
Other alternative is gnu-netcat. With this tool you must run `nc -v localhost 2000 `

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

## Test