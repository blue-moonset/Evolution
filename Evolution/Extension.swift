//
//  Extension.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 22/01/2023.
//

import SwiftUI

func dayIsSave(date: Date, results: FetchedResults<Day>) -> Bool {
    return results.contains { Calendar.current.isDate($0.dateOfDay, inSameDayAs: date) }
}
func getDay(date: Date, results: FetchedResults<Day>) -> Int? {
    return results.firstIndex { Calendar.current.isDate($0.dateOfDay, inSameDayAs: date) }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
extension View {
    @ViewBuilder
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
extension String {
    var capitalizedSentence: String {
        let firstLetter = self.prefix(1).capitalized
        let remainingLetters = self.dropFirst().lowercased()
        return firstLetter + remainingLetters
    }
}
struct ScaleButtonStyle: ButtonStyle {
    @ViewBuilder
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
