CityShelf iOS
=============

## About
CityShelf iOS is a native iOS application that makes searching for books through local and independent booksellers quick and easy. You can find more information in the [service repo](https://github.com/ericqweinstein/quixote) and [web client repo](https://github.com/ericqweinstein/cityshelf).

## Running Locally
To get up and running, you'll need the following:

* XCode 6.3.2+
* Swift

By default, you'll be querying the production CityShelf search service; you can spin up your own local and point to that if you like. You'll need to [clone the service repo](https://github.com/ericqweinstein/quixote), start it up as per the README, and point your CityShelf iOS to localhost in `Settings.swift`.

## Installation
1. Clone the repository (`$ git clone git@github.com:ericqweinstein/cityshelf-ios.git`)
2. Optional: spin up a local CityShelf search service and point your `Settings.swift` there (see above)
3. Open, build, and run the application in XCode

## Contributing
1. Branch (`$ git checkout -b fancy-new-feature`)
2. Commit (`$ git commit -m "Fanciness!"`)
3. Run tests (Command-Shift-U in XCode)
4. Push (`$ git push origin fancy-new-feature`)
5. Ye Olde Pulle Request

## License
MIT (see LICENSE).
