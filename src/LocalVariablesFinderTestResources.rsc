module LocalVariablesFinderTestResources

import IO;
import lang::java::\syntax::Java18;
import ParseTree;

public MethodBody enhancedForLoopFinalVarDecl() {
	fileLoc = |project://rascal-Java8//testes/localVariables/EnhancedForLoopFinalVarDecl|;
	content = readFile(fileLoc);
	return parse(#MethodBody, content);
}

public MethodBody enhancedForLoopWithException() {
	fileLoc = |project://rascal-Java8//testes/localVariables/EnhancedForLoopWithException|;
	content = readFile(fileLoc);
	return parse(#MethodBody, content);
}