class FetchWeightMeasures < PowerTypes::Command.new(:from, :to)
  TIME_FORMAT = '%Y-%m-%dT%H'

  def perform
    source_url = ENV.fetch('WOLKE_API_URL') + '/platanusintfweighing?'
    conn = Faraday.new source_url, request: { params_encoder: DoNotEncoder }
    response = conn.get source_url, api_params
    parse_body(response)
  end

  private

  def api_params
    {
      startDate: @from.localtime.strftime(TIME_FORMAT),
      endDate: @to.localtime.strftime(TIME_FORMAT),
      token: ENV.fetch('WOLKE_TOKEN')
    }
  end

  def parse_body(response)
    JSON.parse(response.body)
        .map { |hash| hash.transform_keys(&:underscore) }
        .map(&:deep_symbolize_keys!)
  end

  class DoNotEncoder
    def self.encode(params)
      buffer = ''
      params.each do |key, value|
        buffer << "#{key}=#{value}&"
      end
      buffer.chop
    end
  end
end
