require 'spec_helper'

describe FyberAPI do
  let(:params) { { uid: 'testuser', pub0: 'testpub', page: 1 } }

  before(:each) do
    allow_any_instance_of(Time).to receive(:to_i).and_return('1438442624')
  end

  it "should return correct query" do 
    api = FyberAPI.new(params)
    api.query_builder.should == "http://api.sponsorpay.com/feed/v1/offers.json?appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&ip=109.235.143.113&locale=de&offer_types=112&page=1&pub0=testpub&timestamp=1438442624&uid=testuser&hashkey=0b606c78eb0a4bcba83c72cbf3ba7f091f2591ed"
  end

  describe "valid_signature?" do

    context "when signature is valid" do 
      it "returns true" do 
        api = FyberAPI.new(params)
        body = '{ "code" : "OK" }'
        header = { 'X-Sponsorpay-Response-Signature' => '1b055355dd9a96c1c95a1e6f6536ebebba3426b8' }
        api.valid_signature?(body, header).should be_truthy
      end
    end

    context "when signature is invalid" do 
      it "returns false" do 
        api = FyberAPI.new(params)
        body = '{ "code" : "OK" }'
        header = { 'X-Sponsorpay-Response-Signature' => '1b055355dd9a' }
        api.valid_signature?(body, header).should be_falsy
      end
    end
  end

  describe "FyberAPI requester" do
    describe "/" do
      it "returns status code 200" do
        get '/'
        last_response.status.should == 200
      end
    end
  end

end