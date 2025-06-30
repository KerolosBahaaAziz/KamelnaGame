import SwiftUI

struct FriendAddView: View {
    @ObservedObject var userViewModel: UserViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var email = ""

    var body: some View {
        NavigationView { // <-- this is the key change
            ZStack {
                BackgroundGradient.backgroundGradient.ignoresSafeArea()

                GeometryReader { geometry in
                    ZStack {
                        SecondaryBackgroundGradient.backgroundGradient

                        VStack {
                            TextField("اضف صديق بالبريدالالكترونى", text: $email)
                                .padding()
                                .background(Color.white)
                                .submitLabel(.done)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .focused($isTextFieldFocused)
                                .padding(.top, 30)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("ابحث") {
                                            isTextFieldFocused = false
                                            if userViewModel.sendFriendRequest(email: email) {
                                                print("Done")
                                            } else {
                                                print("not done")
                                            }
                                        }
                                    }
                                }

                            Spacer()
                        }
                        .padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: UIScreen.main.bounds.width - 20,
                           height: UIScreen.main.bounds.height - 220)
                    .position(x: geometry.size.width / 2,
                              y: geometry.size.height / 2)
                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                isTextFieldFocused = false
            }
        }
    }

}
