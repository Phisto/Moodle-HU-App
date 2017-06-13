# Important

This application is not an official app. 
**It is NOT supported, maintained or otherwise associated with the 'Humboldt-Universität zu Berlin' or Moodle Pty Ltd.**

**Do not contact their support for help.**

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## Overview

I wrote this app to access a user account on the Moodle™ instance of the 'Humboldt-Universität zu Berlin'.

## Accessiblity

I have given much attention to support VoiceOver properly. 
I don't have feedback regarding the VoiceOver behavior of the app, 
so I dont know if it fits the need of users who utilize this technologie.

### Screenshots

Login                      |  My Courses
:-------------------------:|:-------------------------:
![](http://simonsapps.de/hu_moodle_screenshots/login.png)  |  ![](http://simonsapps.de/hu_moodle_screenshots/kurse.png)


Course Detail              |  Course Section
:-------------------------:|:-------------------------:
![](http://simonsapps.de/hu_moodle_screenshots/kurs_detail.png)  |  ![](http://simonsapps.de/hu_moodle_screenshots/kurs_sektion.png)

Document                   |  Course Search
:-------------------------:|:-------------------------:
![](http://simonsapps.de/hu_moodle_screenshots/dokument.png)  |  ![](http://simonsapps.de/hu_moodle_screenshots/suche.png)


## Install

1. Install [Xcode](https://developer.apple.com/xcode/)
1. Download the source code or `git clone https://github.com/Phisto/Moodle-HU-App.git`
1. Open "Moodle.xcodeproj" in Xcode
1. Go to Xcode's Preferences > Accounts and add your Apple ID
1. In Xcode's sidebar select "Moodle" and go to General > Identity. Append a word at the end of the *Bundle Identifier* e.g. de.simonsserver.Moodle*.name* so it's unique. Select your Apple ID in Signing > Team
1. Connect your iPhone using USB and select it in Xcode's Product menu > Destination
1. Press CMD+R or Product > Run to install the HU-Moodle app
1. If you install using a free (non-developer) account, make sure to rebuild Dash every 7 days, otherwise it will quit at launch when your certificate expires

## Device Compatibility

* iPhone: iPhone 4s and above

* iPad: The iPad is not tested and optimized so far, in the simulator the iPad Air, Air 2 and Pro do work well.

* OS: iOS 9.3 and above

## Credits

#### Icons

* App icon and banner based on logo from the [HU website](https://www.hu-berlin.de/de/hu-intern/design/downloads/logo).

* Checkmark icon made by [Catalin Fertu](http://www.flaticon.com/authors/catalin-fertu) from [flaticon](www.flaticon.com).

* Document icons, favorit and folder icon made by [Madebyoliver](http://www.flaticon.com/authors/madebyoliver) from [flaticon](www.flaticon.com).

* 'My Courses' icon made by [Stationery](http://www.flaticon.com/packs/stationery) from [flaticon](www.flaticon.com).

* Forum icon made by [Vectors Market](http://www.flaticon.com/authors/vectors-market) from [flaticon](www.flaticon.com).

#### Frameworks

* KeychainWrapper created by Tim Mitra. Source: https://developer.apple.com/library/content/documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html

* Hpple created by Geoffrey Grosenbach. Source: https://github.com/topfunky/hpple


## License

The app is released under the GNU General Public License (GPL). 

See <http://www.gnu.org/licenses/> for details.

## Trademark

The word Moodle™ is a registered trademark. 

See: https://docs.moodle.org/dev/License
