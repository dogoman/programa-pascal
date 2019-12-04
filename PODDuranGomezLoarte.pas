PROGRAM PODDuranGomezLoarte (input, output);

{Este programa muestra estadísticas varias de un texto corto en castellano.
No debe haber tildes ni eñes. El texto reside en 'texto.txt' junto al programa.}

CONST
{Aumentar el numero máximo de palabras,
o el numero máximo de letras por palabra, si es necesario.}
	maxPalabras= 250;
	maxLetras= 35;
	anchuraConsola= 120; {Anchura en numero de caracteres}
	{Por defecto en Windows 10 y myApps la consola es 120 chars ancho.
	Windows 7 y XP: 80 chars.}
TYPE
	tPalabra= string[maxLetras];
	tTexto= array[1..maxPalabras] of tPalabra;
	tSilabas= array [1..maxPalabras] of integer;
VAR
	entrada: text;
	parsedText: tTexto;
	numPalabras: integer;
	vocalInicial, consonanteInicial: integer;
	vocalFinal, consonanteFinal: integer;
	silabasMatriz: tSilabas;
	numSilabas: integer;

PROCEDURE creacionFichero (VAR entrada: text);
{Si no existe el archivo "texto.txt", se crea}
	BEGIN
		{$I-} {se desactiva para controlar reset}
		reset(entrada);
		{$I+} {se activa para detectar otros errores que no controlamos}
		IF (IOResult<>0) THEN BEGIN
			rewrite(entrada);
			writeLn(entrada,'Archivo creado.');
			close(entrada);
			writeLn('    (El archivo "texto.txt" no existe, ha sido creado.)');
		END;
	END;
PROCEDURE retirarSimbolos (VAR linea: string);
{Convierte las lineas de texto a sólo letras minusculas y espacios. P. ej.:
'¡Vaya ilusion, 6 amigos!' se convierte en ' vaya ilusion    amigos '}
	VAR n, tamano, ordinal: integer;
	BEGIN
		tamano:= length(linea);
		IF (tamano<>0) THEN BEGIN
			FOR n:=1 TO tamano DO BEGIN
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
				ELSE
					BEGIN
						ordinal:= ord(linea[n]);
						IF ((ordinal<97) or (ordinal>122)) THEN linea[n]:= ' ';
					END;
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
			FOR j:=1 TO tamano DO BEGIN
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
		posSigPalabra:= 1;
		WHILE not(EOF(entrada)) DO BEGIN
			readLn(entrada,linea);
			retirarSimbolos(linea);
			lineasToPalabras(linea,parsedText,posSigPalabra);
		END;
		numPalabras:= posSigPalabra - 1;
	END;
FUNCTION esVocal (letra: char): boolean;
	BEGIN
		IF ((letra='a') or
			(letra='e') or
			(letra='i') or
			(letra='o') or
			(letra='u')) THEN esVocal:= TRUE
		ELSE esVocal:= FALSE;
	END;
FUNCTION esCons (letra: char): boolean;
	BEGIN
		esCons:= not(esVocal(letra));
	END;
FUNCTION esHiato (letra1: char; letra2: char): boolean;
	BEGIN
		IF (((letra1='a') or (letra1='e') or (letra1='o')) and
			((letra2='a') or (letra2='e') or (letra2='o')))
			THEN esHiato:= TRUE
		ELSE esHiato:= FALSE;
	END;
PROCEDURE letraInicial (VAR parsedText: tTexto; VAR vocalInicial,
consonanteInicial: integer; numPalabras: integer);
{Aquí 'parsedText' no se modifica, sólo se lee}
	VAR n: integer; letra: char;
	BEGIN
		vocalInicial:= 0;
		IF (numPalabras<>0) THEN BEGIN
			FOR n:= 1 to numPalabras DO BEGIN
				letra:= parsedText[n][1];
				IF esVocal(letra) THEN vocalInicial:= vocalInicial + 1;
			END;
		END;
		consonanteInicial:= numPalabras - vocalInicial;
	END;
PROCEDURE letraFinal (VAR parsedText: tTexto; VAR vocalFinal,
consonanteFinal: integer; numPalabras: integer);
{Aquí 'parsedText' no se modifica, sólo se lee}
	VAR n, j: integer; letra: char;
	BEGIN
		vocalFinal:= 0;
		IF (numPalabras<>0) THEN BEGIN
			FOR n:= 1 to numPalabras DO BEGIN
				j:= length(parsedText[n]);
				letra:= parsedText[n][j];
				IF esVocal(letra) THEN vocalFinal:= vocalFinal + 1;
			END;
		END;
		consonanteFinal:= numPalabras - vocalFinal;
	END;
PROCEDURE contarSilabas (VAR parsedText: tTexto; VAR silabasMatriz: tSilabas;
VAR numSilabas: integer; numPalabras: integer);

