//
//  ForgotPasswordView.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/27/25.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State var email: String = ""
    var onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onBack()
            }) {
                Text("< Back")
                    .foregroundStyle(.blue)
                    .padding()
            }
            Spacer()
        }
        VStack(spacing: 24) {
            Text("Reset Password")
                .font(.largeTitle).bold()

            TextField("email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                AuthManager.shared.resetPassword(email: email)
            }) {
                Text("Send Password Reset Email")
                    .frame(maxWidth: 375)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(7)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ForgotPasswordView(onBack: {})
}
