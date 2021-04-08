# WhoSings
![WhoSingsLogoSmall](https://user-images.githubusercontent.com/82147874/114013651-0c945300-9868-11eb-9b67-435ad95ec787.jpg)

WhoSings is an iOS GameApp created for the Musixmatch iOS Test 

## Installation
The only requirement to install the app is to use CocoaPods to install the 3 libraries I used.

```
pod install
```

## Libraries

For this project I wanted to keep the usage of libraries as low as possible so I chosen the 3 most useful ones for me:

### Alamofire

Alamofire is my favourite HTTP networking library you can check it here: https://github.com/Alamofire/Alamofire

### ObjectMapper

ObjectMapper is a useful tool for mapping JSON objects fast and easy: https://github.com/tristanhimmelman/ObjectMapper

### Realm

Realm allow to manage and store data on the fly like no other: https://github.com/realm/realm-cocoa

## Style, Icons & Logos

The simple style of the app was made with Sketch and iOS standards.
The 2 icons used in the app are from:
- [user.pdf](https://github.com/Jukemberg/who-sings/files/6278052/user.pdf) Icon made by PixelPerfect from www.flaticon.com
- [MXM-Mark.pdf](https://github.com/Jukemberg/who-sings/files/6278062/MXM-Mark.pdf) Logo mark of Musixmatch from https://about.musixmatch.com/brand-resources

App logo is born from an idea at the end of the project I hope you'll like it!

## Customizations

In the info.plist file I have added the possibilty to customize your gameplay 

### Game Variables

- QUIZ_QUESTIONS (default 10): Determines the amount of questions for each quiz
- QUIZ_TIMER (default 12): Determines the amount of time a player has to answer a question

### Track Filters

- CHART_COUNTRY (default "us"): Determines the chart country
- CHART_NAME (default "top"): Determines the type of chart, possible options:
    + top : editorial chart
    + hot : Most viewed lyrics in the last 2 hours
    + mxmweekly : Most viewed lyrics in the last 7 days
    + mxmweekly_new : Most viewed lyrics in the last 7 days limited to new releases

# Have fun! 
