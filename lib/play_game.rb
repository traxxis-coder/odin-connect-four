# - players choose color of their pieces (in BOARD)
# - a 'coinflip' method picks first player
# - LOOP
#   - player picks a column
#   - method finds the lowest unoccupied slot & 'drops' a disc there
#   - once a player has 4 or more discs in play, checks every new disc if it meets victory conditions
#     - finds whether the board includes 3  other discs in positions to complete a line, column, or diagonal of 4
#   - changes active player

require_relative 'board'

class PlayGame
  attr_accessor :players, :active_player
  attr_reader :board

  def initialize
    @players = [{}, {}]
    @active_player = 0
    @board = Board.new
  end

  def play_game
    game_setup
    loop do
      @active_player = @active_player == 0 ? 1 : 0 # rubocop:disable Style/NumericPredicate
      puts board
      play_round
      break if game_over?
    end
  end

  def game_setup
    @active_player = 0
    pick_nickname
    set_color

    @active_player = 1
    pick_nickname
    set_color
  end

  def play_round
    puts "#{players[active_player][:nickname]}, enter the number of a column to drop a disc there."
    board.drop_disc(players[active_player][:color], input_column, active_player)
  end

  def game_over?
    if board.victory?(active_player)
      puts board
      puts "Congratulations! #{players[active_player][:nickname]} won!"
      true
    elsif board.board_full?
      puts board
      puts 'This game is a tie.'
      true
    else
      false
    end
  end

  def input_column
    loop do
      # subtracting 1 from the input, because arrays are numbered from 0,
      # but I think it is more intuitive for the player to count from 1
      column = gets.chomp.to_i - 1
      return column if board.column_valid?(column)

      puts 'Invalid input.'
    end
  end

  def pick_nickname
    puts "Player #{active_player + 1}, choose a nickname."
    players[active_player][:nickname] = gets.chomp
  end

  def set_color
    new_color = ''
    loop do
      puts "#{players[active_player][:nickname]}, choose a color from the list below:"
      board.colors
      new_color = gets.chomp
      break if color_valid?(new_color)

      puts 'Invalid input.'
    end
    players[active_player][:color] = new_color.to_sym
  end

  def color_valid?(color)
    Board::PLAYER_COLORS.include?(color.to_sym) && players.none? { |player| player[:color] == color.to_sym }
  end
end
