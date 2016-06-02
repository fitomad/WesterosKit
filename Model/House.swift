//
//  House.swift
//  WesterosKit
//
//  Created by Adolfo on 1/6/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

public class House: Parseable
{
	///
	public internal(set) var houseURL: NSURL!
	///
	public internal(set) var name: String!
	///
	public internal(set) var region: String?
	///
	public internal(set) var coatOfArms: String?
	///
	public internal(set) var words: String?
	///
	public internal(set) var titles: [String]?
	///
	public internal(set) var seats: [String]?
	///
	public internal(set) var currentLord: NSURL?
	///
	public internal(set) var heir: NSURL?
	///
	public internal(set) var overlord: NSURL?
	///
	public internal(set) var founded: String?
	///
	public internal(set) var founder: NSURL?
	///
	public internal(set) var diedOut: String?
	///
	public internal(set) var ancestralWeapons: [String]?
	///
	public internal(set) var cadetBranches: [NSURL]?
	///
	public internal(set) var swornMembers: [NSURL]?

	///
	public var died: Bool
	{
		return self.diedOut == nil
	}

	/**

	*/
	internal init?(jsonDictionary dictionary: [String: AnyObject])
	{
		guard let name = dictionary["name"] as? String, 
				  region = dictionary["region"] as? String,
				  uri = dictionary["url"] as? String 
		else
		{
			return nil
		}

		self.name = name
		self.region = region
		self.houseURL = NSURL(string: uri)!

		self.coatOfArms = self.parseStringFromDictionary(dictionary, forKey: "coatOfArms")
		self.words = self.parseStringFromDictionary(dictionary, forKey: "words")
		self.titles = self.parseStringArrayFromDictionary(dictionary, forKey: "titles")
		self.seats = self.parseStringArrayFromDictionary(dictionary, forKey: "seats")
		self.currentLord = self.parseURLFromDictionary(dictionary, forKey: "currentLord")
		self.heir = self.parseURLFromDictionary(dictionary, forKey: "heir")
		self.overlord = self.parseURLFromDictionary(dictionary, forKey: "overlord")
		self.founded = self.parseStringFromDictionary(dictionary, forKey: "founded")
		self.founder = self.parseURLFromDictionary(dictionary, forKey: "founder")
		self.diedOut = self.parseStringFromDictionary(dictionary, forKey: "diedOut")
		self.ancestralWeapons = self.parseStringArrayFromDictionary(dictionary, forKey: "ancestralWeapons")
		self.cadetBranches = self.parseURLArrayFromDictionary(dictionary, forKey: "cadetBranches")
		self.swornMembers = self.parseURLArrayFromDictionary(dictionary, forKey: "swornMembers")
	}
}