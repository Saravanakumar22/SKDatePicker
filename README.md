# SKDatePicker

Present Date picker like action sheet
```swift
let datePicker = DatePickerSheet(dateMode: .date)
datePicker.show()
datePicker.dateAction = { date in
      print("Date: \(date)")
}
```
