#!/usr/bin/env ruby
require 'net/http'
require 'nokogiri'

class RatesStore
  
    def initialize
        @xml_doc = nil
    end

    def get_rate(date, currency)
        begin
            if(currency == "EUR")
                1.to_f
            else
                @xml_doc.xpath("//xmlns:Cube[@time='#{date}']/xmlns:Cube[@currency='#{currency}']").first.attr('rate').to_f
            end
        rescue => e
            print_exception e
        end
    end

    def read_api
        begin
            uri = URI('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml')
            Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
                request = Net::HTTP::Get.new uri
                response = http.request request
                response.body
            end
        rescue => e
            print_exception e
        end
    end

    def get_data(force_refresh = false)
        begin
            if(File.exist?('fx.cache') && !force_refresh)
                data = File.read('fx.cache')
                @xml_doc = Nokogiri::XML(data)
                puts "Using cached data"
            elsif
                data = read_api
                @xml_doc = Nokogiri::XML(data)
                File.open('fx.cache', 'w') do |f|
                    f.puts data
                end
                puts "Using fresh data"
            end
        rescue => e
            print_exception e
        end
        @xml_doc
    end

    def print_exception(exception)
        puts "#{exception.class}: #{exception.message}"
        puts exception.backtrace.join("\n")
    end
end
