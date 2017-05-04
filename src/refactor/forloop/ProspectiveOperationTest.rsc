module refactor::forloop::ProspectiveOperationTest

import refactor::forloop::ProspectiveOperation;
import refactor::forloop::ProspectiveOperationTestResources;
import refactor::forloop::OperationType;
import MethodVar;
import lang::java::\syntax::Java18;
import IO;
import List;

public test bool shouldReturnAForEachOnSimpleShortExample() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] simpleShort = simpleShort();
	
	prospectiveOperations = retrieveProspectiveOperations(simpleShort.vars, simpleShort.loop);
	
	return size(prospectiveOperations) == 1 &&
		prospectiveOperations[0].stmt == "writer.write(thing);" &&
		prospectiveOperations[0].operation == FOR_EACH;
}

public test bool shouldHandleReduce() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] filterMapReduce = filterMapReduce();
	
	prospectiveOperations = retrieveProspectiveOperations(filterMapReduce.vars, filterMapReduce.loop);
	
	return size(prospectiveOperations) == 2 && 
		prospectiveOperations[0].stmt == "rule.hasErrors()" &&
		prospectiveOperations[0].operation == FILTER &&
		prospectiveOperations[1].stmt == "count += rule.getErrors().size();" &&
		prospectiveOperations[1].operation == REDUCE;
}

//public test bool shouldHandleAnyMatchAndIfWithContinue() {
//	tuple [set[MethodVar] vars, EnhancedForStatement loop] continueAndReturn = continueAndReturn();
//	
//	prospectiveOperations = retrieveProspectiveOperations(continueAndReturn.vars, continueAndReturn.loop);
//	println(prospectiveOperations);
//	
//	return size(prospectiveOperations) == 2 && 
//		prospectiveOperations[0].stmt == "e.getGrammarName() != null" &&
//		prospectiveOperations[0].operation == FILTER &&
//		prospectiveOperations[1].stmt == "e.getGrammarName().equals(grammarName)" &&
//		prospectiveOperations[1].operation == ANY_MATCH;
//}
//
//public test bool shouldHandleIfWithContinue() {
//	tuple [set[MethodVar] vars, EnhancedForStatement loop] continueAndReturn = continueAndReturn();
//	
//	prospectiveOperations = retrieveProspectiveOperations(continueAndReturn.vars, continueAndReturn.loop);
//	println(prospectiveOperations);
//	
//	return prospectiveOperations[0].stmt == "e.getGrammarName() != null" &&
//		prospectiveOperations[0].operation == FILTER;
//}

public test bool shouldHandleAnyMatch() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] continueAndReturn = continueAndReturn();
	
	prospectiveOperations = retrieveProspectiveOperations(continueAndReturn.vars, continueAndReturn.loop);
	
	return prospectiveOperations[1].stmt == "e.getGrammarName().equals(grammarName)" &&
		prospectiveOperations[1].operation == ANY_MATCH;
}

public test bool shouldSeparateAndChooseCorrectOperationsOnMultipleStatements() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] filterAndMergedForEach = filterAndMergedForEach();
	
	prospectiveOperations = retrieveProspectiveOperations(filterAndMergedForEach.vars, filterAndMergedForEach.loop);
	
	return size(prospectiveOperations) == 4 &&
		prospectiveOperations[0].stmt == "isValid(entry)" &&
		prospectiveOperations[0].operation == FILTER &&
		prospectiveOperations[1].stmt == "ClassLoader cl = entry.getKey();" &&
		prospectiveOperations[1].operation == MAP &&
		prospectiveOperations[2].stmt == "!((WebappClassLoader)cl).isStart()" &&
		prospectiveOperations[2].operation == FILTER &&
		prospectiveOperations[3].stmt == "result.add(entry.getValue());" &&
		prospectiveOperations[3].operation == FOR_EACH;
}

public test bool shouldSeparateAndChooseCorrectOperationsOnMultipleMapsEndingWithAReduce() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] multipleMapsAndEndingReducer = multipleMapsAndEndingReducer();
	
	prospectiveOperations = retrieveProspectiveOperations(multipleMapsAndEndingReducer.vars, multipleMapsAndEndingReducer.loop);
	
	return size(prospectiveOperations) == 5 &&
		prospectiveOperations[0].stmt == "assertTrue(map.containsKey(entry.getKey()));" &&
		prospectiveOperations[0].operation == MAP &&
		prospectiveOperations[1].stmt == "assertTrue(map.containsValue(entry.getValue()));" &&
		prospectiveOperations[1].operation == MAP &&
		prospectiveOperations[2].stmt == "int expectedHash =\r\n            (entry.getKey() == null ? 0 : entry.getKey().hashCode())\r\n                ^ (entry.getValue() == null ? 0 : entry.getValue().hashCode());" &&
		prospectiveOperations[2].operation == MAP &&
		prospectiveOperations[3].stmt == "assertEquals(expectedHash, entry.hashCode());" &&
		prospectiveOperations[3].operation == MAP &&
		prospectiveOperations[4].stmt == "expectedEntrySetHash += expectedHash;" &&
		prospectiveOperations[4].operation == REDUCE;
}

public test bool shouldThrowExceptionWhenInnerLoopIsFound() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] innerLoop = innerLoop1();
	
	try {
		prospectiveOperations = retrieveProspectiveOperations(innerLoop.vars, innerLoop.loop);
	} catch:
		return true;
	
	return false;
}

public test bool shouldThrowExceptionWhenAnotherInnerLoopIsFound() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] innerLoop = innerLoop2();
	
	try {
		prospectiveOperations = retrieveProspectiveOperations(innerLoop.vars, innerLoop.loop);
	} catch:
		return true;
	
	return false;
}

public test bool shouldThrowExceptionWhenLoopWithInnerWhileIsFound() {
	tuple [set[MethodVar] vars, EnhancedForStatement loop] loopWithInnerWhile = loopWithInnerWhile();
	
	try {
		prospectiveOperations = retrieveProspectiveOperations(loopWithInnerWhile.vars, loopWithInnerWhile.loop);
	} catch:
		return true;
	
	return false;
}