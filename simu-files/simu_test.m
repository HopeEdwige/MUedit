signal.data = randn(64, 20000); % 64 canaux, 20s de bruit
signal.fsamp = 2048;
signal.nChan = 64;
signal.ngrid = 1;
signal.gridname = {'GR08MM1305'}; % Un nom standard reconnu
save('test_muedit.mat', 'signal');