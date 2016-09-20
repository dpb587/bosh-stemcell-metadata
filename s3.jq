#
# separate file since it's used for a couple things
#

def s3:
  {
    "endpoint": "https://s3.amazonaws.com",
    "bucket": "dpb587-bosh-stemcell-metadata-us-east-1",
    "prefix": "v2/",
    "access_key_id": env.AWS_ACCESS_KEY_ID,
    "secret_access_key": env.AWS_SECRET_ACCESS_KEY
  }
;
