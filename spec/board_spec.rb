require_relative '../lib/board'

describe Board do
  describe '#initialize' do
    subject(:new_board) { described_class.new }
    it 'sets up an empty board of 6 * 7 slots' do
      expect(new_board.board.flatten.size).to eq(6 * 7)
    end

    it 'creates an empty variable to track player discs' do
      expect(new_board.player_discs).to eq([[], []])
    end
  end

  describe '#column_valid?' do
    subject(:valid_column_board) { described_class.new }
    context 'when the column is outside the board\'s range' do
      it 'returns false' do
        expect(valid_column_board.column_valid?(10)).to be false
      end
    end

    context 'when the column is full' do
      before do
        6.times { valid_column_board.drop_disc(:purple, 3, 0) }
        allow(valid_column_board).to receive(:puts).and_return('This column is already full.')
      end

      it 'returns false' do
        expect(valid_column_board.column_valid?(3)).to be false
      end
    end

    context 'when the column is valid' do
      it 'returns true' do
        expect(valid_column_board.column_valid?(4)).to be true
      end
    end
  end

  describe '#drop_disc' do
    context 'when a player picks a column in an empty board' do
      subject(:empty_board) { described_class.new }

      before do
        empty_board.drop_disc(:yellow, 2, 0)
      end

      it 'drops a disc to the bottom' do
        expect(empty_board.board[5][2]).to eq("\u{1F7E1}")
      end
    end
    context 'when a player picks a column that already contains a disc' do
      subject(:board_one_disc) { described_class.new }

      before do
        board_one_disc.drop_disc(:yellow, 2, 1)
        board_one_disc.drop_disc(:red, 2, 0)
      end

      it 'drops the disc just above the previous disc' do
        expect(board_one_disc.board[4][2]).to eq("\u{1F534}")
      end
    end
  end

  describe '#victory?' do
    context 'when the board is empty' do
      subject(:no_win_empty_board) { described_class.new }

      it 'returns false' do
        expect(no_win_empty_board.victory?(0)).to be false
      end
    end

    context 'when player 0 connects four in a column' do
      subject(:win_column) { described_class.new }

      before do
        4.times { win_column.drop_disc(:green, 1, 0) }
      end

      it 'returns true for player 0' do
        expect(win_column.victory?(0)).to be true
      end

      it 'returns false for player 1' do
        expect(win_column.victory?(1)).to be false
      end
    end

    context 'when player 1 connects four in a line' do
      subject(:win_line) { described_class.new }
      before do
        4.times { |column| win_line.drop_disc(:blue, column, 1) }
      end
      it 'returns true for player 1' do
        expect(win_line.victory?(1)).to be true
      end

      it 'returns false for player 0' do
        expect(win_line.victory?(0)).to be false
      end
    end

    context 'when player 0 puts four in a line in any other order' do
      subject(:win_line_shuffle) { described_class.new }
      before do
        [4, 3, 6, 5].each { |column| win_line_shuffle.drop_disc(:brown, column, 0) }
      end

      it 'returns true for player 0' do
        expect(win_line_shuffle.victory?(0)).to be true
      end

      it 'returns false for player 1' do
        expect(win_line_shuffle.victory?(1)).to be false
      end
    end

    context 'when player 0 forms an ascending diagonal of four' do
      subject(:asc_diagonal_win) { described_class.new }
      before do
        [1, 2, 3].each do |n|
          n.times { asc_diagonal_win.drop_disc(:orange, n, 1) }
        end
        [0, 1, 2, 3].each { |n| asc_diagonal_win.drop_disc(:blue, n, 0) }
      end
      it 'returns true for player 0' do
        expect(asc_diagonal_win.victory?(0)).to be true
      end

      it 'returns false for player 1' do
        expect(asc_diagonal_win.victory?(1)).to be false
      end
    end

    context 'when player 1 forms a descending diagonal of four' do
      subject(:desc_diagonal_win) { described_class.new }
      before do
        [3, 4, 5].each do |n|
          (6 - n).times { desc_diagonal_win.drop_disc(:red, n, 0) }
        end
        [3, 4, 5, 6].each { |n| desc_diagonal_win.drop_disc(:yellow, n, 1) }
      end

      it 'returns true for player 1' do
        expect(desc_diagonal_win.victory?(1)).to be true
      end

      it 'returns false for player 0' do
        expect(desc_diagonal_win.victory?(0)).to be false
      end
    end
  end

  describe '#board_full?' do
    subject(:full_board) { described_class.new }
    context 'when the board is empty' do
      it 'returns false' do
        expect(full_board).not_to be_board_full
      end
    end

    context 'when the board is almost full' do
      before do
        5.times do
          7.times do |n|
            full_board.drop_disc(:red, n, 0)
          end
        end
      end
      it 'returns false' do
        expect(full_board).not_to be_board_full
      end
    end

    context 'when the board is filled up' do
      before do
        6.times do
          7.times do |n|
            full_board.drop_disc(:red, n, 0)
          end
        end
      end
      it 'returns true' do
        expect(full_board).to be_board_full
      end
    end
  end
end
