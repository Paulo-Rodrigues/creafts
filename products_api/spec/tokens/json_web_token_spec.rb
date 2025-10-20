require "rails_helper"

describe JsonWebToken do
  let(:external_id) { "XYZ123" }
  let(:encoded) { described_class.encode({ user_id: external_id }) }

  it ".encode" do
    expect(encoded).to be_a(String)
  end

  it ".decode" do
    expected_payload = { "user_id" => external_id }

    expect(JsonWebToken.decode(encoded)).to include(expected_payload)
  end
end
