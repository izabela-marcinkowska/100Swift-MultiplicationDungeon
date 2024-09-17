//
//  ContentView.swift
//  MultiplicationDungeon
//
//  Created by Izabela Marcinkowska on 2024-09-17.
//

import SwiftUI


struct ContentView: View {
    @State private var wishedAmountQuestions = 10
    @State private var wishedLevel = 5
    @State private var questions = [Int]()
    var body: some View {
        VStack {
            Button ("Click here") {
                createQuestions(AmountQuestions: wishedAmountQuestions, level: wishedLevel)
            }
            List {
                Section("Section 2") {
                    ForEach(questions, id: \.self) {
                        Text("Dynamic row \($0)")
                    }
                }
                
                
            }
        }
    }
    
    func createQuestions (AmountQuestions: Int, level: Int) -> Void {
        for _ in 1...AmountQuestions {
            let firstNumber = Int.random(in: 1...wishedLevel)
            let secondNumber = Int.random(in: 1...wishedLevel)
            let result = firstNumber * secondNumber
            print(firstNumber, secondNumber, result)
            questions.append(result)
        }
    }
}



#Preview {
    ContentView()
}
