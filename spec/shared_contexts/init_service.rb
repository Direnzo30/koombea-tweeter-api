RSpec.shared_context "init_service" do
  
  subject { described_class.new(create(:user)) }
  #By default, the caller will be executed
  let(:call_function_hook) { true }
  #Default for paramters in case thy are not declared
  let(:parameters) { nil }

  #fn is the caller function, must be defined on every general describe, example:
  # describe "::example_function" do
  #   let(:fn) { subject.method(:example_function)}
  # end

  before(:example) do
    if call_function_hook
      if parameters
        @response, @code = fn.call(parameters)
      else
        @response, @code = fn.call()
      end
    end
  end

end