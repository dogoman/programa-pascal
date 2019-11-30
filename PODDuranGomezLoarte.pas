PROGRAM PODDuranGomezLoarte (input, output);

{Este programa muestra estadísticas varias de un texto corto en castellano.
No debe haber tildes ni eñes. El texto reside en 'texto.txt' junto al programa.}

CONST
{Aumentar el numero máximo de palabras,
o el numero máximo de letras por palabra, si es necesario.}
	maxPalabras= 250;
	maxLetras= 25;
	anchuraConsola= 120; {Anchura en numero de caracteres}
	{Por defecto en Windows 10 y servidores myApps URJC la consola es de
	120 chars de ancho. Windows 7 y XP: 80 chars.}
TYPE
	tPalabra= string[maxLetras];
	tTexto= array[1..maxPalabras] of tPalabra;
VAR
	entrada: text;
	parsedText: tTexto;
	numPalabras: integer;

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
PROCEDURE inicializar (VAR parsedText: tTexto);
{En un principio asignamos a parsedText strings de longitud 0, esta vacía}
	VAR n: integer;
	BEGIN
		FOR n:=1 TO maxPalabras DO setlength(parsedText[n],0);
	END;
PROCEDURE retirarSimbolos (VAR linea: string);
{Convierte las lineas de texto a sólo letras minusculas y espacios. P. ej.:
'¡Vaya ilusion, 6 amigos!' se convierte en ' vaya ilusion    amigos '}
	VAR n, tamano: integer;
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
PROCEDURE printPalabras (VAR parsedText: tTexto; numPalabras: integer);
{Aquí 'parsedText' no se modifica, sólo se lee}
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
			totalColumnas:= (anchuraConsola - 5) div (maxLongPalabra + 6);
			writeLn('    Palabras en el texto:');
			writeLn();
			REPEAT
				numEnLista:= j + totalColumnas - 1;
				WHILE (numEnLista>numPalabras) DO numEnLista:= numEnLista - 1;
				write('    ');
				FOR n:=j TO numEnLista DO BEGIN
					write(n:3, '. ');
					write(parsedText[n]);
					espacios:= maxLongPalabra - length(parsedText[n]) + 1;
					FOR m:=1 TO espacios DO write(' ');
				END;
				j:= numEnLista + 1;
				writeLn();
			UNTIL (numEnLista=numPalabras);
		END;
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
	inicializar(parsedText);
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
	writeLn('    Palabras que empiezan por vocal: ');
	writeLn('    Palabras que empiezan por consonante: ');
	writeLn('    Palabras que acaban por vocal: ');
	writeLn('    Palabras que acaban por consonante: ');
	writeLn('    Numero de palabras: ', numPalabras);
	writeLn('    Numero de silabas (sin contar hiatos): ');
	printLinea;

	writeLn();
	printPalabras(parsedText,numPalabras);
	printLinea;

	readLn();

	{Addendum:
	No es necesario inicializar parsedText si en el código no se trabaja
	con strings de parsedText[n] tal que n es mayor al numPalabras}

END.
