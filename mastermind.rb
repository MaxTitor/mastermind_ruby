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
	@@spaces = [1, 2, 3, 4]
	@@colors = ["r", "g", "p", "y", "c", "o", "b", "w"]
	@@pattern = Array.new

	def get_board
		@@board
	end

	def get_spaces
		@@spaces
	end

	def get_colors
		@@colors
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

	def create_pattern
		@@pattern = []
		for i in 1..4 do
			@color = @@colors[rand(8)]

			while @@pattern.include?(@color)
				@color = @@colors[rand(8)]
			end

			@@pattern.push(@color)
		end
	end

	def check(row)
		@row_pattern = @@board[row].shift(4)
		@pattern_check = Array.new

		@row_pattern.each_with_index do |color, index|
			if color == @@pattern[index] && index < 4
				@pattern_check.push("+")
			elsif @@pattern.include?(color) && index < 4
				@pattern_check.push("|")
			elsif @@pattern.include?(color) == false && index < 4
				@pattern_check.push("-")
			end
		end

		for i in 0..3 do
			@@board[row] = @row_pattern
			@@board[row][4 + i] = @pattern_check[i]
		end

		if @pattern_check == ["+", "+", "+", "+"]
			return "win"
		end
	end

	def instructions
		puts "+: the color is part of the code and is in it's correct position"
		puts "|: the color is part of the code but is not in it's correct position"
		puts "-: the color is not part of the code"
		puts "r: red"
		puts "g: green"
		puts "p: purple"
		puts "y: yellow"
		puts "c: chocolate"
		puts "o: orange"
		puts "b: black"
		puts "w: white"
		puts "There are no doubles"
	end

	def player_input(space, color, row)
		@space = space.to_i - 1
		@color = color.to_s
		@row = row.to_i
		@@board[@row][@space] = @color
	end
end

class Shell
	def initialize
		game = Mastermind.new
		game.create_pattern
		@board = game.get_board
		@spaces = game.get_spaces
		@colors = game.get_colors
		@pattern = game.get_pattern
		@row = 11

		while true do
			game.show_board
			puts
			game.instructions
			puts

			puts "Select space:"
			space_input = gets.chomp.to_i

			while @spaces.include?(space_input) == false
				puts "That is not a valid space. Please select a space between 1 to 4."
				space_input = gets.chomp.to_i

				if @spaces.include?(space_input)
					break
				end
			end

			puts "Select color:"
			color_input = gets.chomp.to_s

			while @colors.include?(color_input) == false || @board[@row].include?(color_input)
				if @colors.include?(color_input) == false
					puts "That is not a valid color. Please select one of the colors from the list."
				elsif @board[@row].include?(color_input)
					puts "That color has already been placed. Please select a different color."
				end

				color_input = gets.chomp.to_s

				if @colors.include?(color_input) && @board[@row].include?(color_input) == false
					break
				end
			end

			game.player_input(space_input, color_input, @row)

			if game.get_board[@row].include?(".") == false
				puts "You've entered four colors, would you like to check your pattern? y/n"
				user_input = gets.chomp

				if user_input == "y"
					verdict = game.check(@row)
					if verdict == "win"
						game.show_board
						puts
						puts "Game Over"
						puts "Codebreaker wins!"
						puts "#{@pattern}"
						break
					end
					@row -= 1
				end
			end

			if @row < 0
				game.show_board
				puts
				puts "Game Over"
				puts "Codemaker wins!"
				puts "The code was: #{@pattern}"
				break
			end
		end
	end
end

Shell.new