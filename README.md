# Navigation Accessories
Customize your iOS app's navigation bar with SwiftUI.

## Wee Title

A small ("wee") title placed above the standard large navigation bar title.
This is seen in apps like Fitness for displaying the current date.

<img width="332" alt="Navigation Bar Wee Title" src="https://github.com/user-attachments/assets/80ce424c-3ebc-48b7-9342-563491935045">

### Usage
Parameters:
- `title`: The string to show as the navigation bar's wee title.

Example:
```swift
.navigationWeeTitle("Navigation")
```

## Large Title Accessory View

A view placed opposite the standard large navigation bar title serving as an accessory view.
It is commonly used as a button to show the user's profile.

<img width="332" alt="Large Title Accessory View" src="https://github.com/user-attachments/assets/2ebd1667-f4b8-4261-ab5c-37c9db90a7a0">

### Usage
Parameters:
- `alignsToBaseline`: A boolean value of whether the accessory view is aligned with the large title's baseline. The default is `true`.
- `content`: The view to show as the navigation bar's large title accessory view.

Example:
```swift
.navigationLargeTitleAccessoryView(alignsToBaseline: false) {
    Button("View Profile", systemImage: "person.crop.circle", action: showProfile)
        .font(.largeTitle)
        .labelStyle(.iconOnly)
}
```

## Bottom Palette

A view that is pinned below the standard navigation bar title. 
Some system apps use this space to place a picker view.

<img width="332" alt="Navigation Bar Bottom Palette" src="https://github.com/user-attachments/assets/bc7131ea-32a9-42a2-b15b-e48733276ba0">

### Usage
Parameters:
- `displaysWhenSearchActive`: A boolean value of whether the bottom palette is shown when the navigation bar's search field is focused. The default is `false`.
- `height`: The height of the bottom palette view. Pass `nil` to use the height of the content. The default is `nil`.
- `alignment`: An alignment descibing how the content is positioned within the bottom palette area.
- `content`: The view to show as the navigation bar's bottom palette.

Example:
```swift
.navigationBottomPalette(height: 44, alignment: .top) {
    Picker("Framework", selection: $selectedFramework) {
        ForEach(frameworks) { framework in
            Text(framework.name)
        }
    }
    .pickerStyle(.segmented)
    .safeAreaPadding(.horizontal)
}
```

## Title View

A title view in the navigation bar with a customizable height. 
The Messages app uses this to show a contact's profile picture and name.

<img width="332" alt="Title View" src="https://github.com/user-attachments/assets/76e647e7-71c9-4be6-84f8-f1ed5b8d57ce">

### Usage
Parameters:
- `hidesStandardTitle`: A boolean value of whether the navigation bar's standard title is hidden. The default is `false`.
- `height`: The height of the title view. Pass `nil` to use the height of the content. The default is `nil`.
- `alignment`: An alignment descibing how the content is positioned within the title view area.
- `content`: The view to show as the navigation bar's title view.

Example:
```swift
.navigationTitleView(hidesStandardTitle: true, height: 84) {
    VStack {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.secondary)

        Text("John Appleseed")
            .font(.caption)
    }
    .padding(10)
}
```

## How To Use

You can copy [NavigationAccessories.swift](NavigationAccessories.swift) into your project and start using the view modifiers straight away. Attach the modifiers to the content within a navigation structure, such as `NavigationStack` or `NavigationSplitView`. This would be where you normally place the `navigationTitle(_:)`.

**Important:** To activate the navigation accessories, you will need to append the `navigationAccessoriesTarget()` modifier to the end of the navigation content (the place to collect the previously declared accessories).

```swift
NavigationStack {
    List(0..<10) { i in
        Text("Row \(i)")
    }
    .navigationTitle("Navigation")
    .navigationWeeTitle(Date.now.formatted(.dateTime.day().month().weekday(.wide)))
    .navigationLargeTitleAccessoryView(alignsToBaseline: false) {
        Button(action: showProfile) {
            Image(profile.picture)
                .resizable()
                .scaledToFill()
                .frame(width: 34, height: 34)
                .clipShape(.circle)
        }
    }
    .navigationAccessoriesTarget()
}
```

\
\
**WARNING: This project makes use of Apple's PRIVATE navigation APIs. They are undocumented and may be changed or removed in the future. If you are going to use this in production, please take this into account. All strings (keys and class names) will likely need to be obfuscated.**
