//
//  ImageClip.swift
//  On Boarding
//
//  Created by akhmad khalif on 29/08/21.
//

import SwiftUI

struct ImageClip: View {
    @State var offset: CGFloat = 0
    @State var indexx: Int = 0
    @State var anm: Bool = false
    @State var opcty: CGFloat = 0.0
    @State var offsetText: CGFloat = 50
    
    @State var liquidOffset: CGSize = .zero
    @State var showHome = false
    
    var body: some View {
        if showHome {
//            Text("Welcome mother fucker")
//                .onTapGesture {
//                    withAnimation(.spring()){
//                        liquidOffset = .zero
//                        showHome.toggle()
//                    }
//                }
            Home()
        } else {
            OffsetPageTabView(offset: $offset){
                HStack(spacing: 0){
                    ForEach(boardingScreens.indices, id: \.self){index in
                        
                        VStack(spacing: 15){
                            VStack(alignment: .leading, spacing: 12){
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: 20, y: 30)
                            .animation(.easeInOut, value: indexx)
                            //                        .opacity(indexx == index ? 1 : 0)
                            
                        }
                        .padding()
                        .frame(width: getScreenBounds().width)
                        .frame(maxHeight: .infinity)
                    }
                }
                
            }
            .overlay(
                VStack{
                    HStack{
                        HStack {
                            ForEach(boardingScreens.indices, id: \.self){index in
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color.black)
                                    .opacity(index == getIndex() ? 1 : 0.4)
                                    .frame(width: index == getIndex() ? 25 : 8, height: 8)
                                    .scaleEffect(index == (getIndex()) ? 1.1 : 0.85)
                                    .animation(.easeInOut, value: getIndex())
                            }
                        }
                        Spacer()
                            .frame(maxWidth: .infinity)
                        if getIndex() != 3 {
                            Button{
                                offset = min(offset + getScreenBounds().width,getScreenBounds().width * 3)
                            } label : {
                                Text("Next")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)                        }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 50)
                ,alignment: .bottom
            )
            .background(
                VStack{
                    ForEach(boardingScreens.indices, id: \.self){index in
                        if index == getIndex(){
                            VStack(alignment: .leading){
                                Text("\(boardingScreens[index].title)")
                                    .font(.title)
                                    .bold()
                                    .padding(.top, 20)
                                Text("\(boardingScreens[index].description)")
                                    .font(.subheadline)
                                    .padding(.top, 10)
                            }
                            .onAppear{
                                print("appear")
                                opcty = 0.0
                                offsetText = 50
                                let baseAnimation = Animation.easeIn(duration: 0.8)
                                let repeated = baseAnimation.repeatCount(1)
                                
                                withAnimation(repeated) {
                                    opcty = 1
                                    offsetText = 20
                                }
                            }
                            .onDisappear{
                                //                            opcty = 0
                                print("dis")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .offset(x: 20, y: 30)
                            .offset(y: offsetText)
                            .animation(.easeInOut, value: getIndex())
                            .opacity(Double(opcty))
                            
                        }
                    }
                }
            )
            .background(Image("bg\(getIndex() + 1)")
                            .transition(AnyTransition.slide)
                            .animation(.easeInOut, value: getIndex())
                            //                        .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: getScreenBounds().width - 100, height: getScreenBounds().height - 100)
                            .mask(
                                RoundedRectangle(cornerRadius: 90)
                                    .frame(width: getScreenBounds().width + 100, height: getScreenBounds().width + 100)
                                    .rotationEffect(.init(degrees: 25))
                                    .rotationEffect(.init(degrees: getRotation()))
                                    .offset(y: -getScreenBounds().width + 30)
                            ))
            
            .background(
                Color("screen1")
                    .animation(.easeInOut, value: getIndex())
            )
            .clipShape(
                LiquidSwipe(show: getIndex(), offset: liquidOffset)
            )
            .background(Color("primary"))
            .overlay(
                VStack{
                    if (getIndex() == 3){
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .rotationEffect(.init(degrees: 25))
                            .font(.title)
                            .frame(width: 50, height: 50)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged({ (value) in
                                        withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)){
                                            liquidOffset = value.translation
                                        }
                                    })
                                    .onEnded({(value) in
                                        let screen = UIScreen.main.bounds
                                        withAnimation(.spring()){
                                            if -liquidOffset.width > (screen.width / 2){
                                                liquidOffset.width = -screen.height
                                                showHome.toggle()
                                            } else {
                                                liquidOffset = .zero
                                            }
                                        }
                                    })
                            )
                            .offset(x: -20, y: -130)
                            .opacity(liquidOffset == .zero ? 1 : 0)
                    }
                }
                , alignment: .bottomTrailing
            )
            .ignoresSafeArea(.container, edges: .all)
            .ignoresSafeArea(.container, edges: .all)
        }
        
    }
    
    
    func getRotation()->Double{
        let progress = offset / (getScreenBounds().width * 4)
        let rotation = Double(progress) * 360
        
        return rotation
    }
    func getIndex()->Int{
        let progress = (offset / getScreenBounds().width).rounded()
        
        return Int(progress)
    }
}

struct ImageClip_Previews: PreviewProvider {
    static var previews: some View {
        ImageClip()
    }
}

//Custom Shape

struct LiquidSwipe: Shape {
    var show: Int
    var offset: CGSize
    var animatableData: CGSize.AnimatableData{
        get{return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    func path(in rect: CGRect) -> Path {
        let path = Path{ path in
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            let height = rect.height
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let from = (height - 200) + (offset.height) + (offset.width)
            var to = height + (-offset.width)
            to = to < height ? height : to
            
            path.move(to: CGPoint(x: rect.width, y: from > (height - 200) ? (height - 200) : from))
            
            let mid: CGFloat = 80 + ((to + width) / 2)
            
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 170, y: mid), control2: CGPoint(x: width - 0, y: mid + 20))
        }
        
        
        
        
        let path2 = Path{path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
        }
        
        if show == 3 {
            return path
        } else {
            return path2
        }
        
    }
    
}


