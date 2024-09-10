require 'aws-sdk-s3'    # Load the AWS SDK for Ruby, specifically for S3 operations
require 'pry'           # Load Pry for debugging (optional)
require 'securerandom'  # Load SecureRandom for generating unique UUIDs

bucket_name = ENV['BUCKET_NAME']  # Get the bucket name from the environment variable `BUCKET_NAME`
region = 'us-east-1'  # Specify the AWS region where the bucket will be created

# Initialize the AWS S3 client specifying the region
client = Aws::S3::Client.new(region: region)

# Prepare the bucket creation parameters
create_bucket_params = {
  bucket: bucket_name  # The name of the bucket to create
}

# Add location constraint only if not 'us-east-1'
unless region == 'us-east-1'
  create_bucket_params[:create_bucket_configuration] = {
    location_constraint: region  # Specify the region constraint for the bucket
  }
end

# Create a new S3 bucket with or without location constraint based on the region
resp = client.create_bucket(create_bucket_params)

# Debugging breakpoint
# binding.pry

number_of_files = 1 + rand(6)  # Randomly generate a number between 1 and 6 for the number of files to create
puts "number_of_files: #{number_of_files}"  # Output how many files will be generated

number_of_files.times.each do |i|
  puts "i: #{i}"  # Output the index of the current file being processed
  filename = "file_#{i}.txt"  # Generate a filename like `file_0.txt`, `file_1.txt`, etc.
  output_path = "/tmp/#{filename}"  # Specify the path where the file will be created locally

  # Open a new file at the `output_path` and write a random UUID to it
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid  # Write a unique UUID string into the file
  end

  # Open the file again, this time in read-binary mode to prepare it for uploading to S3
  File.open(output_path, 'rb') do |file|
    # Upload the file to S3 using the `put_object` method
    client.put_object(
      bucket: bucket_name,  # The name of the bucket where the file will be uploaded
      key: filename,  # The key (file name) under which the object will be stored in S3
      body: file  # The content (file) to upload
    )
  end
end
