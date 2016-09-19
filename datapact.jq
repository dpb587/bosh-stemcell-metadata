include "s3" {"search":"."};
include "gh-pages" {"search":"."};

{
  "branch_list": [
    {
      "branch": "aws-ubuntu-trusty-stemcell"
    },
    {
      "branch": "aws-ubuntu-trusty-metadata"
    }
  ],
  "datapact_job": {
    "name": "datapact-job",
    "type": "datapact",
    "check_interval": "1h",
    "source": {
      "uri": "git@github.com:dpb587/bosh-stemcell-metadata.git",
      "private_key": env.GIT_PRIVATE_KEY,
      "s3_endpoint": s3.endpoint,
      "s3_bucket": s3.bucket,
      "s3_prefix": s3.prefix,
      "s3_access_key_id": s3.access_key_id,
      "s3_secret_access_key": s3.secret_access_key
    }
  },
  "pipeline": gh_pages
}
