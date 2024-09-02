//
//  ContributeQuestionView.swift
//  VOQA
//
//  Created by Tony Nlemadim on 8/30/24.
//

import SwiftUI
import SwiftUILib_DocumentPicker

// Parent View: ContributeQuestionView
struct ContributeQuestionView: View {
    @State private var isModalPresented: Bool = false
    @State private var selectedDocumentURL: URL? = nil
    @State private var showDocumentPicker: Bool = false // State to manage document picker presentation
    @Binding var isLoggedIn: Bool
    var themeColor: Color
    var submitQuestionText: (String) -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            if isLoggedIn {
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
                
                // Button with image to present the document picker
                Button(action: {
                    showDocumentPicker.toggle()
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
                .documentPicker(isPresented: $showDocumentPicker, documentTypes: ["public.item"], onDocumentsPicked:  { urls in
                    if let selectedURL = urls.first {
                        selectedDocumentURL = selectedURL
                    }
                })
                
            } else {
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 80)
                
                Text("Join The Community".uppercased())
                    .font(.title2)
                    .foregroundStyle(themeColor)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 80)
                
                VStack(spacing: 4) {
                    Text("Sign-In to post a question")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    MediumDownloadButton(
                        label: "Sign In",
                        color: themeColor,
                        iconImage: "apple.logo",
                        action: {
                            //MARK: TODO:- Navigation Action for Sign In
                        }
                    )
                    .padding()
                }
            }
            
            Spacer()
            
            // Display selected document over the rectangle if available
            if let documentURL = selectedDocumentURL {
                SelectedDocumentView(documentURL: documentURL) {
                    // Action to clear the document selection
                    selectedDocumentURL = nil
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .sheet(isPresented: $isModalPresented) {
            ContributeQuestionModalView { questionText in
                submitQuestionText(questionText)
            }
            .preferredColorScheme(.dark)
        }
    }
}

// Modal View: ContributeQuestionModalView
struct ContributeQuestionModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var typedText: String = ""
    @FocusState private var isTextEditorFocused: Bool
    var submit: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            QuestionTextEditor(text: $typedText, isFocused: $isTextEditorFocused)
            
            Spacer(minLength: 0)
            
            SubmitButton(questionText: typedText) { contributedQuestion in
                submit(contributedQuestion) // Callback to pass text to parent
                dismiss()
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

// Text Editor View: QuestionTextEditor
struct QuestionTextEditor: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
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

// Button View: SubmitButton
struct SubmitButton: View {
    let questionText: String
    let action: (String) -> Void
    
    var body: some View {
        MediumDownloadButton(
            label: "Submit",
            color: questionText.isEmpty ? .gray.opacity(0.4) : .teal.opacity(0.7),
            iconImage: "arrow.up",
            action: { action(questionText) }
        )
        .disabled(questionText.isEmpty)
    }
}

// Selected Document View: SelectedDocumentView
struct SelectedDocumentView: View {
    let documentURL: URL
    let onRemove: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Image(systemName: "doc.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
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

#Preview {
    ContributeQuestionView(isLoggedIn: .constant(false), themeColor: .pink, submitQuestionText: { text in })
        .preferredColorScheme(.dark)
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
