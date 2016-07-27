#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [[ "$TRAVIS_BRANCH" != "master" ]]; then
  echo "Testing on a branch other than master/staging. No deployment will be done."
  exit 0
fi

PROVISIONING_PROFILE="$HOME/Library/MobileDevice/Provisioning Profiles/$PROFILE_NAME.mobileprovision"
OUTPUTDIR="$PWD/build/Release-iphoneos"
RELEASE_DATE=`date '+%Y-%m-%d %H:%M:%S'`
RELEASE_NOTES="Build: $TRAVIS_BUILD_NUMBER\nUploaded: $RELEASE_DATE"

echo "********************"
echo "*     Signing      *"
echo "********************"

xcrun -log -sdk iphoneos PackageApplication "$OUTPUTDIR/$APP_NAME.app" -o "$OUTPUTDIR/$APP_NAME.ipa" -sign "$DEVELOPER_NAME" -embed "$PROVISIONING_PROFILE"
zip -r -9 "$OUTPUTDIR/$APP_NAME.app.dSYM.zip" "$OUTPUTDIR/$APP_NAME.app.dSYM"

echo "**************************************************"
echo "*   (Master Branch) Uploading To Crashlytics     *"
echo "**************************************************"

Pods/Crashlytics/submit 0c31dbdd91674d7e38c2970702a8ed1296c2b427 60c8c37aabf092fb185bb414226b3c778eb2f32c630ce3584780de36c08014e5 -ipaPath "$OUTPUTDIR/$APP_NAME.ipa"
