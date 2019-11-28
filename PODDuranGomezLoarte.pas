PROGRAM PODDuranGomezLoarte (input, output);

{Este programa muestra estadisticas varias de un texto corto en castellano.
No debe haber tildes ni eñes. El texto reside en 'texto.txt' junto al programa.}

CONST
{Aumentar el numero maximo de palabras, o el numero maximo de
letras por palabra, si es necesario.}
	maxPalabras= 350;
	maxLetras= 23;
TYPE
	tPalabra= string[maxLetras];
	tTexto= array[1..maxPalabras] of tPalabra;
VAR
	entrada: text;
	parsedText: tTexto;
	numPalabras: integer;

PROCEDURE inicializar(VAR parsedText: tTexto);
	VAR n: integer;
	{En un principio asignamos a parsedText strings de longitud 0, esta vacia}
	BEGIN
		FOR n:=1 TO maxPalabras DO setlength(parsedText[n],0);
	END;
PROCEDURE retirarSimbolos(VAR linea: string);
	{Convierte las lineas de texto a solo letras minusculas y espacios. P. ej.:
	'¡Vaya ilusion, 6 amigos!' se convierte en ' vaya ilusion    amigos '}
	VAR n, tamano: integer;
	BEGIN
		tamano:= length(linea);
		IF (tamano<>0) THEN BEGIN
			FOR n:= 1 TO tamano DO BEGIN
				CASE linea[n] OF
					'A': linea[n]:= 'a';
					'B': linea[n]:= 'b';
					'C': linea[n]:= 'c';
					'D': linea[n]:= 'd';
					'E': linea[n]:= 'e';
					'F': linea[n]:= 'f';
					'G': linea[n]:= 'g';
					'H': linea[n]:= 'h';
					'I': linea[n]:= 'i';
					'J': linea[n]:= 'j';
					'K': linea[n]:= 'k';
					'L': linea[n]:= 'l';
					'M': linea[n]:= 'm';
					'N': linea[n]:= 'n';
					'O': linea[n]:= 'o';
					'P': linea[n]:= 'p';
					'Q': linea[n]:= 'q';
					'R': linea[n]:= 'r';
					'S': linea[n]:= 's';
					'T': linea[n]:= 't';
					'U': linea[n]:= 'u';
					'V': linea[n]:= 'v';
					'W': linea[n]:= 'w';
					'X': linea[n]:= 'x';
					'Y': linea[n]:= 'y';
					'Z': linea[n]:= 'z';
				ELSE IF ((ord(linea[n])<97) or (ord(linea[n])>122)) THEN
					linea[n]:= ' ';
				END;
			END;
		END;
	END;
PROCEDURE lineasToPalabras (VAR linea: string; VAR parsedText: tTexto;
VAR posSigPalabra: integer);
	{Guarda todas las palabras de 'linea' en 'parsedText'}
	VAR j, k, tamano: integer; palabra: string;
	BEGIN
		k:= 1;
		tamano:= length(linea);
		palabra:= 'iniciada';
		IF (tamano<>0) THEN BEGIN
			FOR j:= 1 TO tamano DO BEGIN
				IF ((linea[j]<>' ') and (j<>tamano)) THEN BEGIN
					palabra[k]:= linea[j];
					k:= k + 1;
				END
				ELSE IF ((linea[j]<>' ') and (j=tamano)) THEN BEGIN
					palabra[k]:= linea[j];
					setlength(palabra,k);
					parsedText[posSigPalabra]:=  palabra;
					posSigPalabra:= posSigPalabra + 1;
				END
				ELSE IF ((j>1) and (linea[j-1]<>' ')) THEN BEGIN
					setlength(palabra,k-1);
					parsedText[posSigPalabra]:=  palabra;
					posSigPalabra:= posSigPalabra + 1;
					k:= 1;
				END;
			END;
		END;
	END;
PROCEDURE textoToPalabras (VAR entrada: text; VAR parsedText: tTexto;
VAR numPalabras: integer);
	{Guarda todas las palabras de 'entrada' en 'parsedText', consecutivamente}
	VAR	posSigPalabra: integer; linea: string;
	BEGIN
		posSigPalabra:=1;
		WHILE not(EOF(entrada)) DO BEGIN
			readLn(entrada,linea);
			retirarSimbolos(linea);
			lineasToPalabras(linea,parsedText,posSigPalabra);
		END;
		numPalabras:= posSigPalabra - 1;
	END;
PROCEDURE printPalabras (VAR parsedText: tTexto; numPalabras: integer);
{'parsedText' no se modifica, solo se lee}
	VAR n, m, j, espacios, columnas: integer;
	BEGIN
		IF (numPalabras<>0) THEN BEGIN
			j:=1;
			REPEAT
				{Numero de columnas con que saldra impresa la lista de palabras}
				{P.ej. si se quieren 5 columnas, escribir 'columnas:= j + 4;'}
				columnas:= j + 3;
				WHILE (columnas>numPalabras) DO columnas:= columnas - 1;
				FOR n:=j TO columnas DO BEGIN
					write(n:3, '. ');
					write(parsedText[n]);
					espacios:= (maxLetras + 1) - length(parsedText[n]);
					FOR m:=1 TO espacios DO write(' ');
				END;
				j:= columnas + 1;
				writeLn();
			UNTIL (columnas=numPalabras);
		END;
	END;
BEGIN {Programa principal}

	inicializar(parsedText);
	assign(entrada, 'texto.txt');
	reset(entrada);
	{Convertimos el texto en un array de palabras}
	textoToPalabras(entrada,parsedText,numPalabras);
	{Ahora trabajamos con el array 'parsedText'}
	close(entrada);



	{'parsedText' es un array con todas las palabras del texto original
	en minusculas.

	Asi pues si el texto es 'Las primeras noticias.'
	parsedText[1]= 'las'
	parsedText[2]= 'primeras'
	parsedText[3]= 'noticias'

	numPalabras es el numero de palabras que hay en el texto, y por tanto
	en el array parsedText.}


	
	{Añadir codigo restante aqui}

	
	
	writeLn();
	writeln('Este programa muestra varias estadisticas del texto');
	writeLn('que hay en su mismo directorio, en "texto.txt".');
	writeLn('Las estadisticas son las siguientes: ');
	writeLn();
	writeLn('Palabras que empiezan por vocal: ');
	writeLn('Palabras que empiezan por consonante: ');
	writeLn('Palabras que acaban por vocal: ');
	writeLn('Palabras que acaban por consonante: ');
	writeLn('Numero de palabras: ', numPalabras);
	writeLn('Numero de silabas (sin contar hiatos): ');

	writeLn();
	writeLn('Palabras en el texto:');
	printPalabras(parsedText,numPalabras);

	readLn();

	{Addendum:
	No es necesario inicializar parsedText si no se trabaja con strings
	de parsedText[n] donde n es mayor al numPalabras}

END.
