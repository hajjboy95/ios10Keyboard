# iOS10Keyboard
iOS keyboard for tableView or UIViews Storyboard implementation

![alt tag](Swift3_tableviewcontroller/Screenshots/demoiOS10MessageAccessoryView.gif)

## How to Use IEHKeyboard

### Copy the 2 sources files into your project (Cocoapod coming soon)
![alt tag](Swift3_tableviewcontroller/Screenshots/1.png)

![alt tag](Swift3_tableviewcontroller/Screenshots/2.png)

### Add a tableview into your view controller and set the class to IEHTableView (if your adding the functionality to a UIView just replace IEHTableView to IEHView )
![alt tag](Swift3_tableviewcontroller/Screenshots/3.png)

![alt tag](Swift3_tableviewcontroller/Screenshots/4.png)

### Add tableView as an outlet to your view controller 

![alt tag](Swift3_tableviewcontroller/Screenshots/5.png)

### Create a prototype cell and give it an identifier
![alt tag](Swift3_tableviewcontroller/Screenshots/6.png)

![alt tag](Swift3_tableviewcontroller/Screenshots/7.png)


### To get the final text before the send button is tapped
 
  1 - set self as the delegate of the keyboardBar in the viewDidLoad()
  ```tableView.keyboardBar.iehKeyboardDelegate = self```
  
  2 - conform to the IEHKeyboardBarProtocol 
  ```class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, IEHKeyboardBarProtocol {```
  
  3 - conform to the IEHKeyboardBarProtocol method ``` func iehKeyboardFinishing(text: String)  ```

Your good to go



