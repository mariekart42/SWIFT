
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
		Color.black // Sets the background color to black
			.edgesIgnoringSafeArea(.all)
			.overlay(
				
			GeometryReader { proxy in
				VStack(spacing: spacing)
				{
					Text("Marie's Calculator lol")
						.foregroundColor(Color(hex: "#a3d1ff"))
					Spacer()
					HStack
					{
						Text(getDispalyText(display: realDisplay))
							.font(Font.system(size: proxy.size.width/CGFloat(columns)).weight(.thin))
							.minimumScaleFactor(0.6) // Adjust the minimum scale factor as needed
							.lineLimit(1) // everything will be dispalyed on 0ne line
							.frame(maxWidth: .infinity, alignment: .trailing) // Align the text to the right side
							.multilineTextAlignment(.center) // Align the text to the center if resized
							.foregroundColor(.white)
							.onAppear
						{
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
								if ((row == 0 || row == 4) && column != 3) {
									if (column == 0) {
										longRoundButton(row: row, column: column, width: getWidth(proxy: proxy)*3+(2*spacing), height: getWidth(proxy: proxy), myAction: {
											ButtonInstance.row = row
											ButtonInstance.column = column
											initButtonValues(instance: ButtonInstance, pressedButton: getValueAt(row: row, column: column))
											realDisplay = ButtonInstance.display
										})
									}
								} else {
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
				}
			}.padding(spacing)// distance between screen edge and buttons
		)
    }
		
    
    func getWidth(proxy: GeometryProxy) -> CGFloat {
        let columnsCGFloat: CGFloat = CGFloat(columns)
        return (UIScreen.main.bounds.width - (columnsCGFloat + 1) * spacing) / columnsCGFloat
    }

    func getDispalyText(display: String) -> String {
        let displayCGFloat = myStoCGFloat(val: display)
        
        if displayCGFloat.truncatingRemainder(dividingBy: 1) == 0 {
            // The CGFloat has no fractional part and can be converted to Int
            if let intValue = Int(exactly: displayCGFloat) {
                return String(describing: intValue)
            }
        }
        return display
    }
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

struct longRoundButton: View {
    var row: Int
    var column: Int
    var width: CGFloat
    var height: CGFloat
    var myAction: () -> Void
    
    var body: some View
    {
        Button(action: myAction)
        {
            Text(getValueAt(row: row, column: column))
                .font(.largeTitle)
                .fontWeight(.regular)
                .frame(width: width)
                .frame(height: height)
                .foregroundColor(getForegroundColor(currentRow: row, currentColumn: column))
                .background(getBackgroundColor(currentRow: row, currentColumn: column))// and here
                .cornerRadius(width/2)
        }
    }
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
                .foregroundColor(getForegroundColor(currentRow: currentRow, currentColumn: currentColumn))
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


func initButtonValues(instance: ButtonData, pressedButton: String) -> Void {
    let buttonValueCFFloat: CGFloat = myStoCGFloat(val: pressedButton)
    
    var tmpLeftHand: String = instance.leftHandValue ?? "0" // if leftHandValue is nil -> assigns it to "0"
    var tmpRightHand: String = instance.rightHandValue ?? "0" // if rightHandValue is nil -> assigns it to "0"

    if (pressedButton == "AC") {
        instance.currentOperator = nil
        instance.rightHandValue = nil
        instance.leftHandValue = nil
        instance.display = "0"
        return
    } else if (buttonIsNumber(value: buttonValueCFFloat)) {
        if (instance.display == "0" && buttonValueCFFloat == 0) {
            instance.display = "0"
            return
        } else if (instance.currentOperator == nil) { // writing to leftHand value
            if (tmpLeftHand == "0") {
                instance.leftHandValue = pressedButton
                instance.display = pressedButton
                return
            } else {
                tmpLeftHand += pressedButton
                instance.leftHandValue = tmpLeftHand
                instance.display = tmpLeftHand
                return
            }
        } else if (instance.currentOperator != nil) { // writing to rightHand value
            if (tmpRightHand == "0") {
                instance.rightHandValue = pressedButton
                instance.display = pressedButton
                return
            } else {
                tmpRightHand += pressedButton
                instance.rightHandValue = tmpRightHand
                instance.display = tmpRightHand
                return
            }
        }
    } else if (buttonIsOperator(value: pressedButton)) {
        instance.currentOperator = pressedButton
    } else if (pressedButton == "=") {
        let unwrapedOperator: String = instance.currentOperator ?? "0"
        let result: CGFloat = getResult(leftHand: myStoCGFloat(val: tmpLeftHand), operatorString: unwrapedOperator, rightHand: myStoCGFloat(val: tmpRightHand))
        instance.rightHandValue = nil
        instance.display = String(describing: result)
        instance.leftHandValue = String(describing: result)
        instance.currentOperator = nil
        return
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
