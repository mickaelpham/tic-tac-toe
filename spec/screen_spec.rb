require_relative '../lib/screen'

RSpec.describe Screen do
  describe '#display' do
    let(:board) { instance_double(Board, grid: grid) }

    subject { described_class.display(board) }

    context 'empty board' do
      let(:grid) { [[nil]] }

      before do
        allow(described_class).to receive(:clear)
      end

      specify do
        expect(described_class).to receive(:puts).with('+---+').twice
        expect(described_class).to receive(:print).with('|')
        expect(described_class).to receive(:print).with(' 1 |')
        expect(described_class).to receive(:puts).twice
        subject
      end

      context 'board with a player token' do
        let(:grid) { [['X']] }

        before do
          allow(described_class).to receive(:clear)
        end

        specify do
          expect(described_class).to receive(:puts).with('+---+').twice
          expect(described_class).to receive(:print).with('|')

          # light cyan token
          expect(described_class).
            to receive(:print).with(" \e[0;96;49mX\e[0m |")

          expect(described_class).to receive(:puts).twice
          subject
        end
      end
    end
  end

  describe '#delimiter' do
    subject { described_class.delimiter(length) }

    context 'length = 1' do
      let(:length) { 1 }
      specify { expect(subject).to eq('+---+') }
    end

    context 'length = 3' do
      let(:length) { 3 }
      specify { expect(subject).to eq('+---+---+---+') }
    end
  end

  describe '#prompt' do
    let(:player) { instance_double(Player, name: 'John', token: 'O') }
    let(:input)  { '1' }
    subject { described_class.prompt(player) }

    before do
      allow(described_class).
        to receive(:puts).with('[John] Place token (O) at: ')
      allow(STDIN).to receive(:gets).and_return(input)
    end

    specify { expect(subject).to eq(input.to_i - 1) }
  end

  describe '#create_player' do
    let(:player_name)  { 'John' }
    let(:player_token) { 'O' }

    subject { described_class.create_player(1) }

    before do
      allow(described_class).to receive(:puts).with('P1 name: ')

      allow(STDIN).to receive(:gets).and_return(player_name, player_token)

      allow(described_class).
        to receive(:puts).with('P1 token (1 character, e.g., \'X\'): ')

      allow(described_class).to receive(:puts)
    end

    specify { expect(subject.name).to eq(player_name) }

    specify { expect(subject.token).to eq(player_token) }
  end

  describe '#victory' do
    let(:board)  { instance_double(Board) }
    let(:player) { instance_double(Player, name: 'John Doe') }

    subject { described_class.victory(board, player) }
    before  { allow(described_class).to receive(:display).with(board) }

    specify do
      expect(described_class).to receive(:puts).with('John Doe won the game!')
      subject
    end
  end

  describe '#tie' do
    let(:board) { instance_double(Board) }
    subject { described_class.tie(board) }
    before { allow(described_class).to receive(:display).with(board) }

    specify do
      expect(described_class).to receive(:puts).with('Nobody won...')
      subject
    end
  end

  describe '#error' do
    let(:player_error) { StandardError.new('msg') }
    subject { described_class.error(player_error) }

    specify do
      expect(described_class).
        to receive(:puts).with("\n#{player_error}! Let's try again...\n\n")
      subject
    end
  end

  describe '#bye' do
    subject { described_class.bye }

    specify do
      expect(described_class).
        to receive(:puts).with("\n\nQuitting Tic-Tac-Toe by Mickael Pham")
      subject
    end
  end

  describe '#new_game?' do
    subject { described_class.new_game? }

    before do
      allow(described_class).
        to receive(:puts).with("\n\nPlay another game? (y/N)")
      allow(STDIN).to receive(:gets).and_return(player_response)
    end

    context '[yes]' do
      let(:player_response) { 'y' }
      specify { expect(subject).to be_truthy }
    end

    context '[no]' do
      let(:player_response) { 'N' }
      specify { expect(subject).to be_falsey }
    end

    context '[no] is the default' do
      let(:player_response) { '' }
      specify { expect(subject).to be_falsey }
    end
  end

  describe '#clear' do
    subject { described_class.clear }

    context 'Windows platform' do
      before { stub_const('RUBY_PLATFORM', 'windows') }

      specify do
        expect(described_class).to receive(:system).with('cls')
        subject
      end
    end

    context 'all other platforms' do
      specify do
        expect(described_class).to receive(:system).with('clear')
        subject
      end
    end
  end
end
