# ApplicationService
#
# This very thin base service currently provides:
# * simplified calling of services, i.e. `MyService.call option: :abc` instead of `MyService.new(option: :abc).call`
class ApplicationService
  extend Dry::Initializer

  def self.call(...)
    new(...).call
  end
end
