require "helper"
require "freesound"

describe "finding a sound" do
  let(:api_key) { ENV.fetch("FREESOUND_KEY") }
  let(:client)  { Freesound::Client.new(api_key) }

  context "that exists" do
    let(:sound) do
      VCR.use_cassette(:sound_18763) do
        client.sound(18763)
      end
    end

    it "returns an object with sound attributes" do
      expect(sound.id).to be(18763)
      expect(sound.ref).to match(/\/sounds\/18763/)
      expect(sound.tags).to respond_to(:each)
    end

    it "belongs to a user" do
      expect(sound.user.username).to be_present
    end
  end

  context "that doesn't exist" do
    it "raises an exception" do
      expect {
        VCR.use_cassette(:sound_unknown) do
          client.sound(123456789)
        end
      }.to raise_error(Freesound::ResourceNotFound, /sound with id 123456789/i)
    end
  end
end