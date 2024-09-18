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
    @State private var isGameActive = false
    @State private var finalScore = 0
    @State private var showAlert = false
    
    

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
                Button ("Start Game") {
                    isGameActive = true
                }
                
            }
        }.sheet(isPresented: $isGameActive) {
            GameView(wishedAmountQuestions: wishedAmountQuestions, wishedLevel: wishedLevel, onGameEnd: { score in
                finalScore = score
                isGameActive = false
                showAlert = true
            }
            )
        }
        .alert("Game Over! Your score is \(finalScore)", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct GameView: View {
    let wishedAmountQuestions: Int
    let wishedLevel: Int
    let onGameEnd: (Int) -> Void
    
    @State private var currentQuestion = 0
    @State private var answer = 0
    @State private var amountPoints = 0
    @State private var questions = [Question]()
    
    init(wishedAmountQuestions: Int, wishedLevel: Int, onGameEnd: @escaping (Int) -> Void) {
            self.wishedAmountQuestions = wishedAmountQuestions
            self.wishedLevel = wishedLevel
            self.onGameEnd = onGameEnd
        }
    
    var body: some View {
        Form {
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
                    onGameEnd(amountPoints)
                    questions = []
                }
                
            }
        }.onAppear{generateQuestions()}
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
    
    func generateQuestions() {
        for _ in 0..<wishedAmountQuestions {
            questions.append(Question(level: wishedLevel))
        }
    }
}



#Preview {
    ContentView()
}
