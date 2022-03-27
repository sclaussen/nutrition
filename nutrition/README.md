# Features

## P1

- Factor views out of Name/Value
- Enable profile info to be retrieved from health kit or not (optional)
- Add health zones
- Do not allow the meat adjustment to be edited in the edit dialog, or, allow it but update profile
- Reset all (or one) bases to default amount (Reset single bases to default right right hand menu)
- Add vitamins/minerals
- Enable Caden profile (profiles in general)
- recursive deletes, primary/foreign key updates (eg ing.name)
- Custom tab bar
- Custom nav bar
- Allow meal ingredient update to hit return and go back to meal list
- Combine input fields into single view w/generics
- Use generics to combine Picker*Edit
- Geometry flexibility for different devices
- Hover effects
- Add brand information to ingredients, determine how to display (hover, et al)
- Dark mode support
- Capitalize each word of ingredients
- Custom keyboard to support negative numbers
  - https://developer.apple.com/documentation/uikit/keyboards_and_input/creating_a_custom_keyboard
- Rationalize why setNetCarbsMax works diff than setWeight/etc for Profile.swift
- Correct use case where you want to change 1 piece = 28g to 1 gram = 1gram
- Add new ingredient with auto-add options for also adding to adjustments/meals
  - Finished the UI, provide implementation


## P2

- Splash screen
- Remove 0s from int/double input fields
- Filter ingredients based on fat, carbs, protein, alpha, ..


## P3

- Add form/field validation
- Tuna freeze out dates
- Meat adjustments: Add delete capability (to both add/edit)
- Fix delete swipe action on lists
- Fix ing/adj so they don't serialize on each character typed
- Quick actions (icon menu)


## P4

- Fix all previews
- Disallow duplicate ingredients/base/adjustments
- DatePicker/Sheet https://github.com/shaotaoliu/SwiftUI.DatePickerTextField/tree/main/DatePickerTextField
- List/ForEach or just List(items, ...)?


## Future
- Logging
- export/import yaml/json


## Visual

- HStack(alignment: .bottom)?
- Use sheets for picks, date selection, et al
- Add No Item views
