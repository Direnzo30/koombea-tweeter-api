RSpec.shared_examples "a bad request response" do
  it "returns an unprocessable response" do
    expect(@code).to eq(:bad_request)
    expect(@response[:error]).not_to be_nil
    expect(@response[:content]).to be_nil
  end
end