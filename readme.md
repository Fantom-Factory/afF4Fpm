# F4 Features
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom-lang.org/)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

F4 Features currently boasts support for:

 - [Fantom Pod Manager](http://eggbox.fantomfactory.org/pods/afFpm/)


 
## Installation

To install F4 Features, download the latest `.zip` from the [F4 Features Downloads Page](downloads).

From within F4 visit the main menu and click `Help -> Install new software...` Drag and drop the downloaded .zip file into the dialogue window.

To see 'F4 Add-Ons' you may need to de-select `Group items by category` as shown below.

![Installing F4 Features]()

Click `next` and follow on screen instructions.



## Fantom Pod Manager

The Fantom Pod Manager feature adds support for using an [Fantom Pod Manager](http://eggbox.fantomfactory.org/pods/afFpm/) Environment within F4.

After installing you should be able to select `FpmEnv` from the standard Fantom Env preferences dialogue.

![Fantom Env Dialogue]()

A project that uses `FpmEnv` will resolve all its dependencies via the usual FPM means of `fpm.props` files. F4 will use the project's Fantom interpreter and imported environment variables (`PATH_ENV`) to find the `fpm.props` files.

On a successful build, pods may be optionally published to a named repository.

Note that if a dependent project is open in F4, it will be used as a dependency regardless of version.
