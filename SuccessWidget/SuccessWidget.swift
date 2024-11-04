//
//  SuccessWidget.swift
//  SuccessWidget
//
//  Created by 최대성 on 11/2/24.
//

import WidgetKit
import SwiftUI


struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        // .atEnd: 마지막 date가 끝난 후 타임라인 reloading
        // .after: 다음 data가 지난 후 타임라인 reloading
        // .never: 즉시 타임라인 reloading
        completion(timeline)
    }
}

// 데이터
struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

// 뷰 구성
struct SuccessWidgetEntryView : View {
    
    let totalDays = 30
    
    @State private var successCount = ""
    @State private var percentage = 0.0
    
    var entry: Provider.Entry

    var body: some View {
        statisticsView()
    }
    func statisticsView() -> some View {
        
        VStack {
            Text("\(Int(UserDefaults(suiteName: "group.com.morningGlory")?.string(forKey: "success") ?? "")!)일 성공!")
                .bold()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.top, 10)
            graphView()
        }
    }
    
    
    func graphView() -> some View {
        circleGrapth()
            .padding(.bottom, 30)
            .padding(.top, 10)
    }
    
    func circleGrapth() -> some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .frame(width: 80, height: 80)
                .foregroundStyle(.white)
                .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Circle()
                .stroke(lineWidth: 0.34)
                .frame(width: 35, height: 35)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.black.opacity(0.3), .clear]), startPoint: .bottomTrailing, endPoint: .topLeading))
            
            Circle()
                .trim(from: 0, to: (Double(UserDefaults(suiteName: "group.com.morningGlory")?.string(forKey: "success") ?? "") ?? 0.0) / Double(30))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
            
            Text(String(format: "%.1f", (Double(UserDefaults(suiteName: "group.com.morningGlory")?.string(forKey: "success") ?? "") ?? 0.0) / Double(30)*100) + "%")
                .font(.system(size: 12))

        }
        .task() {
            checkSuccess()
        }
    }
    
    func checkSuccess() {
       
        successCount = UserDefaults(suiteName: "group.com.morningGlory")?.string(forKey: "success") ?? ""
        successCount = Int(successCount) ?? 0 >= 30 ? String(30) : successCount
        percentage = (Double(UserDefaults(suiteName: "group.com.morningGlory")?.string(forKey: "success") ?? "") ?? 0.0) / Double(30)
//        failCount = realmRepo.failCount
        
        
        print("value 값", successCount)
    }
}

struct SuccessWidget: Widget {
    let kind: String = "SuccessWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                SuccessWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                SuccessWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Success")
        .description("Rate of your Success.")
    }
}




#Preview(as: .systemSmall) {
    SuccessWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
