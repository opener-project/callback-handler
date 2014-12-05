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
      @queue    = AWS::SQS::Queue.new('foo')

      @strategy.stub(:queue_for_uri).and_return(@queue)
    end

    example 'send a message to the queue' do
      @queue.should_receive(:send_message).with(JSON.dump(:foo => 10))

      @strategy.process('foo', :foo => 10)
    end
  end

  context '#queue_for_uri' do
    before do
      @strategy = described_class.new
      @queue    = AWS::SQS::Queue.new('foo')
    end

    example 'return the queue for a URI' do
      @strategy.should_receive(:queue_for_name)
        .with('foo')
        .and_return(@queue)

      @strategy.queue_for_uri('sqs://foo').should == @queue
    end

    example 'return the queue for a URI containing an underscore' do
      @strategy.should_receive(:queue_for_name)
        .with('foo_bar')
        .and_return(@queue)

      @strategy.queue_for_uri('sqs://foo_bar').should == @queue
    end
  end
end
