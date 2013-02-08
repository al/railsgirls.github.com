#!/bin/bash

rsync -avz --rsh="ssh -i /Users/alan/.ec2/iorum.pem" _site iorum@sportsbook.iorum.ie:apps/railsgirls/
