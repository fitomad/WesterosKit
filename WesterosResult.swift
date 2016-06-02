//
//  WesterosResult.swift
//  WesterosKit
//
//  Created by Adolfo on 1/6/16.
//  Copyright (c) 2016 Adolfo Vera. All rights reserved.
//

import Foundation

/**
	Tipo donde devolvemos el resultado de las 
	operaciones de consulta al API
	
	- Success: Todo correcto
	- Error: Algo ha pasado... :(
*/
public enum WesterosResult<T>
{
	/// Operacion terminada con exito
	case Success(result: T)
	///	Algo ha salido mal
	case Error(reason: String)
}