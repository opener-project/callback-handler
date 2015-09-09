require 'spec_helper'

describe Opener::CallbackHandler::Strategies::AmazonSqs do
  context 'pass_validation?' do
    example 'return true if the URI is an SQS URI' do
      described_class.pass_validation?('sqs://foo').should == true
    end

    example 'return false if only the URI scheme is given' do
      described_class.pass_validation?('sqs://').should == false
    end

    example 'return false for non SQS URIs' do
      described_class.pass_validation?('http://foo').should == false
    end
  end

  context '#process' do
    before do
      @strategy = described_class.new
    end

    example 'send a message to the queue' do
      @strategy.sqs
        .should_receive(:send_message)
        .with(
          :queue_url    => 'http://foo.com',
          :message_body => JSON.dump(:foo => 10)
        )

      @strategy.should_receive(:queue_url_for_uri)
        .with('sqs://foo')
        .and_return('http://foo.com')

      @strategy.process('sqs://foo', :foo => 10)
    end
  end

  context '#queue_url_for_uri' do
    example 'return the URL of a queue' do
      strategy = described_class.new

      strategy.should_receive(:queue_url_for_name)
        .with('foo')
        .and_return('http://foo.com')

      strategy.queue_url_for_uri('sqs://foo').should == 'http://foo.com'
    end
  end

  context '#queue_url_for_name' do
    example 'return the URL of a queue' do
      strategy = described_class.new

      strategy.sqs
        .should_receive(:get_queue_url)
        .with(:queue_name => 'foo')
        .and_return(double(:response, :queue_url => 'http://foo.com'))

      strategy.queue_url_for_name('foo').should == 'http://foo.com'
    end
  end
end
