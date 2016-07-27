#!/bin/sh
echo "Running Crashlytics (${CONFIGURATION})"
"${PODS_ROOT}/Fabric/run" ${MY_CRASHLYTICS_API_KEY} ${MY_CRASHLYTICS_BUILD_SECRET}
