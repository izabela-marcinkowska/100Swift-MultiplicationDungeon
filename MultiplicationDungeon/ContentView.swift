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
    @State private var questions = [Question]()
    @State private var currentQuestion = 0
    @State private var answer = 0
    var body: some View {
        VStack {
            Form {
                Picker("Amount questions", selection: $wishedAmountQuestions) {
                    ForEach(1..<20, id: \.self) { num in
                        Text("\(num) questions").tag(num)
                    }
                }
                Stepper("Table up to \(wishedLevel)", value: $wishedLevel, in: 2...12)
                TextField("Answer", value: $answer, format: .number)
                Button("Submit answer") {
                    
                }
            }
            
            Text(questions.isEmpty ? "Question" : "\(questions[currentQuestion])")
            Button ("Next Question") {
                currentQuestion += 1
            }
            
            Button ("Click here") {
                for _ in 0...wishedAmountQuestions {
                    questions.append(Question(level: wishedAmountQuestions))
                    
                }
            }
            
        }
    }
   
    
    struct Question {
        let firstNumber: Int
        let secondNumber: Int
        let questionText: String
        let correctAnswer: Int

        init(level: Int) {
            self.firstNumber = Int.random(in: 1...level)
            self.secondNumber = Int.random(in: 1...level)
            self.questionText = "\(firstNumber) * \(secondNumber)"
            self.correctAnswer = firstNumber * secondNumber
        }
        
        func checkAnswer (answer: Int) {
            if (answer == correctAnswer) {
                print("It's correct")
            } else {
                print("it's not correct")
            }
        }
    }
    
    
}



#Preview {
    ContentView()
}
