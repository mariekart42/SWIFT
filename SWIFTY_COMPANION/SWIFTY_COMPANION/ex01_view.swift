
import SwiftUI

class ButtonData {
    var leftHandValue: String? = nil
    var rightHandValue: String? = nil
    var currentOperator: String? = nil
    var display: String = "0"
    var column: Int
    var row: Int

    init(row: Int = 0, column: Int = 0) {
        self.row = row
        self.column = column
    }
}


struct ContentViewEx01: View
{
    let rows = 5
    let columns = 4
    let spacing: CGFloat = 15
    let ButtonInstance = ButtonData()
    @State private var realDisplay: String = "0"
    
    var body: some View
    {
        GeometryReader { proxy in
            VStack(spacing: spacing)
            {
//                print("After initButton: \(ButtonInstance.display)")
                Spacer()
                HStack
                {
//                    let displayNow: String = realDisplay
                    Text(realDisplay)
                        .font(Font.system(size: proxy.size.width/CGFloat(columns)).weight(.thin)) // Set the font size to 30 points
                        .minimumScaleFactor(0.6) // Adjust the minimum scale factor as needed
                        .lineLimit(1) // everything will be dispalyed on 0ne line
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align the text to the right side
                        .multilineTextAlignment(.center) // Align the text to the center if resized
                        .onAppear
                        {
                            // TODO: here add later, if text is too big, dont change previuse text(only for typing numbers, not calculating and displayin!)
                            let textSize = ButtonInstance.display.size(withAttributes: [.font: UIFont.systemFont(ofSize: proxy.size.width / CGFloat(columns))])
                            let scaleFactor: CGFloat = proxy.size.width / (CGFloat(columns) * textSize.width)
                            
                            if scaleFactor < 0.6 {
                                print("Text is too big and is getting resized beyond the specified minimumScaleFactor.")
                            }
                        }
                }.padding(spacing) // distance between upper Spacer and buttons
                ForEach(0..<rows, id: \.self) { row in
                    HStack(spacing: spacing)
                    {
                        ForEach(0..<Int(columns), id: \.self) { column in
                            roundNumberButton(currentRow: row, currentColumn: column, width: getWidth(proxy: proxy), myAction: {
                                ButtonInstance.row = row
                                ButtonInstance.column = column
                                initButtonValues(instance: ButtonInstance, pressedButton: getValueAt(row: row, column: column))
                                realDisplay = ButtonInstance.display
                            })
                        }
                    }
                }
            }
        }.padding(spacing)// distance between screen edge and buttons
    }
    
    
    func getWidth(proxy: GeometryProxy) -> CGFloat {
        let columnsCGFloat: CGFloat = CGFloat(columns)
        return (UIScreen.main.bounds.width - (columnsCGFloat + 1) * spacing) / columnsCGFloat
    }
// end of struct
}



func buttonIsNumber(value: CGFloat) -> Bool {
    if value >= 0 && value <= 9 {
        return true // its a number
    }
    return false // if nil or not a number
}

func buttonIsOperator(value: String) -> Bool {
    
    if value == "÷" || value == "×" || value == "−" || value == "+" {
        return true
    }
    return false
}




struct roundNumberButton: View
{
    var currentRow: Int
    var currentColumn: Int
    var width: CGFloat
    
    var myAction: () -> Void
    
    var body: some View
    {
        Button(action: myAction)
        {
            Text(getValueAt(row: currentRow, column: currentColumn))
                .font(.largeTitle)
                .fontWeight(.regular)
                .frame(width: width)
                .frame(height: width)
                .foregroundColor(getForegroundColor(currentRow: currentRow, currentColumn: currentColumn))// here
                .background(getBackgroundColor(currentRow: currentRow, currentColumn: currentColumn))// and here
                .cornerRadius(width/2)
        }
    }
}
    

func getForegroundColor(currentRow: Int, currentColumn: Int) -> Color {
    if (currentRow == 0 && currentColumn != 3) {
        return .black
    } else {
        return .white
    }
}

func getBackgroundColor(currentRow: Int, currentColumn: Int) -> Color {
    if (currentRow == 0 && currentColumn != 3) {
        return Color(hex: "#b5b5b5") // light gray
    } else if (currentColumn == 3) {
        return Color(hex: "#fc9505") // orange
    } else {
        return Color(hex: "#333333") // dark gray
    }
}


