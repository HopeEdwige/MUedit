%% SCRIPT DE CONVERSION - SIGNAL SYNTHÉTIQUE -> MUEDIT
clear; clc;

% --- 1. Chargement du fichier source ---
source_file = 'sEMG_SynthSig_BicepsBrachii_F10MVC_Len20_SNRInf_03-Apr-2024_rawSignals.mat';
if ~exist(source_file, 'file')
    error('Le fichier %s est introuvable.', source_file);
end

data_struct = load(source_file);

% --- 2. Identification des données ---
% Dans les fichiers sEMG_SynthSig, les données sont souvent dans une variable 
% nommée 'rawSignals' ou simplement 'data'. 
% Nous allons chercher dynamiquement la variable qui contient la matrice.

vars = fieldnames(data_struct);
% On cherche la matrice (généralement la plus grosse variable)
main_var = vars{1}; 
emg_data = data_struct.(main_var);

% --- 3. Adaptation de la structure 'signal' ---
% Note : Pour ces signaux synthétiques, la fsamp est souvent de 2048 Hz
signal.fsamp = 2048; 

% Si emg_data est (temps x canaux), on doit la transposer pour MUedit (canaux x temps)
[r, c] = size(emg_data);
if r > c
    signal.data = double(emg_data'); 
    signal.nChan = c;
else
    signal.data = double(emg_data);
    signal.nChan = r;
end

signal.ngrid = 1;
signal.gridname = {'GR08MM1305'}; % Configuration standard 64ch
signal.muscle = {'Biceps Brachii (Synth)'};

% --- 4. Sauvegarde ---
output_name = 'biceps_synth_muedit.mat';
save(output_name, 'signal', '-v7');

fprintf('Fichier synthétique converti : %s\n', output_name);