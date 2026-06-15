# frozen_string_literal: true

class Board
  PLAYER_COLORS = { blue: "\u{1F535}",
                    green: "\u{1F7E2}",
                    orange: "\u{1F7E0}",
                    purple: "\u{1F7E4}",
                    brown: "\u{1F7E3}",
                    red: "\u{1F534}",
                    yellow: "\u{1F7E1}" }.freeze
  attr_accessor :board, :player_discs

  def initialize
    @board = Array.new(6) { Array.new(7) { "\u{26AB}" } }
    @player_discs = [[], []]
    @new_disc = nil
  end

  def drop_disc(color, column, player)
    return nil unless column_valid?(column)

    board.reverse.each_with_index do |line, index|
      if line[column] == "\u{26AB}" # rubocop:disable Style/Next
        board[6 - index - 1][column] = PLAYER_COLORS[color]
        @new_disc = [6 - index - 1, column]
        break
      end
    end
    player_discs[player] << @new_disc
  end

  def column_valid?(col)
    col >= 0 && col <= board[0].size && !column_full?(col)
  end

  def column_full?(col)
    board.none? { |line| line[col] == "\u{26AB}" }
  end

  def victory?(player)
    if @new_disc && player_discs[player].include?(@new_disc)
      column_victory?(player) ||
        line_victory?(player) ||
        asc_diagonal_victory?(player) ||
        desc_diagonal_victory?(player)
    else
      false
    end
  end

  def column_victory?(player)
    player_discs[player].any? do |disc|
      player_discs[player].include?([disc[0] + 1, disc[1]]) &&
        player_discs[player].include?([disc[0] + 2, disc[1]]) &&
        player_discs[player].include?([disc[0] + 3, disc[1]])
    end
  end

  def line_victory?(player)
    player_discs[player].any? do |disc|
      player_discs[player].include?([disc[0], disc[1] + 1]) &&
        player_discs[player].include?([disc[0], disc[1] + 2]) &&
        player_discs[player].include?([disc[0], disc[1] + 3])
    end
  end

  def asc_diagonal_victory?(player)
    player_discs[player].any? do |disc|
      player_discs[player].include?([disc[0] - 1, disc[1] + 1]) &&
        player_discs[player].include?([disc[0] - 2, disc[1] + 2]) &&
        player_discs[player].include?([disc[0] - 3, disc[1] + 3])
    end
  end

  def desc_diagonal_victory?(player)
    player_discs[player].any? do |disc|
      player_discs[player].include?([disc[0] + 1, disc[1] + 1]) &&
        player_discs[player].include?([disc[0] + 2, disc[1] + 2]) &&
        player_discs[player].include?([disc[0] + 3, disc[1] + 3])
    end
  end

  def board_full?
    board.none? { |line| line.any? { |slot| slot == "\u{26AB}" } }
  end

  def colors
    puts PLAYER_COLORS.keys.join(', ')
  end

  def to_s
    board_strings = board.map do |line|
      line.join(' ')
    end
    board_strings.unshift([' 1  2  3  4  5  6  7'])
    board_strings.join("\n")
  end
end
