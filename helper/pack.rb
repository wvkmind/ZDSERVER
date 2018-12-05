require 'msgpack'
module Packer
    def self.pack(source)
        source.to_msgpack
    end
    def self.unpack(source)
        MessagePack.unpack(msg)
    end
end