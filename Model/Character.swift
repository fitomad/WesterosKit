//
//  Character.swift
//  WesterosKit
//
//  Created by Adolfo on 1/6/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

public class Character: Parseable
{
	/**

	*/
	public enum Gender: String
	{
		case Female = "Female"
		case Male = "Male"
		case Unknown = "Unknown"	
	}

	///
	public internal(set) var characterURL: NSURL!
	///
	public internal(set) var name: String!
	///
	public internal(set) var gender: Gender!
	///
	public internal(set) var culture: String?
	///
	public internal(set) var bornAt: String?
	///
	public internal(set) var diedAt: String?
	///
	public internal(set) var titles: [String]?
	///
	public internal(set) var aliases: [NSURL]?
	///
	public internal(set) var father: NSURL?
	///
	public internal(set) var mother: NSURL?
	///
	public internal(set) var spouse: NSURL?
	///
	public internal(set) var allegiances: [NSURL]?
	///
	public internal(set) var books: [NSURL]?
	///
	public internal(set) var povBooks: [NSURL]?
	///
	public internal(set) var tvSerie: [String]?
	///
	public internal(set) var playedBy: [String]?

	///
	public var alive: Bool
	{
		return self.diedAt == nil
	}

	/**

	*/
	internal init?(jsonDictionary dictionary: [String: AnyObject])
	{
		guard let name = dictionary["name"] as? String, 
				  gender = dictionary["gender"] as? String, 
				  uri = dictionary["url"] as? String 
		else
		{
			return nil
		}

		self.name = name
		self.gender = Gender(rawValue: gender)
		self.characterURL = NSURL(string: uri)!

		self.culture = self.parseStringFromDictionary(dictionary, forKey: "culture")
		self.bornAt = self.parseStringFromDictionary(dictionary, forKey: "born")
		self.diedAt = self.parseStringFromDictionary(dictionary, forKey: "died")
		self.father = self.parseURLFromDictionary(dictionary, forKey: "father")
		self.mother = self.parseURLFromDictionary(dictionary, forKey: "mother")
		self.spouse = self.parseURLFromDictionary(dictionary, forKey: "spouse")
		self.titles = self.parseStringArrayFromDictionary(dictionary, forKey: "titles")
		self.aliases = self.parseURLArrayFromDictionary(dictionary, forKey: "aliases")
		self.allegiances = self.parseURLArrayFromDictionary(dictionary, forKey: "allegiances")
		self.books = self.parseURLArrayFromDictionary(dictionary, forKey: "books")
		self.povBooks = self.parseURLArrayFromDictionary(dictionary, forKey: "povBooks")
		self.tvSerie = self.parseStringArrayFromDictionary(dictionary, forKey: "tvSeries")
		self.playedBy = self.parseStringArrayFromDictionary(dictionary, forKey: "playedBy")
	}
}