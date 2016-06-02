//
//  WesterosClient.swift
//  WesterosKit
//
//  Created by Adolfo on 1/6/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

///
/// All API request will be *returned* here
///

//
// Until [SE-0048](https://github.com/apple/swift-evolution/blob/master/proposals/0048-generic-typealias.md) 
// proposal will be approved I have to declare
// two different typealias, one for request that produce a dictionary
// and other one for request generating an array of dictionaries.
//

/**
    HTTP request that generates JSON dictionaries
 */
private typealias HttpRequestDictionaryCompletionHandler = (result: HttpResult<[String: AnyObject]>) -> (Void)

/**
    HTTP request that generates and *array* of JSON dictionaries
 */
private typealias HttpRequestArrayCompletionHandler = (result: HttpResult<[[String: AnyObject]]>) -> (Void)

/**
    Client to access data services related to
    the **A Song of Ice and Fire** book series 
    develop by [joakimskoog](https://github.com/joakimskoog)

    More info about service:
    * [Server](http://anapioficeandfire.com)
    * [GitHub](https://github.com/joakimskoog/AnApiOfIceAndFire)

    - Author: Adolfo // [@fitomad](https://twitter.com/fitomad)
    - Version: 1.0
*/
public class WesterosClient
{
	/// Singleton
	public static let westerosInstance: WesterosClient = WesterosClient()

	/// El recurso donde se encuentra el servicio
	private let baseURL: String

	/// The API client HTTP session
    private var httpSession: NSURLSession!
    /// API client HTTP configuration
    private var httpConfiguration: NSURLSessionConfiguration!

    /**
        Configuramos la conexion `HTTP`
    */
	private init()
	{
		self.baseURL = "http://anapioficeandfire.com/api"

		self.httpConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.httpConfiguration.HTTPMaximumConnectionsPerHost = 10

        let http_queue: NSOperationQueue = NSOperationQueue()
        http_queue.maxConcurrentOperationCount = 10

        self.httpSession = NSURLSession(configuration:self.httpConfiguration,
                                             delegate:nil,
                                        delegateQueue:http_queue)
	}

	//
	// MARK: - Private Methods
	//

	/**
        Peticion a una URL

        - Parameters:
            - url: Request URL
            - completionHandler: The HTTP response will be found here.
    */
    private func requestDictionaryForURL(url: NSURL, httpHandler: HttpRequestDictionaryCompletionHandler) -> Void
    {
        let request: NSURLRequest = NSURLRequest(URL: url)

        let data_task: NSURLSessionDataTask = self.httpSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error
            {
                httpHandler(result: HttpResult.ConnectionError(reason: error.localizedDescription))
            }

            guard let data = data, http_response = response as? NSHTTPURLResponse else
            {
                httpHandler(result: HttpResult.ConnectionError(reason: NSLocalizedString("HTTP_CONNECTION_ERROR", comment: "")))
                return
            }

            switch http_response.statusCode
            {
                case 200:
                    if let result = (try? NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)) as? [String: AnyObject]
                    {
                        httpHandler(result: HttpResult.Success(json: result))
                    }
                    else 
                    {
                        httpHandler(result: HttpResult.JsonParingError)
                    }
                default:
                    let code: Int = http_response.statusCode
                    let message: String = NSHTTPURLResponse.localizedStringForStatusCode(code)

                    httpHandler(result: HttpResult.RequestError(code: code, message: message))
            }
        })

        data_task.resume()
    }
    
    /**
     Peticion a una URL
     
     - Parameters:
     - url: Request URL
     - completionHandler: The HTTP response will be found here.
     */
    private func requestArrayForURL(url: NSURL, httpHandler: HttpRequestArrayCompletionHandler) -> Void
    {
        let request: NSURLRequest = NSURLRequest(URL: url)
        
        let data_task: NSURLSessionDataTask = self.httpSession.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let error = error
            {
                httpHandler(result: HttpResult.ConnectionError(reason: error.localizedDescription))
            }
            
            guard let data = data, http_response = response as? NSHTTPURLResponse else
            {
                httpHandler(result: HttpResult.ConnectionError(reason: NSLocalizedString("HTTP_CONNECTION_ERROR", comment: "")))
                return
            }
            
            switch http_response.statusCode
            {
            case 200:
                if let result = (try? NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.AllowFragments)) as? [[String: AnyObject]]
                {
                    httpHandler(result: HttpResult.Success(json: result))
                }
                else
                {
                    httpHandler(result: HttpResult.JsonParingError)
                }
            default:
                let code: Int = http_response.statusCode
                let message: String = NSHTTPURLResponse.localizedStringForStatusCode(code)
                
                httpHandler(result: HttpResult.RequestError(code: code, message: message))
            }
        })
        
        data_task.resume()
    }
}

//
// MARK: - Characters Methods
//

