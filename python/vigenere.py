import argparse  # Module pour analyser les arguments de la ligne de commande
import os        # Module pour les opérations sur le système d'exploitation
import sys       # Module fournissant des fonctionnalités pour interagir avec le système

# Tableau avec les caractères spéciaux à ignorer
SPECIAL_CHARS = ['é', 'è', 'ê', 'à', 'â', 'ç', '!', '?', ',', '.', ';', ':', '-', '_', '(', ')', '[', ']', '{', '}', '&', '*', '@', '#', '$', '%', '^', '/', '\\']

def encrypt_decrypt(text, key, mode):
    """
    Fonction pour chiffrer ou déchiffrer le texte en utilisant une clé et un mode donnés.
    
    Arguments :
        text : str - Le texte à chiffrer ou déchiffrer
        key : int - La clé de chiffrement
        mode : int - Le mode de chiffrement, 1 pour le chiffrement et -1 pour le déchiffrement
        
    Returns :
        str - Le texte chiffré ou déchiffré
    """
    result = ''
    for char in text:
        if char.isalpha() and char not in SPECIAL_CHARS:  # Vérifie si le caractère est une lettre et si ce n'est pas un caractère spécial
            if char.islower():
                shifted = ord('a') + (
                    ord(char) - ord('a') + key * mode
                ) % 26
                result += chr(shifted)
            elif char.isupper():
                shifted = ord('A') + (
                    ord(char) - ord('A') + key * mode
                ) % 26
                result += chr(shifted)
        else:
            result += char  # Conserve les caractères non alphabétiques inchangés
    return result

def main():
    """
    Fonction principale pour exécuter le script.
    """
    parser = argparse.ArgumentParser(description="Encrypt or decrypt a file.")  # Crée un analyseur d'arguments
    group = parser.add_mutually_exclusive_group(required=True)  # Crée un groupe d'options mutuellement exclusives
    group.add_argument("-c", "--chiffrement", action="store_true", help="Mode chiffrement")  # Option pour le chiffrement
    group.add_argument("-d", "--dechiffrement", action="store_true", help="Mode déchiffrement")  # Option pour le déchiffrement
    parser.add_argument("input_file", type=str, help="Chemin du fichier d'entrée")  # Argument pour le chemin du fichier d'entrée
    parser.add_argument("key", type=str, help="Clé du chiffrement")  # Argument pour la clé de chiffrement
    parser.add_argument("output_file", type=str, help="Chemin du fichier de sortie")  # Argument pour le chemin du fichier de sortie
    args = parser.parse_args()  # Analyse les arguments de la ligne de commande

    mode = 1 if args.chiffrement else -1  # Détermine le mode de chiffrement en fonction de l'option choisie

    if not os.path.exists(args.input_file):  # Vérifie si le fichier d'entrée existe
        print("Error: Input file does not exist.")  # Affiche un message d'erreur
        sys.exit(1)  # Quitte le programme avec un code d'erreur

    with open(args.input_file, 'r') as f:  # Ouvre le fichier d'entrée en mode lecture
        text = f.read()  # Lit le contenu du fichier

    result = encrypt_decrypt(text, int(args.key), mode)  # Chiffre ou déchiffre le texte

    with open(args.output_file, 'w') as f:  # Ouvre le fichier de sortie en mode écriture
        f.write(result)  # Écrit le résultat dans le fichier de sortie

    print("L'opération c'est bien passée !")  # Affiche un message de succès

if __name__ == "__main__":
    main()  # Appel de la fonction principale si le script est exécuté directement
