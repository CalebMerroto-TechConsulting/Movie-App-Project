//
//  SignOutAlert.swift
//  Movie-App-Project
//
//  Created by Caleb Merroto on 3/28/25.
//

import SwiftUI

struct SignOutAlert: View {
    @Binding var showAlert: Bool
    @Binding var signedIn: Bool
    private var buttonWidth: CGFloat = 65
    private var buttonPad: CGFloat = 10
    private var buttonRad: CGFloat = 20

    init(_ showAlert: Binding<Bool>, _ signedIn: Binding<Bool>) {
        self._showAlert = showAlert
        self._signedIn = signedIn
    }
    
    var body: some View {
        if showAlert {
            ZStack {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 24) {
                    Text("Are you sure you want to sign out?")
                        .font(.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.center)
                        .padding(.top, 15)
                    
                    HStack {
                        Button(action: {
                            showAlert = false
                        }) {
                            Text("Cancel")
                                .frame(minWidth: buttonWidth)
                                .padding(buttonPad)
                                .background(Color.gray.opacity(0.5))
                                .foregroundColor(.white)
                                .cornerRadius(buttonRad)
                        }
                        Spacer()
                        Button(action: {
                            do {
                                try AuthManager.shared.signOut()
                                signedIn = false
                                showAlert = false
                            }
                            catch {
                                print("Sign out error: \(error.localizedDescription)")
                                showAlert = false
                            }
                        }) {
                            Text("Confirm")
                                .frame(minWidth: buttonWidth)
                                .padding(buttonPad)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(buttonRad)
                        }
                    }
                    .padding(.horizontal, 45)
                    .padding(.bottom, 15)
                }
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.black, lineWidth: 2)
                )
            }
        }
    }
}

#Preview {
    SignOutAlert(.constant(true), .constant(true))
}
