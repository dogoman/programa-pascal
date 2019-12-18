PROGRAM PODDuranGomezLoarte (input, output);

{Este programa muestra estadísticas varias de un texto corto en castellano.
No debe haber tildes ni eñes. El texto reside en 'texto.txt' junto al programa.}

{Tab default width in original editor is 4 spaces.}

CONST
{Aumentar el número máximo de palabras,
o el número máximo de letras por palabra, si es necesario.}
	MAXPALABRAS= 250;
	MAXLETRAS= 35;
	ANCHURACONSOLA= 120; {anchura en número de caracteres}
	{Por defecto en Windows 10 y myApps la consola es 120 chars ancho.
	Windows 7 y XP: 80 chars.}
TYPE
	tPalabra= string[MAXLETRAS];
	tFicha=	RECORD
			palabra: tPalabra;
			silabas: integer;
			END;
	tDatabase= array[1..MAXPALABRAS] of tFicha;
VAR
	entrada: text;
	parsedText: tDatabase;
	numPalabras: integer;
	vocalInicial, consonanteInicial: integer;
	vocalFinal, consonanteFinal: integer;
	numSilabas: integer;

PROCEDURE creacionFichero (VAR entrada: text);
{Si no existe el archivo "texto.txt", se crea.}
	BEGIN
		{$I-} {se desactiva para controlar reset}
		reset(entrada);
		{$I+} {se activa para detectar otros errores que no controlamos}
		IF (IOResult<>0) THEN BEGIN
			rewrite(entrada);
			writeLn(entrada, 'Archivo creado.');
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
PROCEDURE lineasToPalabras (VAR linea: string; VAR parsedText: tDatabase;
VAR posSigPalabra: integer);
{Guarda todas las palabras de 'linea' en 'parsedText'.}
	VAR
		j, k, tamano: integer;
		palabra: tPalabra;
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
					parsedText[posSigPalabra].palabra:=  palabra;
					posSigPalabra:= posSigPalabra + 1;
				END
				ELSE IF ((j>1) and (linea[j-1]<>' ')) THEN BEGIN
					setlength(palabra,k-1);
					parsedText[posSigPalabra].palabra:=  palabra;
					posSigPalabra:= posSigPalabra + 1;
					k:= 1;
				END;
			END;
		END;
	END;
PROCEDURE textoToPalabras (VAR entrada: text; VAR parsedText: tDatabase;
VAR numPalabras: integer);
{Guarda todas las palabras de 'entrada' en 'parsedText', consecutivamente.}
	VAR
		posSigPalabra: integer;
		linea: string;
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
PROCEDURE letraInicial (VAR parsedText: tDatabase; VAR vocalInicial,
consonanteInicial: integer; numPalabras: integer);
{Aquí 'parsedText' no se modifica, sólo se lee.}
	VAR
		n: integer;
		letra: char;
	BEGIN
		vocalInicial:= 0;
		IF (numPalabras<>0) THEN BEGIN
			FOR n:=1 TO numPalabras DO BEGIN
				letra:= parsedText[n].palabra[1];
				IF esVocal(letra) THEN vocalInicial:= vocalInicial + 1;
			END;
		END;
		consonanteInicial:= numPalabras - vocalInicial;
	END;
PROCEDURE letraFinal (VAR parsedText: tDatabase; VAR vocalFinal,
consonanteFinal: integer; numPalabras: integer);
{Aquí 'parsedText' no se modifica, sólo se lee.}
	VAR
		n, j: integer;
		letra: char;
	BEGIN
		vocalFinal:= 0;
		IF (numPalabras<>0) THEN BEGIN
			FOR n:=1 TO numPalabras DO BEGIN
				j:= length(parsedText[n].palabra);
				letra:= parsedText[n].palabra[j];
				IF esVocal(letra) THEN vocalFinal:= vocalFinal + 1;
			END;
		END;
		consonanteFinal:= numPalabras - vocalFinal;
	END;
