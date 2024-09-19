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
    @FocusState private var answerIsFocused: Bool
    
    init(wishedAmountQuestions: Int, wishedLevel: Int, onGameEnd: @escaping (Int) -> Void) {
        self.wishedAmountQuestions = wishedAmountQuestions
        self.wishedLevel = wishedLevel
        self.onGameEnd = onGameEnd
    }
    
    
    var body: some View {
        
        VStack{
            HStack {
                NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].firstNumber)
                Image("11").resizable().frame(width: 45, height: 40)
                NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].secondNumber)
            }
            VStack{
                Text("My answer is ...")
                //                Image("13").resizable().frame(width: 400, height: 350)
                //            }.frame(width: 200, height: 100)
            }
            HStack{
                
                TextField("Answer", value: $answer, format: .number)
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .keyboardType(.decimalPad)
                    .focused($answerIsFocused)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Submit") {
                    submitAnswer()
                }
            }
        }.onAppear {
            generateQuestions()
            answerIsFocused = true
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
    
    func generateQuestions() {
        for _ in 0..<wishedAmountQuestions {
            questions.append(Question(level: wishedLevel))
        }
    }
    
    func submitAnswer() {
        if questions[currentQuestion].checkAnswer(answer: answer) {
            amountPoints += 1
            print("It's correct")
        } else {
            print("It's wrong")
        }
        print("Amount points is \(amountPoints)")
        if currentQuestion < wishedAmountQuestions - 1 {
            currentQuestion += 1
            print("current is \(currentQuestion), and count is \(questions.count)")
            print(String(questions[currentQuestion].firstNumber))
            answer = 0 // Reset the answer field
        } else {
            onGameEnd(amountPoints)
            questions = []
        }
        // Keep the keyboard up by setting focus back to the TextField
        DispatchQueue.main.async {
            answerIsFocused = true
        }
    }
    
    struct NumberPicture: View {
        var picture: Int
        var body: some View {
            Image(String(picture))
                .resizable()
                .frame(width: 100.0, height: 150.0)
                .shadow(radius: 5)
        }
    }
}



#Preview {
    ContentView()
}
