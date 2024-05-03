#!/bin/sh
echo "--------Deploy started--------"
echo "--------Removing old packages--------"
cd ../silver-api
rm -rf node_modules
echo "--------Old Packages removed--------"
echo "--------Installing new packages--------"
npm i --omit=dev
echo "--------New packages installed--------"
echo "--------Creating packages file--------"
tar -czvf node_modules.tgz node_modules
echo "--------File created. File name: node_modules.tgz--------"
cd ../silver-app
echo "--------Cleaning flutter environment--------"
flutter clean
echo "--------Cleaning old obfuscatad environment variables--------"
dart run build_runner clean
echo "--------Creating new obfuscatad environment variables--------"
dart run build_runner build --delete-conflicting-outputs
echo "--------Generating a release build web--------"
flutter build web
echo "--------Release build web created--------"
tar -czvf web.tgz build/web
echo "--------Generating a release build app--------"
flutter build appbundle --release
echo "--------Release build app created--------"
echo "--------Sending builds to Droplet--------"
echo "--------Sending Release build APP--------"
scp web.tgz <droplet ip:/folder>
cd ../silver-api
echo "--------Sending Release build API--------"
scp node_modules.tgz <droplet ip:/folder>
echo "--------Cleaning disk space--------"
echo "--------Cleaning API build--------"
rm -rf node_modules
rm node_modules.tgz
cd ../silver-app
rm web.tgz
echo "--------Cleaning APP build--------"
flutter clean
echo "--------Cleaning APP obfuscated environment variables--------"
dart run build_runner clean
echo "--------Cleaning completed--------"
echo "
----------------------------------------------------------------
-----------Successful deployment. Greetings, go rest!-----------
----------------------------------------------------------------
"