PROCEDURE contarSilabas (VAR parsedText: tDatabase; VAR numSilabas: integer;
numPalabras: integer);

{Aquí 'parsedText' no se modifica, sólo se lee.}

{Cuenta las sílabas de cada palabra, y las sílabas totales.
Las sílabas de 'parsedText[n].palabra' serán 'parsedText[n].silabas'.}

{Las uniones de vocales ia, ie, io, iu; ua, ue, ui, uo; ai, ei, oi; au, eu, ou;
(y respectivas variantes con hache intercalada) se consideran aquí
diptongos/triptongos siempre, aunque en realidad sean a veces hiatos.

P. ej:
		día (2 sílabas), capicúa (4), baúl (2), maíz (2), búho (2), ahí (2)

Se procesan así:

		dia (1 sílaba), capicua (3), baul (1), maiz (1), buho (1), ahi (1)

Distinguir estos hiatos requeriría trabajar con tildes.}

	VAR
		j, silabas, longitud: integer;
		palabra: tPalabra;
		acabar: boolean;
		iteraciones: integer;
		{Cuando son demasiadas iteraciones se hace error handling.}
	BEGIN
		numSilabas:= 0;
		IF (numPalabras<>0) THEN BEGIN
			FOR j:=1 TO numPalabras DO BEGIN
				silabas:= 0;
				palabra:= parsedText[j].palabra;
				acabar:= FALSE;
				iteraciones:= 0;
				REPEAT
					longitud:= length(palabra);
					iteraciones:= iteraciones + 1;
					{Casos más extraños al final de la lista de condicionales.}

					{Empieza aquí lista de condicionales.}
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
					{'Angstromio' y similares.}
					ELSE IF (longitud>6) and esVocal(palabra[1]) and
						esVocal(palabra[7]) THEN BEGIN
						silabas:= silabas + 1;
						palabra:= copy(palabra,7,(longitud-6));
					END
					{Para algunos extranjerismos, 'golf', 'sexy'.}
					ELSE IF (longitud<4) and esVocal(palabra[1]) THEN BEGIN
						IF (palabra[3]='y') THEN silabas:= silabas + 2
						ELSE silabas:= silabas + 1;
						acabar:= TRUE;
					END
					{Para algunos extranjerismos, 'tests', 'whisky'.}
					ELSE IF (longitud<5) and esVocal(palabra[1]) THEN BEGIN
						IF (palabra[4]='y') THEN silabas:= silabas + 2
						ELSE silabas:= silabas + 1;
						acabar:= TRUE;
					END
					{Onomatopeyas, 'Pfff', 'Shhh', etc.}
					ELSE IF (longitud<5) and (iteraciones=1) and
						(pos('a',palabra)=0) and (pos('e',palabra)=0) and
						(pos('i',palabra)=0) and (pos('o',palabra)=0) and
						(pos('u',palabra)=0) and
						(palabra[2]=palabra[3]) THEN BEGIN
						silabas:= 1;
						acabar:= TRUE;
					END
					{Para algunas palabras especiales, 'pymes', 'byte',
					'bypass', 'lycra'.}
					ELSE IF (longitud<7) and (iteraciones=1) and
						esCons(palabra[1]) and (palabra[2]='y') and
						esCons(palabra[3]) and
						( ((longitud>3) and esVocal(palabra[4])) or
						((longitud>4) and esVocal(palabra[5])) ) and
						( ((longitud>5) and esCons(palabra[6])) or
						(longitud<6) ) THEN BEGIN
						IF (longitud>4) and esHiato(palabra[4],palabra[5])
							THEN silabas:= 3
						ELSE silabas:= 2;
						acabar:= TRUE;
					END
					{Podriamos seguir escribiendo muchas más condicionales
					o excepciones, pero escapan al propósito real de esta
					práctica. Software más sofisticado disponible en internet.}
					{Otros extranjerismos pasarán por error handling.}

					{Error handling.}
					ELSE IF (iteraciones>50) THEN BEGIN
						writeLn();
						write('    El programa no consigue contar las ');
						writeLn('silabas de "', parsedText[j].palabra, '", ');
						write('    palabra numero ', j, '. Se le asignara ');
						writeLn('un total de 0 silabas.');
						write('    Presiona Enter para seguir ');
						write('con el resto de palabras.');
						readLn();
						silabas:= 0;
						acabar:= TRUE;
					END;
				UNTIL (acabar);
			parsedText[j].silabas:= silabas;
			numSilabas:= numSilabas + silabas;
			END;
		END;
	END;
