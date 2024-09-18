//
//  ContentView.swift
//  MultiplicationDungeon
//
//  Created by Izabela Marcinkowska on 2024-09-17.
//

import SwiftUI


struct ContentView: View {
    @State private var wishedAmountQuestions = 5
    @State private var wishedLevel = 5
    @State private var questions = [String]()
    @State private var currentQuestion = 0
    var body: some View {
        VStack {
            Form {
                Picker("Amount questions", selection: $wishedAmountQuestions) {
                    ForEach(1..<20, id: \.self) { num in
                        Text("\(num) questions").tag(num)
                    }
                }
                Stepper("Table up to \(wishedLevel)", value: $wishedLevel, in: 2...12)
            }
            
            Text(questions.isEmpty ? "Question" : "\(questions[currentQuestion])")
            Button ("Next Question") {
                currentQuestion += 1
            }
            
            Button ("Click here") {
                createQuestions(AmountQuestions: wishedAmountQuestions, level: wishedLevel)
            }
            
        }
    }
    
    func createQuestions (AmountQuestions: Int, level: Int) -> Void {
        questions = []
        for _ in 0...AmountQuestions {
            let firstNumber = Int.random(in: 1...wishedLevel)
            let secondNumber = Int.random(in: 1...wishedLevel)
            
            let question = "\(firstNumber) * \(secondNumber)"
            let answer = firstNumber * secondNumber
            
            print(firstNumber, secondNumber, answer)
            questions.append(question)
        }
        questions.forEach { question in
                print(question)
            }
    }
    
    
}



#Preview {
    ContentView()
}
