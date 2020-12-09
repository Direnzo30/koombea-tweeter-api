RSpec.shared_examples "a valid response" do
  it "returns a valid response" do
    expect(@code).to eq(:ok)
    expect(@response[:error]).to be_nil
    expect(@response[:content]).not_to be_nil
  end
end