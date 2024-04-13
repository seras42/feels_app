# feels_app

A feeling app for feelers. Log your emotions in an encrypted diary. See statistics of your feelings. You have an option to encrypt the data with or without password. The app is intended to be used as a diary.

ANDROID https://f-droid.org/packages/com.feels.feelingsApp.feels_app/

Specifics:

App uses [sqflite_sqlcipher](https://pub.dev/packages/sqflite_sqlcipher) for creating, managing and encrypting a SQL database where all of the notes are stored. If the user decides to not use a password, random password will be generated and stored using [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage), this allows the data to still be encrypted when the app is not used. The statistics uses an implementation of [fl_chart. ](https://pub.dev/packages/fl_chart)


![1](https://github.com/seras42/feels_app/assets/109229384/c3d3f7ad-7439-4706-8414-7a411a1c589c) | ![2](https://github.com/seras42/feels_app/assets/109229384/3254f267-2e14-4f2d-bba3-e5f11bc640ac)
![3](https://github.com/seras42/feels_app/assets/109229384/428783c7-3df6-4b6f-8a1f-fe5b09ef0d63) | ![4](https://github.com/seras42/feels_app/assets/109229384/380bb6c9-2e12-4366-8fae-44e0c3c7ece0)
![5](https://github.com/seras42/feels_app/assets/109229384/2f5f209a-f627-43f3-ac36-a20bdf7a6443)
