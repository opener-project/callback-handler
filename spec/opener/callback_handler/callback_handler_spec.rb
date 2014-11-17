require 'spec_helper'

describe Opener::CallbackHandler do
  before do
    @handler = described_class.new
  end

  context '#post' do
    example 'submit data to an SQS callback' do
      Opener::CallbackHandler::Strategies::AmazonSqs.any_instance
        .should_receive(:process)
        .with('sqs://foo', :number => 10)

      @handler.post('sqs://foo', :number => 10)
    end

    example 'submit data to an HTTP callback' do
      Opener::CallbackHandler::Strategies::Http.any_instance
        .should_receive(:process)
        .with('http://foo', :number => 10)

      @handler.post('http://foo', :number => 10)
    end
  end

  context '#select_strategy' do
    example 'return the Amazon SQS strategy' do
      @handler.select_strategy('sqs://foo')
        .should == Opener::CallbackHandler::Strategies::AmazonSqs
    end

    example 'return the HTTP strategy' do
      @handler.select_strategy('http://foo')
        .should == Opener::CallbackHandler::Strategies::Http
    end
  end
end
