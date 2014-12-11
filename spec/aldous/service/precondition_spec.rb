RSpec.describe Aldous::Service::Precondition do
  class Dummy
    include Aldous::Service::Precondition
  end

  it "creates a Failure result class named after the class where the module was included" do
    expect{Aldous::Result::DummyFailure.new}.to_not raise_error
  end

  it "the failure result is a type of failure" do
    expect(Aldous::Result::DummyFailure.new.failure?).to eq true
  end

  it "the failure result is a type of precondition failure" do
    expect(Aldous::Result::DummyFailure.new.precondition_failure?).to eq true
  end
end
