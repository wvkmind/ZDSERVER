require 'msgpack'
module Packer
    def pack(source)
        source.to_msgpack
    end
    def unpack(source)
        MessagePack.unpack(msg)
    end
end