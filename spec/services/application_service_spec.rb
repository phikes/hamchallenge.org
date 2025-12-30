require "rails_helper"

RSpec.describe ApplicationService do
  describe "::call" do
    subject(:service) do
      Class.new(ApplicationService) do
        attr_reader :args, :kwargs, :block

        def initialize(*args, **kwargs, &block)
          @args = args
          @kwargs = kwargs
          @block = block
        end

        def call
          [args, kwargs, block]
        end
      end
    end

    it "instantiates the service with the provided arguments and calls it" do
      block = -> {}

      expect(service.call("test", abc: 123, &block)).to eq [["test"], {abc: 123}, block]
    end
  end
end
