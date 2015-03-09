# jekyll-s3-build

Jekyll build tool to build, compress, and deploy to AWS S3. Hoping to keep this simple with only has one requirement.

##Dependancies

* [s3cmd](https://github.com/s3tools/s3cmd)
* S3 bucket configured for Static Website Hosting

## Installation

Run jekyll-s3-build.sh from the Jekyll root folder where build goes to ~/_site.

## Usage

	./jekyll-s3-build.sh s3_bucketname

**Example:**

	./jekyll-s3-build.sh www.yourjekyllsite.com


## Todo

* Add CloudFront invalidation
* Smarter Cache headers