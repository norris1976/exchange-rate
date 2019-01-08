class MockStore
    attr_accessor  :get_rate_count
    attr_accessor  :read_api_count
    attr_accessor  :get_data_count
    attr_accessor  :rate_to_return
    attr_accessor  :rate_xml

    def initialize
        self.reset
    end

    def get_rate(date, currency)
        @get_rate_count += 1

        @rate_to_return
    end

    def read_api
        @read_api_count += 1
        @rate_xml
    end

    def reset
        @get_rate_count = 0
        @read_api_count = 0
        @get_data_count = 0
        @rate_to_return = 0
        @rate_xml = nil
    end

    def get_data(force_refresh = false)
        @get_data_count += 1
        @xml_doc = Nokogiri::XML(@rate_xml)
        @xml_doc
    end

end