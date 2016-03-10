module Instaw
  class Client
    module Searching

      def find_locations(query)
        search(query)['places'] || []
      end

      def find_hashtags(query)
        search(query)['hashtags'] || []
      end

      private

      def search(query)
        response = get(
          '/web/search/topsearch/',
          { context: 'blended', query: query, rank_token: rank_token },
          { referer: Instaw.endpoint + '/' }
        )
      end

      def rank_token
        rand
      end

    end
  end
end