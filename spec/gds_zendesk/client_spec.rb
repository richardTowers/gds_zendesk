require 'spec_helper'
require 'gds_zendesk/test_helpers'
require 'gds_zendesk/client'
require 'null_logger'

module GDSZendesk
  describe Client do
    include GDSZendesk::TestHelpers

    def valid_credentials
      { "username" => "user", "password" => "pass" }
    end

    def client(options = {})
      Client.new(valid_credentials.merge(options))
    end

    it "should raise an error if no username is provided" do
      expect { Client.new(password: "abc") }.to raise_error(ArgumentError,
        /username not provided/)
    end

    it "should raise an error if no password is provided" do
      expect { Client.new(username: "abc") }.to raise_error(ArgumentError,
        /password not provided/)
    end

    it "should use a null logger if no logger has been provided" do
      expect(client.config_options[:logger]).to be_an_instance_of(NullLogger::Logger)
    end

    it "should use the passed logger if one has been provided" do
      custom_logger = double("logger")

      expect(client(logger: custom_logger).config_options[:logger]).to eq(custom_logger)
    end

    it "should raise tickets in Zendesk" do
      self.valid_zendesk_credentials = valid_credentials
      post_stub = stub_zendesk_ticket_creation(some: "data")

      client.ticket.create(some: "data")

      expect(post_stub).to have_been_requested
    end
  end
end
