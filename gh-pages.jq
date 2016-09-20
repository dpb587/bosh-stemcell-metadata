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
      [ "aws-xen-centos-7", "aws-xen-ubuntu-trusty" ] | map({
        "name": "publish-\(.)",
        "serial": true,
        "plan": [
          {
            "get": "stemcell-metadata",
            "resource": "\(.)-metadata",
            "passed": [
              "\(.)-metadata"
            ],
            "params": {
              "download": false
            },
            "trigger": true
          },
          {
            "get": "stemcell",
            "resource": "\(.)-stemcell",
            "passed": [
              "\(.)-metadata"
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
              "stemcell": .,
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
      })[]
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
