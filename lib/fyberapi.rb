
require 'digest/sha1'
require 'net/http'
require 'json'

class FyberAPI
  attr_reader :params, :response, :error
  
  DEFAULT_PARAMS  = {
    :appid       => Settings.appid,
    :ip          => Settings.ip,
    :locale      => Settings.locale,
    :device_id   => Settings.device_id,
    :offer_types => Settings.offer_types
  }

  def initialize(params)
    @params = DEFAULT_PARAMS.merge params.symbolize_keys!
    @params[:timestamp] = Time.now.to_i.to_s
  end

  def query_builder
    query_string = ''
    @params.keys.sort.each do |key|
      query_string += key.to_s + '=' + @params[key].to_s + '&'
    end
    query_string.chop!
    hashkey = signature("#{query_string}&")
    query_string = "#{Settings.url}?#{query_string}&hashkey=#{hashkey}"
  end

  def request! ( query_string = nil )
    query_string ||= query_builder
    url = URI.parse(query_string)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    @response = res
  end

  def valid_signature? (body = nil, header = nil)
    body ||= @response.body
    header ||= @response.header
    signature(body) == header['X-Sponsorpay-Response-Signature']
  end

  def signature(data = nil)
    Digest::SHA1.hexdigest(data + Settings.apikey)
  end

  def response_body (body = nil)
    body ||= @response.body
    JSON.parse(body)
  end

  def error?
    data = response_body
    if not valid_signature? 
      @error = 'Invalid signature'
    elsif @response.code != '200' 
      @error = "HTTP error. Status: #{@response.code}. Message: #{@response.message}"
    elsif data['code'] != 'OK'
      @error = data['message'] 
    end
    @error
  end

  def offers
    response_body['offers']
  end

end