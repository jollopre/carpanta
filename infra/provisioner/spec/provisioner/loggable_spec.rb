require 'provisioner/loggable'

RSpec.describe Provisioner::Loggable do
  subject do
    Class.new do
      extend Provisioner::Loggable
    end
  end

  describe '#logger' do
    it 'logs to STDOUT' do
      expect do
        subject.logger.info('wadus')
      end.to output(/wadus/).to_stdout_from_any_process
    end
  end
end
