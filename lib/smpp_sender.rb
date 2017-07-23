require 'uri'
require 'net/http'
require 'iconv'
module SmppSender
  def self.send_sms(credentials, mobile_number, message,sender,options = nil)
    username = credentials['username']
    password = credentials['password']
    mobile = mobile_number.gsub(/[^a-z,0-9]/, "")
    iconv = Iconv.conv("utf-16be", "utf-8", message)
    m = iconv.force_encoding("utf-8")
    hex = m.unpack('H*').first
    url = URI("#{credentials['server']}/send?username=#{username}&password=#{password}&to=#{mobile}&from=#{sender}&coding=8&hex-content=#{hex}")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    puts response.read_body
    if response.code.to_i == 200
      body = response.body.split(' ')
      body[0] = nil
      message_id = body.join
      return {message_id: message_id.gsub(/[^a-z,.:_,\-, ,^A-Z,0-9]/, "") , code: 0}
    else
      return {error: response.body.gsub(/[^a-z,.:_,\-, ,^A-Z,0-9]/, ""), code: response.code.to_i}
    end
  end
end

