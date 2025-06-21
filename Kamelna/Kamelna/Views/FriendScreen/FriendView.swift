import SwiftUI

struct FriendView: View {
    @StateObject var userViewModel = UserViewModel()
    @State var showRequest = false
   
    
    var body: some View {
        
        NavigationView{
            ZStack{
                BackgroundGradient.backgroundGradient.ignoresSafeArea()
              
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
                            .foregroundStyle(.black)
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
                        
                    }.padding(.bottom,20)
                        .frame(alignment: .top)
                
                    ZStack{
                    
                        SecondaryBackgroundGradient.backgroundGradient
                        if !userViewModel.isLoading{
                            if  !userViewModel.friendList.isEmpty {
                                List {
                                    ForEach(userViewModel.friendList, id: \.id) { user in
                                        
                                        
                                        HStack{
                                            HStack{
                                                Image(systemName: "star.circle.fill")
                                                    .foregroundStyle(.white)
                                                    .background(.cyan)
                                                    .clipShape(Circle())
                                                    .padding(.trailing,50)
                                            
                                                Text("\(user.rankPoints)")
                                            }.padding(5)
                                            .background(Color(#colorLiteral(red: 0.67680469, green: 0.5414626345, blue: 0.4466940624, alpha: 1)))
                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                           
                                            Spacer()
                                            HStack{
                                                Text("\(user.firstName) \(user.lastName)")
                                                    .font(.subheadline)
                                                AsyncImageView(url: URL(string:user.profilePictureUrl ?? ""), placeHolder: "person.fill", errorImage: "photo.artframe.circle.fill")
                                                    .padding(.leading,5)
                                                

                                                

                                            }
                                        }
                                        
                                    }.listRowBackground(Color.clear)
                                }.scrollContentBackground(.hidden)
                            }else{
                                Text("لا يوجد لديك اصدقاء")
                            }
                        }else{
                            VStack(spacing: 16) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(1.5)
                                    Text("جارى التحميل ...")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                }
                                
                        }
                       
                        
                    }.clipShape(RoundedRectangle(cornerRadius: 25))
                        .frame(width: UIScreen.main.bounds.width - 50, height:  UIScreen.main.bounds.height - 200  )
                }
                
            }
        }
           
        
    }
}
