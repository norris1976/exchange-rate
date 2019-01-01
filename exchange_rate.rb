#!/usr/bin/env ruby
require 'date'
require './rates_store'

class ExchangeRate
  
    def initialize(st = RatesStore.new)
        @store = st
    end

    def at(date, base, counter)
        begin
            @store.get_data

            date_to_use = self.get_week_day(date)
            dateFormat = date_to_use.strftime("%Y-%m-%d")

            base_rate = @store.get_rate(dateFormat, base)
            counter_rate = @store.get_rate(dateFormat, counter)

            rate = (counter_rate / base_rate).round(4)
            p "#{base} to #{counter}: #{rate}"
            rate
        rescue => e
            print_exception e
        end
    end

    def update_data
        @store.get_data true
    end

    def get_week_day(date)
        # If date is in the future, use today's date
        date_to_use = date
        if date_to_use > Date.today
            date_to_use = Date.today
        end

        # If date is on weekend, get previous Friday
        offset = 0
        if date_to_use.wday == 0
            offset = 2
        end
        if date_to_use.wday == 6
            offset = 1
        end
        date_to_use - offset
    end

    def print_exception(exception)
        puts "#{exception.class}: #{exception.message}"
        puts exception.backtrace.join("\n")
    end
end


if __FILE__ == $0
  fx = ExchangeRate.new
  #fx.at(Date.today + 2, "GBP", "RUB")
  fx.update_data
end