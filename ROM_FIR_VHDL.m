function [x] = ROM_FIR_VHDL(Fs,N,Fc,Q,K)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1
% FIR filter design with the window method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% User parameters
% Sampling frequency in Hz
%Fs = 1000.0;
% Filter order
%     For LP and BP, N can be any order
%     For HP and BS, N must be even
%N  = 7;
% Cutoff frequency
%     For LP and HP, Fc is a single value
%     For BP and BS, Fc is an ordered array [fc1 fc2]
%Fc = 120.0;
% Fc = [100.0 200.0];
% Filter window
%     Check matlab help for available windows
W  = window(@rectwin,N+1);
% Computation
% Normalized cutoff frequency
Fn = 2.0*Fc/Fs;
% Digital FIR filter with the window method
%     LP 'low'     HP 'high'     BP 'bandpass'     BS 'stop'
a  = fir1(N,Fn,'low',W);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2
% Coefficient quantization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coefficient bits
%Q  = 18;
% Format computation
aM = max(abs(a));        % Maximum absolute coefficient value
L  = 1.0 - 2.0^(1-Q);    % Least value represented with Q bits
% Integer part
if (aM < L)
    e  = 1;
else
    e  = 1 + ceil(log(aM)/log(2.0*L));
end;
% Fractionary part
f  = Q - e;
% Quantization factor
Fq = 2^f;
% Coefficient quantization by rounding
aQ = floor(a*Fq + 0.5);
% Coefficient scaling
aS = aQ/Fq;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3
% Binarization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MAC programmable counter bits
%K  = 3;
% Index binarization
% Realize the conversion from the index in decimal base to binary base
for i=1:N+1
    Auxiliar = i-1;
    for j=K:-1:1
        IDX(i,j) = rem(Auxiliar,2);
        Auxiliar = floor(Auxiliar/2);
    end;
end;
% Coefficient binarization in 2's complement
for i=1:N+1
    % Positive-integer adjustment for negative numbers
    Auxiliar = aQ(i);
    if (Auxiliar < 0)
        Auxiliar = 2^Q + Auxiliar;
    end;
    % Binarization
    for j=Q:-1:1
        ABI(i,j) = rem(Auxiliar,2);
        Auxiliar = floor(Auxiliar/2);
    end;
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 4
% Automatic VHDL file generation of the coefficient ROM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open VHDL file
fid = fopen('ROM_FIR.vhd','wt');
% Description header
fprintf(fid,'library IEEE;\n');
fprintf(fid,'use IEEE.std_logic_1164.all;\n');
fprintf(fid,'\n');
fprintf(fid,'entity ROM_FIR is\n');
fprintf(fid,'   port(\n');
% Coefficient index declaration
fprintf(fid,'      I : in  std_logic_vector(%d downto 0);\n',K-1);
% Filter coefficient declaration
fprintf(fid,'      A : out std_logic_vector(%d downto 0)\n',Q-1);
fprintf(fid,'      );\n');
fprintf(fid,'   end ROM_FIR;\n');
fprintf(fid,'\n');
fprintf(fid,'architecture LUTable of ROM_FIR is\n');
fprintf(fid,'begin\n');
fprintf(fid,'   process(I)\n');
fprintf(fid,'   begin\n');
fprintf(fid,'      case I is\n');
fprintf(fid,'         -- Coefficient format %d.%d\n',e,f);
% Automatic table generation
for i=1:N+1
    fprintf(fid,'         when "');
    % Index binarization
    for j=1:K
        fprintf(fid,'%d',IDX(i,j));
    end;
    fprintf(fid,'" => A <= "');
    % Coefficient binarization
    for j=1:Q
        fprintf(fid,'%d',ABI(i,j));
    end;
    % Decimal values
    fprintf(fid,'"; -- Index %d   Coefficient %1.8f\n',i-1,aS(i));
end;
% End VHDL file
fprintf(fid,'         when others => A <= "');
for i=1:Q
    fprintf(fid,'0');
end;
fprintf(fid,'"; -- Irrelevant indexes\n');
fprintf(fid,'      end case;\n');
fprintf(fid,'   end process;\n');
fprintf(fid,'end LUTable;\n');

% Close file
fclose(fid);
x=1;
end