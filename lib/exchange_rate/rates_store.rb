#!/usr/bin/env ruby
require 'net/http'
require 'nokogiri'

# The class for handling the data.
class RatesStore
  
    def initialize
        @xml_doc = nil
    end

    # Gets a rate, given a date and 2 currencies
    #
    # Example:
    #   >> RatesStore.new.get_rate("2018-12-18", "GBP")
    #   => 1.1072
    #
    # Arguments:
    #   date: (String)
    #   currency: (String)
    def get_rate(date, currency)
        begin
            if(currency == "EUR")
                1.to_f
            else
                rate_node = @xml_doc.xpath("//xmlns:Cube[@time='#{date}']/xmlns:Cube[@currency='#{currency}']").first
                if(rate_node)
                    rate_node.attr('rate').to_f
                else
                    -1.to_f
                end
            end
        rescue => e
            print_exception e
        end
    end

    # Calls the ECB API to retrieve the rates xml
    # URL could be put into a constants file.
    #
    # Example:
    #   >> RatesStore.new.read_api
    #   => <..XML..>
    #
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

    # Gets the data form the cached file if it exists.
    # Can also force a refresh if required to overwrite cache.
    #
    # Example:
    #   >> RatesStore.new.get_data
    #   => 1.1072
    #
    # Arguments:
    #   force_refresh: (Boolean)
    #
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
