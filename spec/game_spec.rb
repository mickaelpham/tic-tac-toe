require_relative '../lib/game'

RSpec.describe Game do
  let(:instance) { described_class.new }

  let(:players) do
    [
      Player.new('Jane', 'X'),
      Player.new('John', 'O')
    ]
  end

  before do
    # initialize players
    allow(Screen).to receive(:create_player).and_return(*players)
  end

  describe '#setup_players' do
    before do
      allow(Screen).to receive(:create_player).and_raise(Interrupt)
      allow(Screen).to receive(:bye)
    end

    specify { expect { instance }.to raise_error(SystemExit) }
  end

  describe '#board' do
    subject(:board) { instance.board }
    specify { expect(board.full?).to    be_falsey }
    specify { expect(board.victory?).to be_falsey }
  end

  describe '#players' do
    specify { expect(instance.players).to eq(players) }
  end

  describe '#current_player' do
    specify { expect(instance.current_player).to eq(players.first) }

    context 'after 1 turn' do
      before  { instance.send(:next_player) }
      specify { expect(instance.current_player).to eq(players.last) }
    end
  end

  describe '#run' do
    let(:board) { instance_double(Board) }

    subject(:run) { instance.run }

    before { allow(Board).to receive(:new).and_return(board) }

    context '[during turn]' do
      let(:turns) { [false, false, true] }

      before do
        allow(board).to  receive(:victory?).and_return(*turns)
        allow(board).to  receive(:full?).and_return(false)
        allow(Screen).to receive(:display).with(board)
      end

      context '[player prompt invalid]' do
        let(:input) { -1 }

        before do
          allow(board).to receive(:place).and_raise(Board::BoardError)
          allow(Screen).to receive(:error)
          allow(Screen).to receive(:new_game?)
          allow(Screen).
            to receive(:prompt).with(players.first).and_return(input)
        end

        it 'asks the same player again after displaying an error message' do
          run
          expect(instance.current_player).to eq(players.first)
          expect(Screen).to have_received(:error).at_least(1)
        end
      end

      context '[player prompt valid]' do
        let(:input) { 1 }

        before do
          allow(board).to receive(:place)
          allow(Screen).to receive(:new_game?)
          allow(Screen).
            to receive(:prompt).with(players.first).and_return(input)
        end

        it 'adds the token then goes to the next player' do
          run
          expect(instance.current_player).to eq(players.last)
        end
      end

      context '[CTRL-C pressed]' do
        before do
          allow(Screen).to receive(:bye)
          allow(Screen).
            to receive(:prompt).with(players.first).and_raise(Interrupt)
        end

        it 'quits the program' do
          expect { run }.to raise_error(SystemExit)
        end
      end
    end

    context '[end of game]' do
      before { allow(board).to receive(:victory?).and_return(true) }

      describe '[new game?]' do
        before do
          allow(Screen).to receive(:new_game?).and_return(*new_game)
        end

        context '[No]' do
          let(:new_game) { false }

          specify do
            run
            expect(Screen).to have_received(:new_game?).once
          end
        end

        context '[Yes then No]' do
          let(:new_game) { [true, false] }

          specify do
            run
            expect(Screen).to have_received(:new_game?).twice
            expect(Board).to have_received(:new).twice
          end
        end
      end
    end
  end
end
