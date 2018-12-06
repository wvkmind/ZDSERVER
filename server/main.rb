require "base64"
require "./autoload/auto_load"

module Main
    Log.write
    Container::Box.put(:dispatch,NodeDispatchPort.new(ServerConfig::NODE_TYPE[:gate],NetConfig::IP,NetConfig::PORT))
    CONSOLE.join
end

