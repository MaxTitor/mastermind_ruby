class Mastermind
	@@board = [
		@@row_1 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_2 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_3 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_4 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_5 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_6 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_7 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_8 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_9 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_10 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_11 = [".", ".", ".", ".", "-", "-", "-", "-"],
		@@row_12 = [".", ".", ".", ".", "-", "-", "-", "-"],
	]
	@@colors = ["r", "g", "p", "y", "c", "o", "b", "w"]
	@@pattern = Array.new

	def get_board
		@@board
	end

	def get_colors
		@@colors
	end

	def get_keys
		["+", "|", "-"]
	end

	def get_pattern
		@@pattern
	end

	def show_board
		@@board.each_with_index do |row, index|
			if index % 1 == 0
				puts
			end
			print row.join
		end
		puts
	end

	def create_pattern(pattern)
		@@pattern = pattern
	end

	def key_pegs(peg, row, space)
		@@board[row][space + 3] = peg
	end

	def instructions(which = "colors")
		if which == "colors"
			puts "r: red"
			puts "g: green"
			puts "p: purple"
			puts "y: yellow"
			puts "c: chocolate"
			puts "o: orange"
			puts "b: black"
			puts "w: white"
		end

		if which == "codemaking"
			puts "Input your code:"
		end

		if which == "key_pegs"
			puts "Pegs:"
			puts "+: the color is part of the code and is in it's correct position."
			puts "|: the color is part of the code but is not in it's correct position."
			puts "-: the color is not part of the code."
			puts
			puts "Place the key pegs to judge the Codebreaker's code:"
		end
	end

	def cpu_input(color, space, row)
		@space = space.to_i - 1
		@color = color.to_s
		@row = row.to_i
		@@board[@row][@space] = @color
	end
end

module Cpu
	@@row = 0

	def self.increment_row
		@@row += 1
	end

	def self.row
		@@row
	end

	def self.play
		game = Mastermind.new
		@board = game.get_board
		@colors = game.get_colors

		if @@row == 0
			for i in 1..4 do
				@color = @colors.sample
				while @board[@@row].include?(@color)
					@color = @colors.sample
				end
				game.cpu_input(@color, i, @@row)
			end
		end

		if @@row > 0 && @board[@@row - 1].count("+") < 4
			for i in 0..3 do
				@color = @board[@@row - 1][i]
				@key_peg = @board[@@row - 1][i + 4]
				
				if @key_peg == "+" || @key_peg == "|" && @board[@@row - 1].include?("-")
					game.cpu_input(@color, i + 1, @@row)
				elsif @key_peg == "-"
					@new_color = @colors.sample
					while @board[@@row].include?(@new_color) || @board[@@row - 1].include?(@new_color)
						@new_color = @colors.sample
					end
					game.cpu_input(@new_color, i + 1, @@row)
				end
			end

			if @board[@@row - 1].include?("-") == false
				@colors = Array.new
				@color_index = Array.new

				for i in 0..3 do
					if @board[@@row - 1][i + 4] == "|"
						@colors.push(@board[@@row - 1][i])
					end
				end

				@colors.each do |color|
					@color_index.push(@board[@@row - 1].index(color))
				end

				if @colors.count == 2
					@colors[0], @colors[1] = @colors[1], @colors[0]
					@colors.each_with_index do |color, index|
						@space = @color_index[index]
						@space += 1
						game.cpu_input(color, @space, @@row)
					end
				elsif @colors.count == 3
					@colors[0], @colors[1], @colors[2] = @colors[2], @colors[1], @colors[0]
					@colors.each_with_index do |color, index|
						@space = @color_index[index]
						@space += 1
						game.cpu_input(color, @space, @@row)
					end
				elsif @colors.count == 4
					which = rand(0..1)
					if which == 0
						@colors[0], @colors[1], @colors[2], @colors[3] = @colors[3], @colors[2], @colors[1], @colors[0]
						@colors.each_with_index do |color, index|
							@space = @color_index[index]
							@space += 1
							game.cpu_input(color, @space, @@row)
						end
					elsif which == 1
						@colors[0], @colors[1], @colors[3], @colors[2] = @colors[2], @colors[3], @colors[1], @colors[0]
						@colors.each_with_index do |color, index|
							@space = @color_index[index]
							@space += 1
							game.cpu_input(color, @space, @@row)
						end
					end
				end
			end
		end
	end
end

class Shell
	include Cpu
	@@row = Cpu.row

	def initialize
		game = Mastermind.new
		@colors = game.get_colors
		@keys = game.get_keys
		@row = Cpu.row
		@board = game.get_board
		game.instructions
		code = Array.new

		while true do 
			game.instructions("codemaking")
			code = gets.chomp.to_s.split("")
			@color_pass = true
			@doubles_pass = true

			code.each do |color|
				if @colors.include?(color) == false 
					puts "One or more of the colors you entered is invalid. Please enter valid colors only."
					@color_pass = false
					break
				end
			end

			if code.uniq.length != code.length
				puts "Your code contains doubles, which are not allowed in this game. Please enter unique colors only."
				@doubles_pass = false
			end
			code = code.shift(4)
			if @color_pass == true && @doubles_pass == true
				break
			end
		end

		game.create_pattern(code)
		while true do
			Cpu.play
			game.show_board
			p game.get_pattern
			puts 

			while true do 
				game.instructions("key_pegs")
				key_pegs = gets.chomp.split("").shift(4)

				@space = 1
				@keys_pass = true
				key_pegs.each do |peg|
					if @keys.include?(peg) == false
						puts "Some of the things you entered are not key pegs. Please enter only key pegs."
						puts
						@keys_pass = false
						break
					end
				end

				if @keys_pass == true
					key_pegs.each do |peg|
						game.key_pegs(peg, @@row, @space)
						@space += 1
					end
					break
				end
			end

			game.show_board
			Cpu.increment_row

			if @board[@@row - 1].count("+") == 4
				puts "Codebreaker wins!"
				break
			elsif @@row == 12
				puts "Codemaker wins!"
				break
			end
		end
	end
end

Shell.new