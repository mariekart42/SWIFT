
import SwiftUI

struct ContentViewEx01: View
{
    let rows = 5
    let columns = 4
    let spacing: CGFloat = 15
    
    var body: some View
    {
        GeometryReader { proxy in
            VStack(spacing: spacing)
            {
                Spacer()
                HStack
                {
                    Spacer()
                    Text("999")
                        .font(Font.system(size: proxy.size.width/CGFloat(columns))) // Set the font size to 30 points
                        .fontWeight(.thin)
                        .minimumScaleFactor(0.5) // Adjust the minimum scale factor as needed
                        .lineLimit(1) // Limit the text to a single line
                        .frame(maxWidth: .infinity, alignment: .trailing) // Align the text to the right side
                        
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
    var foregroundColor: Color = .white
    var backgroundColor: Color = .gray
    var width: CGFloat
    
    var myAction: () -> Void
    
    var body: some View
    {
        Button(action: myAction)
        {
            Text(getTitle(currentRow: currentRow, currentColumn: currentColumn))
                .font(.title)
                .fontWeight(.medium)
                .frame(width: width)
                .frame(height: width)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
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
}

