
import SwiftUI

struct PostView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var weatherDescription: String = ""
    @State private var temperature: Double = 0.0
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                
                Text("Fetching weather for: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                    .onAppear {
                        GetWeather.shared.callWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude) { result in
                            self.weatherDescription = result.weather.first?.main ?? ""
                            self.temperature = result.main.temp
                        }
                    }
            } else {
                Text("Fetching location...")
            }
            
            Text("\(Int(temperature))°C")
                .font(.largeTitle)
                .padding()
            
            Text(weatherDescription)
                .font(.title)
                .padding()
            
            weatherImage(for: weatherDescription)
        }
        
    }
    
    func weatherImage(for description: String) -> Image {
        switch description {
        case "Clear":
            return Image(systemName: "sun.max.fill")
        case "Clouds":
            return Image(systemName: "cloud.fill")
        case "Rain":
            return Image(systemName: "cloud.rain.fill")
        case "Snow":
            return Image(systemName: "cloud.snow.fill")
        default:
            return Image(systemName: "cloud.fill")
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
