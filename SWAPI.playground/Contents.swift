import UIKit

// Reference URLs
// https://swapi.dev/api/people/1/
// https://swapi.dev/api/films/


struct Person: Decodable {
    let name: String
    let birth_year: String
    let height: String
    let homeworld: URL
    let mass: String
    let gender: String
    let films: [URL]
} // END OF STRUCT

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
} // END OF STRUCT

struct Planet: Decodable {
    let name: String
    let population: String
} // END OF STRUCT

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        print(finalURL)
        // 2 - Contact Server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle Errors
            if let error = error {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                completion(nil)
                return
            }
            
            // 4 - Check for Data
            guard let data = data else { return completion(nil) }
            do {
                // 5 - Decode Person from JSON
                let personDecoder = try JSONDecoder().decode(Person?.self, from: data)
                completion(personDecoder)
            } catch {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                completion(nil)
                return
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact Server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle Errors
            if let error = error {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                completion(nil)
                return
            }
            
            // 3 - Check for Data
            guard let data = data else { return completion(nil) }
            do {
                // 4 - Decode Film From JSON
                let filmDecoder = try JSONDecoder().decode(Film?.self, from: data)
                completion(filmDecoder)
            } catch {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                completion(nil)
                return
            }
            
        }.resume()
    }
    
    static func fetchPlanet(url: URL, completion: @escaping (Planet?) -> Void) {
        // 1 - Contact Server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle Errors
            if let error = error {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                completion(nil)
                return
            }
            // 3 - Check for Data
            guard let data = data else { return completion(nil) }
            do {
                // 4 - Decode Planet from JSON
                let planetDecoder = try JSONDecoder().decode(Planet?.self, from: data)
                completion(planetDecoder)
                
            } catch {
                print("========= ERROR =========")
                print("Function: \(#function)")
                print("Error: \(error)")
                print("Description: \(error.localizedDescription)")
                print("========= ERROR =========")
                
                completion(nil)
                return
            }
        }.resume()
    }
} // END OF CLASS

SwapiService.fetchPerson(id: 22) { person in
    if let person = person {
        print("Name: \(person.name)")
        print("Birth Year: \(person.birth_year)")
        print("Gender: \(person.gender)")
        print("Height \(person.height)cm & Mass: \(person.mass)kg")
        fetchPlanet(url: person.homeworld)
        
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print("Title: \(film.title)")
            print("Release Date: \(film.release_date)")
            print("Opening Crawl:\n\(film.opening_crawl)\n")
        }
    }
}

func fetchPlanet(url: URL) {
    SwapiService.fetchPlanet(url: url) { (planet) in
        if let planet = planet {
            print("Home Planet: \(planet.name) \n")
        }
    }
}





