require 'uri'
require 'net/http'
require 'iconv'
module SmppSender
  def self.send_sms(credentials, mobile_number, message,sender,options = nil)
    username = credentials['username']
    password = credentials['password']
    mobile = mobile_number
    from = sender
    iconv = Iconv.conv("utf-16be", "utf-8", message)
    m = iconv.force_encoding("utf-8")
    hex = m.unpack('H*').first
    if from.blank?
      url = URI("#{credentials['server']}/send?username=#{username}&password=#{password}&to=#{mobile}&coding=8&hex-content=#{hex}")
    else
      url = URI("#{credentials['server']}/send?username=#{username}&password=#{password}&from=#{from}&to=#{mobile}&coding=8&hex-content=#{hex}")
    end
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    puts response.read_body
  end
end

