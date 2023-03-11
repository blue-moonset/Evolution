//
//  SF.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 14/02/2023.
//

import SwiftUI

struct SF: View {
    @Binding var sFSelect:String?
    let columns = [GridItem(.flexible()), GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]
    var body: some View {
        VStack (spacing: 0){
            HStack {
                Text(sFSelect==nil ? "Sélectionne un symbole":"Symbole sélectionné")
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                ZStack{
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(width: 60,height: 60)
                        .cornerRadius(10)
                    if sFSelect != nil{
                        Image(systemName: sFSelect!).font(.title)
                            .foregroundColor(.white)
                    }
                }
            }.padding(.horizontal,30)
                .padding(.bottom,10)
            ScrollView {
                LazyVStack {
                    LazyVGrid(columns: columns) {
                        ForEach(Symbols().sf, id: \.self) { item in
                            Image(systemName: item)
                                .font(sFSelect==item ? .title:.title2)
                                .foregroundColor(sFSelect==item ? .blue:.black)
                                .animation(.easeIn(duration: 0.1), value:sFSelect)
                                .frame(width: 50,height: 50)
                                .background(.white.opacity(0.001))
                                .onTapGesture {
                                    if sFSelect == item{
                                        sFSelect=nil
                                    }else{
                                        sFSelect=item
                                    }
                                }
                        }.padding(.top,10)
                    }.frame(width: UIScreen.main.bounds.width)
                }
            }.frame(height: 300)
        }
    }
}

struct SF_Previews: PreviewProvider {
    static var previews: some View {
        SF(sFSelect: .constant(nil))
    }
}
