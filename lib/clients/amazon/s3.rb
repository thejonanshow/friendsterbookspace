module Clients
  module Amazon
    class S3
      BUCKET_NAME = "friendsterbookspace"
      attr_reader :client

      def initialize
        @client = Aws::S3::Client.new(
          access_key_id: ENV["AWS_ACCESS_KEY_ID"],
          secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
        )

        create_bucket!
      end

      def create_bucket!
        client.create_bucket(acl: "public-read", bucket: BUCKET_NAME)
      rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
      end

      def upload_file(filename, file)
        resource = Aws::S3::Resource.new(client: client)
        s3_object = resource.bucket(BUCKET_NAME).object(filename)
        s3_object.put(body: file, acl: "public-read")
      end

      def url_for(filename)
        resource = Aws::S3::Resource.new(client: client)
        resource.bucket(BUCKET_NAME).object(filename).public_url
      end

      def download_file(filename)
        client.get_object(bucket: BUCKET_NAME, key: filename).body
      end

    end
  end
end
