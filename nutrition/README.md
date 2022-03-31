# Features

## P0

- Add form/field validation
- Meat meal adjustments: Add delete capability (to both add/edit)
- Fix issue wrt what meal adjustments are shown in IngredientAdd
- BUG: Fix ing/adj so they don't serialize on each character typed
- BUG: profile change value, then cancel, value remains...  valueString "feature"
  - Numbers Only
    https://programmingwithswift.com/numbers-only-textfield-with-swiftui/



## P1

- Enable Caden profile (profiles in general)
- BUG: onDelete brings up swipe menu now vs deleting, dig into why
- Next/Next/Next field ...
- Collapsible: https://betterprogramming.pub/how-to-write-a-collapsible-expandable-view-for-your-swiftui-app-d4a47fe8cb52
- Cloud Kit Extending/Collaboration:
  - https://swiftwithmajid.com/2022/03/29/zone-sharing-in-cloudkit
  - https://swiftwithmajid.com/2022/03/22/getting-started-with-cloudkit
- Consider changing consumption unit to preparation unit
- Re-add the grams/100 to the IngredientEdit view
- Variable picker style type
- Add health zones
- Allow meal ingredient update to hit return and go back to meal list
- Rationalize why setNetCarbsMax works diff than setWeight/etc for Profile.swift
- Enable profile info to be retrieved from health kit or not (optional)
- Reset all (or one) bases to default amount (Reset single bases to default right right hand menu)
- Populate brands
- Display brand on hover?
- Add $/gram
- Add vitamins/minerals
- Custom tab bar
- Custom nav bar
- Hover effects
- Capitalize each word of ingredients
- Custom keyboard to support negative numbers
  - https://developer.apple.com/documentation/uikit/keyboards_and_input/creating_a_custom_keyboard
- Add new ingredient with auto-add options for also adding to adjustments/meals
  - Finished the UI, provide implementation
- Alternative BMR:
  Harris-Benedict               if(Sex="Male", 66+(6.2*Weight)+(12.7*Height)-(6.76*Age), 655+(4.35*Weight)+(4.7*Height)-(4.7*Age))
  Harris-Benedict-Revised       =if(Sex="Male", (88.362 + (13.397 * WeightKG) + (4.799 * HeightCM) - (5.677 * Age)), 447.593 + (9.247 * WeightKG) + (3.098 * Height) - (4.33 * Age))
  Katch-McArdle                 =370+(21.6*LeanBodyMassKG)
  Cunningham                    =500+(22*LeanBodyMassKG)
- Ingredient URLs
  Link(destination: URL(string: "https://www.apple.com")!) {
    Image(systemName: "link.circle.fill")
        .font(.largeTitle)
}
https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-shake-gestures

## P2

- Make progressbar generic
- Fix date picker so it sizes properly
- Splash screen
- Remove 0s from int/double input fields
- Filter ingredients based on fat, carbs, protein, alpha, ..


## P3

- Tuna freeze out dates
- Fix delete swipe action on lists
- Quick actions (icon menu)


## P4

- Fix all previews
- DatePicker/Sheet https://github.com/shaotaoliu/SwiftUI.DatePickerTextField/tree/main/DatePickerTextField
- Add No Item views
- Logging
- export/import yaml/json
