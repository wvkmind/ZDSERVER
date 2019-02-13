require "base64"
require "./autoload/auto_load"

module Main
    begin
        Log.write
        Container::Box.put(:dispatch,NodeDispatchPort.new(ServerConfig::NODE_TYPE[:gate],NetConfig::IP,NetConfig::PORT))
        Job.run
        CONSOLE.join
    ensure
        DataBase.exit
    end
end
