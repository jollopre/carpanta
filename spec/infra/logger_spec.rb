require 'infra/logger'

RSpec.describe Infra::Logger do

  describe '.new' do
    it 'raises NoMethodError' do
      expect do
        described_class.new
      end.to raise_error(NoMethodError, /private method `new' called/)
    end
  end

  subject { described_class.build }

  describe '#info' do
    it 'logs an info message' do
      expect do
        subject.info('wadus')
      end.to output(/INFO -- : wadus/).to_stdout_from_any_process
    end
  end

  describe '#warn' do
    it 'logs a warn message' do
      expect do
        subject.warn('wadus')
      end.to output(/WARN -- : wadus/).to_stdout_from_any_process
    end
  end

  describe '#error' do
    it 'logs an error message' do
      expect do
        subject.error('wadus')
      end.to output(/ERROR -- : wadus/).to_stdout_from_any_process
    end
  end
end
