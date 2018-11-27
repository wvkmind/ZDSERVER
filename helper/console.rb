require 'readline'

def help
	puts "你可以输入以下命令:#{LIST}"
end

def history
	puts Readline::HISTORY.to_a[-2]
end

trap('INT', 'SIG_IGN')


LIST = [
  'help', 'history', 'exit'
].sort

comp = proc { |s| LIST.grep( /^#{Regexp.escape(s)}/ ) }

Readline.completion_append_character = " "
Readline.completion_proc = comp

CONSOLE = Thread.new do 
	loop do 
        begin
            input = Readline.readline('> ', true).chomp
            raise "没有这个命令，请查看help" unless LIST.include?(input)
			eval input
		rescue => exception
			if exception.message.index("undefined local variable or method ")
				puts "没有找到命令\"#{input}\""
			else
				puts exception
			end
		end
	end
end

