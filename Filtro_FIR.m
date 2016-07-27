% Sampling frequency in Hz
Fs = 1000.0;
% Filter order
%     For LP and BP, N can be any order
%     For HP and BS, N must be even
N  = 30;
% Cutoff frequency
%     For LP and HP, Fc is a single value
%     For BP and BS, Fc is an ordered array [fc1 fc2]
Fc = 120.0;
% Coefficient bits
Q  = 18;
% MAC programmable counter bits
n = size(dec2bin(N));
K  = n(2);
x1 = Contador_VHDL();
x2 = Multiplicador_VHDL();
x3 = MUX_VHDL(N);
x4 = Registro_Paralelo_VHDL();
x5 = Registro_Paralelo_Clear_VHDL();
x6 = FSM_MAC_VHDL();
x7 = MAC_VHDL();
x8 = ROM_FIR_VHDL(Fs,N,Fc,Q,K);
x9 = FSM_FIR_VHDL();
x10 = FIR_VHDL(N,K);
x11 = FIR_Test_Bench_VHDL(N,Fs,Fc,Fc+60,Fc+120);
[~,struc] = fileattrib;
PathCurrent = struc.Name;
FolderName = 'Filtro FIR';
mkdir(PathCurrent,FolderName);
movefile('Contador_Ascendente_Hold_Clear.vhd',FolderName);
movefile('FIR.vhd',FolderName);
movefile('FSM_FIR.vhd',FolderName);
movefile('FSM_MAC.vhd',FolderName);
movefile('MAC.vhd',FolderName);
movefile('Multiplicador_nm_ss.vhd',FolderName);
movefile('MUX.vhd',FolderName);
movefile('Registro_Paralelo_Hold.vhd',FolderName);
movefile('Registro_Paralelo_Hold_Clear.vhd',FolderName);
movefile('ROM_FIR.vhd',FolderName);
movefile('Test_Bench_FIR.vhd',FolderName);
