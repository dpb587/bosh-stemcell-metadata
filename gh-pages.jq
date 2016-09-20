#
# once the regular datapact jobs have extracted what they need, aggregate and
# index it into our indexed JSON file and make it available via GitHub Pages.
#

include "s3" {"search":"."};

def gh_pages:
  {
    "groups": [
      {
        "name": "aws",
        "jobs": [
          "publish-aws-xen-ubuntu-trusty"
        ]
      },
      {
        "name": "ubuntu-trusty",
        "jobs": [
          "publish-aws-xen-ubuntu-trusty"
        ]
      }
    ],
    "jobs": [
      {
        "name": "publish-aws-xen-ubuntu-trusty",
        "serial": true,
        "plan": [
          {
            "get": "stemcell-metadata",
            "resource": "aws-xen-ubuntu-trusty-metadata",
            "passed": [
              "aws-xen-ubuntu-trusty-metadata"
            ],
            "params": {
              "download": false
            },
            "trigger": true
          },
          {
            "get": "stemcell",
            "resource": "aws-xen-ubuntu-trusty-stemcell",
            "passed": [
              "aws-xen-ubuntu-trusty-metadata"
            ],
            "params": {
              "download": false
            }
          },
          {
            "get": "gh-pages"
          },
          {
            "task": "amend-stemcell",
            "file": "gh-pages/config/tasks/amend-stemcell.yml",
            "params": {
              "stemcell": "aws-xen-ubuntu-trusty",
              "s3_endpoint": s3.endpoint,
              "s3_bucket": s3.bucket,
              "s3_prefix": s3.prefix,
              "s3_access_key_id": s3.access_key_id,
              "s3_secret_access_key": s3.secret_access_key
            }
          },
          {
            "put": "gh-pages",
            "params": {
              "repository": "gh-pages",
              "rebase": true
            }
          }
        ]
      }
    ],
    "resources": [
      {
        "name": "gh-pages",
        "type": "git",
        "source": {
          "uri": "git@github.com:dpb587/bosh-stemcell-metadata.git",
          "branch": "gh-pages",
          "private_key": env.GIT_PRIVATE_KEY
        }
      }
    ]
  }
;
