//
//  Test.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 16/03/2023.
//

import SwiftUI

struct Test: View {
    @State private var numbers = [1,2,3,4,5,6,7,8,9]
    @State var globalFrame=[CGFloat]()
    var body: some View {
        
//            ScrollView {
//                //                ForEach(0 ..< 20) { item in
//                //                    Text("header")
//                //                }
                    List {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 414)
                            .listRowBackground(Color(.secondarySystemBackground))
                        Section {
                            HStack {
                                Spacer()
                                Text("dldldl")
                            }
                                
                        }.listRowBackground(Back(top: true, bottom: true))
                        .listRowBackground(Color(.secondarySystemBackground))
                        .scaleEffect(0.9)
//                        Section{
//                            ForEach(0 ..< 50,id: \.self) { item in
//                                Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
//
//                                }
//                            }
//                        }.background(GeometryReader { proxy in
//                            Color.clear.onAppear{
//                                globalFrame.append(proxy.frame(in: .global).height)
//                                print(proxy.frame(in: .global).height)
//                            }
//                        })
                    }.scaleEffect(1.12)
//                    .frame(width:UIScreen.main.bounds.width, height: total())
//                        .scrollDisabled(true)
//            }
        //        ScrollView{
        //            List{
        //                Section {
        //                    Text("ldlldldl")
        //                }
        //                ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
        //                    Text("ldlldldl")
        //                }
        //            }
        //        }
    }
    func total()->CGFloat{
        var total:CGFloat=0
        globalFrame.forEach({total=total+$0})
        return total
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
