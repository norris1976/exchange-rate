#!/usr/bin/env ruby
require 'date'
require 'exchange_rate/rates_store'

# The main Exchange Rate driver.
class ExchangeRate

    def initialize(st = RatesStore.new)
        @store = st
    end

    # Get exchange data
    #
    # Example:
    #   >> ExchangeRate.new.at(Date.today, "GBP", "EUR")
    #   => 1.1072
    #
    # Arguments:
    #   date: (Date)
    #   base: (String)
    #   counter: (String)
    def at(date, base, counter)
        begin
            @store.get_data

            date_to_use = self.get_week_day(date)
            dateFormat = date_to_use.strftime("%Y-%m-%d")

            base_rate = @store.get_rate(dateFormat, base)
            counter_rate = @store.get_rate(dateFormat, counter)

            if(base_rate > 0 and counter_rate > 0)
                rate = (counter_rate / base_rate).round(4)
                p "#{base} to #{counter}: #{rate}"
                rate
            elsif
                0.to_f
            end
        rescue => e
            print_exception e
        end
    end

    # Update the data store. 
    # Can be used from cron job.
    #
    # Example:
    #   >> ExchangeRate.new.update_data
    #
    def update_data
        @store.get_data true
    end

    # Gets a valid date i.e. non-weekend and non future.
    #
    # Example:
    #   >> ExchangeRate.new.get_week_day Date.today
    #
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
