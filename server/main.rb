require "./autoload/auto_load"

module Main
    Container::Box.put(:dispatch,NodeDispatchPort.new)
    CONSOLE.join
end

