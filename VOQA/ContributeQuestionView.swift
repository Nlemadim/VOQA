//
//  ContributeQuestionView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import SwiftUI

struct ContributeQuestionModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var questionText: String = "" // State variable for the text editor input
    @State private var contributeQuestion = ContributeQuestion(questionText: "") // Model to store the question and document
    @FocusState private var isTextEditorFocused: Bool // Focus state for the text editor

    var body: some View {
        VStack(alignment: .leading) {
            QuestionTextEditor(text: $questionText, isFocused: $isTextEditorFocused)
            
            Spacer(minLength: 0)
            
            SubmitButton(questionText: questionText) {
                // Populate the contributeQuestion model when submitting
                contributeQuestion.questionText = questionText
                dismiss()
                print("Submitted question: \(contributeQuestion)")
            }
            .padding()
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            isTextEditorFocused = true
        }
    }
}

struct SubmitButton: View {
    let questionText: String
    let action: () -> Void
    
    var body: some View {
        MediumDownloadButton(
            label: "Submit",
            color: questionText.isEmpty ? .gray.opacity(0.4) : .teal.opacity(0.7),
            iconImage: "arrow.up",
            action: action
        )
        .disabled(questionText.isEmpty)
    }
}

struct QuestionTextEditor: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    //@Binding var isFocused: Bool
    
    var body: some View {
        TextEditor(text: $text)
            .focused($isFocused)
            .frame(minHeight: 50)
            .frame(height: 300)
            .cornerRadius(8)
            .lineSpacing(5)
            .font(.system(size: 16, weight: .regular, design: .default))
            .frame(maxWidth: .infinity)
            .background(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .overlay {
                if text.isEmpty {
                    Text("Type your question here...")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 12)
                }
            }
            .onTapGesture {
                isFocused = true
            }
    }
}


struct ContributeQuestionView: View {
    @State private var isModalPresented: Bool = false // State to manage modal presentation
    @State private var selectedDocumentURL: URL? = nil 
    var body: some View {
        VStack {
            Spacer()
            
            // Button with text to present the modal
            Button(action: {
                isModalPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "questionmark.bubble")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                        .background(Color.themePurpleLight)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Text("Contribute a Question")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(10)
                }
            }
            .padding(.bottom, 20)
            .scaleEffect(0.8)
            .hAlign(.leading)

            // Button with image to present the modal
            Button(action: {
                isModalPresented.toggle()
            }) {
                HStack {
                    Image(systemName: "doc.badge.plus")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(10)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Text("Add Practice Exam PDF")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .cornerRadius(10)
                }
            }
            .scaleEffect(0.8)
            .hAlign(.leading)

            Spacer()
            
            // Display selected document over the rectangle if available
            if let documentURL = selectedDocumentURL {
                SelectedDocumentView(documentURL: documentURL) {
                    // Action to clear the document selection
                    selectedDocumentURL = nil
                }
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 200)
                    .overlay(
                        Text("No Document Selected")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .fullScreenCover(isPresented: $isModalPresented) {
            ContributeQuestionModalView()
                .preferredColorScheme(.dark)
                .onDisappear {
                    
                }
        }
    }
}

struct SelectedDocumentView: View {
    let documentURL: URL
    let onRemove: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Image(systemName: "doc.fill") // Use a system image to represent the document
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100) // Adjust the size as needed
                    .padding()
            }
            .frame(height: 200)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            
            // "X" button to remove the document
            Button(action: {
                onRemove() // Action to remove the document
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
            }
        }
        .padding()
    }
}


struct AddDocumentButton: View {
    let action: () -> Void
    
    var body: some View {
        MediumDownloadButton(
            label: "Add Practice Exam PDF",
            color: .teal.opacity(0.7),
            iconImage: "doc.badge.plus",
            action: action
        )
        .padding(.bottom, 20)
        .padding()
    }
}


/**
 https://github.com/swiftuilib/document-picker
 
 import SwiftUI
 import DocumentPicker

 struct ContentView: View {
     @State private var selectedDocumentURL: URL?

     var body: some View {
         VStack {
             if let url = selectedDocumentURL {
                 Text("Selected document: \(url.lastPathComponent)")
             } else {
                 Text("No document selected")
             }
             Button("Pick Document") {
                 DocumentPickerViewController.pickDocument { url in
                     selectedDocumentURL = url
                 }
             }
         }
     }
 }

 **/
