
import SwiftUI

struct PostView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherIcon: String = ""
    @State private var temperature: Double = 0.0
    
    var body: some View {
        VStack {
            
            if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png") {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
            Text("\(Int(temperature))°C")
                .font(.largeTitle)
                .padding()
        }
        .task {
            if let location = locationManager.location {
                GetWeather.shared.callWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { result in
                    self.weatherIcon = result.weather.first?.icon ?? "아이콘"
                    self.temperature = result.main.temp
                    print(self.weatherIcon)
                }
                
            }
        }
    }
}


struct ContentView: View {
    var body: some View {
        PostView()
    }
}

#Preview {
    ContentView()
}
