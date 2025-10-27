if [ $# -eq 0 ];
then
	echo "Aucun argument fourni";
	exit 1;
fi

if [ ! -f "$1" ];
then
	echo "Le fichier spécifié n'existe pas";
	exit 1;
fi

i=1;

while read -r line;
do
	# le fichier dump est surtout là pour rediriger le contenu de l'URL dans ce dernier
	# afin qu'il ne s'affiche pas dans le terminal
    http_code=$(curl -s -o dump -w "%{http_code}" "$line")
    
    encoding=$(curl -s -I "$line" | grep -i "content-type" | grep -o -i "charset=.*" |
	 cut -d= -f2 | tr -d '\r\n' | head -1)
    if [ -z "$encoding" ]; 
	then
        encoding="null"
    fi
    
    if [ "$http_code" = "200" ]; 
	then
        word_count=$(curl -s "$line" | wc -w)
    else
        word_count="null"
    fi
    
    echo -e "${i}\t${line}\t${http_code}\t${encoding}\t${word_count}";
    
    ((i++));
done < "$1";


# 1) cat serait plus adapté pour juste afficher le contenu d'un fichier. Ici on veut lire ligne par ligne.
# 2) "urls/fr.txt" est remplacé par "$1" pour utiliser le fichier passé en argument. On ecrira alors "urls/fr.txt"
# dans le terminal lors de l'appel du script.
# 3 Pour afficher le numéro de ligne avant chaque URL j'ai fait une variable i qui s'incrémentera à chaque itération de la boucle.