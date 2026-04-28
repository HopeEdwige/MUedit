%% SCRIPT DE CONVERSION POLY5 -> MUEDIT (Biceps Brachii)
clear; clc;

% --- Configuration ---
filename = 'contraction_bb.Poly5'; 
fsamp = 2048; % Fréquence d'échantillonnage standard Mobita
nChan = 64; 

% --- 1. Lecture du binaire "Brut" ---
if ~exist(filename, 'file')
    error('Fichier %s introuvable !', filename);
end

fid = fopen(filename, 'r');

% ASTUCE : On saute l'entête textuelle du Poly5 pour arriver aux données.
% Sur un Mobita, l'entête fait souvent environ 4096 octets.
fseek(fid, 4096, 'bof'); 

raw_data = fread(fid, 'int16'); 
fclose(fid);

% --- 2. Vérification et Reshape ---
nb_points = length(raw_data);
nb_col = floor(nb_points / nChan);

if nb_col == 0
    error('Le fichier semble vide ou l''entête est trop longue.');
end

% On s'assure que la matrice est bien découpée en 64 lignes
data_matrix = reshape(raw_data(1:nChan * nb_col), nChan, nb_col);

% --- 3. Structure MUedit (Cible Grille 8x8) ---
signal.data = double(data_matrix); 
signal.fsamp = fsamp;
signal.nChan = nChan;
signal.ngrid = 1;
signal.gridname = {'GR08MM1305'}; % Ta grille 8x8
signal.muscle = {'Biceps Brachii'}; % C'est ton muscle !

% --- 4. Sauvegarde compatible MUedit ---
save('mon_biceps_clean.mat', 'signal', '-v7');

% Création du fichier decomp pour l'interface d'édition
edition.binary_source = filename; 
edition.fsamp = fsamp;
save('mon_biceps_decomp.mat', 'edition', '-v7');

disp('Conversion de ton Biceps terminée !');