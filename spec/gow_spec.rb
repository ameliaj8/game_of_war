require 'open3'

RSpec.describe "GoW" do
  context 'with no arguments' do
    it 'raises an error' do
      stdout, stderr, status = Open3.capture3('./gow')
      expect(stderr).to eq("Error: You must specify a number of players\n")
      expect(status.exitstatus).to eq(1)
    end
  end

  context 'with more than one argument' do
    it 'raises an error' do
      stdout, stderr, status = Open3.capture3('./gow 1 2')
      expect(stderr).to eq("Error: Too many arguments\n")
      expect(status.exitstatus).to eq(1)
    end
  end

  context 'with number of players argument' do
    context 'not a number' do
      it 'raises an error' do
        stdout, stderr, status = Open3.capture3('./gow hello')
        expect(stderr).to eq("Error: Number of players must be a number between 2-52\n")
        expect(status.exitstatus).to eq(1)
      end
    end

    context '<2 players' do
      it 'raises an error' do
        stdout, stderr, status = Open3.capture3('./gow -1')
        expect(stderr).to eq("Error: Number of players must be a number between 2-52\n")
        expect(status.exitstatus).to eq(1)
      end
    end


    context '>52 players' do
      it 'raises an error' do
        stdout, stderr, status = Open3.capture3('./gow 1000')
        expect(stderr).to eq("Error: Number of players must be a number between 2-52\n")
        expect(status.exitstatus).to eq(1)
      end
    end
  end
end