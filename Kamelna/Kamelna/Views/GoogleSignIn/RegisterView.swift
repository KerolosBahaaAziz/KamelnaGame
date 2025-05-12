//
//  RegisterView.swift
//  Kamelna
//
//  Created by Kerlos on 03/05/2025.
//

import SwiftUI

struct RegisterView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var registrationSuccess = false
    @State private var alertMessage = ""
    @State private var navigateToSignIn = false // Add this state

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundGradient.backgroundGradient
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Spacer()
                    LogoView()
                    Spacer()
                    
                    TextField("First Name", text: $firstName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                    
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 40)

                    Button(action: {
                        SoundManager.shared.playSound(named: "ButtonPressed.mp3")
                        print("Register with email and password")
                        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
                            self.alertMessage = "Please fill all the fields."
                            self.registrationSuccess = false
                            self.showAlert = true
                        }else{
                            EmailAuthHandler.shared.registerWithEmail(email: email, password: password, firstName: firstName, lastName: lastName) { success, message in
                                self.registrationSuccess = success
                                self.alertMessage = message
                                self.showAlert = true
                            }
                        }
                    }) {
                        Text("Register")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .cornerRadius(12)
                            .padding(.horizontal, 40)
                    }//.disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)
                    //.opacity((firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) ? 0.5 : 1)
                    //.animation(.easeInOut, value: firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty)

                    Button(action: {
                        // Navigate manually to Sign In screen
                        SoundManager.shared.playSound(named: "ButtonClicked.mp3")
                        self.navigateToSignIn = true
                    }) {
                        Text("Already have an account? Sign In")
                            .foregroundStyle(ButtonBackGroundColor.backgroundGradient)
                            .padding(.top, 10)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: GoogleSignInView(), isActive: $navigateToSignIn) {
                        EmptyView()
                    }
                    .hidden()
                }
                .padding(.top, 50)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(registrationSuccess ? "Registered Successfully" : "Failed to Register"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"), action: {
                            if registrationSuccess {
                                navigateToSignIn = true
                            }
                        })
                    )
                }
            }
            .navigationBarBackButtonHidden(true) // Hide back button on register screen
        }
    }
}


#Preview {
    RegisterView()
}
