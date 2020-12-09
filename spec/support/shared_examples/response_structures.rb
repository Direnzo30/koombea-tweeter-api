RSpec.shared_examples "a bad request response" do
  it "is a bad request response response" do
    response, code = result
    expect(code).to eq(:bad_request)
    expect(response[:error]).not_to be_nil
    expect(response[:content]).to be_nil
  end
end

RSpec.shared_examples "an unprocessable response" do
  it "is an unprocessable response" do
    response, code = result
    expect(code).to eq(:unprocessable_entity)
    expect(response[:error]).not_to be_nil
    expect(response[:content]).to be_nil
  end
end

RSpec.shared_examples "a valid response" do
  it "returns a valid response" do
    response, code = result
    expect(code).to eq(:ok)
    expect(response[:error]).to be_nil
    expect(response[:content]).not_to be_nil
  end
end