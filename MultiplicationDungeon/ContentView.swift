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
    @State private var setAmountOfQuestions = false
    @State private var setLevelSelection = false
    
    var body: some View {
        VStack (spacing: 100) {
            HStack{
                
            Button ("Questions") {
                setAmountOfQuestions = true
            }.sheet(isPresented: $setAmountOfQuestions) {
                AmountOfQuestions { selectedAmount in
                    wishedAmountQuestions = selectedAmount // Update state variable
                    // The sheet is already dismissed inside AmountOfQuestions
                }
            }
            Button("Level") {
                setLevelSelection = true
            }
            .sheet(isPresented: $setLevelSelection) {
                LevelSelection { selectedLevel in
                    wishedLevel = selectedLevel
                }
            }
            }
        VStack {
            Button() {
                isGameActive = true
            } label: {
                Image("start-game").resizable().frame(width: 300, height: 300)
            }
        }
        }
        .sheet(isPresented: $isGameActive) {
            GameView(
                wishedAmountQuestions: wishedAmountQuestions,
                wishedLevel: wishedLevel,
                onGameEnd: { score in
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
    @State private var answerText = ""
    @State private var amountPoints = 0
    @State private var questions = [Question]()
    @State private var isAnswerCorrect = true
    @State private var showAnswerAlert = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].firstNumber)
                Image("11")
                    .resizable()
                    .frame(width: 45, height: 40)
                NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].secondNumber)
            }

            Text("My answer is...")
                .padding()
                .font(.custom(
                        "Chalkduster",
                        fixedSize: 36))
            TextField("Answer", text: $answerText)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .italic()
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done) // This shows "Done" on the return key
                .onSubmit {
                    showAnswerAlert = true
                    submitAnswer()
                }
            Spacer()
        }
        .padding()
        .onAppear {
            generateQuestions()
        }.alert(isAnswerCorrect ? "Correct!" : "Better luck next time!", isPresented: $showAnswerAlert) {
            Button("OK") {
                if currentQuestion < wishedAmountQuestions - 1 {
                    currentQuestion += 1
                    print("Current question is \(currentQuestion), total questions \(questions.count)")
                    
                    answerText = "" // Reset the answer field
                } else {
                    onGameEnd(amountPoints)
                    questions = []
                }
            }
        }
    }

    struct Question {
        let firstNumber: Int
        let secondNumber: Int
        let correctAnswer: Int

        init(level: Int) {
            self.firstNumber = Int.random(in: 1...level)
            self.secondNumber = Int.random(in: 1...level)
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
        let userAnswer = Int(answerText) ?? 0
        if questions[currentQuestion].checkAnswer(answer: userAnswer) {
            amountPoints += 1
            print("It's correct")
            isAnswerCorrect = true
        } else {
            print("It's wrong")
            isAnswerCorrect = false
        }
        print("Amount points is \(amountPoints)")
        showAnswerAlert = true
        // Do not change `currentQuestion` or call `onGameEnd` here
    }

    struct NumberPicture: View {
        var picture: Int
        var body: some View {
            Image("\(picture)")
                .resizable()
                .frame(width: 100.0, height: 150.0)
                .shadow(radius: 5)
        }
    }
}

struct AmountOfQuestions: View {
    let onSetAmount: (Int) -> Void // Closure to pass back the selected amount

        @Environment(\.dismiss) var dismiss // Environment variable to dismiss the sheet

        init(onSetAmount: @escaping (Int) -> Void) {
            self.onSetAmount = onSetAmount
        }
    var body: some View {
        Text("This will be amount question window")
    }
}

struct LevelSelection: View {
    let onSetLevel: (Int) -> Void

    @Environment(\.dismiss) var dismiss

    init(onSetLevel: @escaping (Int) -> Void) {
        self.onSetLevel = onSetLevel
    }

    var body: some View {
        Text("This will be amount level window")
    }
}

#Preview {
    ContentView()
}