// INIT THESE:
//    instance.display
//    instance.leftHandValue
//    instance.rightHandValue
//    instance.currentOperator
func initButtonValues(instance: ButtonData, pressedButton: String) -> Void {
    print("lol: \(instance.row) | \(instance.column)")
    
    let buttonValueCFFloat: CGFloat = myStoCGFloat(val: pressedButton)
    
    var tmpLeftHand: String = instance.leftHandValue ?? "0" // if leftHandValue is nil -> assigns it to "0"
    var tmpRightHand: String = instance.rightHandValue ?? "0" // if rightHandValue is nil -> assigns it to "0"

    if (pressedButton == "AC") {
        instance.currentOperator = nil
        instance.rightHandValue = nil
        instance.leftHandValue = nil
        instance.display = "0"
        return
    }
    else if (buttonIsNumber(value: buttonValueCFFloat))
    {
        if (instance.display == "0" && buttonValueCFFloat == 0)
        {
            instance.display = "0"
        }
        else if (instance.currentOperator == nil)
        {
            if (tmpLeftHand == "0")
            {
                instance.leftHandValue = pressedButton
                instance.display = pressedButton
                return
            }
            else
            {
                tmpLeftHand += pressedButton
                instance.leftHandValue = tmpLeftHand
                instance.display = tmpLeftHand
                return
            }
        }
        else if (instance.currentOperator != nil)
        {
            if (tmpRightHand == "0")
            {
                instance.rightHandValue = pressedButton
                instance.display = pressedButton
                return
            }
            else if (instance.rightHandValue != nil && instance.currentOperator != nil)
            {
                let result: CGFloat = getResult(leftHand: myStoCGFloat(val: tmpLeftHand), operatorString: pressedButton, rightHand: myStoCGFloat(val: tmpRightHand))
                instance.rightHandValue = nil
                instance.display = String(describing: result)
                instance.leftHandValue = String(describing: result)
                instance.currentOperator = nil
            }
            else
            {
                tmpRightHand += pressedButton
                instance.leftHandValue = tmpRightHand
                instance.display = tmpRightHand
                return
            }
        }
    } else if (buttonIsOperator(value: pressedButton)) {
//        if (instance.leftHandValue != nil)
//        {
//            //
//
//        }
        instance.currentOperator = pressedButton
    }
    
    
    
    
}




func getResult(leftHand: CGFloat, operatorString: String, rightHand: CGFloat) -> CGFloat {
    if (operatorString == "÷") {
        return leftHand / rightHand
    } else if (operatorString == "×") {
        return leftHand * rightHand
    } else if (operatorString == "−") {
        return leftHand - rightHand
    } else {
        return leftHand + rightHand
    }
}



//                                if (buttonIsNumber(value: cgFloatButtonValue)) {
//                                    if (currentOperator != nil) {
//                                        // we are d
//                                    }
//                                    if (cgFloatButtonValue == 0 && cgFloatResult == 0) {
//                                        print("i will do nothing lol")
//                                    } else if (cgFloatResult == 0) {
//                                        display = stringButtonValue
//                                        operationArray.removeAll()
//                                        operationArray.append(stringButtonValue)
//                                    } else {
//                                        display += stringButtonValue
//                                    }
//                                } else if (stringButtonValue == "AC") {
//                                    display = "0";
//                                    operationArray.removeAll()
//                                } else if (buttonIsOperator(value: stringButtonValue)) {
//                                    currentOperator = stringButtonValue
//                                } else {
//                                    print("not implemented yet")
//                                }


//                                let displayValueCGFloat: CGFloat = myStoCGFloat(result: ButtonInstance.display)
//                                let buttonValueString: String = getValueAt(row: row, column: column)
//                                let buttonValueCFFloat: CGFloat = myStoCGFloat(result: buttonValueString)
//
//                                if (buttonValueString == "AC") {
//                                    display = "0"
//                                    ButtonInstance.leftHandValue = nil
//                                    ButtonInstance.rightHandValue = nil
//                                    ButtonInstance.currentOperator = nil
//                                } else if (buttonIsNumber(value: buttonValueCFFloat)) {
//                                    display = getDisplayValue()
//                                    if (currentOperator == nil) {
//                                        ButtonInstance.rightHandValue = getRightHandValue()
//                                    } else {
//                                        leftHandValue = getLeftHandValue()
//                                    }
//                                    if (currentOperator == nil) {
//                                        if (displayValueCGFloat == 0 && buttonValueCFFloat == 0) {
//                                            display = "0"
