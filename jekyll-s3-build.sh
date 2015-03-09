#!/bin/bash
# File name: jekyll-s3-build.sh

# Variables
S3_BUCKET="s3://$1"
SITE_DIR='_site/' # run this script from your Jekyll root folder.

##
# Usage:
# ./jekyll-s3-build.sh S3_Bucket_Name
# ./jekyll-s3-build.sh www.yourjekyllsite.com

# Check for argument
if (( $# != 1 ))
then
  echo "Whoops, you forgot to include the S3 Bucket."
  echo "Usage: jekyll-s3-build.sh S3_Bucket_Name "
  exit 1
fi


echo '===================================='
echo 'Build and deploy for site:'
echo $1
echo '===================================='

echo -e '\nBuilding Jekyll site.'
jekyll build
echo -e '> Done.\n'

echo 'Compress .html, .css and .js files.'
find $SITE_DIR \( -iname '*.html' -o -iname '*.css' -o -iname '*.js' \) -exec gzip -9 -n {} \; -exec mv {}.gz {} \;
echo -e "> Done.\n"

echo "Sync to Amazon S3 Bucket: $S3_BUCKET"
# Sync gzipped html/css/js files, which require special header
s3cmd sync --progress -M --acl-public --delete-removed --add-header 'Cache-Control: max-age=600' --add-header 'Content-Encoding:gzip' _site/ $S3_BUCKET --exclude '*.*' --include '*.html' --include '*.js' --include '*.css'
# Sync other files (not html/js/css)
s3cmd sync --progress -M --acl-public --delete-removed --add-header 'Cache-Control: max-age=600' --exclude '*.html' --exclude '*.js' --exclude '*.css' --exclude '*.sh' --exclude '.DS_Store' --exclude 'README.md' _site/ $S3_BUCKET
echo '> Done.'

exit 0