{Aquí 'parsedText' no se modifica, sólo se lee}

{Cuenta las sílabas de cada palabra, y las sílabas totales. Asigna el número
de sílabas de cada palabra al array 'silabasMatriz'. Las sílabas
de 'parsedText[n]' serán 'silabasMatriz[n]'}

{Las uniones de vocales ia, ie, io, iu; ua, ue, ui, uo; ai, ei, oi; au, eu, ou;
(y respectivas variantes con hache intercalada) se consideran aquí
diptongos/triptongos siempre, aunque en realidad sean a veces hiatos.

P. ej:				día (2 sílabas), capicúa (4), baúl (2),
					maíz (2), búho (2), ahí (2)

Se procesan así:	dia (1 sílaba), capicua (3), baul (1),
					maiz (1), buho (1), ahi (1)

Distinguir estos hiatos requeriría trabajar con tildes.}

	VAR
		j, silabas, longitud: integer;
		palabra: tPalabra;
		acabar: boolean;
		iteraciones: integer;
		{Cuando son demasiadas iteraciones se hace error handling}
	BEGIN
		numSilabas:= 0;
		IF (numPalabras<>0) THEN BEGIN
			FOR j:=1 TO numPalabras DO BEGIN
				silabas:= 0;
				palabra:= parsedText[j];
				acabar:= FALSE;
				iteraciones:= 0;
				REPEAT
					longitud:= length(palabra);
					iteraciones:= iteraciones + 1;
					{Casos más extraños al final de la lista de condicionales}

					{Empieza aquí lista de condicionales}
					IF (longitud<2) THEN BEGIN
						silabas:= silabas + 1;
						acabar:= TRUE;
					END
					ELSE IF (longitud<3) THEN BEGIN
						IF (esHiato(palabra[1],palabra[2])) THEN
							silabas:= silabas + 2
						ELSE silabas:= silabas + 1;
						acabar:= TRUE;
					END
					ELSE IF esCons(palabra[1]) and esVocal(palabra[2]) THEN
						palabra:= copy(palabra,2,(longitud-1))
					ELSE IF esCons(palabra[1]) and esVocal(palabra[3]) THEN
						palabra:= copy(palabra,3,(longitud-2))
					ELSE IF esHiato(palabra[1],palabra[2]) THEN BEGIN
		   				silabas:= silabas + 1;
						palabra:= copy(palabra,2,(longitud-1));
					END
					ELSE IF esVocal(palabra[1]) and esVocal(palabra[2]) THEN
						palabra:= copy(palabra,2,(longitud-1))
					ELSE IF esVocal(palabra[1]) and (palabra[2]='h') and
						esVocal(palabra[3]) THEN BEGIN
						palabra[2]:= palabra[1];
						palabra:= copy(palabra,2,(longitud-1));
					END
					ELSE IF esVocal(palabra[1]) and
						esVocal(palabra[3]) THEN BEGIN
						silabas:= silabas + 1;
						palabra:= copy(palabra,3,(longitud-2));
					END
					ELSE IF (longitud>3) and esVocal(palabra[1]) and
						esVocal(palabra[4]) THEN BEGIN
							silabas:= silabas + 1;
							palabra:= copy(palabra,4,(longitud-3));
					END
					ELSE IF (longitud>4) and esVocal(palabra[1]) and
						esVocal(palabra[5]) THEN BEGIN
						silabas:= silabas + 1;
						palabra:= copy(palabra,5,(longitud-4));
					END
					ELSE IF (longitud>5) and esVocal(palabra[1]) and
						esVocal (palabra[6]) THEN BEGIN
						silabas:= silabas + 1;
						palabra:= copy(palabra,6,(longitud-5));
					END
					{'Angstromio' y similares}
					ELSE IF (longitud>6) and esVocal(palabra[1]) and
						esVocal(palabra[7]) THEN BEGIN
						silabas:= silabas + 1;
						palabra:= copy(palabra,7,(longitud-6));
					END
					{Para algunos extranjerismos, 'golf', 'sexy'}
					ELSE IF (longitud<4) and esVocal(palabra[1]) THEN BEGIN
						IF (palabra[3]='y') THEN silabas:= silabas + 2
						ELSE silabas:= silabas + 1;
						acabar:= TRUE;
					END
					{Para algunos extranjerismos, 'tests', 'whisky'}
					ELSE IF (longitud<5) and esVocal(palabra[1]) THEN BEGIN
						IF (palabra[4]='y') THEN silabas:= silabas + 2
						ELSE silabas:= silabas + 1;
						acabar:= TRUE;
					END
					{Onomatopeyas, 'Pfff', 'Shhh', etc.}
					ELSE IF (length(parsedText[j])<5) and
						(pos('a',palabra)=0) and (pos('e',palabra)=0) and
						(pos('i',palabra)=0) and (pos('o',palabra)=0) and
						(pos('u',palabra)=0) and
						(palabra[2]=palabra[3]) THEN BEGIN
						silabas:= silabas + 1;
						acabar:= TRUE;
					END
					{Para algunas palabras especiales, 'pymes', 'byte',
					'bypass', 'lycra'}
					ELSE IF (length(parsedText[j])<7) and esCons(palabra[1]) and
						(palabra[2]='y') and esCons (palabra[3]) and
						( esVocal(palabra[4]) or
						esVocal(palabra[5]) ) THEN BEGIN
						silabas:= 2;
						acabar:= TRUE;
					END
					{Podriamos seguir escribiendo muchas más condicionales
					o excepciones, pero escapan al propósito real de esta
					práctica. Software más sofisticado disponible en internet.}
					{Otros extranjerismos pasarán por error handling}

					{Error handling}
					ELSE IF (iteraciones>50) THEN BEGIN
						writeLn();
						write('    El programa no consigue contar las ');
						writeLn('silabas de "', parsedText[j], '", ');
						write('    palabra numero ', j, '. Se le asignara ');
						writeLn('un total de 0 silabas.');
						write('    Presiona Enter para seguir ');
						write('con el resto de palabras.');
						readLn();
						silabas:= 0;
						acabar:= TRUE;
					END;
				UNTIL (acabar);
			silabasMatriz[j]:= silabas;
			numSilabas:= numSilabas + silabas;
			END;
		END;
	END;
