
import SwiftUI

struct ContentViewEx01: View
{
    let rows = 5
    let columns = 4
    let spacing: CGFloat = 15
    
    @State private var display = "0"
    @State private var scaleFactor: CGFloat = 1.0
    @State private var currentOperator: String? // means can be nil
    @State var operationArray: [String]
    
    var body: some View
    {
        GeometryReader { proxy in
            VStack(spacing: spacing)
            {
                Spacer()
                HStack
                {
                    Text(display)
                        .font(Font.system(size: proxy.size.width/CGFloat(columns)).weight(.thin)) // Set the font size to 30 points
                        .minimumScaleFactor(0.6) // Adjust the minimum scale factor as needed
                        .lineLimit(1) // everything will be dispalyed on 0ne line
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align the text to the right side
                        .multilineTextAlignment(.center) // Align the text to the center if resized
                        .onAppear
                        {
                            // TODO: here add later, if text is too big, dont change previuse text(only for typing numbers, not calculating and displayin!)
                            let textSize = display.size(withAttributes: [.font: UIFont.systemFont(ofSize: proxy.size.width / CGFloat(columns))])
                            scaleFactor = proxy.size.width / (CGFloat(columns) * textSize.width)
                            
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
                                // action
                                
                                let cgFloatResult: CGFloat = myStoCGFloat(result: display)
                                let stringButtonValue: String = getValueAt(row: row, column: column)
                                let cgFloatButtonValue: CGFloat = myStoCGFloat(result: stringButtonValue)

                                if (buttonIsNumber(value: cgFloatButtonValue)) {
                                    if (currentOperator != nil) {
                                        // we are d
                                    }
                                    if (cgFloatButtonValue == 0 && cgFloatResult == 0) {
                                        print("i will do nothing lol")
                                    } else if (cgFloatResult == 0) {
                                        display = stringButtonValue
                                        operationArray.removeAll()
                                        operationArray.append(stringButtonValue)
                                    } else {
                                        display += stringButtonValue
                                    }
                                } else if (stringButtonValue == "AC") {
                                    display = "0";
                                    operationArray.removeAll()
                                } else if (buttonIsOperator(value: stringButtonValue)) {
                                    currentOperator = stringButtonValue
                                } else {
                                    print("not implemented yet")
                                }
                            })
                        }
                    }
                }
            }
        }.padding(spacing)// distance between screen edge and buttons
    }

    
    func buttonIsOperator(value: String) -> Bool {
        if value == "÷" || value == "×" || value == "−" || value == "+" {
            return true
        }
        return false
    }
    
    func buttonIsNumber(value: CGFloat) -> Bool {
        if value >= 0 && value <= 9 {
            return true // its a number
        }
        return false // if nil or not a number
    }
    
    func getWidth(proxy: GeometryProxy) -> CGFloat {
        let typecastColumns: CGFloat = CGFloat(columns)
        
        return (proxy.size.width/typecastColumns)-spacing*0.75
    }
// end of struct
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

