gem 'minitest' if defined? Bundler
require 'minitest/autorun'

require 'faraday/newscred'

class FaradayNewscredTest < MiniTest::Unit::TestCase

  def setup
    @url = 'http://newscred.example.com/articles' 
    @optional_api_params = {
      :format    => :json, 
      :pagesize  => 10, 
      :offset    => 2, 
      :fields    => "article.title", 
      :from_date => "12-02-2013",
      :to_date   => "12-03-2013",
      :query     => "fun"
    } 
  end

  def conn
    Faraday::Connection.new('http://example.net/') do |builder|
      yield builder
      builder.adapter :test do |stub|
        stub.get('/newscred_path') do |env|
          [200, {}, env[:url].query]
        end
      end
    end
  end

  def test_does_not_allow_invalid_api_params
    no_access_key = lambda { 
      conn do |b|
        b.use Faraday::Newscred, {:access_key => "some_key", :invalid_key => "i am not valid"} 
      end.get("/newscred_path") 
    }
    no_access_key.must_raise(ArgumentError)
    error = no_access_key.call rescue $!
    assert_equal 'Unknown api params: invalid_key. '\
      'Valid api params are: '\
      '[access_key, format, pagesize, offset, fields, from_date, to_date, query]', error.message
  end

  def test_raises_if_access_key_missing
    no_access_key = lambda { conn { |b| b.use Faraday::Newscred }.get('/newscred_path')}
    no_access_key.must_raise(ArgumentError)
    error = no_access_key.call rescue $!
    assert_equal 'access_key can not be nil, please pass in access_key in options hash', error.message
  end

  def test_adds_access_key_to_query_string
    response = conn { |b|
      b.use Faraday::Newscred, {:access_key => "some_key"}
    }.get('/newscred_path')

    assert_equal("access_key=some_key", response.body)
  end

  def test_adds_all_optional_newscred_api_params
    response = conn { |b|
      b.use Faraday::Newscred, {:access_key => "some_key"}.update(@optional_api_params)
    }.get('/newscred_path')

    assert_equal(
      "access_key=some_key&"\
      "format=json&"\
      "pagesize=10&"\
      "offset=2&"\
      "fields=article.title&"\
      "from_date=12-02-2013&"\
      "to_date=12-03-2013&"\
      "query=fun", response.body)
  end

  def test_overrides_existing_params
    response = conn { |b|
      b.use Faraday::Newscred, {:access_key => "some_key"}
    }.get('/newscred_path?some=thing')

    assert_equal("access_key=some_key", response.body)
  end

end
