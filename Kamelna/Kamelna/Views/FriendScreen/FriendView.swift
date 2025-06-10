import SwiftUI

struct FriendView: View {
    @StateObject var userViewModel = UserViewModel()
    @State var showRequest = false
   
    
    var body: some View {
        
        NavigationView{
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
                SecondaryBackgroundGradient.backgroundGradient
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .frame(width: UIScreen.main.bounds.width - 50, height:  UIScreen.main.bounds.height - 200)
                VStack{
                    HStack{
                        Button {
                            showRequest.toggle()
                        } label: {
                            Text("طلبات")
                        }.padding(10)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 10))

                        Text("الاصدقاء")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding(.leading,50)
                            .padding(.trailing, 50)
                        Button {
                            
                        } label: {
                            Text("عوده")
                        }.padding(10)
                            .foregroundStyle(ButtonForeGroundColor.backgroundGradient)
                            .background(ButtonBackGroundColor.backgroundGradient)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        NavigationLink(destination: RequestView(userViewModel: userViewModel), isActive: $showRequest) {
                            EmptyView()
                        }
                        
                    }
               
                    if  !userViewModel.friendList.isEmpty {
                        List {
                            ForEach(userViewModel.friendList, id: \.id) { friend in
                                Text("\(friend.firstName) \(friend.lastName)")
                            }.listRowBackground(Color.clear)
                        }.scrollContentBackground(.hidden)
                    }
                }
                
            }
        }
           
        
    }
}
