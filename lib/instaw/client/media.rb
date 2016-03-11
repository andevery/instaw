module Instaw
  class Client
    module Media
      def popular_media(**args)
        search_media(args).fetch('top_posts', {}).fetch('nodes', [])
      end

      def recent_media(**args)
        search_media(args).fetch('media', {}).fetch('nodes', [])
      end

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
        response = get(
          "/explore/tags/#{hashtag}/",
          {__a: 1},
          {referer: Instaw.endpoint + "/explore/tags/#{hashtag}/"}
        )
        response['tag']
      end

      def search_media_by_location(location)
        response = get(
          "/explore/locations/#{location}/",
          {__a: 1},
          {referer: Instaw.endpoint + "/explore/locations/#{location}/"}
        )
        response['location']
      end
    end
  end
end