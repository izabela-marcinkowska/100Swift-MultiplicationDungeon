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
    @State private var amountPoints = 0
    @State private var endOfGame = false
    var body: some View {
        VStack {
            Form {
                Picker("Amount questions", selection: $wishedAmountQuestions) {
                    ForEach(1..<20, id: \.self) { num in
                        Text("\(num) questions").tag(num)
                    }
                }
                Stepper("Table up to \(wishedLevel)", value: $wishedLevel, in: 2...12)
                Text(questions.isEmpty ? "Question" : "\(questions[currentQuestion].questionText)")
                TextField("Answer", value: $answer, format: .number)
                Button("Submit answer") {
                    if (questions[currentQuestion].checkAnswer(answer: answer)) {
                        amountPoints += 1
                        print("It's correct")
                    } else {
                        print("It's wrong")
                    }
                    print("Amount points is \(amountPoints)")
                    if (currentQuestion < wishedAmountQuestions - 1) {
                        currentQuestion += 1
                        print("current is \(currentQuestion), and count is \(questions.count)")
                    } else {
                        endOfGame = true
                    }
                    
                }
            }
            
            
        
            Button ("Start Game") {
                questions = []
                amountPoints = 0
                currentQuestion = 0
                endOfGame = false
                answer = 0 // Reset the answer field
                for _ in 0..<wishedAmountQuestions {
                    questions.append(Question(level: wishedAmountQuestions))
                    
                }
            }
            
        }.alert("Game is end", isPresented: $endOfGame) {
            Button("ok") {
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
        
        func checkAnswer(answer: Int) -> Bool {
                return answer == correctAnswer
            }
    }
    
    
}



#Preview {
    ContentView()
}