extension WesterosClient
{
    ///
    /// Closure donde devolvemos el resultado de la operacion de busqueda
    /// 
    ///
    /// - Parameter result: Un valor de la enumeracion que informa del 
    ///     exito o fracaso de la operacion
    ///
    typealias CharactersCompletionHandler = (result: WesterosResult<[Character]>) -> (Void)

    ///
    /// Closure donde devolvemos el resultado de la operacion de busqueda
    ///
    /// - Parameter result: Un valor de la enumeracion que informa del 
    ///     exito o fracaso de la operacion
    ///
    typealias CharacterCompletionHandler = (result: WesterosResult<Character>) -> (Void)

    /**

    */
    func characters(handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characters(named name: String, handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters?name=\(name.encoded)")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characters(gender: Character.Gender, handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters?gender=\(gender.rawValue)")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characters(culture culture: String, handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters?culture=\(culture.encoded)")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characters(isAlive alive: Bool, handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters?isAlive=\(alive)")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characters(bornAtYear year: Int, handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters?born=\(year)")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characters(diedAtYear year: Int, handler: CharactersCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters?died=\(year)")!
        self.requestCharactersForURL(url, handler: handler)
    }

    /**

    */
    func characterByID(identifier: Int, handler: CharacterCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/characters/\(identifier)")!

        self.requestDictionaryForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    if let character = Character(jsonDictionary: data)
                    {
                        handler(result: WesterosResult.Success(result: character))
                    }
                    else
                    {
                        handler(result: WesterosResult.Error(reason: "No information related to this identifier"))
                    }
                case let HttpResult.RequestError(_, message):
                    handler(result: WesterosResult.Error(reason: message))
                case let HttpResult.ConnectionError(reason):
                    handler(result: WesterosResult.Error(reason: reason))
                case HttpResult.JsonParingError:
                    handler(result: WesterosResult.Error(reason: "json parse error"))
            }
        }
    }

    /**
        Se encarga de hacer las llamadas `HTTP` para los dos tipos
        de peticiones que podemos hacer al servidor.

        El resultado de las dos operaciones es el mismo por lo que no
        es necesario ningun tipo de tratamiento especial.

        - Parameters:
            - url: Recurso que solicitamos
            - handler: Resultado de la peticion
        - SeeAlso: `requestHousesForURL` y `requestBooksForURL`
    */
    private func requestCharactersForURL(url: NSURL, handler: CharactersCompletionHandler) -> Void
    {
        self.requestArrayForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    var characters: [Character] = [Character]()

                    for dictionary in data
                    {
                        if let character = Character(jsonDictionary: dictionary)
                        {
                            characters.append(character)
                        }
                    }

                    handler(result: WesterosResult.Success(result: characters))
                    
                case let HttpResult.RequestError(_, message):
                    handler(result: WesterosResult.Error(reason: message))

                case let HttpResult.ConnectionError(reason):
                    handler(result: WesterosResult.Error(reason: reason))

                case HttpResult.JsonParingError:
                    handler(result: WesterosResult.Error(reason: "json parse error"))
            }
        }
    }
}

//
// MARK: - Houses Methods
//

extension WesterosClient
{
    ///
    /// Closure donde devolvemos el resultado de la operacion de busqueda
    /// 
    ///
    /// - Parameter result: Un valor de la enumeracion que informa del 
    ///     exito o fracaso de la operacion
    ///
    typealias HousesCompletionHandler = (result: WesterosResult<[House]>) -> (Void)

    ///
    /// Closure donde devolvemos el resultado de la operacion de busqueda
    ///
    /// - Parameter result: Un valor de la enumeracion que informa del 
    ///     exito o fracaso de la operacion
    ///
    typealias HouseCompletionHandler = (result: WesterosResult<House>) -> (Void)

