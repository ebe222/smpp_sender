#!/bin/env ruby
# encoding: utf-8
require 'uri'
require 'net/http'
require 'iconv'
module smpp_sender
class SmppSender
  def self.send_sms(creditnatiols, mobile_number, message)
    username = creditnatiols['username']
    password = creditnatiols['password']
    mobile = mobile_number
    from = creditnatiols['from']
    iconv = Iconv.conv("utf-16be", "utf-8", message)
    m = iconv.force_encoding("utf-8")
    hex = m.unpack('H*').first
    if from.blank?
      url = URI("#{creditnatiols['server']}/send?username=#{username}&password=#{password}&to=#{mobile}&coding=8&hex-content=#{hex}")
    else
      url = URI("#{creditnatiols['server']}/send?username=#{username}&password=#{password}&from=#{from}&to=#{mobile}&coding=8&hex-content=#{hex}")
    end
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    puts response.read_body
  end
end
