module Instaw
  class Client
    module Locations
      def find_locations(query)
        response = get(
          '/web/search/topsearch/',
          { context: 'blended', query: query, rank_token: rank_token },
          { referer: Instaw.endpoint + '/' }
        )
      end

      private

      def rank_token
        rand()
      end
    end
  end
end