PROCEDURE printPalabras (VAR parsedText: tTexto; VAR silabasMatriz: tSilabas;
numPalabras: integer);
{Aquí 'parsedText' y 'silabasMatriz' no se modifican, sólo se leen}
	VAR
		n, m, j, maxLongPalabra, totalColumnas: integer;
		numEnLista, espacios: integer;
	BEGIN
		IF (numPalabras<>0) THEN BEGIN
			maxLongPalabra:= 1;
			FOR n:=1 TO numPalabras DO
				IF (maxLongPalabra<length(parsedText[n])) THEN
					maxLongPalabra:= length(parsedText[n]);
			j:= 1;
			totalColumnas:= (anchuraConsola - 5) div (maxLongPalabra + 11);
			writeLn('    Palabras en el texto y sus silabas:');
			writeLn();
			REPEAT
				numEnLista:= j + totalColumnas - 1;
				WHILE (numEnLista>numPalabras) DO numEnLista:= numEnLista - 1;
				write('    ');
				FOR n:=j TO numEnLista DO BEGIN
					write(n:3, '. ');
					write(parsedText[n]);
					IF (silabasMatriz[n]>9) THEN
						write(' (', silabasMatriz[n], ')')
					ELSE write(' (', silabasMatriz[n], ') ');
					espacios:= maxLongPalabra - length(parsedText[n]) + 1;
					FOR m:=1 TO espacios DO write(' ');
				END;
				j:= numEnLista + 1;
				writeLn();
			UNTIL (numEnLista=numPalabras);
		END
		{En caso de cero palabras}
		ELSE writeLn('    El archivo no contiene ninguna palabra.');
	END;
PROCEDURE printLinea;
	VAR n: integer;
	BEGIN
		FOR n:=1 TO (anchuraConsola-1) DO write('-');
		writeLn();
	END;
BEGIN {Programa principal}

	assign(entrada,'texto.txt');

	writeLn();
	write('    Este programa muestra estadisticas del texto ');
	writeLn('en "texto.txt", ');
	write('    archivo en el mismo directorio. Las estadisticas ');
	writeLn('son las siguientes.');
	creacionFichero(entrada);
	printLinea;

	reset(entrada);
	{Convertimos el texto en un array de palabras}
	textoToPalabras(entrada,parsedText,numPalabras);
	{Ahora trabajamos con el array 'parsedText'}
	close(entrada);

	{Numero de vocales y consonantes iniciales}
	letraInicial(parsedText,vocalInicial,consonanteInicial,numPalabras);
	{Numero de vocales y consonantes finales}
	letraFinal(parsedText,vocalFinal,consonanteFinal,numPalabras);

	contarSilabas(parsedText,silabasMatriz,numSilabas,numPalabras);

	writeLn();
	writeLn('    Palabras que empiezan por vocal: ', vocalInicial);
	writeLn('    Palabras que empiezan por consonante: ', consonanteInicial);
	writeLn('    Palabras que acaban por vocal: ', vocalFinal);
	writeLn('    Palabras que acaban por consonante: ', consonanteFinal);
	writeLn('    Numero de palabras: ', numPalabras);
	writeLn('    Numero de silabas (sin contar hiatos): ', numSilabas);
	printLinea;

	writeLn();
	{Mostramos la lista de palabras con sus respectivos números de sílabas}
	printPalabras(parsedText,silabasMatriz,numPalabras);
	printLinea;

	readLn();

END.
