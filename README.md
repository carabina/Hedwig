# Hedwig

![Hello from Hedwig](https://github.com/Lab111/Hedwig/blob/master/Assets/hello.gif)

Hedwig shows notification and enables users to handle it.

Hedwig (d. 27 July, 1997) was Harry Potter's pet Snowy Owl. For more information, see [Hedwig | Harry Potter Wiki](http://harrypotter.wikia.com/wiki/Hedwig).

Instead of just showing notification, Hedwig tries to be interactive. When a notification pops up, it will be more efficient and user-friendly if the user is able to handle it directly, especially for sophisticated applications like Facebook. Hedwig currently has a tap gesture recognizer so that you can handle the notification by adding an action to it. You can also customize it by adding views and gesture recognizers to satisfy your needs. Although it seems quite simple at the time, the concept behind is more important, and there are a lot Hedwig can develop in the future for better interaction.

- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [License](#license)

## Installation

### [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)

- Create a [Podfile](https://guides.cocoapods.org/using/the-podfile.html), and add Hedwig:

```
target '<Your Project Name>' do
    pod 'Hedwig', '~> 1.0'
end
```

- Run `$ pod install` in your project directory.
- Open `Project.xcworkspace` and build.

### [Carthage](https://github.com/Carthage/Carthage#installing-carthage)

- Create a [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile), and add Hedwig:

```
github "Lab111/Hedwig" ~> 1.0
```

- Run `carthage update` in your project directory.
- Drag `Hedwig.framework` from `Carthage/Build` into your Xcode project.

## Configuration

Hedwig works as a singleton, so you talk to `shared` directly to configure it. Some common configurations are listed below:

- Height: `Hedwig.shared.height`
- Background Color: `Hedwig.shared.windowShade.backgroundColor`
- Text Color: `Hedwig.shared.label.textColor`
- Font: `Hedwig.shared.label.font`
- Slide Duration: `Hedwig.shared.windowShade.slideDuration`
- Display Duration: `Hedwig.shared.displayDuration`

## Usage

### Show Notification

```swift
import Hedwig

Hedwig.show(notification: "Hello from Hedwig")
```

You can add action to the `tapGestureRecognizer` when asking Hedwig to show notification.

```swift
Hedwig.show(notification: "Hello from Hedwig", handler: { (_) in
    print("Tap")
}, completion: nil)
```

### Hide Notification

```swift
Hedwig.hide()
```

Hedwig will hide automatically if the `displayDuration` is positive, but you can hide it manually before it hides automatically. Be aware that Hedwig will hide the notification when the user swipes up over it.

## License

Hedwig is released under the MIT license. For details, see [LICENSE](https://github.com/Lab111/Hedwig/blob/master/LICENSE).
