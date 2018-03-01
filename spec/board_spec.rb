require_relative '../lib/board'

RSpec.describe Board do
  let(:dimension) { 3 }
  let(:board)     { described_class.new(dimension) }

  describe '#new' do
    context 'with 0 dimensions' do
      let(:dimension) { 0 }
      specify { expect { board }.to raise_error(Board::InvalidDimension) }
    end
  end

  describe '#grid' do
    subject { board.grid }

    context 'standard size' do
      let(:expected_grid) do
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil]
        ]
      end

      specify { expect(subject).to eq(expected_grid) }
    end

    context '6x6' do
      let(:dimension) { 6 }

      let(:expected_grid) do
        [
          [nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil]
        ]
      end

      specify { expect(subject).to eq(expected_grid) }
    end
  end

  describe '#place' do
    let(:token) { 'X' }
    let(:row)   { 0 }
    let(:col)   { 0 }

    subject { board.place(token, row, col) }

    context 'valid move' do
      let(:expected_grid) do
        [
          ['X', nil, nil],
          [nil, nil, nil],
          [nil, nil, nil],
        ]
      end

      before  { subject }
      specify { expect(board.grid).to eq(expected_grid) }
    end

    context 'out of board move' do
      let(:row) { -1 }
      specify   { expect { subject }.to raise_error(Board::OutOfBoard) }
    end

    context 'token already present' do
      before  { board.place(1, row, col) }
      specify { expect { subject }.to raise_error(Board::TokenPresent) }
    end
  end

  describe 'full?' do
    let(:max_moves) { dimension ** 2 }
    subject         { board.full? }

    context 'not yet' do
      specify { expect(subject).to be_falsey }
    end

    context 'almost' do
      before  { board.instance_variable_set(:@moves, max_moves - 1) }
      specify { expect(subject).to be_falsey }
    end

    context 'definitely' do
      before do
        (0..(dimension - 1)).each do |row|
          (0..(dimension - 1)).each { |col| board.place(1, row, col) }
        end
      end

      specify { expect(subject).to be_truthy }
    end
  end

  describe 'victory?' do
    before  { board.instance_variable_set(:@grid, grid) }
    subject { board.victory? }

    context 'without any moves' do
      let(:grid) do
        [
          [nil, nil, nil],
          [nil, nil, nil],
          [nil, nil, nil],
        ]
      end

      specify { expect(subject).to be_falsey }
    end

    context 'with a row' do
      let(:grid) do
        [
          ['X', 'X', 'X'],
          [nil, nil, nil],
          [nil, nil, nil],
        ]
      end

      specify { expect(subject).to be_truthy }
    end

    context 'with a column' do
      let(:grid) do
        [
          [nil, 'X', nil],
          [nil, 'X', nil],
          [nil, 'X', nil]
        ]
      end

      specify { expect(subject).to be_truthy }
    end

    context 'with the main diagonal' do
      let(:grid) do
        [
          ['X', nil, nil],
          [nil, 'X', nil],
          [nil, nil, 'X']
        ]
      end

      specify { expect(subject).to be_truthy }
    end

    context 'with the anti diagonal' do
      let(:grid) do
        [
          [nil, nil, 'X'],
          [nil, 'X', nil],
          ['X', nil, nil]
        ]
      end

      specify { expect(subject).to be_truthy }
    end
  end
end
