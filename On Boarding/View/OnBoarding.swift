//
//  OnBoarding.swift
//  On Boarding
//
//  Created by akhmad khalif on 28/08/21.
//

import SwiftUI

struct OnBoarding: View {
    @State var offset : CGFloat = 0
    var body: some View {
        OffsetPageTabView(offset: $offset){
            HStack(spacing: 0) {
                ForEach(boardingScreens){ screen in
                    VStack(spacing: 15) {
                        Image(screen.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
                            .scaleEffect(getScreenBounds().height < 750 ? 0.9 : 1)
                            .offset(y: getScreenBounds().height < 750 ? -100 : -130)
                        
                        VStack(alignment: .leading, spacing: 12){
                            Text(screen.title)
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .padding(.top, 20)
                            Text(screen.description)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .offset(y: -20)
                    }
                    .padding()
                    .frame(width: getScreenBounds().width)
                    .frame(maxHeight: .infinity)
                    
                }
            }
            
        }
        .background(
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.white)
                .frame(width: getScreenBounds().width - 100, height: getScreenBounds().width - 100)
                .scaleEffect(2)
                .rotationEffect(.init(degrees: 25))
                .rotationEffect(.init(degrees: getRotation()))
                .offset(y: -getScreenBounds().width + 20)
            , alignment: .leading
            
        )
        .background(
            Color("screen\(getIndex() + 1)")
                .animation(.easeInOut, value: getIndex())
        )
        .ignoresSafeArea(.container, edges: .all)
        .overlay(
            VStack{
                
                
                HStack{
                    Button{
                        
                    } label : {
                        Text("Skip")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    HStack(spacing: 8) {
                        ForEach(boardingScreens.indices, id: \.self){index in
                            Circle()
                                .fill(Color.white)
                                .opacity(index == getIndex() ? 1 : 0.4)
                                .frame(width: 9, height: 8)
                                .scaleEffect(index == (getIndex()) ? 1.3 : 0.85)
                                .animation(.easeInOut, value: getIndex())
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Button{
                        offset = min(offset + getScreenBounds().width,getScreenBounds().width * 3)
                    } label : {
                        Text("Next")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 8)
            }
            .padding()
            ,alignment: .bottom
        )
    }
    func getRotation()->Double{
        let progress = offset / (getScreenBounds().width * 4)
        let rotation = Double(progress) * 360
        
        print(rotation)
        
        return rotation
    }
    func getIndex()->Int{
        let progress = (offset / getScreenBounds().width).rounded()
        
        return Int(progress)
    }
}

struct OnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        OnBoarding()
    }
}

extension View{
    func getScreenBounds()->CGRect{
        return UIScreen.main.bounds
    }
}
