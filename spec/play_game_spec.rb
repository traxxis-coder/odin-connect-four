# frozen_string_literal: true

require_relative '../lib/play_game'
require_relative '../lib/board'

describe PlayGame do
  describe 'initialize' do
    subject(:new_game) { described_class.new }
    it 'sets up a list of hashes to keep track of player info' do
      expect(new_game.players).to eq([{}, {}])
    end

    it 'creates a tracker for the active player with a value of 0 or 1' do
      expect(new_game.active_player).to eq(0) | eq(1)
    end

    it 'creates an instance of Board' do
      expect(new_game.board.instance_of?(Board)).to be true
    end
  end
  describe 'color_valid?' do
    subject(:game_color_check) { described_class.new }
    context 'when the color is valid' do
      it 'returns true' do
        valid_input = 'red'
        expect(game_color_check.color_valid?(valid_input)).to be true
      end
    end

    context 'when the color is invalid' do
      it 'returns false' do
        invalid_input = '3'
        expect(game_color_check.color_valid?(invalid_input)).to be false
      end
    end

    context 'when another player has the same color' do
      before do
        game_color_check.players[0][:color] = :red
      end

      it 'returns false' do
        same_color = 'red'
        expect(game_color_check.color_valid?(same_color)).to be false
      end
    end
  end

  describe '#pick_nickname' do
    subject(:game_nick) { described_class.new }

    context 'when player 0 picks a nickname' do
      before do
        game_nick.active_player = 0
        allow(game_nick).to receive(:gets).and_return('nicholas')
        game_nick.pick_nickname
      end
      it 'changes player 0\'s nick' do
        expect(game_nick.players[0][:nickname]).to eq('nicholas')
      end
    end

    context 'when player 1 picks a nickname' do
      before do
        game_nick.active_player = 1
        allow(game_nick).to receive(:gets).and_return('flamel')
        game_nick.pick_nickname
      end
      it 'changes player 1\'s nick' do
        expect(game_nick.players[1][:nickname]).to eq('flamel')
      end
    end
  end

  describe '#set_color' do
    subject(:game_color_set) { described_class.new }
    context 'when player 0 sets their color to blue' do
      before do
        game_color_set.active_player = 0
        allow(game_color_set).to receive(:gets).and_return('blue')
        allow(game_color_set).to receive(:puts)
        allow(game_color_set.board).to receive(:colors)
        game_color_set.set_color
      end
      it 'sets the color to blue' do
        expect(game_color_set.players[0][:color]).to eq(:blue)
      end
    end

    context 'when player 1 enters invalid input 2 times before setting color to orange' do
      before do
        game_color_set.active_player = 1
        allow(game_color_set).to receive(:gets).and_return('lemon', 'apple', 'orange')
        allow(game_color_set).to receive(:puts)
        allow(game_color_set.board).to receive(:colors)
      end

      it 'loops twice' do
        expect(game_color_set).to receive(:puts).with('Invalid input.').twice
        game_color_set.set_color
      end

      it 'sets player 1\'s color to orange' do
        game_color_set.set_color
        expect(game_color_set.players[1][:color]).to eq(:orange)
      end
    end
  end

  describe '#input_column' do
    subject(:input_game) { described_class.new }

    context 'when input is valid' do
      it 'returns the entered value - 1' do
        allow(input_game).to receive(:gets).and_return('7')
        expect(input_game.input_column).to eq(6)
      end
    end

    context 'when input is an invalid number and then a valid number' do
      before do
        allow(input_game).to receive(:gets).and_return('13', '4')
        allow(input_game).to receive(:puts)
      end
      it 'puts "Invalid input." once' do
        expect(input_game).to receive(:puts).with('Invalid input.').once
        input_game.input_column
      end

      it 'returns the entered value - 1' do
        expect(input_game.input_column).to eq 3
      end
    end
  end

  describe '#game_over?' do
    subject(:endgame) { described_class.new }
    before do
      allow(endgame).to receive(:puts)
    end
    context 'if a player had just won' do
      before do
        allow(endgame.board).to receive(:victory?).and_return(true)
        allow(endgame.board).to receive(:board_full?).and_return(false)
      end

      it 'returns true' do
        expect(endgame).to be_game_over
      end
    end

    context 'if the board is full, but there is no winner' do
      before do
        allow(endgame.board).to receive(:victory?).and_return(false)
        allow(endgame.board).to receive(:board_full?).and_return(true)
      end

      it 'returns true' do
        expect(endgame).to be_game_over
      end
    end

    context 'if there is no winner and the board isn\'t full' do
      before do
        allow(endgame.board).to receive(:victory?).and_return(false)
        allow(endgame.board).to receive(:board_full?).and_return(false)
      end

      it 'returns false' do
        expect(endgame).not_to be_game_over
      end
    end
  end
end