PROCEDURE printPalabras (VAR parsedText: tDatabase; numPalabras: integer);
{Aquí 'parsedText' no se modifica, sólo se lee.}
	VAR
		maxLongPalab, columnas: integer;
		min, max, espacios: integer;
		i, j: integer;
	BEGIN
		IF (numPalabras<>0) THEN BEGIN
			maxLongPalab:= 1;
			FOR i:=1 TO numPalabras DO BEGIN
				j:= length(parsedText[i].palabra);
				IF (maxLongPalab<j) THEN maxLongPalab:= j;
			END;
			columnas:= (ANCHURACONSOLA - 5) div (maxLongPalab + 11);
			writeLn('    Palabras en el texto y sus silabas:');
			writeLn();
			min:= 1;
			REPEAT
				max:= min + columnas - 1;
				IF (max>numPalabras) THEN max:= numPalabras;
				write('    ');
				FOR i:=min TO max DO BEGIN
					write(i:3, '. ');
					write(parsedText[i].palabra);
					IF (parsedText[i].silabas>9) THEN
						write(' (', parsedText[i].silabas, ')')
					ELSE write(' (', parsedText[i].silabas, ') ');
					espacios:= maxLongPalab - length(parsedText[i].palabra) + 1;
					FOR j:=1 TO espacios DO write(' ');
				END;
				min:= max + 1;
				writeLn();
			UNTIL (max=numPalabras);
		END
		{En caso de cero palabras.}
		ELSE writeLn('    El archivo no contiene ninguna palabra.');
	END;
PROCEDURE printLinea;
	VAR n: integer;
	BEGIN
		FOR n:=1 TO (ANCHURACONSOLA-1) DO write('-');
		writeLn();
	END;
BEGIN {programa principal}

	assign(entrada,'texto.txt');

	writeLn();
	write('    Este programa muestra estadisticas del texto ');
	writeLn('en "texto.txt", ');
	write('    archivo en el mismo directorio. Las estadisticas ');
	writeLn('son las siguientes.');
	creacionFichero(entrada);
	printLinea;

	reset(entrada);
	{Convertimos el texto en un array de palabras.}
	textoToPalabras(entrada,parsedText,numPalabras);
	{Ahora trabajamos con el array en 'parsedText'.}
	close(entrada);

	{Número de vocales y consonantes iniciales.}
	letraInicial(parsedText,vocalInicial,consonanteInicial,numPalabras);
	{Número de vocales y consonantes finales.}
	letraFinal(parsedText,vocalFinal,consonanteFinal,numPalabras);

	contarSilabas(parsedText,numSilabas,numPalabras);

	writeLn();
	writeLn('    Palabras que empiezan por vocal: ', vocalInicial);
	writeLn('    Palabras que empiezan por consonante: ', consonanteInicial);
	writeLn('    Palabras que acaban por vocal: ', vocalFinal);
	writeLn('    Palabras que acaban por consonante: ', consonanteFinal);
	writeLn('    Numero de palabras: ', numPalabras);
	writeLn('    Numero de silabas (sin contar hiatos): ', numSilabas);
	printLinea;

	writeLn();
	{Mostramos la lista de palabras con sus respectivos números de sílabas.}
	printPalabras(parsedText,numPalabras);
	printLinea;

	readLn();
END.
