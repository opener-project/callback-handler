require 'spec_helper'

describe Opener::CallbackHandler::Strategies::Http do
  context 'pass_validation?' do
    example 'return true for an HTTP URL' do
      described_class.pass_validation?('http://foo.com').should == true
    end

    example 'return true for an HTTPS URL' do
      described_class.pass_validation?('https://foo.com').should == true
    end

    example 'return false for a URL with just a scheme' do
      described_class.pass_validation?('http://').should == false
    end
  end

  context '#process' do
    before do
      @strategy = described_class.new
    end

    example 'send a message to the callback URL' do
      url     = 'http://foo.com'
      payload = JSON.dump(:number => 10)

      @strategy.http.should_receive(:post)
        .with(url, payload, :header => described_class::HEADERS)

      @strategy.process(url, :number => 10)
    end
  end
end
