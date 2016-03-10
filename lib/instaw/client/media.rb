module Instaw
  class Client
    module Media

      private

      def search_media(hashtag: nil, location: nil)
        raise ArgumentError unless hashtag.nil? ^ location.nil?
        if hashtag
          search_media_by_hashtag(hashtag)
        else
          search_media_by_location(location)
        end
      end

      def search_media_by_hashtag(hashtag)
        get(
          "/explore/tags/#{hashtag}/",
          {__a: 1},
          {referer: Instaw.endpoint + "/explore/tags/#{hashtag}/"}
        )
      end

      def search_media_by_location(location)
      end
    end
  end
end