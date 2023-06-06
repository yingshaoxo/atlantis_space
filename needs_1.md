# Needs 1

* If the android version is lower or equal to 9, we suggest it to install virtual_xposed (We bind virtual_xposed as an built-in apk file)
* We release those apks we have under download folder as `Downloads/atlantis/apk/*`, we use code to open that folder
* In our UI, we have a tab where has all built-in apps. At the top, has an button called 'Install APKs Manually', when user click it, we show a window says "We will open ~/Downloads/atlantis/apk folder, you can install app manually from there.", then we open that folder.

# Needs 2
Due to google play store refuse the permission request of `REQUEST_INSTALL_PACKAGES`

We have to use flutter to create another app that simply mimic the old UI, and allow user to backup their apk/installed app to our folder

So we can write them out when needed.

We show those backup apk files as app rows. (get apk icon does not need that permission)

Then we could say 'Due to google play harsh restriction on some permissions, this is just a simplyed version of our app, you can install "atlantis_space full version" to get full feature unlocked.'

We have the full_version apk built_in.