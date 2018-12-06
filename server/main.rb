require "base64"
require "./autoload/auto_load"

module Main
    Log.write
    Container::Box.put(:dispatch,NodeDispatchPort.new)
    CONSOLE.join
end

