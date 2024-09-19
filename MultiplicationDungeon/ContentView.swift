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

    var body: some View {
        VStack {
            Form {
                Picker("Amount of questions", selection: $wishedAmountQuestions) {
                    ForEach(1..<20) { num in
                        Text("\(num) questions").tag(num)
                    }
                }
                Stepper("Table up to \(wishedLevel)", value: $wishedLevel, in: 2...12)
                Button("Start Game") {
                    isGameActive = true
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

    var body: some View {
        VStack {
            HStack {
                NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].firstNumber)
                Image("11")
                    .resizable()
                    .frame(width: 45, height: 40)
                NumberPicture(picture: questions.isEmpty ? 1 : questions[currentQuestion].secondNumber)
            }
            Text("My answer is ...")
                .font(.headline)
                .padding()
            TextField("Answer", text: $answerText)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done) // This shows "Done" on the return key
                .onSubmit {
                    submitAnswer()
                }
            Spacer()
        }
        .padding()
        .onAppear {
            generateQuestions()
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
        } else {
            print("It's wrong")
        }
        print("Amount points is \(amountPoints)")
        if currentQuestion < wishedAmountQuestions - 1 {
            currentQuestion += 1
            print("Current question is \(currentQuestion), total questions \(questions.count)")
            answerText = "" // Reset the answer field
        } else {
            onGameEnd(amountPoints)
            questions = []
        }
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

#Preview {
    ContentView()
}
