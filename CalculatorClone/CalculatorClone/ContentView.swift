//
//  ContentView.swift
//  CalculatorClone
//
//  Created by 유빈 on 2023/05/31.
//

import SwiftUI

enum ButtonType: String {
    case first, second, third, forth, fifth, sixth, seventh, eighth, nineth, zero
    case dot, equal, plus, minus, multiple, divide
    case percent, opposite, clear
    
    var buttonDisplayName: String {
        switch self {
        case .first :
            return "1"
        case .second :
            return "2"
        case .third :
            return "3"
        case .forth :
            return "4"
        case .fifth :
            return "5"
        case .sixth :
            return "6"
        case .seventh :
            return "7"
        case .eighth :
            return "8"
        case .nineth :
            return "9"
        case .zero :
            return "0"
        case .dot :
            return "."
        case .equal :
            return "="
        case .plus :
            return "+"
        case .minus :
            return "-"
        case .multiple :
            return "X"
        case .divide :
            return "÷"
        case .percent :
            return "%"
        case .opposite :
            return "+/-"
        case .clear :
            return "AC"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .first, .second, .third, .forth, .fifth, .sixth, .seventh, .eighth, .nineth, .zero, .dot:
            return Color("NumberButton")
        case .equal, .plus, .minus, .multiple, .divide :
            return Color.orange
        case .percent, .opposite, .clear:
            return Color.gray
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .first, .second, .third, .forth, .fifth, .sixth, .seventh, .eighth, .nineth, .zero, .dot, .equal, .plus, .minus, .multiple, .divide:
            return Color.white
        case .percent, .opposite, .clear:
            return Color.black
        }
    }
}

struct ContentView: View {
    
    //temp와 total의 이름과 역할이 바뀜
    @State private var totalNumber: String = "0"
    @State var tempNumber: Double = 0.0
    @State var operatorType: ButtonType = .clear
    @State var isNotEditing: Bool = true
    
    func integerCheck() {
        let isWholeNumber = (totalNumber).contains(".") && totalNumber.hasSuffix("0")
        
        if isWholeNumber {
            totalNumber = String(totalNumber.dropLast(2))
            // Remove last two characters ("." and "0")
        }
    }
    
    private let buttonData: [[ButtonType]] = [
        [.clear, .opposite, .percent, .divide],
        [.seventh, .eighth, .nineth, .multiple],
        [.forth, .fifth, .sixth, .minus],
        [.first, .second, .third, .plus],
        [.zero, .dot, .equal]
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                
                Spacer()
                HStack {
                    Spacer()
                    Text(totalNumber)
                        .padding()
                        .foregroundColor(.white)
                        .font(.system(size: 72))
                        .minimumScaleFactor(0.8)
                        .frame(height: 120)
                }
                
                ForEach(buttonData, id: \.self) { line in
                    HStack {
                        ForEach(line, id: \.self) { item in
                            Button{
                                
                                if item == .clear {
                                    totalNumber = "0"
                                } else if item == .plus {
                                    tempNumber = Double(totalNumber) ?? 0.0
                                    operatorType = .plus
                                    totalNumber = "0"
                                } else if item == .multiple {
                                    tempNumber = Double(totalNumber) ?? 0.0
                                    operatorType = .multiple
                                    totalNumber = "0"
                                } else if item == .minus {
                                    tempNumber = Double(totalNumber) ?? 0.0
                                    operatorType = .minus
                                    totalNumber = "0"
                                } else if item == .divide {
                                    tempNumber = Double(totalNumber) ?? 0.0
                                    operatorType = .divide
                                    totalNumber = "0"
                                } else if item == .dot {
                                    if !totalNumber.contains(".") {
                                        totalNumber += "."
                                    }
                                } else if item == .percent {
                                    totalNumber = String((Double(totalNumber) ?? 0.0) / 100)
                                    integerCheck()
                                } else if item == .opposite {
                                    totalNumber = String(-(Double(totalNumber) ?? 0.0))
                                    integerCheck()
                                } else if item == .equal {
                                    
                                    //print(totalNumber)
                                    //print(tempNumber)
                                    
                                    if operatorType == .plus {
                                        totalNumber = String(Double(totalNumber) ?? 0.0 + tempNumber)
                                    } else if operatorType == .multiple {
                                        totalNumber = String((Double(totalNumber) ?? 0.0) * tempNumber)
                                    } else if operatorType == .minus {
                                        totalNumber = String(tempNumber - (Double(totalNumber) ?? 0.0))
                                    } else if operatorType == .divide {
                                        totalNumber = (Int(totalNumber) == 0) ? "오류" : String(tempNumber / (Double(totalNumber) ?? 0.0))
                                        //삼항연산자-나누기 0이 참일 경우 오류 메세지 출력, 거짓이면 나눗셈 진행
                                    }

                                    integerCheck()
                                    
                                } else {
                                    if totalNumber == "0" {
                                        totalNumber = item.buttonDisplayName
                                    } else {
                                        totalNumber += item.buttonDisplayName
                                    }
                                }
                            } label: {
                                Text(item.buttonDisplayName)
                                    .bold()
                                    .frame(width: calculateButtonWidth(button: item), height: calculateButtonHeight(button: item))
                                    .background(item.backgroundColor)
                                    .cornerRadius(40)
                                    .foregroundColor(item.foregroundColor)
                                    .font(.system(size: 32))
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func calculateButtonWidth(button buttonType: ButtonType) -> CGFloat {
        switch buttonType {
        case .zero:
            //(전체너비 - 5*10)/4
            return (UIScreen.main.bounds.width - 5*10) / 4 * 2
        default:
            return((UIScreen.main.bounds.width - 5*10) / 4)
        }
    }
    
    private func calculateButtonHeight(button: ButtonType) -> CGFloat{
        return (UIScreen.main.bounds.width - 5*10) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
