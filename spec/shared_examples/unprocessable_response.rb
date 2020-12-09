RSpec.shared_examples "an unprocessable response" do
  it "returns an unprocessable response" do
    expect(@code).to eq(:unprocessable_entity)
    expect(@response[:error]).not_to be_nil
    expect(@response[:content]).to be_nil
  end
end