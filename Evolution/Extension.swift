//
//  Extension.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 22/01/2023.
//

import SwiftUI
import UIKit

func activityIsSave(date: Date, results: [Activity]) -> Bool {
    return results.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
}
func getActivity(date: Date, results: [Activity]) -> Int? {
    return results.firstIndex { Calendar.current.isDate($0.date, inSameDayAs: date) }
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
extension Int{
    func convertSecondsToMinutes() -> String {
        if self == 0{
            return ""
        }else if self >= 60{
            var result="\(self/60) min"
            let remainingSeconds = self % 60
            if remainingSeconds != 0 {
                result=result+" \(remainingSeconds)"
            }
            return result
        }else{
            return "\(self) sec"
        }
    }
}
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: .leading) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,color:Color) -> some View {
            
            placeholder(when: shouldShow) { Text(text).foregroundColor(color) }
        }
}
func itemFormatterWithYear(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE d MMMM YYYY"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}
func itemFormatter(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE d MMMM"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}
func itemFormatterWhithoutDayName(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}
func itemFormatterMonth(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}
func plural(_ val:Int)->String {
    if val>1 || val<(-1){
        return "s"
    }else{
        return ""
    }
}

extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        var startOfWeek: Date
        if weekday == 1 {
            startOfWeek = calendar.date(byAdding: .day, value: -6, to: self)!
        } else {
            startOfWeek = calendar.date(byAdding: .day, value: -weekday + 2, to: self)!
        }
        return startOfWeek
    }
}

public struct GeometryGetWidth: View {
    @Binding var whidth: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceFlaot.self, value: geometry.frame(in: .global).width)
        }.onPreferenceChange(RectanglePreferenceFlaot.self) { (value) in
            self.whidth = value
        }
    }
}
public struct GeometryGetMinY: View {
    @Binding var minY: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceFlaot.self, value: geometry.frame(in: .global).minY)
        }.onPreferenceChange(RectanglePreferenceFlaot.self) { (value) in
            self.minY = value
        }
    }
}
public struct GeometryGetOriginX: View {
    @Binding var originX: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            AnyView(Color.clear)
                .preference(key: RectanglePreferenceFlaot.self, value: geometry.frame(in: .global).origin.x)
        }.onPreferenceChange(RectanglePreferenceFlaot.self) { (value) in
            self.originX = value
        }
    }
}
public struct RectanglePreferenceFlaot: PreferenceKey {
    public static var defaultValue: CGFloat = .zero

    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