    /**

    */
    func houses(handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(named name: String, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?name=\(name.encoded)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(locatedOn region: String, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?region=\(region.encoded)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(wordsContains words: String, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?words=\(words.encoded)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(hasWords: Bool, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?hasWords=\(hasWords)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(hasTitles titles: Bool, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?hasTitles=\(titles)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(hasSeats seats: Bool, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?hasSeats=\(seats)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(hasDiedOut died: Bool, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?hasDiedOut=\(died)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houses(hasAncestralWeapons weapons: Bool, handler: HousesCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses?hasAncestralWeapons=\(weapons)")!
        self.requestHousesForURL(url, handler: handler)
    }

    /**

    */
    func houseByID(identifier: Int, handler: HouseCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/houses/\(identifier)")!

        self.requestDictionaryForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    if let house = House(jsonDictionary: data)
                    {
                        handler(result: WesterosResult.Success(result: house))
                    }
                    else
                    {
                        handler(result: WesterosResult.Error(reason: "No information related to this identifier"))
                    }
                case let HttpResult.RequestError(_, message):
                    handler(result: WesterosResult.Error(reason: message))
                case let HttpResult.ConnectionError(reason):
                    handler(result: WesterosResult.Error(reason: reason))
                case HttpResult.JsonParingError:
                    handler(result: WesterosResult.Error(reason: "json parse error"))
            }
        }
    }

    /**
        Se encarga de hacer las llamadas `HTTP` para los dos tipos
        de peticiones que podemos hacer al servidor.

        El resultado de las dos operaciones es el mismo por lo que no
        es necesario ningun tipo de tratamiento especial.

        - Parameters:
            - url: Recurso que solicitamos
            - handler: Resultado de la peticion
        - SeeAlso: `requestHousesForURL` y `requestBooksForURL`
    */
    private func requestHousesForURL(url: NSURL, handler: HousesCompletionHandler) -> Void
    {
        self.requestArrayForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    var houses: [House] = [House]()

                    for dictionary in data
                    {
                        if let house = House(jsonDictionary: dictionary)
                        {
                            houses.append(house)
                        }
                    }

                    handler(result: WesterosResult.Success(result: houses))
                    
                case let HttpResult.RequestError(_, message):
                    handler(result: WesterosResult.Error(reason: message))

                case let HttpResult.ConnectionError(reason):
                    handler(result: WesterosResult.Error(reason: reason))

                case HttpResult.JsonParingError:
                    handler(result: WesterosResult.Error(reason: "json parse error"))
            }
        }
    }
}

//
// MARK: - Book Methods
//

extension WesterosClient
{
    ///
    /// Closure donde devolvemos el resultado de la operacion de busqueda
    /// 
    ///
    /// - Parameter result: Un valor de la enumeracion que informa del 
    ///     exito o fracaso de la operacion
    ///
    typealias BooksCompletionHandler = (result: WesterosResult<[Book]>) -> (Void)

    ///
    /// Closure donde devolvemos el resultado de la operacion de busqueda
    ///
    /// - Parameter result: Un valor de la enumeracion que informa del 
    ///     exito o fracaso de la operacion
    ///
    typealias BookCompletionHandler = (result: WesterosResult<Book>) -> (Void)
    
    /**
 
    */
    func books(handler: BooksCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/books")!
        self.requestBooksForURL(url, handler: handler)
    }

    /**

    */
    func books(name: String, handler: BooksCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/books?name=\(name.encoded)")!
        self.requestBooksForURL(url, handler: handler)
    }

    /**

    */
    func books(fromReleaseDate date: String, handler: BooksCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/books?fromReleaseDate=\(date.encoded)")!
        self.requestBooksForURL(url, handler: handler)
    }

    /**

    */
    func books(toReleaseDate date: String, handler: BooksCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/books?toReleaseDate=\(date.encoded)")!
        self.requestBooksForURL(url, handler: handler)
    }

    /**

    */
    func bookByID(identifier: Int, handler: BookCompletionHandler) -> Void
    {
        let url: NSURL = NSURL(string: "\(self.baseURL)/books/\(identifier)")!

        self.requestDictionaryForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    if let book = Book(jsonDictionary: data)
                    {
                        handler(result: WesterosResult.Success(result: book))
                    }
                    else
                    {
                        handler(result: WesterosResult.Error(reason: "No information related to this identifier"))
                    }
                case let HttpResult.RequestError(_, message):
                    handler(result: WesterosResult.Error(reason: message))
                case let HttpResult.ConnectionError(reason):
                    handler(result: WesterosResult.Error(reason: reason))
                case HttpResult.JsonParingError:
                    handler(result: WesterosResult.Error(reason: "json parse error"))
            }
        }
    }

    /**
        Se encarga de hacer las llamadas `HTTP` para los dos tipos
        de peticiones que podemos hacer al servidor.

        El resultado de las dos operaciones es el mismo por lo que no
        es necesario ningun tipo de tratamiento especial.

        - Parameters:
            - url: Recurso que solicitamos
            - handler: Resultado de la peticion
        - SeeAlso: `requestHousesForURL` y `requestBooksForURL`
    */
    private func requestBooksForURL(url: NSURL, handler: BooksCompletionHandler) -> Void
    {
        self.requestArrayForURL(url) { (result: HttpResult) -> (Void) in
            switch result
            {
                case let HttpResult.Success(data):
                    var books: [Book] = [Book]()

                    for dictionary in data
                    {
                        if let book = Book(jsonDictionary: dictionary)
                        {
                            books.append(book)
                        }
                    }

                    handler(result: WesterosResult.Success(result: books))
                    
                case let HttpResult.RequestError(_, message):
                    handler(result: WesterosResult.Error(reason: message))

                case let HttpResult.ConnectionError(reason):
                    handler(result: WesterosResult.Error(reason: reason))

                case HttpResult.JsonParingError:
                    handler(result: WesterosResult.Error(reason: "json parse error"))
            }
        }
    }
}
