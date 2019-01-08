require 'minitest/autorun'
require 'exchange_rate'
require 'util/mock_store'

class ExchangeRateTest < Minitest::Test
  
    def test_update_data_calls_store_once
        # Arrange
        mock_store = MockStore.new
        fx = ExchangeRate.new mock_store

        # Act
        fx.update_data

        # Assert
        assert_equal 1, mock_store.get_data_count
    end

    def test_at_calls_store_correctly
        # Arrange
        mock_store = MockStore.new
        mock_store.rate_to_return = 2
        fx = ExchangeRate.new mock_store

        # Act
        result = fx.at(Date.today, "GBP", "USD")

        # Assert
        assert_equal 1, mock_store.get_data_count
        assert_equal 2, mock_store.get_rate_count
        assert_equal 1, result
    end

end