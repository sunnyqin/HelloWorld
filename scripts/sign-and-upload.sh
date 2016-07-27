#!/bin/sh
if [[ "$TRAVIS_PULL_REQUEST" != "false" ]]; then
  echo "This is a pull request. No deployment will be done."
  exit 0
fi

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
 echo "Testing on master branch"
else
  if [[ "$TRAVIS_BRANCH" == "staging" ]]; then
   echo "Testing on staging branch"
  else
    echo "Testing on a branch other than master/staging. No deployment will be done."
    exit 0
  fi
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

echo "***********************************"
echo "*    Uploading To Crashlytics     *"
echo "***********************************"

if [[ "$TRAVIS_BRANCH" == "master" ]]; then
 Pods/Crashlytics/submit 0c31dbdd91674d7e38c2970702a8ed1296c2b427 60c8c37aabf092fb185bb414226b3c778eb2f32c630ce3584780de36c08014e5 -ipaPath "$OUTPUTDIR/$APP_NAME.ipa"
else
 Pods/Crashlytics/submit d1735a5902bb0852d662b1917c4f691cfc391c5c 2fa52a54d0c2cbf8b079374579123798cba998c9e2a441ba7e95b79c542d99ae -ipaPath "$OUTPUTDIR/$APP_NAME.ipa"
fi