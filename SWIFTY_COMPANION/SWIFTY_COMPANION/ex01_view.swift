
import SwiftUI

struct ContentViewEx01: View
{
    let rows = 5
    let columns = 4
    let spacing: CGFloat = 15
    
    @State private var text = "999.999.9999"
    @State private var scaleFactor: CGFloat = 1.0
    
    var body: some View
    {
        GeometryReader { proxy in
            VStack(spacing: spacing)
            {
                Spacer()
                HStack
                {
                    Text(text)
                        .font(Font.system(size: proxy.size.width/CGFloat(columns)).weight(.thin)) // Set the font size to 30 points
                        .minimumScaleFactor(0.6) // Adjust the minimum scale factor as needed
                        .lineLimit(1) // everything will be dispalyed on 0ne line
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align the text to the right side
                        .multilineTextAlignment(.center) // Align the text to the center if resized
                        .onAppear
                        {
                            // TODO: here add later, if text is too big, dont change previuse text(only for typing numbers, not calculating and displayin!)
                            let textSize = text.size(withAttributes: [.font: UIFont.systemFont(ofSize: proxy.size.width / CGFloat(columns))])
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
                                print("Row: \(row), Column: \(column)")
                            })
                        }
                    }
                }
            }
        }.padding(spacing)// distance between screen edge and buttons
    }

    func getWidth(proxy: GeometryProxy) -> CGFloat {
        let typecastColumns: CGFloat = CGFloat(columns)
        
        return (proxy.size.width/typecastColumns)-spacing*0.75
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
            Text(getTitle(currentRow: currentRow, currentColumn: currentColumn))
                .font(.largeTitle)
                .fontWeight(.regular)
                .frame(width: width)
                .frame(height: width)
                .foregroundColor(getForegroundColor(currentRow: currentRow, currentColumn: currentColumn))// here
                .background(getBackgroundColor(currentRow: currentRow, currentColumn: currentColumn))// and here
                .cornerRadius(width/2)
        }
    }
    
    func getTitle(currentRow: Int, currentColumn: Int) -> String {
        switch currentRow {
        case 0:
            switch currentColumn {
            case 0:
                return "AC"
            case 1:
                return "💀" // dis +/- sign
            case 2:
                return "💀" // dis % sign
            case 3:
                return "÷"
            default:
                return "lol"
            }
        case 1:
            switch currentColumn {
            case 0:
                return "7"
            case 1:
                return "8"
            case 2:
                return "9"
            case 3:
                return "×"
            default:
                return "lol"
            }
        case 2:
            switch currentColumn {
            case 0:
                return "4"
            case 1:
                return "5"
            case 2:
                return "6"
            case 3:
                return "−"
            default:
                return "lol"
            }
        case 3:
            switch currentColumn {
            case 0:
                return "1"
            case 1:
                return "2"
            case 2:
                return "3"
            case 3:
                return "+"
            default:
                return "lol"
            }
        case 4:
            switch currentColumn {
            case 0:
                return "0"
            case 1:
                return "0"
            case 2:
                return ","
            case 3:
                return "="
            default:
                return "lol"
            }
        default:
            return "lol"
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
}

